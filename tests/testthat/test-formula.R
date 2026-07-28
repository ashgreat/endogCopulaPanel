test_that("the index argument determines row order, not the order in 'data'", {
  sim <- simulate_panel()
  set.seed(2)
  shuffled <- sim$data[sample(nrow(sim$data)), ]

  fit1 <- suppressWarnings(
    CopRegPANEL(y ~ x | z, data = sim$data, index = c("id", "time"),
                nboots = 2, verbose = FALSE)
  )
  fit2 <- suppressWarnings(
    CopRegPANEL(y ~ x | z, data = shuffled, index = c("id", "time"),
                nboots = 2, verbose = FALSE)
  )

  # the maximum-likelihood point estimates do not depend on the RNG, only on
  # the data sorted by 'index'; if 'index' were ignored the two fits would
  # see the rows in different (panel, time) order and disagree
  expect_equal(coef(fit1), coef(fit2), tolerance = 1e-6)
})

test_that("the bootstrap resamples whole cross-sectional units, not rows", {
  # with only N = 3 panels, a bootstrap that resamples whole units can only
  # ever produce one of choose(2N - 1, N) = 10 distinct unit multisets; a
  # row-level bootstrap of continuous data would essentially never repeat
  # a "within" coefficient across 40 replicates
  N <- 3L; Time <- 4L
  set.seed(7)
  d <- data.frame(id = rep(seq_len(N), each = Time),
                  time = rep(seq_len(Time), times = N))
  d$x <- rchisq(N * Time, df = 3)
  d$z <- rnorm(N * Time)
  d$y <- rep(rnorm(N), each = Time) + 0.5 * d$x + d$z + rnorm(N * Time)

  set.seed(11)
  fit <- suppressWarnings(
    CopRegPANEL(y ~ x | z, data = d, index = c("id", "time"),
                nboots = 40, verbose = FALSE)
  )

  within_x <- fit$boot[, "within.x"]
  expect_lte(length(unique(round(within_x, 8))), choose(2 * N - 1, N))
})

test_that("lag() inside the formula does not leak across a panel boundary", {
  id <- c(1, 1, 1, 2, 2, 2)
  x  <- c(10, 20, 30, 40, 50, 60)

  # a naive (non-panel-aware) lag would carry unit 1's last value into unit
  # 2's first row
  naive <- c(NA, x[-length(x)])
  expect_identical(naive[4], 30)

  panel_lag <- endogCopulaPanel:::.panel_env(id)$lag(x)

  expect_true(is.na(panel_lag[4]))
  expect_identical(panel_lag, c(NA, 10, 20, NA, 40, 50))
})
