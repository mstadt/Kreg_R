library(ODEsensitivity)

source("set_params.r")
source("model_eqns_baseSS.r")

p <- set_params()

# get testpars, parsbinf, parsbsup
source("set_morris.r")

init_cond = c(amt_gut = 4.37500,
                conc_plas = 18.92818 / p$V_plasma,
                conc_inter = 42.06262 / p$V_inter,
                conc_muscle = 3123.72702 / p$V_muscle)

mtimes = c(0.0001, 500, 2000, 3000, 5000)

set.seed(151)
start <- Sys.time()
print(start)
print('start morris method')
Kmod_res_morris = ODEmorris(mod = model_eqns_baseSS,
                                pars = testpars,
                                state_init = init_cond,
                                times = mtimes,
                                binf = parsbinf,
                                bsup = parsbsup,
                                r = 1000,
                                parallel_eval = TRUE
                                )
end <- Sys.time()
print(end)

print(difftime(end, start, units= "secs"))

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