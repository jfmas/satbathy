# Normalized Difference Water Index (NDWI)

Computes McFeeters' Normalized Difference Water Index,
`(green - nir) / (green + nir)`. Water typically yields positive values
while land and clouds yield negative values, so the NDWI is a convenient
basis for building a water mask when a sensor quality band is not
available (e.g. PlanetScope imagery).

## Usage

``` r
ndwi(x, green = "green", nir = "nir")
```

## Arguments

- x:

  A multi-band
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of surface reflectance.

- green, nir:

  Band identifiers (layer names or integer indices) for the green and
  near-infrared bands of `x`.

## Value

A single-layer
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
named `"ndwi"`.

## References

McFeeters SK (1996). The use of the Normalized Difference Water Index
(NDWI) in the delineation of open water features. International Journal
of Remote Sensing 17(7):1425-1432.

## See also

[`water_mask()`](https://jfmas.github.io/satbathy/reference/water_mask.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
ndwi(img, green = "green", nir = "nir")
#> class       : SpatRaster
#> size        : 313, 196, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 423405, 429285, 2063355, 2072745  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 16N (EPSG:32616)
#> source(s)   : memory
#> varname     : example_sr
#> name        :        ndwi
#> min value   : -125.438593
#> max value   :  125.763004
```
