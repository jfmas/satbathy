#' Log-ratio transform (Stumpf et al. 2003)
#'
#' Computes the log-ratio transform used to linearise the relationship
#' between satellite reflectance and water depth:
#' \deqn{R = \frac{\ln(n \cdot R_{blue})}{\ln(n \cdot R_{green})}}
#' where \eqn{R_{blue}} and \eqn{R_{green}} are the reflectance of a
#' high-penetration and a lower-penetration band (typically blue and green),
#' and \eqn{n} is a fixed constant chosen so that both logarithms stay
#' positive. Because the more strongly attenuated band changes faster with
#' depth, the ratio increases monotonically with depth over its valid range.
#'
#' @param x A multi-band [terra::SpatRaster] of surface reflectance. Non-water
#'   areas should be masked beforehand (see [water_mask()]); cells with
#'   non-positive reflectance yield `NA`.
#' @param blue,green Band identifiers (layer names or integer indices) for the
#'   high-penetration (blue) and lower-penetration (green) bands.
#' @param n Fixed positive constant applied inside the logarithms. Defaults to
#'   `10000`.
#' @param trim Length-2 numeric vector of lower/upper probabilities used to
#'   trim outliers from the ratio: cells outside these quantiles are set to
#'   `NA`. Defaults to `c(0.01, 0.99)`. Use `NULL` to disable trimming.
#'
#' @return A single-layer [terra::SpatRaster] named `"ratio"`.
#'
#' @references
#' Stumpf RP, Holderied K, Sinclair M (2003). Determination of water depth
#' with high-resolution satellite imagery over variable bottom types.
#' Limnology and Oceanography 48(1, part 2):547-556.
#' \doi{10.4319/lo.2003.48.1_part_2.0547}
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' wm  <- water_mask(img, green = "green", nir = "nir")
#' img <- terra::mask(img, wm, maskvalues = c(FALSE, NA))
#' ratio <- log_ratio(img, blue = "blue", green = "green")
#' ratio
#'
#' @seealso [fit_bathymetry()], [correct_glint()], [lowpass_filter()]
#' @export
log_ratio <- function(x, blue = "blue", green = "green", n = 10000,
                      trim = c(0.01, 0.99)) {
  x <- .as_rast(x)
  if (!is.numeric(n) || length(n) != 1L || n <= 0) {
    stop("`n` must be a single positive number.", call. = FALSE)
  }
  b <- .get_band(x, blue, "blue")
  g <- .get_band(x, green, "green")
  ratio <- log(n * b) / log(n * g)

  if (!is.null(trim)) {
    if (length(trim) != 2L) {
      stop("`trim` must be a length-2 vector of probabilities, or NULL.",
           call. = FALSE)
    }
    q <- stats::quantile(terra::values(ratio), probs = trim, na.rm = TRUE)
    ratio[ratio < q[1] | ratio > q[2]] <- NA
  }
  names(ratio) <- "ratio"
  ratio
}
