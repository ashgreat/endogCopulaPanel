# Panel copula correction for endogenous regressors with fixed effects

Maximum-likelihood estimator for linear panel models with individual
fixed effects and endogenous regressors correlated with the structural
error, following Haschka (2022). A forward orthogonal deviations (FOD)
transformation removes the fixed effects, and the regression
coefficients, the copula correlation(s) between the endogenous
regressors and the error, and the error variance are then estimated
jointly by maximum likelihood. Standard errors come from a bootstrap
that resamples whole panels. This is a distinct model class from the
cross-sectional endogCopula estimators reached through `copreg()`, in
the same way that `plm` is separate from `lm`; `CopRegPANEL()` is not
registered with `copreg()`.

## Usage

``` r
CopRegPANEL(
  formula,
  data,
  index,
  cdf = "kde.plugin",
  ties = "max",
  intercept = FALSE,
  nboots = 199,
  method = c("BFGS", "Nelder-Mead"),
  start = NULL,
  maxit = 5000L,
  subset = NULL,
  contrasts = NULL,
  parallel = FALSE,
  ncores = NULL,
  verbose = interactive()
)
```

## Arguments

- formula:

  A two-part formula `y ~ endogenous | exogenous`, as for the
  cross-sectional endogCopula estimators. Anything
  [`lm()`](https://rdrr.io/r/stats/lm.html) accepts is allowed, plus the
  panel-aware [`lag()`](https://rdrr.io/r/stats/lag.html), `lead()` and
  [`diff()`](https://rdrr.io/r/base/diff.html).

- data:

  A `data.frame` with the untransformed panel data.

- index:

  A character vector naming the panel identifier and, usually, the time
  variable in `data`: `c("id", "time")`. With only an identifier the
  existing row order within each panel is taken as the time order.

- cdf:

  Marginal CDF estimator applied to the regressors that enter the
  copula: one of `"kde.silverman"`, `"kde.cv"`, `"kde.plugin"` (the
  default here), `"ecdf.fixed"`, `"ecdf.adj"`, `"rank.n"` or
  `"rank.n1"`.

- ties:

  How ties are handled in the CDF estimate: `"max"` (the counting
  function, the default) or `"average"` (midranks).

- intercept:

  Logical, `FALSE` by default. A fixed-effects transformation removes
  anything time invariant, so an intercept in the transformed regression
  is identified only alongside a full set of time dummies, where it
  stands for the reference period; it is not the structural intercept,
  which is absorbed into the individual effects.

- nboots:

  Number of panel bootstrap replicates used for the standard errors; a
  single number of at least 2.

- method:

  Optimiser for the likelihood: `"BFGS"` (the default), which falls back
  to Nelder-Mead automatically if it fails to converge, or
  `"Nelder-Mead"` directly.

- start:

  Optional numeric vector of starting values for the optimiser.

- maxit:

  Maximum number of iterations for the optimiser.

- subset:

  An optional logical or index vector selecting rows of `data`, as in
  [`lm()`](https://rdrr.io/r/stats/lm.html).

- contrasts:

  An optional list of contrasts passed to
  [`model.matrix()`](https://rdrr.io/r/stats/model.matrix.html).

- parallel:

  How the bootstrap is parallelised: `FALSE` (the default), `TRUE`
  (chooses multicore on Unix and snow elsewhere), `"multicore"` or
  `"snow"`.

- ncores:

  Number of worker processes when `parallel` is not `FALSE`; `NULL` uses
  one less than the number of detected cores.

- verbose:

  Logical; print progress messages during maximisation and the
  bootstrap. Defaults to
  [`interactive()`](https://rdrr.io/r/base/interactive.html).

## Value

An object of class `"copregpanel"`: a list with, among other elements,

- coefficients, std.error, vcov:

  the regression coefficients of the transformed model and their
  bootstrap standard errors and covariance matrix

- rho, rho.se:

  the copula correlation(s) between the normal score of each endogenous
  regressor and that of the error, with bootstrap standard errors

- sigma2, sigma2.se:

  the error variance of the transformed model and its bootstrap standard
  error

- fixef:

  the estimated individual (panel) effects

- fitted.structural, residuals.structural:

  fitted values and residuals of the structural model
  `y = alpha_i + x'beta + z'delta + e` on the original rows

- fitted.transformed, residuals.transformed:

  fitted values and residuals of the FOD-transformed model that the
  likelihood treats as normal

- logLik, AIC, BIC, lr.test, wald.test:

  the maximised log-likelihood, information criteria, and a
  likelihood-ratio and a bootstrap Wald test of `rho = 0`

- within.coefficients, within.std.error, se.ratio:

  the uncorrected within-estimator benchmark on the same bootstrap
  resamples, and the ratio of the copula to the within standard errors

- boot:

  the raw bootstrap draws

- diagnostics:

  identification diagnostics underlying
  [`validity.copregpanel`](https://ashgreat.github.io/endogCopulaPanel/reference/validity.copregpanel.md)

- r.squared:

  transformed, structural, within, between and overall R-squared

and further elements recording the call, the data on both scales, the
panel index, sample sizes and the terms/formula used to fit the model.

## Details

Data are supplied untransformed: `data` holds the original panel, and
`CopRegPANEL()` performs the forward orthogonal deviations
transformation itself. [`lag()`](https://rdrr.io/r/stats/lag.html),
`lead()` and [`diff()`](https://rdrr.io/r/base/diff.html) may be used
inside `formula` exactly as any other function; they are panel aware and
never look across a panel boundary. Time dummies (and any other
regressor that is identical across panels once transformed) stay in the
regression but are dropped from the copula, because after the
transformation a full set of them carries no independent variation and
would leave the correlation matrix of the copula data singular. The
bootstrap used for the standard errors resamples whole cross-sectional
units (panels), not individual rows, which is what preserves the
within-panel dependence and keeps the standard errors valid under serial
correlation and heteroskedasticity.

## References

Haschka, R. E. (2022). Handling endogenous regressors using copulas: A
generalization to linear panel models with fixed effects and correlated
regressors. *Journal of Marketing Research* 59(4), 861-880.

Arellano, M. (1993). On the testing of correlated effects with panel
data. *Journal of Econometrics* 59, 87-97.

Goncalves, S. and L. Kilian (2004). Bootstrapping autoregressions with
conditional heteroskedasticity of unknown form. *Journal of
Econometrics* 123, 89-120.

## Examples

``` r
set.seed(1)
N <- 30L; Time <- 6L
d <- data.frame(id = rep(seq_len(N), each = Time),
                 year = rep(seq_len(Time), times = N))
alpha <- rep(rnorm(N), each = Time)
e <- rnorm(N * Time)
d$x <- exp(rnorm(N * Time) + 0.5 * e)   # endogenous: correlated with e
d$z <- rnorm(N * Time)                  # exogenous
d$y <- alpha + 0.5 * d$x + d$z + e

# \donttest{
fit <- CopRegPANEL(y ~ x | z, data = d, index = c("id", "year"),
                    nboots = 15, verbose = FALSE)
summary(fit)
#> 
#> Panel copula MLE (Haschka 2022)
#> 
#> Call:
#> CopRegPANEL(formula = y ~ x | z, data = d, index = c("id", "year"), 
#>     nboots = 15, verbose = FALSE)
#> 
#> Panel: index = (id, year)
#>   30 cross-sectional units, T = 6
#>   180 observations, 150 after the forward orthogonal deviations transformation
#>   no constant in the transformed regression: the structural intercept is
#>   time invariant and goes with the individual effects
#> 
#> Residuals of the structural model (y - alpha_i - x'beta - z'delta):
#>      Min       1Q   Median       3Q      Max 
#> -2.64558 -0.63148 -0.07251  0.50013  2.47346 
#> 
#> Residuals of the transformed model, which the likelihood treats as normal:
#>      Min       1Q   Median       3Q      Max 
#> -2.89808 -0.56351  0.01295  0.78300  2.61122 
#> 
#> Coefficients:
#>   Estimate Std. Error z value Pr(>|z|)    
#> x  0.47548    0.07064   6.731 1.69e-11 ***
#> z  0.94479    0.12728   7.423 1.14e-13 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Dependence parameters: rho(P*, xi*) is the correlation between the normal
#>   score of an endogenous regressor and that of the error, and sigma^2 is the
#>   variance of the error of the transformed model. rho = 0 means no endogeneity.
#>              Estimate Std. Error z value Pr(>|z|)   
#> rho(x*, xi*)   0.4469     0.1502   2.975  0.00293 **
#> sigma2         0.9559     0.1245                    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> No endogeneity, all rho = 0:
#>   likelihood ratio  chi-squared = 6.277 on 1 df, p = 0.01223
#>   bootstrap Wald   chi-squared = 8.849 on 1 df, p = 0.002933
#> 
#> R-squared:
#>   transformed model 0.762   structural model 0.828
#>   within 0.783   between 0.3704   overall 0.6684
#>   within, between and overall are squared correlations excluding the
#>   individual effects.
#> 
#> Log-likelihood -192.7 on 4 parameters;  AIC 393.4,  BIC 405.4
#> Standard errors from 15 panel bootstrap replicates (cross-sectional units
#>   resampled, not rows); cdf = "kde.plugin", ties = "max"; optimiser BFGS.
#> Pr(>|z|) in both tables: Wald test using the normal approximation with
#>   the bootstrap standard error.
#> 
#> --- Identification diagnostics ------------------------------------
#> 
#> Non-normality of the transformed endogenous regressors
#> (small p = non-normal, which is what identifies the model):
#>      AD      AD p      KS p
#> x 7.074 2.193e-17 0.0008258
#> 
#> Collinearity of the copula data (omega near 0 = weakly identified):
#>   corr(P, C) omega
#> x     0.9094 0.182
#> 
# }
```
