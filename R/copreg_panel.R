# Internal helpers reused by CopRegML_par (Haschka, 2022).

#' Forward orthogonal deviations transform of a single panel series
#'
#' Returns the transformed series followed by a trailing `NA`; a series of
#' length one cannot be transformed and yields `NA`.
#' @noRd
FOD <- function(x) {

  if (length(x) == 1) {

    foo1 <- NA

  } else {

    D <- extRC::dfm(length(x))
    A <- chol(solve(D%*%t(D)))%*%D
    foo1 <- c(A%*%as.numeric(x), NA)

  }

  return(foo1)

}
FOD1 <- Vectorize(FOD)

#' Negative log-likelihood, model without intercept (unconstrained scale)
#' @noRd
likelihood1 <- function(values, M1, P1, Y1, M_star, M_star1) {

  betas1 <- values[1:dim(M1)[2]]
  rhos1 <- tanh(values[(dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])])
  s1 <- exp(values[length(values)])

  e1 <- Y1 - t(betas1%*%t(M1))
  d1 <- sum(stats::dnorm(x = e1[, 1], mean = 0, sd = sqrt(s1), log = TRUE))

  e1_star1 <- stats::pnorm(q = e1[, 1], mean = 0, sd = sqrt(s1))
  if (max(e1_star1) == 1) { e1_star1 <- copula::pobs(e1[, 1]) }

  rhos2 <- copula::P2p(stats::cor(M_star))
  rhos <- c(rhos1, rep(0, dim(M1)[2] - dim(P1)[2]), rhos2)

  U1 <- as.matrix(cbind(e1_star1, M_star1))
  d2 <- sum(copula::dCopula(copula = copula::normalCopula(param = rhos, dim = dim(U1)[2],
                                                          dispstr = "un"), u = U1,
                            log = TRUE))

  d3 <- (d1 + d2)*(-1)

  if(is.infinite(d3)) {d3 <- 1e12}

  return(d3)

}

#' Negative log-likelihood, model with intercept (unconstrained scale)
#' @noRd
likelihood2 <- function(values, M1, P1, Y1, M_star, M_star1) {

  betas1 <- values[1:(dim(M1)[2] + 1)]
  rhos1 <- tanh(values[(dim(M1)[2] + 2):(dim(M1)[2] + dim(P1)[2] + 1)])
  s1 <- exp(values[length(values)])

  e1 <- Y1 - t(betas1%*%t(cbind(rep(1, dim(M1)[1]), M1)))
  d1 <- sum(stats::dnorm(x = e1[, 1], mean = 0, sd = sqrt(s1), log = TRUE))

  e1_star1 <- stats::pnorm(q = e1[, 1], mean = 0, sd = sqrt(s1))
  if (max(e1_star1) == 1) { e1_star1 <- copula::pobs(e1[, 1]) }

  rhos2 <- copula::P2p(stats::cor(M_star))
  rhos <- c(rhos1, rep(0, dim(M1)[2] - dim(P1)[2]), rhos2)

  U1 <- as.matrix(cbind(e1_star1, M_star1))
  d2 <- sum(copula::dCopula(copula = copula::normalCopula(param = rhos, dim = dim(U1)[2],
                                                          dispstr = "un"), u = U1,
                            log = TRUE))

  d3 <- (d1 + d2)*(-1)

  if(is.infinite(d3)) {d3 <- 1e12}

  return(d3)

}

#' Negative log-likelihood, model without intercept (natural scale, bootstrap)
#' @noRd
likelihood_b1 <- function(values, M1, P1, Y1, M_star, M_star1) {

  betas1 <- values[1:dim(M1)[2]]
  rhos1 <- values[(dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])]
  s1 <- values[length(values)]

  if ((sum(rhos1 > -1) == length(rhos1)) && ((sum(rhos1 < 1) == length(rhos1))) && (sum(s1 > 0) == length(s1))) {

    e1 <- Y1 - t(betas1%*%t(M1))
    d1 <- sum(stats::dnorm(x = e1[, 1], mean = 0, sd = sqrt(s1), log = TRUE))

    e1_star1 <- stats::pnorm(q = e1[, 1], mean = 0, sd = sqrt(s1))
    if (max(e1_star1) == 1) { e1_star1 <- copula::pobs(e1[, 1]) }

    rhos2 <- copula::P2p(stats::cor(M_star))
    rhos <- c(rhos1, rep(0, dim(M1)[2] - dim(P1)[2]), rhos2)

    U1 <- as.matrix(cbind(e1_star1, M_star1))
    d2 <- sum(copula::dCopula(copula = copula::normalCopula(param = rhos, dim = dim(U1)[2],
                                                            dispstr = "un"), u = U1,
                              log = TRUE))

    d3 <- (d1 + d2)*(-1)

  } else { d3 <- 1e12 }

  return(d3)

}

