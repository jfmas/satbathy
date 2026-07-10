# Low-pass spatial filter

Applies a low-pass (moving-average) spatial filter to every layer of a
raster, replacing each cell with the mean of its neighbourhood. This
smooths the speckle caused by residual glint and water-surface roughness
before computing the ratio transform. It is a thin, documented wrapper
around
[`terra::focal()`](https://rspatial.github.io/terra/reference/focal.html).

## Usage

``` r
lowpass_filter(x, w = 3)
```

## Arguments

- x:

  A
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html).

- w:

  Neighbourhood size passed to
  [`terra::focal()`](https://rspatial.github.io/terra/reference/focal.html).
  A single odd integer gives a `w x w` window (default `3`, i.e. a 3x3
  mean).

## Value

A
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
with the same layers as `x`, smoothed.

## See also

[`correct_glint()`](https://jfmas.github.io/satbathy/reference/correct_glint.md),
[`log_ratio()`](https://jfmas.github.io/satbathy/reference/log_ratio.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
smoothed <- lowpass_filter(img[["blue"]], w = 3)
```
