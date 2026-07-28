# Summarize a fitted panel copula model

Produces coefficient tables for the regression and for the copula
dependence parameters, the likelihood-ratio and bootstrap Wald tests of
no endogeneity, fit statistics, and the identification diagnostics.

## Usage

``` r
# S3 method for class 'copregpanel'
summary(object, ...)

# S3 method for class 'summary.copregpanel'
print(
  x,
  digits = max(3L, getOption("digits") - 3L),
  signif.stars = getOption("show.signif.stars"),
  ...
)
```

## Arguments

- object:

  A fitted `"copregpanel"` object.

- ...:

  Currently unused.

- x:

  An object of class `"summary.copregpanel"`, as returned by
  `summary.copregpanel`.

- digits:

  Number of significant digits to print.

- signif.stars:

  Logical; show significance stars, as in
  [`printCoefmat`](https://rdrr.io/r/stats/printCoefmat.html).

## Value

An object of class `"summary.copregpanel"`, a list including

- coefficients:

  a coefficient table (estimate, bootstrap standard error, z value, p
  value) for the regression

- rho:

  the equivalent table for the copula correlation(s) and `sigma2`

- lr.test, wald.test:

  the likelihood-ratio and bootstrap Wald tests of `rho = 0`

- r.squared:

  transformed, structural, within, between and overall R-squared

and further elements carried over from the fitted object, such as
`logLik`, `AIC`, `BIC` and `diagnostics`.

`x`, invisibly.

## Examples

``` r
# \donttest{
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
