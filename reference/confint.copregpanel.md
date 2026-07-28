# Confidence intervals for the coefficients of a fitted panel copula model

Confidence intervals for the coefficients of a fitted panel copula model

## Usage

``` r
# S3 method for class 'copregpanel'
confint(object, parm, level = 0.95, type = c("normal", "percentile"), ...)
```

## Arguments

- object:

  A fitted `"copregpanel"` object.

- parm:

  Which parameters to return intervals for; a vector of names or
  indices. Defaults to all coefficients.

- level:

  Confidence level.

- type:

  `"normal"` (the default) for a normal-approximation interval using the
  bootstrap standard error, or `"percentile"` for a percentile interval
  taken directly from the bootstrap draws.

- ...:

  Currently unused.

## Value

A matrix with one row per parameter and the lower and upper confidence
limits in the columns.

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
confint(fit)
#>       2.5 %   97.5 %
#> x 0.3370289 0.613939
#> z 0.6953291 1.194252
confint(fit, type = "percentile")
#>       2.5 %    97.5 %
#> x 0.4105160 0.6250387
#> z 0.6662682 1.1036012
# }
```
