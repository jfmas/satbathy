# Accuracy metrics for depth predictions

`rmse()` and `mae()` return the root-mean-square error and the mean
absolute error between observed and predicted depths.

## Usage

``` r
rmse(observed, predicted, na.rm = TRUE)

mae(observed, predicted, na.rm = TRUE)
```

## Arguments

- observed:

  Numeric vector of observed (in situ) depths.

- predicted:

  Numeric vector of predicted depths, the same length as `observed`.

- na.rm:

  Logical; if `TRUE` (default) pairs with a missing value in either
  vector are dropped before computing the metric.

## Value

A single numeric value.

## Details

\$\$RMSE = \sqrt{\frac{\sum (Z_o - Z_p)^2}{n}}, \qquad MAE = \frac{\sum
\|Z_o - Z_p\|}{n}\$\$

## See also

[`evaluate_bathymetry()`](https://jfmas.github.io/satbathy/reference/evaluate_bathymetry.md)

## Examples

``` r
obs  <- c(-2, -5, -10, -15)
pred <- c(-2.4, -4.6, -11, -14)
rmse(obs, pred)
#> [1] 0.7615773
mae(obs, pred)
#> [1] 0.7
```
