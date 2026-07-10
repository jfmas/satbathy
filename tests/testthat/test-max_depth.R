test_that("optimal_max_depth returns a table over thresholds", {
  set.seed(2)
  ratio <- runif(300, 0.9, 1.2)
  depth <- 40 - 42 * ratio + stats::rnorm(300, sd = 0.5)
  tab <- data.frame(ratio = ratio, depth = depth)

  md <- optimal_max_depth(tab, depths = c(-8, -12, -16, -20))
  expect_named(md, c("max_depth", "n", "r2", "rmse"))
  expect_equal(nrow(md), 4)
  expect_true(all(md$r2[!is.na(md$r2)] <= 1))
})

test_that("thresholds with too few points yield NA metrics", {
  tab <- data.frame(ratio = c(1, 1.1, 1.2), depth = c(-2, -5, -8))
  md <- optimal_max_depth(tab, depths = -6, min_n = 10)
  expect_true(is.na(md$r2))
})
