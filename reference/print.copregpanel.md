# Print a fitted panel copula model

Print a fitted panel copula model

## Usage

``` r
# S3 method for class 'copregpanel'
print(x, digits = max(3L, getOption("digits") - 3L), ...)
```

## Arguments

- x:

  A fitted `"copregpanel"` object.

- digits:

  Number of significant digits to print.

- ...:

  Currently unused.

## Value

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
print(fit)
#> 
#> Panel copula MLE (Haschka 2022)
#> 
#> Call:
#> CopRegPANEL(formula = y ~ x | z, data = d, index = c("id", "year"), 
#>     nboots = 15, verbose = FALSE)
#> 
#> Balanced panel: n = 30, T = 6, observations = 180
#> 
#> Coefficients:
#>      x       z  
#> 0.4755  0.9448  
#> 
# }
```
