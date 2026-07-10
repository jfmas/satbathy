# Extract ratio values at in situ depth points

Builds the modelling table used to calibrate the bathymetry model by
extracting the log-ratio value (see
[`log_ratio()`](https://jfmas.github.io/satbathy/reference/log_ratio.md))
at each in situ bathymetric point and pairing it with the measured
depth.

## Usage

``` r
extract_ratio(ratio, points, depth_field = "depth")
```

## Arguments

- ratio:

  A single-layer
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of ratio values.

- points:

  In situ bathymetric points, either a
  [terra::SpatVector](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  or an `sf` object of points. Reprojected to the CRS of `ratio` if
  needed.

- depth_field:

  Name of the attribute in `points` holding the measured depth (negative
  below the surface). Defaults to `"depth"`.

## Value

A `data.frame` with columns `ratio` and `depth`, with rows containing
missing values removed.

## See also

[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
pts <- terra::vect(system.file("extdata", "example_points.gpkg",
                               package = "satbathy"))
wm  <- water_mask(img)
img <- terra::mask(img, wm, maskvalues = c(FALSE, NA))
ratio <- log_ratio(img)
tab <- extract_ratio(ratio, pts, depth_field = "depth")
head(tab)
#>       ratio       depth
#> 1 1.2292454 -187.000000
#> 2 1.0426425   -4.696015
#> 3 1.0446726   -4.245674
#> 4 1.0613218   -8.109966
#> 5 1.1346521  -10.282619
#> 6 0.8834699   -3.500000
```
