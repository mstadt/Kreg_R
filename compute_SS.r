# Use output of run2equilibrium to find 
#    initial guess for the numerical solver if do not have one

# Computes the steady state solution of the model_eqns using stode

library(rootSolve)
source("set_params.r")
source("model_eqns_baseSS.r")
#source("varnames.r")


# initial guess values
amtgut0 <- 4.37500
conc_plas0 <- 4.206262
conc_inter0 <- 4.206262
conc_muscle0 <- 130.1553

init_guess <- c(amt_gut = amtgut0,
                conc_plas = conc_plas0,
                conc_inter = conc_inter0,
                conc_muscle = conc_muscle0)

params <- set_params()

# set_opts <- list(SS = 1,
#                  doFF = 1,
#                  doins = 1,
#                  Kin = 0,
#                  MKX = 0)

#init_soln <- model_eqns(0, init_guess, params, set_opts)
init_soln <- model_eqns_baseSS(0, init_guess, params)

ST <- stode(init_guess, time = 0, func = model_eqns_baseSS,
                parms = params)
# ST <- stode(init_guess, time = 0, func = model_eqns_baseSS,
#                          parms = params, opts = set_opts)

# SS solution obtained by stode
# ST$yconc <- list(Kplas = ST$y[2]/params$V_plasma,
#                  Kinter = ST$y[3]/params$V_inter,
#                  Kmuscle = ST$y[4]/params$V_muscle)
print(ST$y)
#print(ST$yconc)
