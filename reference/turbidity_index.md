# Turbidity index (Frohn and Autrey 2009)

Computes the band-ratio turbidity index of Frohn and Autrey (2009),
defined as `(green + red) / blue`. Higher values indicate more turbid
water. It is useful for selecting the least turbid image dates before
deriving bathymetry, because the empirical ratio transform performs best
in clear water.

## Usage

``` r
turbidity_index(x, blue = "blue", green = "green", red = "red")
```

## Arguments

- x:

  A multi-band
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of surface reflectance.

- blue, green, red:

  Band identifiers (layer names or integer indices) for the blue, green
  and red bands of `x`.

## Value

A single-layer
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
named `"turbidity"`.

## References

Frohn RC, Autrey BC (2009). Water quality assessment in the Ohio River
using new indices for turbidity and chlorophyll-a with Landsat-7
imagery. Draft Internal Report, U.S. Environmental Protection Agency.

## See also

[`ndwi()`](https://jfmas.github.io/satbathy/reference/ndwi.md),
[`log_ratio()`](https://jfmas.github.io/satbathy/reference/log_ratio.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
turb <- turbidity_index(img, blue = "blue", green = "green", red = "red")
turb
#> class       : SpatRaster
#> size        : 313, 196, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 423405, 429285, 2063355, 2072745  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 16N (EPSG:32616)
#> source(s)   : memory
#> varname     : example_sr
#> name        :   turbidity
#> min value   : -467.441558
#> max value   : 2862.661795
```
