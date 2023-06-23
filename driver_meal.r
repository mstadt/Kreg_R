# Run a meal experiment based on given settings

library(deSolve)
library(rootSolve)

# get relevant functions
source("set_params.r")
source("model_eqns.r")
source("init_conds.r")
source("varnames.r")

## set options for simulation
GI_FF    = 1 # do GI FF effect
Ins      = 1 # do insulin effect
K_in     = 0 # amount of K in meal
MKX_opt  = 0 # optional MK cross talk

## get initial condition (SS)
IC <- init_conds()

init_guess <- c(IC$amt_gut,
                IC$amt_plas,
                IC$amt_inter,
                IC$amt_muscle)
set_opts <- list(SS = 1,
                 doFF = GI_FF,
                 doins = Ins,
                 Kin = K_in,
                 MKX = MKX_opt)

ST <- stode(init_guess, time = 0, func = model_eqns,
                         parms = params, opts = set_opts)

ST$yconc <- list(Kplas = ST$y[2]/params$V_plasma,
                 Kinter = ST$y[3]/params$V_inter,
                 Kmuscle = ST$y[4]/params$V_muscle)
sprintf("Steady state concentrations")
sprintf("Plasma [K]: %0.3f", ST$yconc$Kplas)
sprintf("Inter [K]:  %0.3f", ST$yconc$Kinter)
sprintf("Muslce [K]: %0.3f", ST$yconc$Kmuscle)

## update IC with SS initial conditions
IC$amt_gut <- ST$y[1]
IC$amt_plas <- ST$y[2]
IC$amt_inter <- ST$y[3]
IC$amt_muscle <- ST$y[4]

set_opts$SS = 0 # turn off SS option
set_opts$doins = 0 # turn on insulin when giving meal

kmod <- list(init = IC,
            params = set_params(),
            cmt = get_varnames(),
            model = model_eqns,
            opts = set_opts
            )

times <- seq(0, 100, 0.1)

# Run the model for SS for 100 mins
outSS <- as.data.frame(lsoda(
                            unlist(kmod$init[kmod$cmt]),
                            times,
                            kmod$model,
                            kmod$params,
                            opts = kmod$opts,
                            rtol = 1e-10,
                            atol = 1e-10
                        )
                    )