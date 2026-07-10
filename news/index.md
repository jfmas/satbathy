# Changelog

## satbathy 0.0.0.9000

- Initial development version. Core functionality:
  - [`turbidity_index()`](https://jfmas.github.io/satbathy/reference/turbidity_index.md)
    — turbidity index of Frohn & Autrey (2009) for selecting the least
    turbid image dates.
  - [`ndwi()`](https://jfmas.github.io/satbathy/reference/ndwi.md) /
    [`water_mask()`](https://jfmas.github.io/satbathy/reference/water_mask.md)
    — NDWI water masking (McFeeters 1996).
  - [`correct_glint()`](https://jfmas.github.io/satbathy/reference/correct_glint.md)
    — sun-glint correction (Hedley et al. 2005).
  - [`lowpass_filter()`](https://jfmas.github.io/satbathy/reference/lowpass_filter.md)
    — low-pass spatial filter.
  - [`log_ratio()`](https://jfmas.github.io/satbathy/reference/log_ratio.md)
    — log-ratio transform (Stumpf et al. 2003).
  - [`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md),
    [`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md),
    [`predict_bathymetry()`](https://jfmas.github.io/satbathy/reference/predict_bathymetry.md),
    [`evaluate_bathymetry()`](https://jfmas.github.io/satbathy/reference/evaluate_bathymetry.md)
    — model calibration, prediction and assessment, with an S3
    `satbathy_model` class (`print`/`summary`/`predict`/`plot`).
  - [`optimal_max_depth()`](https://jfmas.github.io/satbathy/reference/optimal_max_depth.md)
    — iterative estimation of the maximum reliable depth
    (signal-saturation analysis).
  - [`rmse()`](https://jfmas.github.io/satbathy/reference/accuracy.md) /
    [`mae()`](https://jfmas.github.io/satbathy/reference/accuracy.md) —
    accuracy metrics.
- Bundled Mahahual (Mexican Caribbean) example dataset in
  `inst/extdata`.
