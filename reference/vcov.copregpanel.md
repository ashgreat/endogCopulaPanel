# Bootstrap covariance matrix of a fitted panel copula model

Bootstrap covariance matrix of a fitted panel copula model

## Usage

``` r
# S3 method for class 'copregpanel'
vcov(object, ...)
```

## Arguments

- object:

  A fitted `"copregpanel"` object.

- ...:

  Currently unused.

## Value

The bootstrap covariance matrix of `coef(object)`.

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
vcov(fit)
#>             x           z
#> x 0.004990241 0.001401283
#> z 0.001401283 0.016199829
# }
```
