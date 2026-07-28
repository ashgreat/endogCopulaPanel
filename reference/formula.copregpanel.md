# Formula of a fitted panel copula model

Formula of a fitted panel copula model

## Usage

``` r
# S3 method for class 'copregpanel'
formula(x, ...)
```

## Arguments

- x:

  A fitted `"copregpanel"` object.

- ...:

  Currently unused.

## Value

The two-part `Formula` object used to fit the model.

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
formula(fit)
#> y ~ x | z
#> <environment: 0x5635464fda30>
# }
```
