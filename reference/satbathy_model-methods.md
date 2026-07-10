# Methods for `satbathy_model` objects

Printing, summary, prediction and plotting methods for the model
returned by
[`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md).

## Usage

``` r
# S3 method for class 'satbathy_model'
print(x, ...)

# S3 method for class 'satbathy_model'
summary(object, ...)

# S3 method for class 'satbathy_model'
predict(object, newdata, ...)

# S3 method for class 'satbathy_model'
plot(x, ...)
```

## Arguments

- x, object:

  A `satbathy_model` from
  [`fit_bathymetry()`](https://jfmas.github.io/satbathy/reference/fit_bathymetry.md).

- ...:

  Passed on to the underlying method (e.g. graphical parameters for
  `plot`).

- newdata:

  A `data.frame` with a `ratio` column, or a single-layer
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of ratio values. If missing, in-sample fitted values are returned.

## Value

[`print()`](https://rdrr.io/r/base/print.html) returns `x` invisibly;
[`summary()`](https://rspatial.github.io/terra/reference/summary.html)
returns the `lm` summary;
[`predict()`](https://rspatial.github.io/terra/reference/predict.html)
returns a numeric vector (for a `data.frame`) or a
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(for a raster);
[`plot()`](https://rspatial.github.io/terra/reference/plot.html) returns
`NULL` invisibly.
