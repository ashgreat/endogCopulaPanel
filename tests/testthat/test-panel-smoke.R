test_that("point estimation works for all three model branches", {
  d <- simulate_test_panel()

  est1 <- CopRegML_par(Yb ~ x, index = c("pan", "year"), data = d, nboots = 0)
  expect_true(is.numeric(est1))
  expect_named(est1, c("x", "rho_x", "sigma2"))
  expect_true(all(is.finite(est1)))
  expect_gt(est1[["sigma2"]], 0)
  expect_lt(abs(est1[["rho_x"]]), 1)

  est2 <- CopRegML_par(Y ~ x | z - 1, index = c("pan", "year"), data = d,
                       nboots = 0)
  expect_named(est2, c("x", "z", "rho_x", "sigma2"))
  expect_true(all(is.finite(est2)))

  est3 <- CopRegML_par(Y ~ x | z, index = c("pan", "year"), data = d,
                       nboots = 0)
  expect_named(est3, c("(Intercept)", "x", "z", "rho_x", "sigma2"))
  expect_true(all(is.finite(est3)))
})

test_that("minimal bootstrap returns finite standard errors and is reproducible", {
  d <- simulate_test_panel(N = 25, Ti = 5)

  run_boot <- function() {
    suppressWarnings(
      CopRegML_par(Y ~ x | z - 1, index = c("pan", "year"), data = d,
                   nboots = 3, ncores = 2, seed = 42)
    )
  }

  out1 <- run_boot()
  expect_true(is.matrix(out1))
  expect_equal(colnames(out1), c("Estimate", "Std.Error"))
  expect_equal(rownames(out1), c("x", "z", "rho_x", "sigma2"))
  expect_true(all(is.finite(out1)))
  expect_true(all(out1[, "Std.Error"] >= 0))

  # same seed -> same resamples -> identical bootstrap standard errors
  out2 <- run_boot()
  expect_equal(out1, out2)
})
