#' Methods for `satbathy_model` objects
#'
#' Printing, summary, prediction and plotting methods for the model returned
#' by [fit_bathymetry()].
#'
#' @param x,object A `satbathy_model` from [fit_bathymetry()].
#' @param newdata A `data.frame` with a `ratio` column, or a single-layer
#'   [terra::SpatRaster] of ratio values. If missing, in-sample fitted values
#'   are returned.
#' @param ... Passed on to the underlying method (e.g. graphical parameters
#'   for `plot`).
#'
#' @return
#' `print()` returns `x` invisibly; `summary()` returns the `lm` summary;
#' `predict()` returns a numeric vector (for a `data.frame`) or a
#' [terra::SpatRaster] (for a raster); `plot()` returns `NULL` invisibly.
#'
#' @name satbathy_model-methods
NULL

#' @rdname satbathy_model-methods
#' @export
print.satbathy_model <- function(x, ...) {
  co <- stats::coef(x$model)
  cat("<satbathy_model>\n")
  cat(sprintf("  depth = %.4g + %.4g * ratio\n", co[[1]], co[[2]]))
  cat(sprintf("  points: %d", x$n))
  if (!is.null(x$max_depth)) {
    cat(sprintf("   (max_depth = %g m)", x$max_depth))
  }
  cat(sprintf("\n  adjusted R-squared: %.3f\n", x$r.squared))
  invisible(x)
}

#' @rdname satbathy_model-methods
#' @export
summary.satbathy_model <- function(object, ...) {
  summary(object$model)
}

#' @rdname satbathy_model-methods
#' @export
predict.satbathy_model <- function(object, newdata, ...) {
  if (missing(newdata)) {
    return(as.numeric(stats::predict(object$model)))
  }
  if (inherits(newdata, "SpatRaster")) {
    return(predict_bathymetry(object, newdata))
  }
  nd <- data.frame(ratio = as.numeric(newdata[["ratio"]]))
  as.numeric(stats::predict(object$model, newdata = nd, ...))
}

#' @rdname satbathy_model-methods
#' @export
plot.satbathy_model <- function(x, ...) {
  d <- x$data
  plot(d$ratio, d$depth, xlab = "Ratio", ylab = "Depth (m)",
       pch = 21, col = "#1f4e79", bg = "#9dc3e6", ...)
  graphics::abline(x$model, col = "red", lwd = 2)
  if (!is.null(x$max_depth)) {
    graphics::abline(h = x$max_depth, lty = 2, col = "grey40")
  }
  graphics::legend("topright",
                   legend = sprintf("R2 = %.3f", x$r.squared), bty = "n")
  invisible(NULL)
}
