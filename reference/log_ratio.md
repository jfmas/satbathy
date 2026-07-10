# Log-ratio transform (Stumpf et al. 2003)

Computes the log-ratio transform used to linearise the relationship
between satellite reflectance and water depth: \$\$R = \frac{\ln(n \cdot
R\_{blue})}{\ln(n \cdot R\_{green})}\$\$ where \\R\_{blue}\\ and
\\R\_{green}\\ are the reflectance of a high-penetration and a
lower-penetration band (typically blue and green), and \\n\\ is a fixed
constant chosen so that both logarithms stay positive. Because the more
strongly attenuated band changes faster with depth, the ratio increases
monotonically with depth over its valid range.

## Usage

``` r
log_ratio(x, blue = "blue", green = "green", n = 10000, trim = c(0.01, 0.99))
```

## Arguments

- x:

  A multi-band
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of surface reflectance. Non-water areas should be masked beforehand
  (see
  [`water_mask()`](https://jfmas.github.io/satbathy/reference/water_mask.md));
  cells with non-positive reflectance yield `NA`.

- blue, green:

  Band identifiers (layer names or integer indices) for the
  high-penetration (blue) and lower-penetration (green) bands.

- n:

  Fixed positive constant applied inside the logarithms, chosen so both
  logarithms stay positive. Defaults to `10000`. Stumpf et al. (2003)
  report the ratio to be insensitive to `n` (root-mean-square error
  changing by less than 0.4 m for `n` between 500 and 1500), as it only
  rescales the ratio, which is absorbed by the calibration coefficients.

- trim:

  Length-2 numeric vector of lower/upper probabilities used to trim
  outliers from the ratio: cells outside these quantiles are set to
  `NA`. Defaults to `c(0.01, 0.99)`. Use `NULL` to disable trimming.

## Value

A single-layer
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
named `"ratio"`.

## References

Stumpf RP, Holderied K, Sinclair M (2003). Determination of water depth
with high-resolution satellite imagery over variable bottom types.
Limnology and Oceanography 48(1, part 2):547-556.
[doi:10.4319/lo.2003.48.1_part_2.0547](https://doi.org/10.4319/lo.2003.48.1_part_2.0547)

## See also

[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md),
[`correct_glint()`](https://jfmas.github.io/satbathy/reference/correct_glint.md),
[`lowpass_filter()`](https://jfmas.github.io/satbathy/reference/lowpass_filter.md)

## Examples

``` r
img <- terra::rast(system.file("extdata", "example_sr.tif",
                               package = "satbathy"))
wm  <- water_mask(img, green = "green", nir = "nir")
img <- terra::mask(img, wm, maskvalues = c(FALSE, NA))
ratio <- log_ratio(img, blue = "blue", green = "green")
ratio
#> class       : SpatRaster
#> size        : 313, 196, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 423405, 429285, 2063355, 2072745  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 16N (EPSG:32616)
#> source(s)   : memory
#> varname     : example_sr
#> name        :    ratio
#> min value   : 0.776217
#> max value   : 1.701639
```
