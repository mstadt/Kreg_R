model_eqns <- function(t, y, params, opts) {
    # Regular model equations
    # State variables
    # amt_gut
    # conc_plas
    # conc_inter
    # conc_muscle

    # simulation settings
    SS = opts$SS
    do_FF = opts$doFF
    do_insulin = opts$doins
    MKX = opts$MKX
    Kintake = opts$Kin
    HighKSim = opts$HighKSim

    # variable names
    amt_gut <- y[1]
    conc_plas <- y[2]
    conc_inter <- y[3]
    conc_muscle <- y[4]

    dydt <- c()
    with(params, {
        Phi_Kin_ss = 70/1440

        # solve parameters that are based on others
        amt_gutSS <- (0.9 * Phi_Kin_ss) / kgut
        NKAbase <- (Vmax*Kecf_base)/(Km + Kecf_base)
        P_muscle <- NKAbase/(KMuscleBase - Kecf_base)

        # total ECF concentration
        K_ECFtot = (conc_plas * V_plasma +
                    conc_inter * V_inter) / (V_plasma + V_inter)

        # ALD
        N_al = exp(m_K_ALDO * (K_ECFtot - Kecf_base))
        C_al = N_al * ALD_eq

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
        dydt[1] <- K_intake - Gut2plasma

        # conc_plas (Plasma K)
        Plas2ECF = P_ECF*(conc_plas - conc_inter)

        # GI FF effect
        if (do_FF) {
            temp = FF * (amt_gut - amt_gutSS) + 1
            gamma_Kin = max(1, temp)
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
        dydt[2] <- (1 / V_plasma) * (Gut2plasma - Plas2ECF - UrineK)

        # conc_inter (Interstitial K)
        rho_al = (66.4 + 0.273 * C_al) / 89.6050

        # insulin
        if (do_insulin){
            if (SS) {
                t_insulin = -1 # will give SS
            } else {
                t_insulin = t
            }
            #C_insulin = get_ins(t_insulin)
            # C_insulin units are in nanomole/L
            if (t_insulin <= 0) {
                C_insulin <- 22.6 / 1000
            } else if ((t_insulin > 0) & (t_insulin < 1.5*60)) {
                C_insulin <- ((325 - 22.6)/(1.5*60)*(t_insulin) + 22.6)/1000
            } else if ((t_insulin >= 1.5*60) & (t_insulin < 6*60)) {
                C_insulin <- ((22.6-325)/((6-1.5)*60)*(t_insulin - 6*60)
                                    + 22.6)/1000
            } else if (t_insulin >= 6*60) {
                C_insulin <- 22.6/1000
            } else {
                print("something went wrong with t_insulin")
            }
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
        dydt[3] <- (1 / V_inter) * (Plas2ECF - Inter2Muscle + Muscle2Inter)

        # conc_muscle (intracellular K)
        # d(conc_muscle)/dt
        dydt[4] <- (1 / V_muscle) * (Inter2Muscle - Muscle2Inter)

        list(c(dydt))
    })

}