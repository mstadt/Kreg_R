# Run a meal experiment based on given settings
library(deSolve)
library(rootSolve)
library(ggplot2)

# get relevant functions
source("set_params.r")
source("model_eqns.r")
source("init_conds.r")
source("varnames.r")

##--------------------------
#   Begin user input
##--------------------------
## set options for simulation
GI_FF     <- 1 # do GI FF effect
Ins       <- 1 # do insulin effect
K_amt     <- 0 # amount of K in meal (35 mEq is Preston exp)
MKX_opt   <- 0 # optional MK cross talk
HighKSim_opt  <- 0 # optional high K sim (based on Wang et al 2023)

meal_time = 30 # time of meal
##---------------------------
#  End user input
##---------------------------
## get initial condition (SS)
IC <- init_conds()
params <- set_params()

init_guess <- c(amt_gut = IC$amt_gut,
                conc_plas = IC$conc_plas,
                conc_inter = IC$conc_inter,
                conc_muscle = IC$conc_muscle)

set_opts <- list(SS = 1,
                 doFF = GI_FF,
                 doins = Ins,
                 Kin = 0,
                 MKX = MKX_opt,
                 HighKSim = HighKSim_opt)

ST <- stode(init_guess, time = 0, func = model_eqns,
                         parms = params, opts = set_opts,
                         ynames = FALSE)

# ## update IC with SS initial conditions
IC$amt_gut <- ST$y[1]
IC$conc_plas <- ST$y[2]
IC$conc_inter <- ST$y[3]
IC$conc_muscle <- ST$y[4]


print(sprintf("Steady state concentrations"))
print(sprintf("Plasma [K]: %0.3f", ST$y[2]))
print(sprintf("Inter [K]:  %0.3f", ST$y[3]))
print(sprintf("Muslce [K]: %0.3f", ST$y[4]))


# Run simulations
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

outfast$time <- outfast$time - tf # shift time so 0 is the meal start

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

out_postmeal <- as.data.frame(lsoda(
                                unlist(kmod$init[kmod$cmt]),
                                times,
                                kmod$model,
                                kmod$params,
                                opts = kmod$opts,
                                rtol = 1e-10,
                                atol = 1e-10 
                                )
                            )

kmod_postmeal <- kmod # save kmod if want later

sim_results <- rbind(outfast, outmeal, out_postmeal) # append sims to one df

## Plot results
plt_res = as.integer(readline(prompt = 'do you want to plot? '))
if (plt_res) {
p1 <- plot(sim_results[['amt_gut']], xlab = 'Time', ylab = 'amt_gut')
p2 <- plot(sim_results[['conc_plas']], xlab = 'Time', ylab = 'conc_plas')
p3 <- plot(sim_results[['conc_inter']], xlab = 'Time', ylab = 'conc_inter')
p4 <- plot(sim_results[['conc_muscle']], xlab = 'Time', ylab = 'conc_muscle')
}
# library(patchwork)
# p1 + p2 + p3 + p4
# library(reshape)
# library(lattice)
# print(xyplot(value~time|variable,
#        data=melt(sim_results,measure.vars=c("amt_gut","conc_plas","conc_inter","conc_muscle",kmod$cmt),id.vars="time"),
#        type='l',par.strip.text=list(cex=0.8),
#        scales=list(y=list(relation='free')),
#        xlab="Time (days)",
#        ylab="conc"
#        )
# )

## Save results
save_info = as.integer(readline(prompt = 'do you want to save? '))
if (save_info) {

    notes = readline(prompt = "notes for filename: ")
    today <- Sys.Date()
    fname <- paste(today, "_MealSim_", "Kin-", toString(K_amt),
                    "_doIns-", toString(Ins),
                    "_notes-", notes,
                    sep = "")
    fcsv <- paste("./results_sim/", fname, ".csv", sep = "")
    write.csv(sim_results, file = fcsv)

    f1 <- paste("./results_sim/", fname, ".RData", sep = "")
    save.image(file = f1) # save details of workspace

    f2 <- paste("./results_sim/", "params_", fname, ".csv", sep = "")
    write.csv(as.data.frame(params), file = f2)

    print("results saved to:")
    print(sprintf("%s.csv", fname))
}
