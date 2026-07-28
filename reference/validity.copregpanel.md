# Validity / identification diagnostics for a fitted panel copula model

Walks the identification requirements that carry over to the panel
estimator from the cross-sectional ones – nonnormality of the
(transformed) endogenous regressors, and the standard-error inflation
relative to the uncorrected within estimator – plus a check that is
specific to this estimator: normality of the error of the
FOD-transformed model, which Equation 12 of Haschka (2022) assumes
directly rather than as a matter of interpretation.

## Usage

``` r
# S3 method for class 'copregpanel'
validity(object, level = 0.05, power = 0.8, ...)

# S3 method for class 'copregpanel.validity'
print(x, digits = 4, ...)
```

## Arguments

- object:

  A fitted `"copregpanel"` object.

- level:

  Significance level used for the nonnormality thresholds.

- power:

  Target power used for the nonnormality thresholds of Becker, Proksch
  and Ringle (2022).

- ...:

  Currently unused.

- x:

  An object of class `"copregpanel.validity"`, as returned by
  `validity.copregpanel`.

- digits:

  Number of significant digits to print.

## Value

An object of class `"copregpanel.validity"`, a list including

- step1:

  the nonnormality table for the transformed endogenous regressors, with
  the Becker-Proksch-Ringle thresholds

- error:

  skewness, excess kurtosis, and Anderson-Darling and Kolmogorov-Smirnov
  tests of normality for the residuals of the transformed model

- inflation:

  a data frame comparing the copula-MLE and within bootstrap standard
  errors, with their ratio

- ratio.max:

  the largest such ratio

`x`, invisibly.

## References

Haschka, R. E. (2022). Handling endogenous regressors using copulas: A
generalization to linear panel models with fixed effects and correlated
regressors. *Journal of Marketing Research* 59(4), 861-880.

Becker, J.-M., D. Proksch, and C. M. Ringle (2022). Revisiting Gaussian
copulas to handle endogenous regressors. *Journal of the Academy of
Marketing Science* 50, 46-66.

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
validity(fit)
#> 
#> Validity check for Panel copula MLE (Haschka 2022)
#> n = 180 observations in 30 panels, target power 80%
#> Sources: Becker, Proksch & Ringle (2022); Haschka (2022)
#> 
#> [1] Nonnormality of the endogenous regressors, after the transformation
#>   skewness ex.kurtosis    AD   CvM     KS p Yang ok Becker ok
#> x    1.987       9.611 7.074 1.295 0.000826    TRUE     FALSE
#>     Becker et al. at n = 180: |skewness| >= not attainable, or AD > 18.964, or CvM > 3.488
#>     Their Study 3 covers fixed-effects panels and finds the cross-sectional
#>     thresholds carry over once total n is the reference.
#> 
#> [2] Error of the transformed model, which Equation 12 assumes normal
#>     skewness = 0.1376, excess kurtosis = 0.1579, AD = 0.5967 (p = 0.117)
#>     Unlike in the cross-sectional estimators this is a stated assumption of the
#>     likelihood rather than a matter of interpretation, so a small p is a real
#>     warning sign.
#> 
#> [3] Standard errors against the uncorrected within estimator, on the
#>     same bootstrap resamples
#>   SE (copula MLE) SE (within) ratio
#> x         0.07064     0.05349 1.321
#> z         0.12728     0.11718 1.086
#>     => largest ratio = 1.321.
#>        Haschka (2022) reads a factor of five to ten as a sign that the model
#>        is not identified; this is below that.
#> 
# }
```
