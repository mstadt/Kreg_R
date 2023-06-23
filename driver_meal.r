# Run a meal experiment based on given settings

library(deSolve)
library(rootSolve)

# get relevant functions
source("set_params.r")
source("model_eqns.r")
source("init_conds.r")
source("varnames.r")

## set options for simulation
GI_FF     <- 1 # do GI FF effect
Ins       <- 1 # do insulin effect
K_amt     <- 35 # amount of K in meal (35 mEq is Preston exp)
MKX_opt   <- 0 # optional MK cross talk

meal_time = 30 # time of meal

## get initial condition (SS)
IC <- init_conds()
params <- set_params()

init_guess <- c(IC$amt_gut,
                IC$amt_plas,
                IC$amt_inter,
                IC$amt_muscle)
set_opts <- list(SS = 1,
                 doFF = GI_FF,
                 doins = Ins,
                 Kin = 0,
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
set_opts$doins = 0 # turn on insulin when giving meal w/ glucose
set_opts$Kin = 0 # fasting state

kmod <- list(init = IC,
            params = set_params(),
            cmt = get_varnames(),
            model = model_eqns,
            opts = set_opts
            )

t0 = 0
tf = 6*60 # 6 hours of fasting
times <- seq(t0, tf, 1)

# Run the model for fasting state for 6 hours
outfast <- as.data.frame(lsoda(
                            unlist(kmod$init[kmod$cmt]),
                            times,
                            kmod$model,
                            kmod$params,
                            opts = kmod$opts,
                            rtol = 1e-10,
                            atol = 1e-10
                        )
                    )

outfast$time_shift <- outfast$time - tf

endpt_fast <- as.list(tail(outfast, n=1)) # last row of outfast

kmod_fast <- kmod # save if need later

# Add Meal Option
t0   = 0 # starting time at end of last simulation
tf   = t0 + meal_time

times =  seq(t0, tf, 1)

kmod$opts$doins = Ins # turn on insulin if doing
kmod$opts$Kin   = K_amt / (tf - t0) # add K intake per minute

kmod$init       = within(endpt_fast, rm("time"))

outmeal <- as.data.frame(lsoda(
                            unlist(kmod$init[kmod$cmt]),
                            times,
                            kmod$model,
                            kmod$params,
                            opts = kmod$opts,
                            rtol = 1e-10,
                            atol = 1e-10 
                            )
                        )

endpt_meal <- as.list(tail(outmeal, n=1)) # last row of outmeal

kmod_meal <- kmod # save kmod if need later

# Done meal intake
t0 = endpt_meal$time
tf = t0 + 1000 - 30
times = seq(t0, tf, 1)

kmod$opts$Kin = 0 # no more K intake

kmod$init     = within(endpt_meal, rm("time"))

outmeal_post <- as.data.frame(lsoda(
                            unlist(kmod$init[kmod$cmt]),
                            times,
                            kmod$model,
                            kmod$params,
                            opts = kmod$opts,
                            rtol = 1e-10,
                            atol = 1e-10 
                            )
                        )

kmodmeal_post <- kmod # save kmod if want later
