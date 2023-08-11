computeSS_plasconc <- function(X) {
    # initial guess values
    amtgut0 <- 4.37500
    conc_plas0 <- 4.206262
    conc_inter0 <- 4.206262
    conc_muscle0 <- 130.1553

    init_guess <- c(amt_gut = amtgut0,
                    conc_plas = conc_plas0,
                    conc_inter = conc_inter0,
                    conc_muscle = conc_muscle0)

    one_par <- function(i){
        ST <- stode(init_guess, time = 0, func = model_eqns_baseSS,
                    parms = X[i, ])
        return(ST$y)
        }

    res_per_par <- sapply(1:nrow(X), one_par, simplify = TRUE)
    res_per_state <- aperm(res_per_par)
    dimnames(res_per_state) <- list(NULL, names(init_guess))
    plas_conc_vals <- res_per_state[,2]
     #print('warning: only doing plasma conc!')
    return(plas_conc_vals)
}

computeSS_interconc <- function(X) {
    # initial guess values
    amtgut0 <- 4.37500
    conc_plas0 <- 4.206262
    conc_inter0 <- 4.206262
    conc_muscle0 <- 130.1553

    init_guess <- c(amt_gut = amtgut0,
                    conc_plas = conc_plas0,
                    conc_inter = conc_inter0,
                    conc_muscle = conc_muscle0)

    one_par <- function(i){
        ST <- stode(init_guess, time = 0, func = model_eqns_baseSS,
                    parms = X[i, ])
        return(ST$y)
        }

    res_per_par <- sapply(1:nrow(X), one_par, simplify = TRUE)
    res_per_state <- aperm(res_per_par)
    dimnames(res_per_state) <- list(NULL, names(init_guess))
    inter_conc_vals <- res_per_state[,3]
    # print('warning: only doing plasma conc!')
    return(inter_conc_vals)
}

computeSS_amtgut <- function(X) {
    # initial guess values
    amtgut0 <- 4.37500
    conc_plas0 <- 4.206262
    conc_inter0 <- 4.206262
    conc_muscle0 <- 130.1553

    init_guess <- c(amt_gut = amtgut0,
                    conc_plas = conc_plas0,
                    conc_inter = conc_inter0,
                    conc_muscle = conc_muscle0)

    one_par <- function(i){
        ST <- stode(init_guess, time = 0, func = model_eqns_baseSS,
                    parms = X[i, ])
        return(ST$y)
        }

    res_per_par <- sapply(1:nrow(X), one_par, simplify = TRUE)
    res_per_state <- aperm(res_per_par)
    dimnames(res_per_state) <- list(NULL, names(init_guess))
    amtgut_vals <- res_per_state[,1]
    return(amtgut_vals)
}

computeSS_muscleconc <- function(X) {
    # initial guess values
    amtgut0 <- 4.37500
    conc_plas0 <- 4.206262
    conc_inter0 <- 4.206262
    conc_muscle0 <- 130.1553

    init_guess <- c(amt_gut = amtgut0,
                    conc_plas = conc_plas0,
                    conc_inter = conc_inter0,
                    conc_muscle = conc_muscle0)

    one_par <- function(i){
        ST <- stode(init_guess, time = 0, func = model_eqns_baseSS,
                    parms = X[i, ])
        return(ST$y)
        }

    res_per_par <- sapply(1:nrow(X), one_par, simplify = TRUE)
    res_per_state <- aperm(res_per_par)
    dimnames(res_per_state) <- list(NULL, names(init_guess))
    muscleconc_vals <- res_per_state[,4]
    return(muscleconc_vals)
}