#' Negative log-likelihood, model with intercept (natural scale, bootstrap)
#' @noRd
likelihood_b2 <- function(values, M1, P1, Y1, M_star, M_star1) {

  betas1 <- values[1:(dim(M1)[2] + 1)]
  rhos1 <- values[(dim(M1)[2] + 2):(dim(M1)[2] + dim(P1)[2] + 1)]
  s1 <- values[length(values)]

  if ((sum(rhos1 > -1) == length(rhos1)) && ((sum(rhos1 < 1) == length(rhos1))) && (sum(s1 > 0) == length(s1))) {

    e1 <- Y1 - t(betas1%*%t(cbind(rep(1, dim(M1)[1]), M1)))
    d1 <- sum(stats::dnorm(x = e1[, 1], mean = 0, sd = sqrt(s1), log = TRUE))

    e1_star1 <- stats::pnorm(q = e1[, 1], mean = 0, sd = sqrt(s1))
    if (max(e1_star1) == 1) { e1_star1 <- copula::pobs(e1[, 1]) }

    rhos2 <- copula::P2p(stats::cor(M_star))
    rhos <- c(rhos1, rep(0, dim(M1)[2] - dim(P1)[2]), rhos2)

    U1 <- as.matrix(cbind(e1_star1, M_star1))
    d2 <- sum(copula::dCopula(copula = copula::normalCopula(param = rhos, dim = dim(U1)[2],
                                                            dispstr = "un"), u = U1,
                              log = TRUE))

    d3 <- (d1 + d2)*(-1)

  } else { d3 <- 1e12 }

  return(d3)

}

#' One bootstrap replication, run on a cluster worker
#'
#' Free variables (`samples1`, `f1`, `f1Z`, `formula`, `ecdf`, `Estimate`,
#' `method`, `f1X_m`) are supplied via the environment that `CopRegML_par`
#' exports to the workers; see `R/globals.R`.
#' @noRd
bootst1 <- function(r1, tpp1) {

  data2 <- samples1[[r1]]

  if (length(f1) == 1) {

    # dependent variable
    Y1 <- with(data2, stats::model.frame(formula, data = data2)[1])

    # endogenous regressor(s)
    P1 <- with(data2, stats::get_all_vars(f1Z, data = data2))
    P_star <- P1
    P_star1 <- P1
    if (ecdf == TRUE) { P_star1 <- copula::pobs(P1)} else {

      for (a in 1:dim(P1)[2]) {

        Fhat <- ks::kcde(P1[, a])
        P_star1[, a] <- stats::predict(Fhat, x = P1[, a])

      }

    }
    P_star <- as.data.frame(stats::qnorm(as.matrix(P_star1)))

    M1 <- P1
    M_star <- P_star
    M_star1 <- P_star1


    # MLE without intercept
    tpp3 <- tryCatch(stats::optim(fn = likelihood_b1, par = Estimate, method = method,
                                  control = list(maxit = 1000000),
                                  M1 = M1, P1 = P1, Y1 = Y1, M_star = M_star, M_star1 = M_star1),
                     error = function(e) NA)

    sds1 <- c(tpp3$par[1:dim(M1)[2]],
              tpp3$par[(dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])],
              tpp3$par[length(tpp1$par)])

  } else {

    # dependent variable
    Y1 <- data2[, 2]

    # endogenous regressor(s)
    P1 <- with(data2, stats::get_all_vars(f1Z, data = data2))
    P_star <- P1
    P_star1 <- P1
    if (ecdf == TRUE) { P_star1 <- copula::pobs(P1)} else {

      for (a in 1:dim(P1)[2]) {

        Fhat <- ks::kcde(P1[, a])
        P_star1[, a] <- stats::predict(Fhat, x = P1[, a])

      }

    }

    P_star <- as.data.frame(stats::qnorm(as.matrix(P_star1)))

    # exogenous regressor(s)
    X1 <- data2[, -c(1:(dim(P1)[2] + 2))]
    X1 <- as.matrix(X1)
    X_star <- X1
    X_star1 <- X1

    M1 <- cbind(P1, X1)


    if (matrixcalc::is.singular.matrix(t(as.matrix(M1))%*%as.matrix(M1)) == FALSE) {

      if (ecdf == TRUE) { X_star1 <- copula::pobs(X1)} else {

        for (a in 1:dim(X1)[2]) {

          Fhat <- ks::kcde(X1[, a])
          X_star1[, a] <- stats::predict(Fhat, x = X1[, a])

        }

      }

      X_star <- as.data.frame(stats::qnorm(as.matrix(X_star1)))

      M_star <- cbind(P_star, X_star)
      M_star1 <- cbind(P_star1, X_star1)


      if (stats::var(f1X_m[, 1]) != 0) {

        # MLE without intercept
        tpp3 <- tryCatch(stats::optim(fn = likelihood_b1, par = Estimate, method = method,
                                      control = list(maxit = 1000000),
                                      M1 = M1, P1 = P1, Y1 = Y1, M_star = M_star, M_star1 = M_star1),
                         error = function(e) NA)

        sds1 <- c(tpp3$par[1:dim(M1)[2]],
                  tpp3$par[(dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])],
                  tpp3$par[length(tpp1$par)])

      } else {

        # MLE with intercept
        tpp3 <- tryCatch(stats::optim(fn = likelihood_b2, par = Estimate, method = method,
                                      control = list(maxit = 1000000),
                                      M1 = M1, P1 = P1, Y1 = Y1, M_star = M_star, M_star1 = M_star1),
                         error = function(e) NA)

        sds1 <- c(tpp3$par[1:(dim(M1)[2] + 1)],
                 tpp3$par[(dim(M1)[2] + 2):(dim(M1)[2] + dim(P1)[2] + 1)],
                 tpp3$par[length(tpp1$par)])

      }

    }

  }

  return(sds1)

}

