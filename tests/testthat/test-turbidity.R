test_that("turbidity_index computes (green + red) / blue", {
  r <- c(terra::rast(nrows = 2, ncols = 2, vals = 2),
         terra::rast(nrows = 2, ncols = 2, vals = 3),
         terra::rast(nrows = 2, ncols = 2, vals = 1))
  names(r) <- c("blue", "green", "red")
  ti <- turbidity_index(r)
  expect_s4_class(ti, "SpatRaster")
  expect_identical(names(ti), "turbidity")
  expect_equal(unname(terra::values(ti)[1, 1]), (3 + 1) / 2)
})

test_that("turbidity_index errors on a missing band", {
  r <- c(terra::rast(nrows = 2, ncols = 2, vals = 3),
         terra::rast(nrows = 2, ncols = 2, vals = 1))
  names(r) <- c("green", "red")
  expect_error(turbidity_index(r), "blue")
})

test_that("turbidity_index rejects non-raster input", {
  expect_error(turbidity_index(data.frame(a = 1)), "SpatRaster")
})
