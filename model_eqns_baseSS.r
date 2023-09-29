model_eqns_baseSS <- function(Time, State, Pars) {

    # State variables
    # amt_gut
    # conc_plas
    # conc_inter
    # conc_muscle

    #dydt <- c()
    with(as.list(c(State, Pars)), {
        #KMuscleBase = 130
        #Kecf_base = 4.2
        Phi_Kin_ss = 70/1440
        #ALD_eq = 85

        # set parameters that are fixed (not in Morris)
        fecal_exc = 0.1 # leave as fixed
        # etapsKreab = 0.92

        amt_gutSS <- ((1 - fecal_exc) * Phi_Kin_ss) / kgut
        NKAbase <- (Vmax*Kecf_base)/(Km + Kecf_base)
        P_muscle <- NKAbase/(KMuscleBase - Kecf_base)

        # simulation settings
        meal_start <- 100 + 6 * 60 # time meal starts
        meal_time <- 30 # meal duration

        SS <- 1 # steady state
        do_FF <- 1
        do_insulin <- 1 
        MKX <- 0
        Kintake = Phi_Kin_ss
        # concentrationsr)
        K_ECFtot = (conc_plas * V_plasma + 
                conc_inter * V_inter) / (V_plasma + V_inter)

        # ALD
        N_al = exp(m_K_ALDO * (K_ECFtot - Kecf_base))
        C_al = N_al * ALD_eq


        # amt_gut (Gut K)
        if (SS) {
            Phi_Kin = Phi_Kin_ss
        } else {
            Phi_Kin = Kintake
        }
        K_intake = (1 - fecal_exc) * Phi_Kin
        Gut2plasma = kgut * amt_gut
        # d(amt_gut)/dt
        dgut <- K_intake - Gut2plasma

        # conc_plas (Plasma K)
        Plas2ECF = P_ECF*(conc_plas - conc_inter)

        # GI FF effect
        if (do_FF) {
            temp = FF * (amt_gut - amt_gutSS) + 1
            gamma_Kin = max(1,temp)
        } else {
            gamma_Kin = 1
        }

        # renal K handling
        filK = GFR * conc_plas
        psKreab = etapsKreab * filK

        # ALD impact
        gamma_al = A_dtKsec * C_al^B_dtKsec
        lambda_al = A_cdKsec * C_al^B_cdKsec

        eta_dtKsec = gamma_al * gamma_Kin
        dtKsec = dtKsec_eq * eta_dtKsec

        eta_cdKsec = lambda_al
        cdKsec = cdKsec_eq * eta_cdKsec

        eta_cdKreab = 1
        dtK = filK - psKreab + dtKsec
        cdKreab = dtK * A_cdKreab * eta_cdKreab

        UrineK = dtK + cdKsec - cdKreab

        # d(conc_plas)/dt
        dplas <- (1 / V_plasma) * (Gut2plasma - Plas2ECF - UrineK)

        # amt_inter (Interstitial K)
        rho_al = (66.4 + 0.273 * C_al)/89.6050

        # insulin
        if (do_insulin){
            t_insulin = -1 # will give SS
            C_insulin = 22.6/1000 # set to SS

            L = 100
            x0 = 0.5381
            k = 1.069
            ins_A = A_insulin
            ins_B = 100 * B_insulin
            temp = (ins_A*(L/(1+exp(-k*(log10(C_insulin)
                    -log10(x0)))))+ ins_B)/100
            rho_insulin = max(1.0, temp)
        } else {
            # set insulin to SS amount
            C_insulin = 22.6/1000
            rho_insulin = 1.0
        }

        eta_NKA = rho_insulin * rho_al

        Inter2Muscle = eta_NKA * ((Vmax * conc_inter)/(Km + conc_inter))
        Muscle2Inter = P_muscle * (conc_muscle - conc_inter)

        # d(conc_inter)/dt
        dinter <- (1 / V_inter) * (Plas2ECF - Inter2Muscle + Muscle2Inter)

        # conc_muscle (intracellular K)
        # d(conc_muscle)/dt
        dmuscle <- (1 / V_muscle) * (Inter2Muscle - Muscle2Inter)

        return(list(c(dgut, dplas, dinter, dmuscle)))
    })

}
