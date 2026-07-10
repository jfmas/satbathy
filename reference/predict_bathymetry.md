# Predict depth from a ratio raster or table

Applies a fitted
[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md)
model to new ratio values to obtain predicted depths. When `newdata` is
a raster the result is a depth map.

## Usage

``` r
predict_bathymetry(model, ratio)
```

## Arguments

- model:

  A `satbathy_model` from
  [`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md).

- ratio:

  A single-layer
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of ratio values (its layer is treated as the `ratio` predictor).

## Value

A single-layer
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
named `"depth"`.

## See also

[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
pts <- terra::vect(system.file("extdata", "example_points.gpkg",
                               package = "satbathy"))
img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
r   <- log_ratio(img)
fit <- fit_bathymetry(extract_ratio(r, pts), max_depth = -16)
depth_map <- predict_bathymetry(fit, r)
```
