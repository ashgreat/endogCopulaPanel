# Extract individual (panel) fixed effects

A generic for the individual (panel) fixed effects of a fitted panel
model. endogCopulaPanel defines this generic unconditionally, which
means it may mask `plm::fixef` or `lme4::fixef` if either of those
packages is attached after endogCopulaPanel; if you need one of those
instead, call it explicitly as `plm::fixef()` or `lme4::fixef()`.

## Usage

``` r
fixef(object, ...)
```

## Arguments

- object:

  A fitted model object.

- ...:

  Further arguments passed to methods.

## Value

A method-specific object holding the estimated individual effects; see
[`fixef.copregpanel`](https://ashgreat.github.io/endogCopulaPanel/reference/fixef.copregpanel.md)
for the method on class `"copregpanel"`.
