make_bg <- function(blue, green) {
  r <- c(terra::rast(nrows = 1, ncols = length(blue), vals = blue),
         terra::rast(nrows = 1, ncols = length(green), vals = green))
  names(r) <- c("blue", "green")
  r
}

test_that("log_ratio matches the Stumpf formula", {
  r <- make_bg(c(0.1, 0.2, 0.3), c(0.2, 0.2, 0.2))
  out <- log_ratio(r, n = 10000, trim = NULL)
  expect_identical(names(out), "ratio")
  expect_equal(
    as.numeric(terra::values(out)),
    log(10000 * c(0.1, 0.2, 0.3)) / log(10000 * c(0.2, 0.2, 0.2))
  )
})

test_that("log_ratio trims outliers to NA", {
  r <- make_bg(seq(0.05, 0.5, length.out = 100), rep(0.2, 100))
  untrimmed <- log_ratio(r, trim = NULL)
  trimmed   <- log_ratio(r, trim = c(0.01, 0.99))
  expect_gt(sum(is.na(terra::values(trimmed))),
            sum(is.na(terra::values(untrimmed))))
})

test_that("log_ratio validates n and trim", {
  r <- make_bg(0.1, 0.2)
  expect_error(log_ratio(r, n = -1), "positive")
  expect_error(log_ratio(r, trim = 0.5), "length-2")
})
