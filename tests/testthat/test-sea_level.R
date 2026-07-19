gauge <- data.frame(
  datetime = as.POSIXct("2025-04-28 13:00", tz = "UTC") + c(0, 600, 1200, 1800),
  nivel = c(5.50, 5.60, 5.80, 5.70)
)

test_that("interpolate_sea_level interpolates linearly", {
  # halfway between 5.50 (t0) and 5.60 (t0+600 s) -> 5.55
  t <- as.POSIXct("2025-04-28 13:05", tz = "UTC")
  expect_equal(interpolate_sea_level(t, gauge), 5.55)
})

test_that("exact times return the recorded level", {
  expect_equal(interpolate_sea_level(gauge$datetime, gauge), gauge$nivel)
})

test_that("it is vectorised and returns NA out of range", {
  t <- as.POSIXct(c("2025-04-28 12:00", "2025-04-28 13:15",
                    "2025-04-28 15:00"), tz = "UTC")
  out <- interpolate_sea_level(t, gauge)
  expect_length(out, 3)
  expect_true(is.na(out[1]))                 # before record
  expect_equal(out[2], 5.70)                 # 13:15 -> midpoint of 5.60 & 5.80
  expect_true(is.na(out[3]))                 # after record
})

test_that("unsorted input is handled", {
  shuffled <- gauge[c(3, 1, 4, 2), ]
  t <- as.POSIXct("2025-04-28 13:05", tz = "UTC")
  expect_equal(interpolate_sea_level(t, shuffled), 5.55)
})

test_that("missing columns raise an error", {
  expect_error(interpolate_sea_level(1, data.frame(a = 1)), "must contain")
})
