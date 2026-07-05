test_that("non-data.frame input is rejected", {
  expect_error(
    CopRegML_par(Y ~ x, index = c("pan", "year"), data = as.matrix(mtcars)),
    "Data must be data.frame"
  )
})

test_that("index argument is validated", {
  d <- simulate_test_panel(N = 5, Ti = 3)
  expect_error(
    CopRegML_par(Yb ~ x, index = c(1, 2), data = d),
    "character vector of length two"
  )
  expect_error(
    CopRegML_par(Yb ~ x, index = "pan", data = d),
    "character vector of length two"
  )
  expect_error(
    CopRegML_par(Yb ~ x, index = c("id", "year"), data = d),
    "index columns are missing in the data: id"
  )
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "period"), data = d),
    "index columns are missing in the data: period"
  )
})

test_that("non-numeric panel and time identifiers are rejected", {
  d <- simulate_test_panel(N = 5, Ti = 3)
  d1 <- d
  d1$pan <- paste0("firm", d1$pan)
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d1),
    "Panel identifier 'pan' must be numeric"
  )
  d2 <- d
  d2$year <- factor(d2$year)
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d2),
    "Time identifier 'year' must be numeric"
  )
})

test_that("too few time periods are rejected", {
  d <- simulate_test_panel(N = 10, Ti = 3)
  d1 <- d[d$year == 1, ]
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d1),
    "Too few time periods"
  )
})

test_that("variables missing from the data are reported", {
  d <- simulate_test_panel(N = 5, Ti = 3)
  expect_error(
    CopRegML_par(Yb ~ nope, index = c("pan", "year"), data = d),
    "variables are missing in the data: nope"
  )
  expect_error(
    CopRegML_par(Y ~ x | gone - 1, index = c("pan", "year"), data = d),
    "variables are missing in the data: gone"
  )
})

test_that("singular designs are rejected with a clear error", {
  d <- simulate_test_panel(N = 20, Ti = 5)
  # time-invariant endogenous regressor (one-part formula)
  d1 <- d
  d1$x <- rep(stats::runif(20), each = 5)
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d1),
    "rank deficient"
  )
  # perfectly collinear exogenous regressors (two-part formula)
  d2 <- d
  d2$z2 <- d2$z
  expect_error(
    CopRegML_par(Y ~ x | z + z2 - 1, index = c("pan", "year"), data = d2),
    "rank deficient"
  )
})

test_that("starting values and seed are validated", {
  d <- simulate_test_panel(N = 10, Ti = 4)
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d,
                 starting_values = c(0, 0)),
    "wrong length"
  )
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d,
                 starting_values = c("a", "b", "c")),
    "numeric vector"
  )
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d, seed = "one"),
    "seed must be a single number"
  )
  expect_error(
    CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d, ncores = 0),
    "ncores must be a single positive number"
  )
})
