library(ODEsensitivity)

source("set_params.r")
source("init_conds.r")
source("varnames.r")
source("model_eqns_baseSS.r")

p <- set_params()

testpars = c("Phi_Kin_ss",
            "kgut",
            "KMuscleBase",
            "Kecf_base",
            "Km",
            "Vmax",
            "V_plasma",
            "V_inter",
            "V_muscle",
            "m_K_ALDO",
            "ALD_eq",
            "P_ECF",
            "FF",
            "GFR",
            "dtKsec_eq",
            "A_dtKsec",
            "B_dtKsec",
            "cdKsec_eq",
            "A_cdKsec",
            "B_cdKsec",
            "A_cdKreab",
            "A_insulin",
            "B_insulin"
            )


parsbinf = c(50/1440, # Phi_Kin_ss
            0.5*p$kgut, # kgut
            120, # KMuscleBase, normal range
            3.5, # KECF_base, normal range
            0.8, # Km, Cheng gave
            0.75 * p$Vmax, # Vmax
            0.9 * p$V_plasma, # V_plasma
            0.9 * p$V_inter, # V_inter
            0.9 * p$V_muscle, # V_muscle
            0.5 * p$m_K_ALDO, # m_K_ALDO
            0.75 * p$ALD_eq, # ALD_eq
            0.5 * p$P_ECF, # P_ECF
            0.5 * p$FF, # FF
            100 / 1000, # GFR, normal healthy range
            0.9 * p$dtKsec_eq, # dtKsec_eq
            0.5 * p$A_dtKsec, # A_dtKsec
            0.5 * p$B_dtKsec, # B_dtKsec
            0.9 * p$cdKsec_eq, # cdKsec_eq
            0.5 * p$A_cdKsec, # A_cdKsec
            0.5 * p$B_cdKsec, # B_cdKsec
            0.9 * p$A_cdKreab, # A_cdKreab
            0.75 * p$A_insulin, # A_insulin
            0.75 * p$B_insulin # B_insulin
            )
            
parsbsup = c(150 / 1440, #Phi_Kin_ss
            1.5 * p$kgut, # kgut
            140, # KMuscleBase, normal range
            5.0, # KECF_base, normal range
            1.5, # Km, Cheng gave
            1.25 * p$Vmax, # Vmax
            1.1 * p$V_plasma, # V_plasma
            1.1 * p$V_inter, # V_inter
            1.1 * p$V_muscle, # V_muscle
            1.5 * p$m_K_ALDO, # m_K_ALDO
            1.25 * p$ALD_eq, # ALD_eq
            1.5 * p$P_ECF, # P_ECF
            1.5 * p$FF, # FF
            130 / 1000, # GFR, normal healthy range
            1.1 * p$dtKsec_eq, # dtKsec_eq
            1.5 * p$A_dtKsec, # A_dtKsec
            1.5 * p$B_dtKsec, # B_dtKsec
            1.1 * p$cdKsec_eq, # cdKsec_eq
            1.5 * p$A_cdKsec, # A_cdKsec
            1.5 * p$B_cdKsec, # B_cdKsec
            1.1 * p$A_cdKreab, # A_cdKreab
            1.25 * p$A_insulin, # A_insulin
            1.25 * p$B_insulin # B_insulin
            )



init_cond = c(amt_gut = 4.37500,
                amt_plas = 18.92818,
                amt_inter = 42.06262,
                amt_muscle = 3123.72702)

mtimes = c(0.0001, 2000, 3000, 5000)

set.seed(151)
start <- Sys.time()
print(start)
print('start sobol method')
Kmod_sobol = ODEsobol(mod = model_eqns_baseSS,
                                pars = testpars,
                                state_init = init_cond,
                                times = mtimes,
                                binf = parsbinf,
                                bsup = parsbsup,
                                n = 1000
                                )
end <- Sys.time()
print(end)

print(difftime(end, start, units= "secs"))

save_info = 1
if (save_info) {
    today <- Sys.Date()
    fname <- paste(today,
                    "_SobolAnalysis",
                    ".RData",
                    sep = "")
    save.image(fname)
    print("results saved to:")
    print(sprintf("%s.RData", fname))
}