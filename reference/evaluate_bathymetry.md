# Evaluate a bathymetry model against independent data

Predicts depth for a test table and returns accuracy metrics.

## Usage

``` r
evaluate_bathymetry(model, newdata, ratio = "ratio", depth = "depth")
```

## Arguments

- model:

  A `satbathy_model` from
  [`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md).

- newdata:

  A `data.frame` with ratio and observed depth columns (e.g. from
  [`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md)
  on held-out points).

- ratio, depth:

  Column names for the ratio and observed depth in `newdata`. Default to
  `"ratio"` and `"depth"`.

## Value

A one-row `data.frame` with columns `n`, `rmse` and `mae`.

## See also

[`rmse()`](https://jfmas.github.io/satbathy/reference/accuracy.md),
[`mae()`](https://jfmas.github.io/satbathy/reference/accuracy.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
pts <- terra::vect(system.file("extdata", "example_points.gpkg",
                               package = "satbathy"))
img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
tab <- extract_ratio(log_ratio(img), pts)
fit <- fit_bathymetry(tab, max_depth = -16)
evaluate_bathymetry(fit, tab)
#>     n     rmse      mae
#> 1 378 65.26401 31.87794
```
