# Water mask from NDWI

Builds a logical water mask by thresholding the NDWI (see
[`ndwi()`](https://jfmas.github.io/satbathy/reference/ndwi.md)). Pixels
with `NDWI > threshold` are flagged as water (`TRUE`).

## Usage

``` r
water_mask(x, green = "green", nir = "nir", threshold = 0)
```

## Arguments

- x:

  A multi-band
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of surface reflectance.

- green, nir:

  Band identifiers (layer names or integer indices) for the green and
  near-infrared bands of `x`.

- threshold:

  Numeric NDWI threshold above which a pixel is considered water.
  Defaults to `0`.

## Value

A single-layer logical
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
named `"water"` (`TRUE` for water, `FALSE` otherwise).

## See also

[`ndwi()`](https://jfmas.github.io/satbathy/reference/ndwi.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
wm <- water_mask(img, green = "green", nir = "nir", threshold = 0)
# keep only water pixels of the image:
water_only <- terra::mask(img, wm, maskvalues = c(FALSE, NA))
```
