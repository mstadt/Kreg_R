library(ODEsensitivity)

source("set_params.r")
source("init_conds.r")
source("varnames.r")
source("model_eqns_baseSS.r")

testpars = c("Phi_Kin_ss",
            "kgut",
            "KMuscleBase",
            "Kecf_base",
            "Km",
            "Vmax",
            "V_plasma",
            "V_inter",
            "V_muscle"
            )


parsbinf = c(0.0347222, # Phi_Kin_ss
            0.005, # kgut
            120, # KMuscleBase
            3.5, # KECF_base
            0.8, # Km
            117, # Vmax
            4.05, # V_plasma
            9, # V_inter
            21.6 # V_muscle
            )
parsbsup = c(0.1041667, #Phi_Kin_ss
            0.015, # kgut
            140, # KMuscleBase
            5.0, # KECF_base
            1.5, # Km
            143, # Vmax
            4.95, # V_plasma
            11, # V_inter
            26.4 # V_muscle
            )



init_cond = c(amt_gut = 4.37500,
                amt_plas = 18.92818,
                amt_inter = 42.06262,
                amt_muscle = 3123.72702)

mtimes = c(0.0001, 2000, 3000, 5000)

set.seed(1618)
start <- Sys.time()
print(start)
print('start morris method')
Kmod_res_morris = ODEmorris(mod = model_eqns_baseSS,
                                pars = testpars,
                                state_init = init_cond,
                                times = mtimes,
                                binf = parsbinf,
                                bsup = parsbsup,
                                r = 500,
                                parallel_eval = TRUE
                                )
end <- Sys.time()
print(end)

print(difftime(end, start, units= "secs"))

save_info = 1
if (save_info) {
    today <- Sys.Date()
    fname <- paste("./MorrisResults/",today, 
                    "_MorrisAnalysis",
                    ".RData",
                    sep = "")
    save.image(fname)

    print("results saved to:")
    print(sprintf("%s.RData", fname))
}