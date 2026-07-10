#' Extract ratio values at in situ depth points
#'
#' Builds the modelling table used to calibrate the bathymetry model by
#' extracting the log-ratio value (see [log_ratio()]) at each in situ
#' bathymetric point and pairing it with the measured depth.
#'
#' @param ratio A single-layer [terra::SpatRaster] of ratio values.
#' @param points In situ bathymetric points, either a [terra::SpatVector] or
#'   an `sf` object of points. Reprojected to the CRS of `ratio` if needed.
#' @param depth_field Name of the attribute in `points` holding the measured
#'   depth (negative below the surface). Defaults to `"depth"`.
#'
#' @return A `data.frame` with columns `ratio` and `depth`, with rows
#'   containing missing values removed.
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' pts <- terra::vect(system.file("extdata", "example_points.gpkg",
#'                                package = "satbathy"))
#' wm  <- water_mask(img)
#' img <- terra::mask(img, wm, maskvalues = c(FALSE, NA))
#' ratio <- log_ratio(img)
#' tab <- extract_ratio(ratio, pts, depth_field = "depth")
#' head(tab)
#'
#' @seealso [fit_bathymetry()]
#' @export
extract_ratio <- function(ratio, points, depth_field = "depth") {
  ratio <- .as_rast(ratio)
  if (inherits(points, "sf")) {
    points <- terra::vect(points)
  }
  if (!inherits(points, "SpatVector")) {
    stop("`points` must be a terra SpatVector or an sf object.", call. = FALSE)
  }
  if (!depth_field %in% names(points)) {
    stop(sprintf("`depth_field` '%s' not found in `points`.", depth_field),
         call. = FALSE)
  }
  points <- .match_crs(points, ratio)
  vals <- terra::extract(ratio[[1]], points, ID = FALSE)
  out <- data.frame(ratio = as.numeric(vals[, 1]),
                    depth = as.numeric(points[[depth_field]][, 1]))
  stats::na.omit(out)
}

#' Fit an empirical bathymetry model
#'
#' Fits the empirical linear model relating depth to the log-ratio,
#' \eqn{Z = m_1 R - m_0} (Stumpf et al. 2003), by ordinary least squares.
#' Optionally restricts the calibration to points shallower than a maximum
#' depth, since the ratio saturates and departs from linearity beyond the
#' penetration limit (see [optimal_max_depth()]).
#'
#' @param data A `data.frame` with the ratio and depth columns, typically the
#'   output of [extract_ratio()].
#' @param ratio,depth Column names in `data` for the ratio and the measured
#'   depth. Default to `"ratio"` and `"depth"`.
#' @param max_depth Optional maximum depth (a negative number). Only points
#'   with `depth > max_depth` (and `depth < 0`) are used for calibration. If
#'   `NULL` (default) all rows with `depth < 0` are used.
#'
#' @return An object of class `satbathy_model`: a list with the fitted `lm`
#'   (`model`), the `data` actually used, the `max_depth` threshold, the
#'   adjusted R-squared (`r.squared`), the number of points (`n`) and the
#'   `call`.
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
#' pts <- terra::vect(system.file("extdata", "example_points.gpkg",
#'                                package = "satbathy"))
#' img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
#' tab <- extract_ratio(log_ratio(img), pts)
#' fit <- fit_bathymetry(tab, max_depth = -16)
#' fit
#'
#' @seealso [extract_ratio()], [predict_bathymetry()], [optimal_max_depth()]
#' @export
fit_bathymetry <- function(data, ratio = "ratio", depth = "depth",
                           max_depth = NULL) {
  d <- .prepare_fit_data(data, ratio, depth, max_depth)
  model <- stats::lm(depth ~ ratio, data = d)
  structure(
    list(model = model,
         data = d,
         max_depth = max_depth,
         r.squared = summary(model)$adj.r.squared,
         n = nrow(d),
         call = match.call()),
    class = "satbathy_model"
  )
}

#' @noRd
.prepare_fit_data <- function(data, ratio, depth, max_depth) {
  if (!all(c(ratio, depth) %in% names(data))) {
    stop(sprintf("`data` must contain columns '%s' and '%s'.", ratio, depth),
         call. = FALSE)
  }
  d <- data.frame(ratio = as.numeric(data[[ratio]]),
                  depth = as.numeric(data[[depth]]))
  d <- stats::na.omit(d)
  d <- d[d$depth < 0, , drop = FALSE]
  if (!is.null(max_depth)) {
    d <- d[d$depth > max_depth, , drop = FALSE]
  }
  if (nrow(d) < 3L) {
    stop("Fewer than 3 usable points after filtering; cannot fit a model.",
         call. = FALSE)
  }
  d
}

#' Predict depth from a ratio raster or table
#'
#' Applies a fitted [fit_bathymetry()] model to new ratio values to obtain
#' predicted depths. When `newdata` is a raster the result is a depth map.
#'
#' @param model A `satbathy_model` from [fit_bathymetry()].
#' @param ratio A single-layer [terra::SpatRaster] of ratio values (its layer
#'   is treated as the `ratio` predictor).
#'
#' @return A single-layer [terra::SpatRaster] named `"depth"`.
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' pts <- terra::vect(system.file("extdata", "example_points.gpkg",
#'                                package = "satbathy"))
#' img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
#' r   <- log_ratio(img)
#' fit <- fit_bathymetry(extract_ratio(r, pts), max_depth = -16)
#' depth_map <- predict_bathymetry(fit, r)
#'
#' @seealso [fit_bathymetry()]
#' @export
predict_bathymetry <- function(model, ratio) {
  if (!inherits(model, "satbathy_model")) {
    stop("`model` must be a `satbathy_model` from fit_bathymetry().",
         call. = FALSE)
  }
  ratio <- .as_rast(ratio)
  r <- ratio[[1]]
  names(r) <- "ratio"
  out <- terra::predict(r, model$model)
  names(out) <- "depth"
  out
}

#' Evaluate a bathymetry model against independent data
#'
#' Predicts depth for a test table and returns accuracy metrics.
#'
#' @param model A `satbathy_model` from [fit_bathymetry()].
#' @param newdata A `data.frame` with ratio and observed depth columns
#'   (e.g. from [extract_ratio()] on held-out points).
#' @param ratio,depth Column names for the ratio and observed depth in
#'   `newdata`. Default to `"ratio"` and `"depth"`.
#'
#' @return A one-row `data.frame` with columns `n`, `rmse` and `mae`.
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' pts <- terra::vect(system.file("extdata", "example_points.gpkg",
#'                                package = "satbathy"))
#' img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
#' tab <- extract_ratio(log_ratio(img), pts)
#' fit <- fit_bathymetry(tab, max_depth = -16)
#' evaluate_bathymetry(fit, tab)
#'
#' @seealso [rmse()], [mae()]
#' @export
evaluate_bathymetry <- function(model, newdata, ratio = "ratio",
                                depth = "depth") {
  if (!inherits(model, "satbathy_model")) {
    stop("`model` must be a `satbathy_model` from fit_bathymetry().",
         call. = FALSE)
  }
  if (!all(c(ratio, depth) %in% names(newdata))) {
    stop(sprintf("`newdata` must contain columns '%s' and '%s'.",
                 ratio, depth), call. = FALSE)
  }
  nd <- data.frame(ratio = as.numeric(newdata[[ratio]]))
  obs <- as.numeric(newdata[[depth]])
  pred <- as.numeric(stats::predict(model$model, newdata = nd))
  data.frame(n = sum(stats::complete.cases(obs, pred)),
             rmse = rmse(obs, pred),
             mae = mae(obs, pred))
}
