test_that("CopRegML_par point estimates match the reference implementation", {
  skip_if_no_reference()

  # The reference functions call many symbols unqualified
  # (%>%, pobs, model.frame, colVars, ...), so attach their packages first.
  suppressMessages({
    library(dplyr)
    library(copula)
    library(ks)
    library(nlme)
    library(Formula)
    library(extRC)
    library(matrixcalc)
    library(resample)
    library(tsoutliers)
    library(nortest)
  })

  ref <- load_reference_functions("CopRegPANEL.R")
  expect_true(is.function(ref$CopRegML_par))
  expect_true(is.function(ref$FOD1))

  d <- simulate_test_panel()

  specs <- list(one_part       = Yb ~ x,
                two_part_noint = Y ~ x | z - 1,
                two_part_int   = Y ~ x | z)

  for (nm in names(specs)) {
    pkg_est <- CopRegML_par(formula = specs[[nm]], index = c("pan", "year"),
                            data = d, nboots = 0)
    ref_est <- ref$CopRegML_par(formula = specs[[nm]], index = c("pan", "year"),
                                data = d, nboots = 0)
    expect_equal(pkg_est, ref_est, tolerance = 1e-8,
                 label = paste0("package estimates (", nm, ")"),
                 expected.label = paste0("reference estimates (", nm, ")"))
  }
})
