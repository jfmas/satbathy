#' Normalized Difference Water Index (NDWI)
#'
#' Computes McFeeters' Normalized Difference Water Index,
#' `(green - nir) / (green + nir)`. Water typically yields positive values
#' while land and clouds yield negative values, so the NDWI is a convenient
#' basis for building a water mask when a sensor quality band is not
#' available (e.g. PlanetScope imagery).
#'
#' @param x A multi-band [terra::SpatRaster] of surface reflectance.
#' @param green,nir Band identifiers (layer names or integer indices) for the
#'   green and near-infrared bands of `x`.
#'
#' @return A single-layer [terra::SpatRaster] named `"ndwi"`.
#'
#' @references
#' McFeeters SK (1996). The use of the Normalized Difference Water Index
#' (NDWI) in the delineation of open water features. International Journal of
#' Remote Sensing 17(7):1425-1432.
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' ndwi(img, green = "green", nir = "nir")
#'
#' @seealso [water_mask()]
#' @export
ndwi <- function(x, green = "green", nir = "nir") {
  x <- .as_rast(x)
  g <- .get_band(x, green, "green")
  n <- .get_band(x, nir, "nir")
  out <- (g - n) / (g + n)
  names(out) <- "ndwi"
  out
}

#' Water mask from NDWI
#'
#' Builds a logical water mask by thresholding the NDWI (see [ndwi()]).
#' Pixels with `NDWI > threshold` are flagged as water (`TRUE`).
#'
#' @inheritParams ndwi
#' @param threshold Numeric NDWI threshold above which a pixel is considered
#'   water. Defaults to `0`.
#'
#' @return A single-layer logical [terra::SpatRaster] named `"water"`
#'   (`TRUE` for water, `FALSE` otherwise).
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' wm <- water_mask(img, green = "green", nir = "nir", threshold = 0)
#' # keep only water pixels of the image:
#' water_only <- terra::mask(img, wm, maskvalues = c(FALSE, NA))
#'
#' @seealso [ndwi()]
#' @export
water_mask <- function(x, green = "green", nir = "nir", threshold = 0) {
  wi <- ndwi(x, green = green, nir = nir)
  out <- wi > threshold
  names(out) <- "water"
  out
}
