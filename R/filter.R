#' Low-pass spatial filter
#'
#' Applies a low-pass (moving-average) spatial filter to every layer of a
#' raster, replacing each cell with the mean of its neighbourhood. This
#' smooths the speckle caused by residual glint and water-surface roughness
#' before computing the ratio transform. It is a thin, documented wrapper
#' around [terra::focal()].
#'
#' @param x A [terra::SpatRaster].
#' @param w Neighbourhood size passed to [terra::focal()]. A single odd
#'   integer gives a `w x w` window (default `3`, i.e. a 3x3 mean).
#'
#' @return A [terra::SpatRaster] with the same layers as `x`, smoothed.
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' smoothed <- lowpass_filter(img[["blue"]], w = 3)
#'
#' @seealso [correct_glint()], [log_ratio()]
#' @export
lowpass_filter <- function(x, w = 3) {
  x <- .as_rast(x)
  terra::focal(x, w = w, fun = "mean", na.rm = TRUE)
}
