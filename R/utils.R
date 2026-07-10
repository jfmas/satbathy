## Internal helpers (not exported)

#' Validate that an object is a SpatRaster
#' @noRd
.as_rast <- function(x) {
  if (!inherits(x, "SpatRaster")) {
    stop("`x` must be a `terra::SpatRaster`.", call. = FALSE)
  }
  x
}

#' Select a single band by name or integer index, with an informative error
#' @noRd
.get_band <- function(x, id, role = "band") {
  if (length(id) != 1L) {
    stop(sprintf("`%s` must identify a single band.", role), call. = FALSE)
  }
  if (is.character(id) && !id %in% names(x)) {
    stop(sprintf("Band '%s' (%s) not found in `x`. Available bands: %s.",
                 id, role, paste(names(x), collapse = ", ")), call. = FALSE)
  }
  if (is.numeric(id) && (id < 1 || id > terra::nlyr(x))) {
    stop(sprintf("Band index %s (%s) is out of range (1-%d).",
                 id, role, terra::nlyr(x)), call. = FALSE)
  }
  x[[id]]
}

#' Reproject a mask (SpatVector/SpatRaster) to the CRS of `x` when they differ
#' @noRd
.match_crs <- function(mask, x) {
  if (terra::crs(mask) != terra::crs(x)) {
    mask <- terra::project(mask, terra::crs(x))
  }
  mask
}
