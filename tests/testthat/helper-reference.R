# Shared helpers for comparing the package against the published reference
# implementation in Copula-based-endogeneity-corrections-main.

endog_ref_dir <- function() {
  dir <- Sys.getenv("ENDOG_REF_DIR", unset = "")
  if (nzchar(dir)) {
    return(dir)
  }
  testthat::test_path("..", "..", "..", "Copula-based-endogeneity-corrections-main")
}

skip_if_no_reference <- function() {
  if (!dir.exists(endog_ref_dir())) {
    testthat::skip("Reference implementation not available (set ENDOG_REF_DIR)")
  }
}

# Parse a reference .R file and evaluate ONLY top-level assignments whose
# right-hand side is a function definition (or a Vectorize() wrapper of one,
# e.g. FOD1 <- Vectorize(FOD)) into a fresh environment. The top-level demo
# code in the reference files (library(...), data simulation, estimator calls)
# is never executed.
load_reference_functions <- function(filename) {
  path <- file.path(endog_ref_dir(), filename)
  exprs <- parse(path)
  env <- new.env(parent = globalenv())
  for (ex in exprs) {
    if (!is.call(ex)) next
    if (!(identical(ex[[1]], quote(`<-`)) || identical(ex[[1]], quote(`=`)))) next
    if (!is.name(ex[[2]])) next
    rhs <- ex[[3]]
    if (!is.call(rhs)) next
    if (identical(rhs[[1]], quote(`function`)) || identical(rhs[[1]], quote(Vectorize))) {
      eval(ex, envir = env)
    }
  }
  env
}
