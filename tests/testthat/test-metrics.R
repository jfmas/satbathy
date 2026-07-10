test_that("rmse and mae match manual computation", {
  obs  <- c(-2, -5, -10, -15)
  pred <- c(-2.4, -4.6, -11, -14)
  err  <- obs - pred
  expect_equal(rmse(obs, pred), sqrt(mean(err^2)))
  expect_equal(mae(obs, pred),  mean(abs(err)))
})

test_that("na.rm drops incomplete pairs", {
  obs  <- c(-2, NA, -10)
  pred <- c(-2, -5, -11)
  expect_equal(rmse(obs, pred), sqrt(mean((c(-2, -10) - c(-2, -11))^2)))
})

test_that("metrics validate input length", {
  expect_error(rmse(1:3, 1:2), "same length")
})
