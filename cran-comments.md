# cran-comments

## Package purpose

endogCopulaPanel implements the fixed-effects panel Gaussian copula
estimator of Haschka (2022, Journal of Marketing Research 59(4), 860-881)
for correcting endogenous regressors in linear fixed-effects panel models
without instrumental variables. The data are transformed by forward
orthogonal deviations within each panel, and the regression coefficients
are estimated jointly with the Gaussian copula correlation(s) between the
regression error and the endogenous regressor(s) by maximum likelihood,
with bootstrap standard errors computed in parallel.

This is a new submission.

## Test environments

* local: macOS 15 (Darwin 25.5.0), R 4.5.0
* GitHub Actions: ubuntu-latest, R release
* GitHub Actions: macos-latest, R release

## R CMD check results

0 errors | 0 warnings | 0 notes

## Downstream dependencies

There are currently no downstream dependencies for this package.
