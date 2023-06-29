# script for testing mealmod_KClOnly.r
library(deSolve)

source("set_params.r")
source("mealmod_KClOnly.r")
source("mealmod_MealOnly.r")

init_cond = c(amt_gut = 4.37500,
                amt_plas = 18.92818,
                amt_inter = 42.06262,
                amt_muscle = 3123.72702)

params <- set_params()

t0 = 0
tf = 1000 
times <- seq(t0, tf, 1)

# KCl Only
outKClOnly <- as.data.frame(lsoda(
                                init_cond,
                                times,
                                func = mealmod_KClOnly,
                                parms = params,
                                rtol = 1e-8,
                                atol = 1e-8 
                                )
                            )

# Meal Only
outKClOnly <- as.data.frame(lsoda(
                                init_cond,
                                times,
                                func = mealmod_MealOnly,
                                parms = params,
                                rtol = 1e-8,
                                atol = 1e-8 
                                )
                            )
