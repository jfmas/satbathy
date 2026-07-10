# Sun-glint correction (Hedley et al. 2005)

Removes sun-glint from visible bands using the image-based method of
Hedley et al. (2005). For each visible band, a linear regression against
the near-infrared (NIR) band is fitted over a deep-water sample, where
the bottom contribution is assumed negligible and NIR reflectance is due
to glint alone. The band is then corrected as
`band - slope * (NIR - min_NIR)`, where `min_NIR` is the glint-free NIR
reflectance estimated as a low quantile of NIR over deep water.

## Usage

``` r
correct_glint(
  x,
  vis_bands = c("blue", "green"),
  nir_band = "nir",
  deep_mask,
  n_sample = 500,
  prob = 0.01
)
```

## Arguments

- x:

  A multi-band
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of surface reflectance.

- vis_bands:

  Band identifiers (layer names or integer indices) of the visible bands
  to correct, e.g. `c("blue", "green")`.

- nir_band:

  Band identifier of the near-infrared band.

- deep_mask:

  A
  [terra::SpatVector](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  (or SpatRaster) delimiting optically deep water, used to sample glint
  and estimate `min_NIR`. Reprojected to the CRS of `x` if necessary.

- n_sample:

  Number of random deep-water pixels used to fit each regression.
  Defaults to `500`.

- prob:

  Lower quantile of NIR over deep water used to estimate the glint-free
  NIR reflectance (`min_NIR`). Defaults to `0.01`.

## Value

A copy of `x` in which the layers named in `vis_bands` have been
glint-corrected. If the deep-water sample is too small to fit the
regressions, `x` is returned unchanged with a warning.

## References

Hedley JD, Harborne AR, Mumby PJ (2005). Technical note: Simple and
robust removal of sun glint for mapping shallow-water benthos.
International Journal of Remote Sensing 26(10):2107-2112.
[doi:10.1080/01431160500034086](https://doi.org/10.1080/01431160500034086)

## See also

[`log_ratio()`](https://jfmas.github.io/satbathy/reference/log_ratio.md),
[`lowpass_filter()`](https://jfmas.github.io/satbathy/reference/lowpass_filter.md)

## Examples

``` r
img  <- terra::rast(system.file("extdata", "example_sr.tif",
                                package = "satbathy"))
deep <- terra::vect(system.file("extdata", "example_deepmask.gpkg",
                                package = "satbathy"))
corrected <- correct_glint(img, vis_bands = c("blue", "green"),
                           nir_band = "nir", deep_mask = deep)
```
