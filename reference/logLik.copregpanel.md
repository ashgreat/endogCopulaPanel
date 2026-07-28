# Log-likelihood of a fitted panel copula model

Log-likelihood of a fitted panel copula model

## Usage

``` r
# S3 method for class 'copregpanel'
logLik(object, ...)
```

## Arguments

- object:

  A fitted `"copregpanel"` object.

- ...:

  Currently unused.

## Value

An object of class `"logLik"` with the maximised log-likelihood, `df`
set to the number of estimated parameters and `nobs` set to the number
of transformed observations.

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
logLik(fit)
#> 'log Lik.' -192.6819 (df=4)
AIC(fit)
#> [1] 393.3638
BIC(fit)
#> [1] 405.4064
# }
```
