# Use output of run2equilibrium to find 
#    initial guess for the numerical solver if do not have one

# Computes the steady state solution of the model_eqns using stode

library(rootSolve)
source("set_params.r")
source("model_eqns.r")
source("varnames.r")

amtgut0 = 4.375
amtplas0 = 18.796
amtinter0 = 41.76168
amtmuscle0 = 3105.964

init_guess <- c(amtgut0,
                amtplas0,
                amtinter0,
                amtmuscle0)

params <- set_params()

set_opts <- list(SS = 1,
                 doFF = 1,
                 doins = 1,
                 Kin = 0,
                 MKX = 0)

init_soln <- model_eqns(0, init_guess, params, set_opts)

ST <- stode(init_guess, time = 0, func = model_eqns,
                         parms = params, opts = set_opts)

# SS solution obtained by stode
ST$yconc <- list(Kplas = ST$y[2]/params$V_plasma,
                 Kinter = ST$y[3]/params$V_inter,
                 Kmuscle = ST$y[4]/params$V_muscle)
print(ST$y)
print(ST$yconc)

sprintf("Steady state concentrations")
sprintf("Plasma [K]: %0.3f", ST$yconc$Kplas)
sprintf("Inter [K]:  %0.3f", ST$yconc$Kinter)
sprintf("Muslce [K]: %0.3f", ST$yconc$Kmuscle)
