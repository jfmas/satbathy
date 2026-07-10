make_tab <- function(n = 200, seed = 1) {
  set.seed(seed)
  depth <- stats::runif(n, -25, -1)              # all negative depths
  ratio <- 1.10 + depth / 50 + stats::rnorm(n, sd = 0.01)
  data.frame(ratio = ratio, depth = depth)
}

test_that("fit_bathymetry recovers the linear relationship", {
  tab <- make_tab()
  fit <- fit_bathymetry(tab)
  expect_s3_class(fit, "satbathy_model")
  co <- stats::coef(fit$model)
  expect_equal(unname(co), unname(stats::coef(stats::lm(depth ~ ratio, tab))))
  expect_gt(fit$r.squared, 0.9)
})

test_that("max_depth restricts calibration points", {
  tab <- make_tab()
  fit_all <- fit_bathymetry(tab)
  fit_lim <- fit_bathymetry(tab, max_depth = -10)
  expect_lt(fit_lim$n, fit_all$n)
  expect_true(all(fit_lim$data$depth > -10))
})

test_that("fit_bathymetry errors with too few points", {
  expect_error(fit_bathymetry(data.frame(ratio = 1, depth = -1)),
               "Fewer than 3")
})

test_that("predict on a data.frame returns numeric predictions", {
  fit <- fit_bathymetry(make_tab())
  p <- stats::predict(fit, newdata = data.frame(ratio = c(1.0, 1.1)))
  expect_type(p, "double")
  expect_length(p, 2)
})

test_that("evaluate_bathymetry returns metrics", {
  tab <- make_tab()
  fit <- fit_bathymetry(tab)
  ev <- evaluate_bathymetry(fit, tab)
  expect_named(ev, c("n", "rmse", "mae"))
  expect_gt(ev$n, 0)
})
