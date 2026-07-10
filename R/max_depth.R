#' Estimate the maximum reliable depth
#'
#' Determines how deep the log-ratio keeps a linear relationship with depth,
#' i.e. the maximum depth the satellite signal can resolve before it
#' saturates. The calibration is repeated for a decreasing sequence of
#' maximum-depth thresholds; for each threshold a linear model is fitted with
#' the points shallower than it and its goodness of fit is recorded. The
#' adjusted R-squared typically increases as more of the linear range is
#' included and then drops once saturated (too-deep) points are added,
#' revealing the usable depth limit.
#'
#' @param data A `data.frame` with ratio and depth columns, typically from
#'   [extract_ratio()].
#' @param depths Optional numeric vector of maximum-depth thresholds (negative
#'   values). If `NULL` (default) a sequence from `-10` down to the deepest
#'   observed point, in 1 m steps, is used.
#' @param min_n Minimum number of points required to fit a model at a given
#'   threshold. Thresholds with fewer points yield `NA` metrics. Defaults to
#'   `10`.
#' @param ratio,depth Column names in `data`. Default to `"ratio"`, `"depth"`.
#'
#' @return A `data.frame` with one row per threshold and columns
#'   `max_depth`, `n` (points used), `r2` (adjusted R-squared) and `rmse`
#'   (in-sample root-mean-square error).
#'
#' @examples
#' img <- terra::rast(system.file("extdata", "example_sr.tif",
#'                                package = "satbathy"))
#' pts <- terra::vect(system.file("extdata", "example_points.gpkg",
#'                                package = "satbathy"))
#' img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
#' tab <- extract_ratio(log_ratio(img), pts)
#' md <- optimal_max_depth(tab)
#' md[which.max(md$r2), ]
#'
#' @seealso [fit_bathymetry()]
#' @export
optimal_max_depth <- function(data, depths = NULL, min_n = 10,
                              ratio = "ratio", depth = "depth") {
  if (!all(c(ratio, depth) %in% names(data))) {
    stop(sprintf("`data` must contain columns '%s' and '%s'.", ratio, depth),
         call. = FALSE)
  }
  d <- data.frame(ratio = as.numeric(data[[ratio]]),
                  depth = as.numeric(data[[depth]]))
  d <- stats::na.omit(d)
  d <- d[d$depth < 0, , drop = FALSE]

  if (is.null(depths)) {
    depths <- seq(-10, floor(min(d$depth)), by = -1)
  }

  res <- lapply(depths, function(t) {
    sub <- d[d$depth > t, , drop = FALSE]
    if (nrow(sub) < min_n) {
      return(data.frame(max_depth = t, n = nrow(sub), r2 = NA_real_,
                        rmse = NA_real_))
    }
    fit <- stats::lm(depth ~ ratio, data = sub)
    pred <- stats::predict(fit)
    data.frame(max_depth = t,
               n = nrow(sub),
               r2 = summary(fit)$adj.r.squared,
               rmse = sqrt(mean((sub$depth - pred)^2)))
  })
  do.call(rbind, res)
}
