#' Accuracy metrics for depth predictions
#'
#' `rmse()` and `mae()` return the root-mean-square error and the mean
#' absolute error between observed and predicted depths.
#'
#' @param observed Numeric vector of observed (in situ) depths.
#' @param predicted Numeric vector of predicted depths, the same length as
#'   `observed`.
#' @param na.rm Logical; if `TRUE` (default) pairs with a missing value in
#'   either vector are dropped before computing the metric.
#'
#' @return A single numeric value.
#'
#' @details
#' \deqn{RMSE = \sqrt{\frac{\sum (Z_o - Z_p)^2}{n}}, \qquad
#'       MAE  = \frac{\sum |Z_o - Z_p|}{n}}
#'
#' @examples
#' obs  <- c(-2, -5, -10, -15)
#' pred <- c(-2.4, -4.6, -11, -14)
#' rmse(obs, pred)
#' mae(obs, pred)
#'
#' @seealso [evaluate_bathymetry()]
#' @name accuracy
NULL

#' @rdname accuracy
#' @export
rmse <- function(observed, predicted, na.rm = TRUE) {
  d <- .clean_pairs(observed, predicted, na.rm)
  sqrt(mean((d$observed - d$predicted)^2))
}

#' @rdname accuracy
#' @export
mae <- function(observed, predicted, na.rm = TRUE) {
  d <- .clean_pairs(observed, predicted, na.rm)
  mean(abs(d$observed - d$predicted))
}

#' @noRd
.clean_pairs <- function(observed, predicted, na.rm) {
  if (length(observed) != length(predicted)) {
    stop("`observed` and `predicted` must have the same length.", call. = FALSE)
  }
  if (na.rm) {
    keep <- stats::complete.cases(observed, predicted)
    observed  <- observed[keep]
    predicted <- predicted[keep]
  }
  if (length(observed) == 0L) {
    stop("No complete observed/predicted pairs to compare.", call. = FALSE)
  }
  list(observed = observed, predicted = predicted)
}
