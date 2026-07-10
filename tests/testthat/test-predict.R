test_that("predict_bathymetry returns a depth raster", {
  set.seed(3)
  tab <- data.frame(ratio = runif(100, 0.9, 1.2))
  tab$depth <- 40 - 42 * tab$ratio + stats::rnorm(100, sd = 0.5)
  fit <- fit_bathymetry(tab)

  ratio <- terra::rast(nrows = 4, ncols = 4, vals = runif(16, 0.9, 1.2))
  names(ratio) <- "ratio"
  dm <- predict_bathymetry(fit, ratio)
  expect_s4_class(dm, "SpatRaster")
  expect_identical(names(dm), "depth")
  expect_equal(terra::ncell(dm), 16)
})

test_that("predict_bathymetry rejects a non-model", {
  ratio <- terra::rast(nrows = 2, ncols = 2, vals = 1)
  expect_error(predict_bathymetry(list(), ratio), "satbathy_model")
})

test_that("integration: example data yields a plausible fit", {
  skip_if_not(nzchar(system.file("extdata", "example_sr.tif",
                                 package = "satbathy")))
  img <- terra::rast(system.file("extdata", "example_sr.tif",
                                 package = "satbathy"))
  pts <- terra::vect(system.file("extdata", "example_points.gpkg",
                                 package = "satbathy"))
  img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
  tab <- extract_ratio(log_ratio(img), pts)
  fit <- fit_bathymetry(tab, max_depth = -16)
  expect_gt(fit$r.squared, 0.6)
  expect_true(all(fit$data$depth > -16))
})
