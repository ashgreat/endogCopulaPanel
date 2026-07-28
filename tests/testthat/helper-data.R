# Small simulated panel with a known true coefficient on a non-normal
# endogenous regressor (chi-squared, correlated with the structural error
# through a shared shock) plus individual fixed effects.
simulate_panel <- function(seed = 5, N = 40L, Time = 8L, beta_x = 0.6) {
  set.seed(seed)
  n <- N * Time
  id    <- rep(seq_len(N), each = Time)
  time  <- rep(seq_len(Time), times = N)
  alpha <- rep(rnorm(N), each = Time)       # individual fixed effects
  e     <- rnorm(n)
  x     <- rchisq(n, df = 3) + 3 * e        # endogenous: non-normal, correlated with e
  z     <- rnorm(n)                          # exogenous
  y     <- alpha + beta_x * x + 0.5 * z + e

  list(data = data.frame(id = id, time = time, y = y, x = x, z = z),
       beta_x = beta_x)
}
