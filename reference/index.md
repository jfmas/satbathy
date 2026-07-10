# Package index

## Image preprocessing

Prepare surface-reflectance imagery before the ratio transform.

- [`turbidity_index()`](https://jfmas.github.io/satbathy/reference/turbidity_index.md)
  : Turbidity index (Frohn and Autrey 2009)
- [`ndwi()`](https://jfmas.github.io/satbathy/reference/ndwi.md) :
  Normalized Difference Water Index (NDWI)
- [`water_mask()`](https://jfmas.github.io/satbathy/reference/water_mask.md)
  : Water mask from NDWI
- [`correct_glint()`](https://jfmas.github.io/satbathy/reference/correct_glint.md)
  : Sun-glint correction (Hedley et al. 2005)
- [`lowpass_filter()`](https://jfmas.github.io/satbathy/reference/lowpass_filter.md)
  : Low-pass spatial filter

## Ratio transform and modelling

The empirical log-ratio transform, calibration and prediction.

- [`log_ratio()`](https://jfmas.github.io/satbathy/reference/log_ratio.md)
  : Log-ratio transform (Stumpf et al. 2003)
- [`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md)
  : Extract ratio values at in situ depth points
- [`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md)
  : Fit an empirical bathymetry model
- [`predict_bathymetry()`](https://jfmas.github.io/satbathy/reference/predict_bathymetry.md)
  : Predict depth from a ratio raster or table
- [`optimal_max_depth()`](https://jfmas.github.io/satbathy/reference/optimal_max_depth.md)
  : Estimate the maximum reliable depth

## Accuracy assessment

- [`rmse()`](https://jfmas.github.io/satbathy/reference/accuracy.md)
  [`mae()`](https://jfmas.github.io/satbathy/reference/accuracy.md) :
  Accuracy metrics for depth predictions
- [`evaluate_bathymetry()`](https://jfmas.github.io/satbathy/reference/evaluate_bathymetry.md)
  : Evaluate a bathymetry model against independent data

## Model methods

- [`print(`*`<satbathy_model>`*`)`](https://jfmas.github.io/satbathy/reference/satbathy_model-methods.md)
  [`summary(`*`<satbathy_model>`*`)`](https://jfmas.github.io/satbathy/reference/satbathy_model-methods.md)
  [`predict(`*`<satbathy_model>`*`)`](https://jfmas.github.io/satbathy/reference/satbathy_model-methods.md)
  [`plot(`*`<satbathy_model>`*`)`](https://jfmas.github.io/satbathy/reference/satbathy_model-methods.md)
  :

  Methods for `satbathy_model` objects
