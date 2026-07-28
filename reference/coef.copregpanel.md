# Coefficients of a fitted panel copula model

Extracts the regression coefficients of the FOD-transformed model fitted
by
[`CopRegPANEL`](https://ashgreat.github.io/endogCopulaPanel/reference/CopRegPANEL.md).
The structural intercept, if any, is not among them: it is absorbed into
the individual effects, see
[`fixef.copregpanel`](https://ashgreat.github.io/endogCopulaPanel/reference/fixef.copregpanel.md).

## Usage

``` r
# S3 method for class 'copregpanel'
coef(object, ...)
```

## Arguments

- object:

  A fitted `"copregpanel"` object.

- ...:

  Currently unused.

## Value

A named numeric vector of coefficients.

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
coef(fit)
#>         x         z 
#> 0.4754839 0.9447905 
# }
```
