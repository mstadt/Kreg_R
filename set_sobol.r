# parameter settings for Sobol method
testpars <- c("V_plasma",
            "V_inter",
            "V_muscle",
            "kgut",
            "Km",
            "Vmax",
            "m_K_ALDO",
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

parsbinf <- c(0.75 * p$V_plasma, # V_plasma
            0.75 * p$V_inter, # V_inter
            0.75 * p$V_muscle, # V_muscle
            0.75 * p$kgut, # kgut
            0.8, # Km, Cheng gave
            0.75 * p$Vmax, # Vmax
            0.75 * p$m_K_ALDO, # m_K_ALDO
            0.75 * p$P_ECF, # P_ECF
            0.75 * p$FF, # FF
            100 / 1000, # GFR, normal healthy range
            0.85 * p$dtKsec_eq, # dtKsec_eq
            0.75 * p$A_dtKsec, # A_dtKsec
            0.75 * p$B_dtKsec, # B_dtKsec
            0.85 * p$cdKsec_eq, # cdKsec_eq
            0.75 * p$A_cdKsec, # A_cdKsec
            0.75 * p$B_cdKsec, # B_cdKsec
            0.85 * p$A_cdKreab, # A_cdKreab
            0.75 * p$A_insulin, # A_insulin
            0.75 * p$B_insulin # B_insulin
            )

parsbsup <- c(1.25 * p$V_plasma, # V_plasma
            1.25 * p$V_inter, # V_inter
            1.25 * p$V_muscle, # V_muscle
            1.25 * p$kgut, # kgut
            1.5, # Km, Cheng gave
            1.25 * p$Vmax, # Vmax
            1.25 * p$m_K_ALDO, # m_K_ALDO
            1.25 * p$P_ECF, # P_ECF
            1.25 * p$FF, # FF
            130 / 1000, # GFR, normal healthy range
            1.15 * p$dtKsec_eq, # dtKsec_eq
            1.25 * p$A_dtKsec, # A_dtKsec
            1.25 * p$B_dtKsec, # B_dtKsec
            1.15 * p$cdKsec_eq, # cdKsec_eq
            1.25 * p$A_cdKsec, # A_cdKsec
            1.25 * p$B_cdKsec, # B_cdKsec
            1.15 * p$A_cdKreab, # A_cdKreab
            1.25 * p$A_insulin, # A_insulin
            1.25 * p$B_insulin # B_insulin
            )