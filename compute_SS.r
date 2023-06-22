# Use output of run2equilibrium to find 
#    initial guess for the numerical solver if do not have one

# Computes the steady state solution of the model_eqns using stode

library(rootSolve)
source("set_params.r")
source("model_eqns.r")

amtgut0 = 4.375
amtplas0 = 18.796
amtinter0 = 41.76168
amtmuscle0 = 3105.964

init_guess <- c(amtgut0,
                amtplas0,
                amtinter0,
                amtmuscle0)

params <- set_params()
init_soln <- model_eqns(0, init_guess, params)

ST <- stode(init_guess, time = 0, func = model_eqns, parms = params)
