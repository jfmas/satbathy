# satbathy

**satbathy** derives bathymetry (water depth) in shallow, low-turbidity
coastal waters from multispectral satellite imagery — such as Landsat
8/9, Sentinel-2 and PlanetScope/SuperDove — using the empirical
log-ratio transform of [Stumpf, Holderied and Sinclair
(2003)](https://doi.org/10.4319/lo.2003.48.1_part_2.0547).

The package covers the full empirical workflow: turbidity indexing to
select clear-water dates, water masking, sun-glint correction, spatial
filtering, the log-ratio transform, linear model calibration and
prediction, iterative estimation of the maximum reliable depth, and
accuracy assessment.

## Installation

Install the development version from GitHub:

``` r
# install.packages("pak")
pak::pak("jfmas/satbathy")
```

## Quick start

``` r
library(satbathy)
library(terra)

# Bundled Mahahual (Mexican Caribbean) example
img <- rast(system.file("extdata", "example_sr.tif",  package = "satbathy"))
pts <- vect(system.file("extdata", "example_points.gpkg", package = "satbathy"))

# 1. Mask land/clouds, keep water only
img <- mask(img, water_mask(img), maskvalues = c(FALSE, NA))

# 2. Log-ratio transform (Stumpf et al. 2003)
ratio <- log_ratio(img, blue = "blue", green = "green")

# 3. Calibrate against in situ depths
tab <- extract_ratio(ratio, pts, depth_field = "depth")

# 4. Find the maximum depth the signal resolves, then fit
md  <- optimal_max_depth(tab)
fit <- fit_bathymetry(tab, max_depth = md$max_depth[which.max(md$r2)])
fit
#> <satbathy_model>
#>   depth = ... + ... * ratio

# 5. Predict a depth map and assess accuracy
depth_map <- predict_bathymetry(fit, ratio)
evaluate_bathymetry(fit, tab)
```

## Method

The log-ratio transform linearises the reflectance–depth relationship as

    R = ln(n * R_blue) / ln(n * R_green)

which is then related to depth by a simple linear model
`Z = m1 * R - m0` calibrated with in situ soundings. Because the more
strongly attenuated band saturates first, the ratio only tracks depth up
to a penetration limit;
[`optimal_max_depth()`](https://jfmas.github.io/satbathy/reference/optimal_max_depth.md)
locates that limit so the model is fitted over its valid range.

## Citation

If you use **satbathy**, please cite Stumpf et al. (2003) for the
underlying method, and:

> Mas JF, Pérez Vega A. Empirical bathymetry with satellite images.

## License

MIT © Jean François Mas and Azucena Pérez Vega.
