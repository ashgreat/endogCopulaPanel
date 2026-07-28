# endogCopulaPanel

Package website: <https://ashgreat.github.io/endogCopulaPanel/>

endogCopulaPanel implements the fixed effects Gaussian copula estimator
for panel data by Haschka (2022, Journal of Marketing Research). The
estimator corrects for endogenous regressors in linear fixed effects
panel models without instrumental variables. The data are transformed by
forward orthogonal deviations within each panel, and the regression
coefficients are estimated jointly with the Gaussian copula correlation
between the regression error and each endogenous regressor by maximum
likelihood. Standard errors come from a bootstrap that resamples whole
panels.

The package builds on endogCopula, which supplies the shared formula
parsing, marginal CDF estimators and diagnostic helpers used across the
whole toolbox.

## Installation

``` r

# install.packages("remotes")
remotes::install_github("ashgreat/endogCopulaPanel")
```

## Usage

The exported function is
[`CopRegPANEL()`](https://ashgreat.github.io/endogCopulaPanel/reference/CopRegPANEL.md).
The model is specified with the same two part formula used across the
toolbox, `y ~ endogenous | exogenous`, with the endogenous regressors
before the bar and the exogenous regressors after it.
[`lag()`](https://rdrr.io/r/stats/lag.html), `lead()` and
[`diff()`](https://rdrr.io/r/base/diff.html) can be used inside the
formula and are panel aware, so they never look across a panel boundary.

The panel structure is declared through the `index` argument,
`index = c("id", "time")`. The panel identifier comes first, both
identifier columns must be numeric, and `data` should hold the
untransformed panel data, because
[`CopRegPANEL()`](https://ashgreat.github.io/endogCopulaPanel/reference/CopRegPANEL.md)
applies the forward orthogonal deviations transformation itself.

By default the transformed regression has no intercept, because a fixed
effects transformation removes anything time invariant and the
structural intercept is absorbed into the individual effects. Set
`intercept = TRUE` only alongside a full set of time dummies.

``` r

library(endogCopulaPanel)

set.seed(1)
N <- 30L; Time <- 6L
d <- data.frame(id = rep(seq_len(N), each = Time),
                 year = rep(seq_len(Time), times = N))
alpha <- rep(rnorm(N), each = Time)
e <- rnorm(N * Time)
d$x <- exp(rnorm(N * Time) + 0.5 * e)   # endogenous: correlated with e
d$z <- rnorm(N * Time)                  # exogenous
d$y <- alpha + 0.5 * d$x + d$z + e

fit <- CopRegPANEL(y ~ x | z, data = d, index = c("id", "year"),
                    nboots = 15, verbose = FALSE)
fit
```

This is the real output of the example above, run with `nboots = 15` to
keep it fast. Use more bootstrap replicates in practice. The default is
199.

    Panel copula MLE (Haschka 2022)

    Call:
    CopRegPANEL(formula = y ~ x | z, data = d, index = c("id", "year"),
        nboots = 15, verbose = FALSE)

    Balanced panel: n = 30, T = 6, observations = 180

    Coefficients:
         x       z
    0.4755  0.9448  

`summary(fit)` adds standard errors, the copula correlation between each
endogenous regressor and the error, a likelihood ratio and a bootstrap
Wald test of no endogeneity, and R-squared:

    Coefficients:
      Estimate Std. Error z value Pr(>|z|)
    x  0.47548    0.07064   6.731 1.69e-11 ***
    z  0.94479    0.12728   7.423 1.14e-13 ***

    Dependence parameters: rho(P*, xi*) is the correlation between the normal
      score of an endogenous regressor and that of the error, and sigma^2 is the
      variance of the error of the transformed model. rho = 0 means no endogeneity.
                 Estimate Std. Error z value Pr(>|z|)
    rho(x*, xi*)   0.4469     0.1502   2.975  0.00293 **
    sigma2         0.9559     0.1245

    No endogeneity, all rho = 0:
      likelihood ratio  chi-squared = 6.277 on 1 df, p = 0.01223
      bootstrap Wald   chi-squared = 8.849 on 1 df, p = 0.002933

## Checking the identifying assumptions

Identification of the copula correction rests on distributional
assumptions that are partly testable. `validity(fit)`, an S3 method
re-exported from endogCopula, checks three things: non-normality of each
endogenous regressor after the panel transformation, since
identification needs that non-normality; normality of the error of the
transformed model, which the likelihood assumes directly; and how much
the copula-corrected standard errors are inflated relative to the
uncorrected within estimator, where a large inflation factor signals
weak identification.

## Related packages

- endogCopula (<https://github.com/ashgreat/endogCopula>):
  cross-sectional Gaussian copula corrections with a shared formula
  interface.
- endogCopulaBayes (<https://github.com/ashgreat/endogCopulaBayes>): the
  Bayesian Gaussian copula sampler of Haschka (2025).

## References

- Haschka, R. E. (2022). Handling endogenous regressors using copulas: a
  generalization to linear panel models with fixed effects and
  correlated regressors. Journal of Marketing Research, 59(4), 861-880.
- Park, S. and S. Gupta (2012). Handling endogenous regressors by joint
  estimation using copulas. Marketing Science, 31(4), 567-586.

## License

MIT (c) Ashwin Malshe
