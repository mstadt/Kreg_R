library(rootSolve)
library(sensitivity)
source("model_eqns_baseSS.r")
source("computeSS_1var.r")
source("computeSS_all.r")
source("set_params.r")

# get testpars, parsbinf, parsbsup
p <- set_params()
source("set_morris.r")

set.seed(151)

rval = 1000

## This is for just one variable.... here is plasma conc, but can get others!
start_all <- Sys.time()
start_pconc <- Sys.time()
print(start_pconc)
print('start plas conc morris method')
x_plasconc <- morris(model = computeSS_plasconc,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup)
end_pconc <- Sys.time()
print(end_pconc)
print(difftime(end_pconc, start_pconc, units= "secs"))
# NOTE: can used x_plasconc$ee to get the elementary effects
# NOTE: I can get X by using x_plasconc$X
start_iconc <- Sys.time()
print(start_iconc)
print('start inter conc morris method')
x_interconc <- morris(model = computeSS_interconc,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup)
end_iconc <- Sys.time()
print(end_iconc)
print(difftime(end_iconc, start_iconc, units= "secs"))

start_mconc <- Sys.time()
print(start_mconc)
print('start muscle conc morris method')
x_muscle <- morris(model = computeSS_muscleconc,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup)
end_mconc <- Sys.time()
print(end_mconc)
print(difftime(end_mconc, start_mconc, units= "secs"))


start_agut <- Sys.time()
print(start_agut)
print('start amt gut morris method')
x_amtgut <- morris(model = computeSS_amtgut,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup)
end_amtgut <- Sys.time()
print(end_amtgut)
print(difftime(end_amtgut, start_agut, units= "secs"))



## Yay! This is working here! :)
# this one gives mu, mu.star and sigma for each of the parameters
# based on all of the variables
start_allvars <- Sys.time()
print(start_allvars)
print('start all morris method')
x_all <- morrisMultOut(model = computeSS_all,
                            factors = testpars,
                            r = 100,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup,
                            scale = TRUE)

print('all morris complete')
end <- Sys.time()
print(end)
print(difftime(end, start_all, units= "mins"))


# use all_SS_morris$ee to get elementary effects
# use all_SS_morris$X to get X for the factors
save_info = 1
if (save_info) {
    today <- Sys.Date()
    fname <- paste(today,
                    "_MorrisAnalysis_SS",
                    ".RData",
                    sep = "")
    save.image(fname)
    print("results saved to:")
    print(sprintf("%s", fname))
}