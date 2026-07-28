# endogCopulaPanel 0.2.0

## Breaking changes

* `CopRegML_par()` is replaced by `CopRegPANEL()`, ported from the
  rewritten reference implementation.
* The formula interface changes to the two part form used across the
  toolbox, `y ~ endogenous | exogenous`, used together with
  `index = c("id", "time")`.

## New features

* `CopRegPANEL()` returns an object of class `"copregpanel"` with
  `coef()`, `vcov()`, `confint()`, `residuals()`, `fitted()`, `fixef()`,
  `logLik()`, `predict()`, `summary()` and `validity()` methods.

## Dependencies

* The package now imports endogCopula for the shared model parsing, CDF
  estimation and diagnostic helpers. The estimator code itself is
  unchanged apart from packaging, and reproduces the upstream
  coefficients, standard errors, rho and log likelihood to 1e-12.
* The dependency list is reduced. copula, dplyr, extRC, ks, matrixcalc,
  nlme, nortest, pbapply, resample and tsoutliers are dropped. Several of
  these did not install from CRAN in their current form.
* The test suite is replaced. The old tests called `CopRegML_par()` and
  `FOD()`, which no longer exist.
