library(ODEsensitivity)

source("set_params.r")
source("init_conds.r")
source("varnames.r")
source("model_eqns_baseSS.r")

testpars = c("Phi_Kin_ss", "FF", "kgut")
parsbinf = c(0.04375, 0.2252466, 0.009)
parsbsup = c(0.05347222, 0.2753014, 0.011)
parsinit = c(amt_gut = 4.37500,
                amt_plas = 18.92818,
                amt_inter = 42.06262,
                amt_muscle = 3123.72702)
mtimes = c(0.0001, 1000, 2000, 3000)

set.seed(1618)
start <- Sys.time()
Kmod_res_morris = ODEmorris(mod = model_eqns_baseSS,
                                pars = testpars,
                                state_init = parsinit,
                                times = mtimes,
                                binf = parsbinf,
                                bsup = parsbsup
                                )
end <- Sys.time()
print(difftime(end, start, units= "secs"))