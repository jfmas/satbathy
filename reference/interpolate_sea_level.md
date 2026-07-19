# Interpolate tide-gauge sea level at arbitrary times

Linearly interpolates a tide-gauge sea-level record at one or more
target times. This is used to normalise in situ echo-sounder depths to a
common datum: each sounding is referred to the sea level measured by the
tide gauge at the moment it was taken, removing the effect of the tide
between and during survey dates.

## Usage

``` r
interpolate_sea_level(
  target_time,
  df,
  time_col = "datetime",
  level_col = "nivel"
)
```

## Arguments

- target_time:

  Time(s) at which to interpolate the sea level. Numeric, `Date`, or
  `POSIXct`; a vector is processed in one call.

- df:

  A `data.frame` holding the tide-gauge record.

- time_col, level_col:

  Names of the columns in `df` with the measurement time and the sea
  level. Default to `"datetime"` and `"nivel"`.

## Value

A numeric vector, the same length as `target_time`, with the
interpolated sea level (`NA` outside the record's time range).

## Details

The function is a thin, vectorised wrapper around
[`stats::approx()`](https://rdrr.io/r/stats/approxfun.html) with
`rule = 1`, so target times outside the range of the record return `NA`.

## See also

[`extract_ratio()`](https://jfmas.github.io/satbathy/reference/extract_ratio.md),
[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md)

## Examples

``` r
gauge <- data.frame(
  datetime = as.POSIXct("2025-04-28 13:00", tz = "UTC") +
    c(0, 600, 1200, 1800),
  nivel = c(5.57, 5.58, 5.60, 5.59)
)
# sea level at two sounding times
times <- as.POSIXct(c("2025-04-28 13:05", "2025-04-28 13:25"), tz = "UTC")
interpolate_sea_level(times, gauge)
#> [1] 5.575 5.595
```
