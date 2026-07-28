# Individual (panel) fixed effects of a fitted panel copula model

`fixef.copregpanel` extracts the estimated individual effects,
`alpha_i = mean(y_i) - mean(x_i)'beta - mean(z_i)'delta`, exactly as in
Haschka (2022) and as `plm::fixef()` computes them for the within
estimator.

## Usage

``` r
# S3 method for class 'copregpanel'
fixef(object, ...)
```

## Arguments

- object:

  A fitted `"copregpanel"` object, as returned by
  [`CopRegPANEL`](https://ashgreat.github.io/endogCopulaPanel/reference/CopRegPANEL.md).

- ...:

  Currently unused.

## Value

A named numeric vector of the estimated individual effects, one per
cross-sectional unit.

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
fixef(fit)
#>           1           2           3           4           5           6 
#> -0.60120108  0.41976410 -0.66310718  1.59056210  0.79001073 -0.33220315 
#>           7           8           9          10          11          12 
#>  0.78604632  0.48161209  0.36375757  0.06812673  2.38541748 -0.27843905 
#>          13          14          15          16          17          18 
#> -0.23449678 -1.86702938  1.04448713  0.23942979 -0.27155961  0.46597589 
#>          19          20          21          22          23          24 
#>  0.25821856  0.18070623  0.33732597  0.99995014  0.39824132 -1.39506170 
#>          25          26          27          28          29          30 
#>  1.47633418 -0.18887497 -0.21028521 -1.75812198  0.13760280  0.76960127 
# }
```
