#' Turbidity index (Frohn and Autrey 2009)
#'
#' Computes the band-ratio turbidity index of Frohn and Autrey (2009),
#' defined as `(green + red) / blue`. Higher values indicate more turbid
#' water. It is useful for selecting the least turbid image dates before
#' deriving bathymetry, because the empirical ratio transform performs best
#' in clear water.
#'
#' @param x A multi-band [terra::SpatRaster] of surface reflectance.
#' @param blue,green,red Band identifiers (layer names or integer indices)
#'   for the blue, green and red bands of `x`.
#'
#' @return A single-layer [terra::SpatRaster] named `"turbidity"`.
#'
#' @references
#' Frohn RC, Autrey BC (2009). Water quality assessment in the Ohio River
#' using new indices for turbidity and chlorophyll-a with Landsat-7 imagery.
#' Draft Internal Report, U.S. Environmental Protection Agency.
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' turb <- turbidity_index(img, blue = "blue", green = "green", red = "red")
#' turb
#'
#' @seealso [ndwi()], [log_ratio()]
#' @export
turbidity_index <- function(x, blue = "blue", green = "green", red = "red") {
  x <- .as_rast(x)
  out <- (.get_band(x, green, "green") + .get_band(x, red, "red")) /
    .get_band(x, blue, "blue")
  names(out) <- "turbidity"
  out
}
