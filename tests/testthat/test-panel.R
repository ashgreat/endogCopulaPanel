sim <- simulate_panel()
fit <- suppressWarnings(
  CopRegPANEL(y ~ x | z, data = sim$data, index = c("id", "time"),
              nboots = 15, verbose = FALSE)
)

test_that("CopRegPANEL returns a copregpanel object with finite named coefficients", {
  expect_s3_class(fit, "copregpanel")

  cf <- coef(fit)
  expect_true(all(is.finite(cf)))
  expect_named(cf)
})

test_that("the copula correction moves the endogenous coefficient toward truth", {
  cf <- coef(fit)
  wb <- fit$within.coefficients

  expect_true(abs(cf[["x"]] - sim$beta_x) < abs(wb[["x"]] - sim$beta_x))
})

test_that("the usual extractor methods run and return the right shapes", {
  s <- summary(fit)
  expect_s3_class(s, "summary.copregpanel")

  cf <- coef(fit)
  ci <- confint(fit)
  expect_equal(dim(ci), c(length(cf), 2L))

  res <- residuals(fit)
  expect_type(res, "double")
  expect_length(res, nobs(fit))

  fv <- fitted(fit)
  expect_length(fv, nobs(fit))

  fe <- fixef(fit)
  expect_length(fe, length(unique(sim$data$id)))

  ll <- logLik(fit)
  expect_s3_class(ll, "logLik")
  expect_true(is.finite(as.numeric(ll)))

  expect_true(is.finite(AIC(fit)))
  expect_identical(nobs(fit), nrow(sim$data))

  v <- validity(fit)
  expect_s3_class(v, "copregpanel.validity")
})
