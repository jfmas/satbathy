#' Sun-glint correction (Hedley et al. 2005)
#'
#' Removes sun-glint from visible bands using the image-based method of
#' Hedley et al. (2005). For each visible band, a linear regression against
#' the near-infrared (NIR) band is fitted over a deep-water sample, where the
#' bottom contribution is assumed negligible and NIR reflectance is due to
#' glint alone. The band is then corrected as
#' `band - slope * (NIR - min_NIR)`, where `min_NIR` is the glint-free NIR
#' reflectance estimated as a low quantile of NIR over deep water.
#'
#' @param x A multi-band [terra::SpatRaster] of surface reflectance.
#' @param vis_bands Band identifiers (layer names or integer indices) of the
#'   visible bands to correct, e.g. `c("blue", "green")`.
#' @param nir_band Band identifier of the near-infrared band.
#' @param deep_mask A [terra::SpatVector] (or SpatRaster) delimiting optically
#'   deep water, used to sample glint and estimate `min_NIR`. Reprojected to
#'   the CRS of `x` if necessary.
#' @param n_sample Number of random deep-water pixels used to fit each
#'   regression. Defaults to `500`.
#' @param prob Lower quantile of NIR over deep water used to estimate the
#'   glint-free NIR reflectance (`min_NIR`). Defaults to `0.01`.
#'
#' @return A copy of `x` in which the layers named in `vis_bands` have been
#'   glint-corrected. If the deep-water sample is too small to fit the
#'   regressions, `x` is returned unchanged with a warning.
#'
#' @references
#' Hedley JD, Harborne AR, Mumby PJ (2005). Technical note: Simple and robust
#' removal of sun glint for mapping shallow-water benthos. International
#' Journal of Remote Sensing 26(10):2107-2112.
#' \doi{10.1080/01431160500034086}
#'
#' @examples
#' img  <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                 package = "satbathy"))
#' deep <- terra::vect(system.file("extdata", "example_deepmask.gpkg",
#'                                 package = "satbathy"))
#' corrected <- correct_glint(img, vis_bands = c("blue", "green"),
#'                            nir_band = "nir", deep_mask = deep)
#'
#' @seealso [log_ratio()], [lowpass_filter()]
#' @export
correct_glint <- function(x, vis_bands = c("blue", "green"), nir_band = "nir",
                          deep_mask, n_sample = 500, prob = 0.01) {
  x <- .as_rast(x)
  if (missing(deep_mask)) {
    stop("`deep_mask` is required to sample deep water.", call. = FALSE)
  }
  deep_mask <- .match_crs(deep_mask, x)

  nir <- .get_band(x, nir_band, "nir_band")
  nir_deep <- terra::mask(nir, deep_mask)

  ## glint-free NIR reflectance and available deep-water pixels
  min_nir <- stats::quantile(terra::values(nir_deep), prob, na.rm = TRUE)
  n_valid <- terra::global(nir_deep, fun = "notNA")[1, 1]
  nir_gc  <- nir - min_nir

  sample_pts <- terra::spatSample(nir_deep, n_sample, method = "random",
                                  replace = FALSE, na.rm = TRUE, as.points = TRUE)
  if (nrow(sample_pts) < 30 || n_valid < 200) {
    warning("Deep-water sample too small; returning `x` unchanged.",
            call. = FALSE)
    return(x)
  }

  xnir <- as.numeric(terra::extract(nir, sample_pts, ID = FALSE)[, 1])
  for (b in vis_bands) {
    band <- .get_band(x, b, "vis_bands")
    yvis <- as.numeric(terra::extract(band, sample_pts, ID = FALSE)[, 1])
    slope <- stats::lm(yvis ~ xnir)$coefficients[["xnir"]]
    x[[b]] <- band - slope * nir_gc
  }
  x
}
