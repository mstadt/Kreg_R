# script for testing mealmod_KClOnly.r
library(deSolve)

source("set_params.r")
source("mealmod_KClOnly.r")
source("mealmod_MealOnly.r")
source("mealmod_MealKCl.r")

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
outMealOnly <- as.data.frame(lsoda(
                                init_cond,
                                times,
                                func = mealmod_MealOnly,
                                parms = params,
                                rtol = 1e-8,
                                atol = 1e-8
                                )
                            )
# Meal + KCl
outMealKCl <- as.data.frame(lsoda(
                                init_cond,
                                times,
                                func = mealmod_MealKCl,
                                parms = params,
                                rtol = 1e-8,
                                atol = 1e-8
                                )
                            )

## save results
save_info = as.integer(readline(prompt = "do you want to save? "))
if (save_info) {
    notes = readline(prompt = "notes for filename: ")
    today <- Sys.Date()
    f_KCl <- paste(today, "_MealMod_KClOnly",
                    "_notes-", notes, ".csv",
                    sep = "")
    write.csv(outKClOnly, file = paste("./results/", f_KCl, sep=""))
    print("KCl only results saved to:")
    print(sprintf("%s", f_KCl))

    f_Meal <- paste(today, "_MealMod_MealOnly",
                    "_notes-", notes, ".csv",
                    sep = "")
    write.csv(outMealOnly, file = paste("./results/", f_Meal, sep=""))
    print("Meal Only results saved to:")
    print(sprintf("%s", f_Meal))

    f_MealKCl <- paste(today, "_MealMod_MealKCl",
                    "_notes-", notes, ".csv",
                    sep = "")
    write.csv(outMealKCl, file = paste("./results/", f_MealKCl, sep=""))
    print("Meal + KCl results saved to:")
    print(sprintf("%s", f_MealKCl))

    # save parameters
    fpars <- paste("./results/", "params_", "MealMod",
                                "_notes-", notes, ".csv",
                                sep = "")
    write.csv(as.data.frame(params), file = fpars)
}