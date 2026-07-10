# Estimate the maximum reliable depth

Determines how deep the log-ratio keeps a linear relationship with
depth, i.e. the maximum depth the satellite signal can resolve before it
saturates. The calibration is repeated for a decreasing sequence of
maximum-depth thresholds; for each threshold a linear model is fitted
with the points shallower than it and its goodness of fit is recorded.
The adjusted R-squared typically increases as more of the linear range
is included and then drops once saturated (too-deep) points are added,
revealing the usable depth limit.

## Usage

``` r
optimal_max_depth(
  data,
  depths = NULL,
  min_n = 10,
  ratio = "ratio",
  depth = "depth"
)
```

## Arguments

- data:

  A `data.frame` with ratio and depth columns, typically from
  [`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md).

- depths:

  Optional numeric vector of maximum-depth thresholds (negative values).
  If `NULL` (default) a sequence from `-10` down to the deepest observed
  point, in 1 m steps, is used.

- min_n:

  Minimum number of points required to fit a model at a given threshold.
  Thresholds with fewer points yield `NA` metrics. Defaults to `10`.

- ratio, depth:

  Column names in `data`. Default to `"ratio"`, `"depth"`.

## Value

A `data.frame` with one row per threshold and columns `max_depth`, `n`
(points used), `r2` (adjusted R-squared) and `rmse` (in-sample
root-mean-square error).

## See also

[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
pts <- terra::vect(system.file("extdata", "example_points.gpkg",
                               package = "satbathy"))
img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
tab <- extract_ratio(log_ratio(img), pts)
md <- optimal_max_depth(tab)
md[which.max(md$r2), ]
#>    max_depth   n        r2     rmse
#> 10       -19 266 0.8510812 1.685461
```
