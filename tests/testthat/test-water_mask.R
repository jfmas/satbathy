test_that("ndwi computes (green - nir) / (green + nir)", {
  r <- c(terra::rast(nrows = 1, ncols = 2, vals = c(0.3, 0.1)),
         terra::rast(nrows = 1, ncols = 2, vals = c(0.1, 0.3)))
  names(r) <- c("green", "nir")
  wi <- ndwi(r)
  expect_identical(names(wi), "ndwi")
  expect_equal(as.numeric(terra::values(wi)),
               c((0.3 - 0.1) / (0.3 + 0.1), (0.1 - 0.3) / (0.1 + 0.3)))
})

test_that("water_mask thresholds ndwi", {
  r <- c(terra::rast(nrows = 1, ncols = 2, vals = c(0.3, 0.1)),
         terra::rast(nrows = 1, ncols = 2, vals = c(0.1, 0.3)))
  names(r) <- c("green", "nir")
  wm <- water_mask(r, threshold = 0)
  expect_identical(names(wm), "water")
  expect_equal(as.logical(terra::values(wm)), c(TRUE, FALSE))
})