#' Fixed-effects Gaussian Copula Estimator for Panel Data
#'
#' Instrument-free correction for endogenous regressors in linear panel models
#' with fixed effects, following Haschka (2022). The data are transformed by
#' forward orthogonal deviations within each panel, and the regression
#' coefficients are estimated jointly with the Gaussian copula correlation(s)
#' between the regression error and the endogenous regressor(s) by maximum
#' likelihood. Standard errors are obtained from a panel (block) bootstrap that
#' runs in parallel.
#'
#' @details
#' Identification rests on assumptions that are partly testable, and
#' `CopRegML_par()` warns when the corresponding diagnostics look problematic:
#' the endogenous regressors must be non-normally distributed (Anderson-Darling
#' test), the regression error must be (symmetric) normal (Jarque-Bera skewness
#' test on the residuals), and the residual distribution must differ
#' sufficiently from the distribution of each endogenous regressor
#' (Kolmogorov-Smirnov test). Because the model includes fixed effects, all
#' regressors -- including any dummy variables -- must be time-varying.
#'
#' @param formula A two-part formula `y ~ endog | exog` with the endogenous
#'   regressor(s) in the first part and the exogenous regressor(s) in the
#'   second; a one-part formula `y ~ endog` fits a model with endogenous
#'   regressor(s) only. Append `- 1` to the second part to drop the intercept.
#' @param index Character vector of length two, `c(panelvar, timevar)`, naming
#'   the panel and time identifiers in `data`; the panel identifier must come
#'   first. Both identifier columns must be numeric.
#' @param data Data frame with the untransformed panel data containing the
#'   variables referenced in the formula; the forward orthogonal deviations
#'   transform is applied internally.
#' @param ecdf Logical; use the empirical CDF (`TRUE`, default) or kernel CDF
#'   estimates via [ks::kcde()] (`FALSE`) for the copula transformation.
#' @param nboots Number of bootstrap replications for standard errors. Values
#'   of 2 or fewer skip the bootstrap and return point estimates only.
#' @param starting_values Optional numeric vector of starting values for the
#'   optimiser; defaults to least-squares estimates.
#' @param method Optimisation method passed to [stats::optim()].
#' @param ncores Number of cores used for the bootstrap cluster. Defaults to
#'   `parallel::detectCores() - 1`.
#' @param seed Optional integer seed. When supplied, `set.seed()` is called for
#'   the sequential part (bootstrap resampling) and
#'   `parallel::clusterSetRNGStream()` for the cluster workers, making
#'   bootstrap standard errors reproducible.
#' @return If bootstrap standard errors are computed (`nboots > 2`), a matrix
#'   with columns `Estimate` and `Std.Error`; otherwise a named numeric vector
#'   of estimates. The estimates comprise the regression coefficients on the
#'   transformed data (plus `(Intercept)` when applicable), one copula
#'   correlation `rho_<name>` per endogenous regressor, and the error variance
#'   `sigma2`.
#' @references Haschka, R. E. (2022). Handling endogenous regressors using
#'   copulas: A generalisation to linear panel models with fixed effects and
#'   correlated regressors. \emph{Journal of Marketing Research}, 59(4),
#'   860--881.
#' @examples
#' # small simulated panel: x is endogenous (correlated with the error) and
#' # non-normal, z is exogenous, alpha is a panel fixed effect
#' set.seed(123)
#' N <- 30; Ti <- 6
#' d <- data.frame(id = rep(1:N, each = Ti), year = rep(1:Ti, times = N))
#' alpha <- rep(runif(N), each = Ti)
#' eps <- matrix(rnorm(N * Ti * 2), ncol = 2) %*% chol(matrix(c(1, .5, .5, 1), 2, 2))
#' d$x <- as.numeric(scale(qlnorm(pnorm(eps[, 2]))))
#' d$z <- rnorm(N * Ti)
#' d$y <- alpha + d$x + d$z + eps[, 1]
#'
#' # point estimates only (no bootstrap)
#' CopRegML_par(y ~ x | z, index = c("id", "year"), data = d, nboots = 0)
#' \donttest{
#' # reproducible bootstrap standard errors on two cores
#' CopRegML_par(y ~ x | z, index = c("id", "year"), data = d,
#'              nboots = 9, ncores = 2, seed = 1)
#' }
#' @export
CopRegML_par <- function(formula, index, data, ecdf = TRUE, nboots = 199,
                         starting_values = NULL, method = "Nelder-Mead",
                         ncores = NULL, seed = NULL) {

  # check if arguments are correctly specified
  if (is.data.frame(data) == FALSE) {

    stop("Data must be data.frame", call. = FALSE)

  }

  if (is.character(index) == FALSE || length(index) != 2) {

    stop("index must be a character vector of length two: c(panelvar, timevar)", call. = FALSE)

  }

  # selecting data
  panelvar <- index[1]
  timevar <- index[2]

  missing_idx <- setdiff(index, names(data))
  if (length(missing_idx) > 0) {

    stop(paste("The following index columns are missing in the data:", paste(missing_idx, collapse = ", ")), call. = FALSE)

  }

  if (is.numeric(data[[panelvar]]) == FALSE) {

    stop(paste0("Panel identifier '", panelvar, "' must be numeric"), call. = FALSE)

  }

  if (is.numeric(data[[timevar]]) == FALSE) {

    stop(paste0("Time identifier '", timevar, "' must be numeric"), call. = FALSE)

  }

  if (max(table(data[[panelvar]])) < 2) {

    stop("Too few time periods: at least one panel must contain two or more observations for the forward orthogonal deviations transform", call. = FALSE)

  }

  if (is.null(seed) == FALSE) {

    if (is.numeric(seed) == FALSE || length(seed) != 1) {

      stop("seed must be a single number", call. = FALSE)

    }

    set.seed(seed)

  }

  if (is.null(ncores) == FALSE) {

    if (is.numeric(ncores) == FALSE || length(ncores) != 1 || ncores < 1) {

      stop("ncores must be a single positive number", call. = FALSE)

    }

  }

  data <- as.data.frame(data[with(data, order(seq(from = 1, to = dim(data)[1]))), ])

  # seperate endogenous and exogenous regressor(s)
  f1 <- nlme::splitFormula(formula, sep = "|")


  if (length(f1) == 1) {

    f1Z <- f1[[1]]

    # Check if all variables exist in the data
    variables <- all.vars(f1Z)
    missing_vars <- setdiff(variables, names(data))
    if(length(missing_vars) > 0) {

      stop(paste("The following variables are missing in the data:", paste(missing_vars, collapse=", ")))

    }

    data <- dplyr::select(data, c(dplyr::all_of(panelvar), colnames(stats::model.frame(formula, data = data)[1]), colnames(stats::get_all_vars(f1Z, data = data))))
    data <- data[stats::complete.cases(data), ]
    data <- as.data.frame(data)

    aux_data <- do.call(rbind.data.frame, base::split(data, data[, which(colnames(data) == panelvar)]))
    data <- do.call(rbind.data.frame, lapply(base::split(data, data[, which(colnames(data) == panelvar)]), FOD1))
    data[, which(colnames(data) == panelvar)] <- aux_data[, which(colnames(aux_data) == panelvar)]
    data <- data[stats::complete.cases(data), ]


    # check if design matrix has full column rank
    if (matrixcalc::is.singular.matrix(t(as.matrix(data[, -1]))%*%as.matrix(data[, -1]))) {

      stop("Design matrix is rank deficient. Either some regressors are perfectly collinear, or increase linearly over time, or are time invariant.", call. = FALSE)

    }


    # dependent variable
    Y1 <- stats::model.frame(formula, data = data)[1]

    # endogenous regressor(s)
    P1 <- stats::get_all_vars(f1Z, data = data)
    P_star <- P1
    P_star1 <- P1
    if (ecdf == TRUE) { P_star1 <- copula::pobs(P1)} else {

      for (a in 1:dim(P1)[2]) {

        Fhat <- ks::kcde(P1[, a])
        P_star1[, a] <- stats::predict(Fhat, x = P1[, a])

      }

    }
    P_star <- as.data.frame(stats::qnorm(as.matrix(P_star1)))

    M1 <- P1
    M_star <- P_star
    M_star1 <- P_star1


    # MLE without intercept
    lm0 <- stats::lm(Formula::as.Formula(formula), data = data)
    lm1 <- stats::lm(Formula::as.Formula(stats::update.formula(stats::formula(lm0), ~ . - 1)), data = data)
    starts <- c(lm1$coefficients, rep(0, dim(P1)[2]), log(stats::var(lm1$residuals)))

    if (is.null(starting_values)) {starts1 <- starts} else {

      if (length(starting_values) != length(starts)) {

        stop("Vector of starting values is of wrong length", call. = FALSE)

      }

      if (is.numeric(starting_values) == FALSE) {

        stop("Starting values must be a numeric vector", call. = FALSE)

      }

      starts1 <- starting_values
      names(starts1) <- names(starts)

    }

    tpp1 <- tryCatch(stats::optim(fn = likelihood1, par = starts1, method = method,
                                  control = list(maxit = 1000000),
                                  M1 = M1, P1 = P1, Y1 = Y1, M_star = M_star, M_star1 = M_star1),
                     error = function(e) NA)

    if (sum(is.na(tpp1)) == 1) {

      stop("Model cannot be evaluated at initial values.", call. = FALSE)

    }

    if (tpp1$value == 1e+12) {

      stop("Model cannot be evaluated at initial values.", call. = FALSE)

    }


    Estimate <- c(tpp1$par[1:dim(M1)[2]],
                  tanh(tpp1$par[(dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])]),
                  exp(tpp1$par[length(tpp1$par)]))
    resids <- unlist(Y1 - t(Estimate[1:dim(M1)[2]]%*%t(M1)))

    normtest_res <- tsoutliers::JarqueBera.test(resids)[[2]]$p.value
    z_vars <- colnames(stats::get_all_vars(f1Z, data = data))

    normtest_z <- rep(NA, dim(P1)[2])
    for (b1 in 1:length(normtest_z)) {

      normtest_z[b1] <- suppressWarnings(nortest::ad.test(scale(P1[, b1]))$p.value)

    }

    kstest_z <- rep(NA, dim(P1)[2])
    for (b2 in 1:length(kstest_z)) {

      kstest_z[b2] <- suppressWarnings(stats::ks.test(scale(resids), scale(P1[, b2]))$p.value)

    }

    names(Estimate)[length(Estimate)] <- "sigma2"
    for (b3 in (dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])){

      names(Estimate)[b3] <- paste("rho_", paste(z_vars[b3 - dim(M1)[2]], collapse = ""), sep = "")

    }


  } else {

    f1Z <- f1[[1]]
    f1X <- f1[[2]]

    variables <- all.vars(f1Z)
    missing_vars <- setdiff(variables, names(data))
    if(length(missing_vars) > 0) {

      stop(paste("The following variables are missing in the data:", paste(missing_vars, collapse=", ")))

    }

    variables <- all.vars(f1X)
    missing_vars <- setdiff(variables, names(data))
    if(length(missing_vars) > 0) {

      stop(paste("The following variables are missing in the data:", paste(missing_vars, collapse=", ")))

    }

    data1 <- data[data[, paste(timevar)] != max(data[, paste(timevar)], na.rm = TRUE), ]
    data1 <- dplyr::select(data1, c(colnames(stats::get_all_vars(f1X, data = data1)), colnames(stats::get_all_vars(f1Z, data = data1))))
    data1 <- data1[stats::complete.cases(data1), ]
    f1X_m <- stats::model.matrix(f1X, data = data1)

    suppressWarnings(data <- dplyr::select(data, c(dplyr::all_of(panelvar), colnames(stats::model.frame(formula, data = data)[1]), colnames(stats::get_all_vars(f1Z, data = data)), colnames(stats::get_all_vars(f1X, data = data)))))
    data <- data[stats::complete.cases(data), ]
    data <- as.data.frame(data)

    data0 <- data
    data <- cbind(data[, 1:(length(colnames(stats::get_all_vars(f1Z, data = data0))) + 2)], stats::model.matrix(f1X, data = data0)[, colnames(f1X_m)])
    if (stats::var(f1X_m[, 1]) != 0) { colnames(data)[(length(colnames(stats::get_all_vars(f1Z, data = data0))) + 3):dim(data)[2]] <- colnames(stats::model.matrix(f1X, data = data0)) }
    data <- dplyr::select_if(data, resample::colVars(data) != 0)


    aux_data <- do.call(rbind.data.frame, base::split(data, data[, which(colnames(data) == panelvar)]))
    data <- do.call(rbind.data.frame, lapply(base::split(data, data[, which(colnames(data) == panelvar)]), FOD1))
    data[, which(colnames(data) == panelvar)] <- aux_data[, which(colnames(aux_data) == panelvar)]
    data <- data[stats::complete.cases(data), ]


    # check if design matrix has full column rank
    if (matrixcalc::is.singular.matrix(t(as.matrix(data[, -1]))%*%as.matrix(data[, -1]))) {

      stop("Design matrix is rank deficient. Either some regressors are perfectly collinear, or increase linearly over time, or are time invariant.", call. = FALSE)

    }


    # dependent variable
    Y1 <- data[, 2]

    # endogenous regressor(s)
    P1 <- stats::get_all_vars(f1Z, data = data)
    P_star <- P1
    P_star1 <- P1
    if (ecdf == TRUE) { P_star1 <- copula::pobs(P1)} else {

      for (a in 1:dim(P1)[2]) {

        Fhat <- ks::kcde(P1[, a])
        P_star1[, a] <- stats::predict(Fhat, x = P1[, a])

      }

    }
    P_star <- as.data.frame(stats::qnorm(as.matrix(P_star1)))

    # exogenous regressor(s)
    X1 <- data[, -c(1:(dim(P1)[2] + 2))]
    X1 <- as.matrix(X1)
    X_star <- X1
    X_star1 <- X1
    if (ecdf == TRUE) { X_star1 <- copula::pobs(X1)} else {

      for (a in 1:dim(X1)[2]) {

        Fhat <- ks::kcde(X1[, a])
        X_star1[, a] <- stats::predict(Fhat, x = X1[, a])

      }

    }
    X_star <- as.data.frame(stats::qnorm(as.matrix(X_star1)))

    M1 <- cbind(P1, X1)
    M_star <- cbind(P_star, X_star)
    M_star1 <- cbind(P_star1, X_star1)


    # check for enough observations
    if (dim(data)[2] + dim(P_star)[2] - 1 > dim(data)[1]) {

      stop("Not enough observations", call. = FALSE)

    }



    if (stats::var(f1X_m[, 1]) != 0) {

      # MLE without intercept
      lm0 <- stats::lm(Formula::as.Formula(formula), data = data)
      lm1 <- stats::lm(Formula::as.Formula(stats::update.formula(stats::formula(lm0), ~ . - 1)), data = data)
      starts <- c(lm1$coefficients, rep(0, dim(P1)[2]), log(stats::var(lm1$residuals)))

      if (is.null(starting_values)) {starts1 <- starts} else {

        if (length(starting_values) != length(starts)) {

          stop("Vector of starting values is of wrong length", call. = FALSE)

        }

        if (is.numeric(starting_values) == FALSE) {

          stop("Starting values must be a numeric vector", call. = FALSE)

        }

        starts1 <- starting_values
        names(starts1) <- names(starts)

      }

      tpp1 <- tryCatch(stats::optim(fn = likelihood1, par = starts1, method = method,
                                    control = list(maxit = 1000000),
                                    M1 = M1, P1 = P1, Y1 = Y1, M_star = M_star, M_star1 = M_star1),
                       error = function(e) NA)

      if (sum(is.na(tpp1)) == 1) {

        stop("Model cannot be evaluated at initial values.", call. = FALSE)

      }

      if (tpp1$value == 1e+12) {

        stop("Model cannot be evaluated at initial values.", call. = FALSE)

      }


      Estimate <- c(tpp1$par[1:dim(M1)[2]],
                    tanh(tpp1$par[(dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])]),
                    exp(tpp1$par[length(tpp1$par)]))
      resids <- unlist(Y1 - t(Estimate[1:dim(M1)[2]]%*%t(M1)))

      normtest_res <- tsoutliers::JarqueBera.test(resids)[[2]]$p.value
      z_vars <- colnames(stats::get_all_vars(f1Z, data = data))

      normtest_z <- rep(NA, dim(P1)[2])
      for (a1 in 1:length(normtest_z)) {

        normtest_z[a1] <- suppressWarnings(nortest::ad.test(scale(P1[, a1]))$p.value)

      }

      kstest_z <- rep(NA, dim(P1)[2])
      for (a2 in 1:length(kstest_z)) {

        kstest_z[a2] <- suppressWarnings(stats::ks.test(scale(resids), scale(P1[, a2]))$p.value)

      }

      names(Estimate)[length(Estimate)] <- "sigma2"
      for (a3 in (dim(M1)[2] + 1):(dim(M1)[2] + dim(P1)[2])){

        names(Estimate)[a3] <- paste("rho_", paste(z_vars[a3 - dim(M1)[2]], collapse = ""), sep = "")

      }

    } else {

      # MLE with intercept
      lm1 <- stats::lm(data[, -1])
      starts <- c(lm1$coefficients, rep(0, dim(P1)[2]), log(stats::var(lm1$residuals)))

      if (is.null(starting_values)) {starts1 <- starts} else {

        if (length(starting_values) != length(starts)) {

          stop("Vector of starting values is of wrong length", call. = FALSE)

        }

        if (is.numeric(starting_values) == FALSE) {

          stop("Starting values must be a numeric vector", call. = FALSE)

        }

        starts1 <- starting_values
        names(starts1) <- names(starts)

      }

      tpp1 <- tryCatch(stats::optim(fn = likelihood2, par = starts1, method = method,
                                    control = list(maxit = 1000000),
                                    M1 = M1, P1 = P1, Y1 = Y1, M_star = M_star, M_star1 = M_star1),
                       error = function(e) NA)

      if (sum(is.na(tpp1)) == 1) {

        stop("Model cannot be evaluated at initial values.", call. = FALSE)

      }

      if (tpp1$value == 1e+12) {

        stop("Model cannot be evaluated at initial values.", call. = FALSE)

      }


      Estimate <- c(tpp1$par[1:(dim(M1)[2] + 1)],
                    tanh(tpp1$par[(dim(M1)[2] + 2):(dim(M1)[2] + dim(P1)[2] + 1)]),
                    exp(tpp1$par[length(tpp1$par)]))
      resids <- unlist(Y1 - t(Estimate[1:(dim(M1)[2] + 1)]%*%t(cbind(rep(1, dim(M1)[1]), M1))))

      normtest_res <- tsoutliers::JarqueBera.test(resids)[[2]]$p.value
      z_vars <- colnames(stats::get_all_vars(f1Z, data = data))

      normtest_z <- rep(NA, dim(P1)[2])
      for (a4 in 1:length(normtest_z)) {

        normtest_z[a4] <- suppressWarnings(nortest::ad.test(scale(P1[, a4]))$p.value)

      }

      kstest_z <- rep(NA, dim(P1)[2])
      for (a5 in 1:length(kstest_z)) {

        kstest_z[a5] <- suppressWarnings(stats::ks.test(scale(resids), scale(P1[, a5]))$p.value)

      }

      names(Estimate)[length(Estimate)] <- "sigma2"
      for (a6 in (dim(M1)[2] + 2):(dim(M1)[2] + dim(P1)[2] + 1)){

        names(Estimate)[a6] <- paste("rho_", paste(z_vars[a6 - (dim(M1)[2] + 1)], collapse = ""), sep = "")

      }

    }

  }


  ################################ Bootstrapping ###############################

  if (nboots > 2) {

    if (dim(data)[1] > length(base::unique(data[, 1]))) {

      # bootstrap standard errors
      m <- 1
      samples1 <- list()

      while (m <= nboots) {

        data1 <- dplyr::slice_sample(dplyr::group_by(data, data[, which(colnames(data) == panelvar)]), prop = 1, replace = TRUE)
        data1 <- as.data.frame(data1[, -dim(data1)[2]])


        if (length(f1) == 1) {

          # dependent variable
          Y1 <- stats::model.frame(formula, data = data1)[1]

          # endogenous regressor(s)
          P1 <- stats::get_all_vars(f1Z, data = data1)
          P_star <- P1
          P_star1 <- P1
          if (ecdf == TRUE) { P_star1 <- copula::pobs(P1)} else {

            for (a in 1:dim(P1)[2]) {

              Fhat <- ks::kcde(P1[, a])
              P_star1[, a] <- stats::predict(Fhat, x = P1[, a])

            }

          }
          P_star <- as.data.frame(stats::qnorm(as.matrix(P_star1)))

          M1 <- P1
          M_star <- P_star
          M_star1 <- P_star1


          # MLE without intercept
          tpp2 <- tryCatch(likelihood_b1(values = Estimate,
                                         M1 = M1, P1 = P1, Y1 = Y1,
                                         M_star = M_star, M_star1 = M_star1),
                           error = function(e) NA)

          suppressWarnings(if (sum(is.na(tpp2)) != 1) {

            if (tpp2 != 1e12) {

              samples1[[m]] <- data1

              m <- m + 1

            } else { m <- m }

          } else { m <- m })


        } else {

          # dependent variable
          Y1 <- data1[, 2]

          # endogenous regressor(s)
          P1 <- stats::get_all_vars(f1Z, data = data1)
          P_star <- P1
          P_star1 <- P1
          if (ecdf == TRUE) { P_star1 <- copula::pobs(P1)} else {

            for (a in 1:dim(P1)[2]) {

              Fhat <- ks::kcde(P1[, a])
              P_star1[, a] <- stats::predict(Fhat, x = P1[, a])

            }

          }
          P_star <- as.data.frame(stats::qnorm(as.matrix(P_star1)))

          # exogenous regressor(s)
          X1 <- data1[, -c(1:(dim(P1)[2] + 2))]
          X1 <- as.matrix(X1)
          X_star <- X1
          X_star1 <- X1

          M1 <- cbind(P1, X1)


          if (matrixcalc::is.singular.matrix(t(as.matrix(M1))%*%as.matrix(M1)) == FALSE) {

            if (ecdf == TRUE) { X_star1 <- copula::pobs(X1)} else {

              for (a in 1:dim(X1)[2]) {

                Fhat <- ks::kcde(X1[, a])
                X_star1[, a] <- stats::predict(Fhat, x = X1[, a])

              }

            }
            X_star <- as.data.frame(stats::qnorm(as.matrix(X_star1)))

            M_star <- cbind(P_star, X_star)
            M_star1 <- cbind(P_star1, X_star1)


            if (stats::var(f1X_m[, 1]) != 0) {

              # MLE without intercept
              tpp2 <- tryCatch(likelihood_b1(values = Estimate,
                                             M1 = M1, P1 = P1, Y1 = Y1,
                                             M_star = M_star, M_star1 = M_star1),
                               error = function(e) NA)

              suppressWarnings(if (sum(is.na(tpp2)) != 1) {

                if (tpp2 != 1e12) {

                  samples1[[m]] <- data1

                  m <- m + 1

                } else { m <- m }

              } else { m <- m })


            } else {

              # MLE with intercept
              tpp2 <- tryCatch(likelihood_b2(values = Estimate,
                                             M1 = M1, P1 = P1, Y1 = Y1,
                                             M_star = M_star, M_star1 = M_star1),
                               error = function(e) NA)

              suppressWarnings(if (sum(is.na(tpp2)) != 1) {

                if (tpp2 != 1e12) {

                  samples1[[m]] <- data1

                  m <- m + 1

                } else { m <- m }

              } else { m <- m })

            }

          } else { m <- m }

        }

      }

      # Parallelisation
      print("calculating bootstrap standard errors")
      if (is.null(ncores)) { ncores <- max(1L, parallel::detectCores() - 1L) }
      c1 <- parallel::makeCluster(ncores)
      on.exit(parallel::stopCluster(c1), add = TRUE)
      if (is.null(seed) == FALSE) { parallel::clusterSetRNGStream(cl = c1, iseed = seed) }

      # Ship everything the workers need inside a self-contained environment.
      # Formula environments are reset to globalenv() so that no reference to
      # the package namespace (or a calling frame) is serialised to the
      # workers; all variables are looked up in the supplied data anyway.
      boot_env <- new.env(parent = globalenv())
      formula1 <- formula
      environment(formula1) <- globalenv()
      boot_env$formula <- formula1
      boot_env$f1 <- lapply(f1, function(ff) { environment(ff) <- globalenv(); ff })
      f1Z1 <- f1Z
      environment(f1Z1) <- globalenv()
      boot_env$f1Z <- f1Z1
      boot_env$samples1 <- samples1
      boot_env$ecdf <- ecdf
      boot_env$Estimate <- Estimate
      boot_env$method <- method
      boot_env$tpp1 <- tpp1

      if (length(f1) != 1) {

        f1X1 <- f1X
        environment(f1X1) <- globalenv()
        boot_env$f1X <- f1X1
        boot_env$f1X_m <- f1X_m

      }

      for (fname in c("bootst1", "likelihood_b1", "likelihood_b2")) {

        ffun <- get(fname)
        environment(ffun) <- boot_env
        assign(fname, ffun, envir = boot_env)

      }

      parallel::clusterExport(cl = c1, varlist = ls(boot_env), envir = boot_env)

      # Calculate bootstrap SE
      sds_mat <- pbapply::pbsapply(X = 1:nboots, FUN = boot_env$bootst1, cl = c1, tpp1 = tpp1)


      # Identification checks
      if (normtest_res < .1) {warning("Residuals may not be symmetrically distributed: Jarque-Bera skewness p = ",
                                      paste(round(normtest_res, digits = 3),
                                            collapse = ""), call. = FALSE)}

      for (a7 in 1:length(normtest_z)) {

        if (normtest_z[a7] > .1) {warning("Endogenous regressor ", paste(z_vars[a7], collapse = ""), " may not be sufficiently different from normality: Anderson-Darling p = ",
                                          paste(round(normtest_z[a7], digits = 3),
                                                collapse = ""), call. = FALSE)}

      }

      for (a8 in 1:length(kstest_z)) {

        if (kstest_z[a8] > .1) {warning("Difference between endogenous regressor ", paste(z_vars[a8], collapse = ""), " and error distribution may not be sufficient for identification: Kolmogorov-Smirnov p = ",
                                        paste(round(kstest_z[a8], digits = 3),
                                              collapse = ""), call. = FALSE)}

      }


      # close(progress_bar)
      Std.Error <- sapply(as.data.frame(t(sds_mat)), stats::sd)
      return(cbind(Estimate, Std.Error))


    } else {

      warning("Not enough observations within panels. Cannot calculate standard errors",
              call. = FALSE)
      return(Estimate)

    }

  } else { return(Estimate) }

}
