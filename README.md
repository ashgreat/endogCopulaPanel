# endogCopulaPanel

<!-- badges: start -->
[![R-CMD-check](https://github.com/ashgreat/endogCopulaPanel/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ashgreat/endogCopulaPanel/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Package website: <https://ashgreat.github.io/endogCopulaPanel/>

`endogCopulaPanel` implements the fixed-effects Gaussian copula estimator for
panel data by Haschka (2022, *Journal of Marketing Research*). The estimator
corrects for endogenous regressors in linear fixed-effects panel models
**without instrumental variables**: the data are transformed by forward
orthogonal deviations within each panel, and the regression coefficients are
estimated jointly with the Gaussian copula correlation(s) between the
regression error and the endogenous regressor(s) by maximum likelihood.
Bootstrap standard errors are computed in parallel.

The package is a faithful port of the published replication code for
copula-based endogeneity corrections (the `PANEL` estimator, `CopRegML_par`).

## Installation

```r
# install.packages("remotes")
remotes::install_github("ashgreat/endogCopulaPanel")
```

## Usage

The exported function is `CopRegML_par()`. The model is specified with a
two-part formula, `y ~ endog1 + endog2 | exog1 + exog2`, with the endogenous
regressors in the first part and the exogenous regressors in the second
(append `- 1` to drop the intercept). Because this is a fixed-effects model,
all regressors — including dummy variables — must be time-varying.

The panel structure is declared through the `index` argument,
`index = c("panelvariable", "timevariable")`:

- the **panel identifier comes first**, as the forward orthogonal deviations
  transform and the bootstrap resampling operate within each panel;
- both identifier columns must be **numeric**;
- `data` should contain the **untransformed** panel data — the function
  applies the model transformation automatically.

```r
library(endogCopulaPanel)

# small simulated panel: x is endogenous (correlated with the error) and
# non-normal, z is exogenous, alpha is a panel fixed effect
set.seed(123)
N <- 30; Ti <- 6
d <- data.frame(id = rep(1:N, each = Ti), year = rep(1:Ti, times = N))
alpha <- rep(runif(N), each = Ti)
eps <- matrix(rnorm(N * Ti * 2), ncol = 2) %*% chol(matrix(c(1, .5, .5, 1), 2, 2))
d$x <- as.numeric(scale(qlnorm(pnorm(eps[, 2]))))
d$z <- rnorm(N * Ti)
d$y <- alpha + d$x + d$z + eps[, 1]

fit <- CopRegML_par(y ~ x | z, index = c("id", "year"), data = d,
                    nboots = 199, seed = 1)
fit
```

Setting `nboots` to 2 or fewer skips the bootstrap and returns point estimates
only. The `seed` and `ncores` arguments make the parallel bootstrap
reproducible and control the size of the worker cluster.

## Identifying assumptions and diagnostics

Identification of the copula correction rests on distributional assumptions
that are partly testable. `CopRegML_par()` runs the following diagnostics and
warns when an assumption looks violated:

- **Non-normality of the endogenous regressors.** Each endogenous regressor
  must be non-normally distributed, otherwise its copula-transformed values
  are indistinguishable from the (normal) error. Checked with an
  Anderson-Darling normality test; a warning is issued when normality cannot
  be rejected.
- **Symmetry/normality of the residuals.** The regression error is assumed
  Gaussian, so the residual distribution should be symmetric. Checked with the
  Jarque-Bera skewness test; a warning is issued when symmetry is rejected.
- **Separation of regressor and error distributions.** The distribution of
  each endogenous regressor must differ sufficiently from the residual
  distribution. Checked with a Kolmogorov-Smirnov test between the scaled
  residuals and each scaled endogenous regressor; a warning is issued when the
  distance is too small for reliable identification.

## Related packages

- [endogCopula](https://github.com/ashgreat/endogCopula) — cross-sectional
  Gaussian copula corrections (Park and Gupta 2012, 2sCOPE, 2sCOPE-np, IMA,
  BWM, JAMS) with a shared formula interface.
- [endogCopulaBayes](https://github.com/ashgreat/endogCopulaBayes) — Bayesian
  Gaussian copula joint-estimation sampler (Haschka 2022b).

## References

- Haschka, R. E. (2022). Handling endogenous regressors using copulas: A
  generalisation to linear panel models with fixed effects and correlated
  regressors. *Journal of Marketing Research*, 59(4), 860–881.
- Park, S. and S. Gupta (2012). Handling endogenous regressors by joint
  estimation using copulas. *Marketing Science*, 31(4), 567–586.

## License

MIT © Ashwin Malshe
