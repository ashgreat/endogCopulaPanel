# FOD returns (the negative of) the usual forward orthogonal deviations:
# FOD(x)[t] = sqrt((n - t)/(n - t + 1)) * (mean(x[(t + 1):n]) - x[t])
# for t = 1, ..., n - 1, followed by a trailing NA.

test_that("FOD matches a hand-computed 3-observation example", {
  x <- c(1, 2, 4)
  expected <- c(sqrt(2/3) * (mean(c(2, 4)) - 1),
                sqrt(1/2) * (4 - 2),
                NA)
  expect_equal(FOD(x), expected, tolerance = 1e-12)
})

test_that("FOD matches a hand-computed 4-observation example", {
  x <- c(2, -1, 3, 5)
  expected <- c(sqrt(3/4) * (mean(c(-1, 3, 5)) - 2),
                sqrt(2/3) * (mean(c(3, 5)) - (-1)),
                sqrt(1/2) * (5 - 3),
                NA)
  expect_equal(FOD(x), expected, tolerance = 1e-12)
})

test_that("FOD handles degenerate and demeaning properties", {
  # single observation cannot be transformed
  expect_true(is.na(FOD(5)))
  # a within-panel constant maps to (numerical) zeros
  expect_equal(FOD(rep(3, 5))[1:4], rep(0, 4), tolerance = 1e-12)
  # FOD1 applies FOD column-wise and preserves column names
  d <- data.frame(a = c(1, 2, 4), b = c(2, -1, 3))
  out <- FOD1(d)
  expect_equal(colnames(out), c("a", "b"))
  expect_equal(out[, "a"], FOD(d$a), tolerance = 1e-12)
  expect_equal(out[, "b"], FOD(d$b), tolerance = 1e-12)
})
