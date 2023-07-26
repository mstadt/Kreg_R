library(ODEsensitivity)

source("set_params.r")
source("mealmod_MealOnly.r")

p <- set_params()

# get testpars, parsbinf, parsbsup
source("set_sobol.r") #

init_cond = c(amt_gut = 4.37500,
                conc_plas = 18.92818 / p$V_plasma,
                conc_inter = 42.06262 / p$V_inter,
                conc_muscle = 3123.72702 / p$V_muscle)

# evaluate every 10 minutes
mtimes = seq(10,1000,10) 

set.seed(151)
start <- Sys.time()
print(start)
print('start sobol method')
Kmod_res_sobol = ODEsobol(mod = mealmod_MealOnly,
                                pars = testpars,
                                state_init = init_cond,
                                times = mtimes,
                                binf = parsbinf,
                                bsup = parsbsup,
                                n = 10000,
                                rfuncs = "runif",
                                rargs = paste0("min = ", parsbinf,
                                                ", max = ", parsbsup)
                                )
end <- Sys.time()
print(end)

save_info = 1
if (save_info) {
    today <- Sys.Date()
    fname <- paste(today,
                    "_SobolAnalysis_MealOnly_longtimes",
                    ".RData",
                    sep = "")
    save.image(fname)
    print("results saved to:")
    print(sprintf("%s", fname))
}

print(difftime(end, start, units = "mins"))