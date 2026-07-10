# Fit an empirical bathymetry model

Fits the empirical linear model relating depth to the log-ratio, \\Z =
m_1 R - m_0\\ (Stumpf et al. 2003), by ordinary least squares.
Optionally restricts the calibration to points shallower than a maximum
depth, since the ratio saturates and departs from linearity beyond the
penetration limit (see
[`optimal_max_depth()`](https://jfmas.github.io/satbathy/reference/optimal_max_depth.md)).

## Usage

``` r
fit_bathymetry(data, ratio = "ratio", depth = "depth", max_depth = NULL)
```

## Arguments

- data:

  A `data.frame` with the ratio and depth columns, typically the output
  of
  [`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md).

- ratio, depth:

  Column names in `data` for the ratio and the measured depth. Default
  to `"ratio"` and `"depth"`.

- max_depth:

  Optional maximum depth (a negative number). Only points with
  `depth > max_depth` (and `depth < 0`) are used for calibration. If
  `NULL` (default) all rows with `depth < 0` are used.

## Value

An object of class `satbathy_model`: a list with the fitted `lm`
(`model`), the `data` actually used, the `max_depth` threshold, the
adjusted R-squared (`r.squared`), the number of points (`n`) and the
`call`.

## References

Stumpf RP, Holderied K, Sinclair M (2003). Determination of water depth
with high-resolution satellite imagery over variable bottom types.
Limnology and Oceanography 48(1, part 2):547-556.
[doi:10.4319/lo.2003.48.1_part_2.0547](https://doi.org/10.4319/lo.2003.48.1_part_2.0547)

## See also

[`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md),
[`predict_bathymetry()`](https://jfmas.github.io/satbathy/reference/predict_bathymetry.md),
[`optimal_max_depth()`](https://jfmas.github.io/satbathy/reference/optimal_max_depth.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
pts <- terra::vect(system.file("extdata", "example_points.gpkg",
                               package = "satbathy"))
img <- terra::mask(img, water_mask(img), maskvalues = c(FALSE, NA))
tab <- extract_ratio(log_ratio(img), pts)
fit <- fit_bathymetry(tab, max_depth = -16)
fit
#> <satbathy_model>
#>   depth = 36.43 + -41.53 * ratio
#>   points: 259   (max_depth = -16 m)
#>   adjusted R-squared: 0.840
```
