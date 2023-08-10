library(rootSolve)
library(sensitivity)
source("model_eqns_baseSS.r")
source("computeSS_plasconc.r")
source("computeSS_all.r")
source("set_params.r")

# get testpars, parsbinf, parsbsup
p <- set_params()
source("set_morris.r")


## This is for just one variable.... here is plasma conc, but can get others!
plasconc_SS_morris <- morris(model = computeSS_plasconc,
                            factors = testpars,
                            r = 100,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup)
# NOTE: can used plasconc_SS_morris$ee to get the elementary effects
# NOTE: I can get X by using plasconc_SS_morris$X



## Yay! This is working here! :)
# this one gives mu, mu.star and sigma for each of the parameters
# based on all of the variables
all_SS_morris <- morrisMultOut(model = computeSS_all,
                            factors = testpars,
                            r = 100,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup)
# use all_SS_morris$ee to get elementary effects
# use all_SS_morris$X to get X for the factors