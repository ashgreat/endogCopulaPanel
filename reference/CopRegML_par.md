# Fixed-effects Gaussian Copula Estimator for Panel Data

Instrument-free correction for endogenous regressors in linear panel
models with fixed effects, following Haschka (2022). The data are
transformed by forward orthogonal deviations within each panel, and the
regression coefficients are estimated jointly with the Gaussian copula
correlation(s) between the regression error and the endogenous
regressor(s) by maximum likelihood. Standard errors are obtained from a
panel (block) bootstrap that runs in parallel.

## Usage

``` r
CopRegML_par(
  formula,
  index,
  data,
  ecdf = TRUE,
  nboots = 199,
  starting_values = NULL,
  method = "Nelder-Mead",
  ncores = NULL,
  seed = NULL
)
```

## Arguments

- formula:

  A two-part formula `y ~ endog | exog` with the endogenous regressor(s)
  in the first part and the exogenous regressor(s) in the second; a
  one-part formula `y ~ endog` fits a model with endogenous regressor(s)
  only. Append `- 1` to the second part to drop the intercept.

- index:

  Character vector of length two, `c(panelvar, timevar)`, naming the
  panel and time identifiers in `data`; the panel identifier must come
  first. Both identifier columns must be numeric.

- data:

  Data frame with the untransformed panel data containing the variables
  referenced in the formula; the forward orthogonal deviations transform
  is applied internally.

- ecdf:

  Logical; use the empirical CDF (`TRUE`, default) or kernel CDF
  estimates via
  [`ks::kcde()`](https://mvstat.net/ks/reference/kcde.html) (`FALSE`)
  for the copula transformation.

- nboots:

  Number of bootstrap replications for standard errors. Values of 2 or
  fewer skip the bootstrap and return point estimates only.

- starting_values:

  Optional numeric vector of starting values for the optimiser; defaults
  to least-squares estimates.

- method:

  Optimisation method passed to
  [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

- ncores:

  Number of cores used for the bootstrap cluster. Defaults to
  `parallel::detectCores() - 1`.

- seed:

  Optional integer seed. When supplied,
  [`set.seed()`](https://rdrr.io/r/base/Random.html) is called for the
  sequential part (bootstrap resampling) and
  [`parallel::clusterSetRNGStream()`](https://rdrr.io/r/parallel/RngStream.html)
  for the cluster workers, making bootstrap standard errors
  reproducible.

## Value

If bootstrap standard errors are computed (`nboots > 2`), a matrix with
columns `Estimate` and `Std.Error`; otherwise a named numeric vector of
estimates. The estimates comprise the regression coefficients on the
transformed data (plus `(Intercept)` when applicable), one copula
correlation `rho_<name>` per endogenous regressor, and the error
variance `sigma2`.

## Details

Identification rests on assumptions that are partly testable, and
`CopRegML_par()` warns when the corresponding diagnostics look
problematic: the endogenous regressors must be non-normally distributed
(Anderson-Darling test), the regression error must be (symmetric) normal
(Jarque-Bera skewness test on the residuals), and the residual
distribution must differ sufficiently from the distribution of each
endogenous regressor (Kolmogorov-Smirnov test). Because the model
includes fixed effects, all regressors – including any dummy variables –
must be time-varying.

## References

Haschka, R. E. (2022). Handling endogenous regressors using copulas: A
generalisation to linear panel models with fixed effects and correlated
regressors. *Journal of Marketing Research*, 59(4), 860–881.

## Examples

``` r
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

# point estimates only (no bootstrap)
CopRegML_par(y ~ x | z, index = c("id", "year"), data = d, nboots = 0)
#> (Intercept)           x           z       rho_x      sigma2 
#> -0.02684614  1.14022852  0.99917787  0.39781373  0.78522223 
# \donttest{
# reproducible bootstrap standard errors on two cores
CopRegML_par(y ~ x | z, index = c("id", "year"), data = d,
             nboots = 9, ncores = 2, seed = 1)
#> [1] "calculating bootstrap standard errors"
#>                Estimate  Std.Error
#> (Intercept) -0.02684614 0.04518831
#> x            1.14022852 0.10159746
#> z            0.99917787 0.10057464
#> rho_x        0.39781373 0.10574560
#> sigma2       0.78522223 0.06794159
# }
```
