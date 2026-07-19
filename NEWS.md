# satbathy 0.0.0.9000

* Initial development version. Core functionality:
  - `turbidity_index()` — turbidity index of Frohn & Autrey (2009) for
    selecting the least turbid image dates.
  - `ndwi()` / `water_mask()` — NDWI water masking (McFeeters 1996).
  - `correct_glint()` — sun-glint correction (Hedley et al. 2005).
  - `lowpass_filter()` — low-pass spatial filter.
  - `log_ratio()` — log-ratio transform (Stumpf et al. 2003).
  - `extract_ratio()`, `fit_bathymetry()`, `predict_bathymetry()`,
    `evaluate_bathymetry()` — model calibration, prediction and assessment,
    with an S3 `satbathy_model` class (`print`/`summary`/`predict`/`plot`).
  - `optimal_max_depth()` — iterative estimation of the maximum reliable
    depth (signal-saturation analysis).
  - `rmse()` / `mae()` — accuracy metrics.
  - `interpolate_sea_level()` — tide-gauge sea-level interpolation to
    normalise in situ soundings to a common datum.
* Bundled Mahahual (Mexican Caribbean) example dataset in `inst/extdata`.
