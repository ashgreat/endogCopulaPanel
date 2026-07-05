# Seeded simulated panel with one non-normal endogenous regressor (x,
# endogenous through errors correlated with e) and one exogenous regressor (z).
simulate_test_panel <- function(seed = 20260704, N = 30, Ti = 6) {
  set.seed(seed)
  d <- data.frame(pan = rep(1:N, each = Ti),
                  year = rep(1:Ti, times = N))
  re <- rep(runif(N, min = 0, max = 1), each = Ti)
  S <- matrix(c(1, .5, .5, 1), 2, 2)
  eps <- matrix(rnorm(N * Ti * 2), ncol = 2) %*% chol(S)
  e <- eps[, 1]
  d$x <- as.numeric(scale(qlnorm(pnorm(eps[, 2]), meanlog = 0, sdlog = 1)))
  d$z <- rnorm(N * Ti)
  d$Y <- re + d$x + d$z + e
  d$Yb <- re + d$x + e
  d
}
