mealmod_MealKCl <- function(Time, State, Pars) {

    # State variables
    # amt_gut
    # conc_plas
    # conc_inter
    # conc_muscle

    #dydt <- c()
    with(as.list(c(State, Pars)), {
        KMuscleBase = 130
        Kecf_base = 4.2
        Phi_Kin_ss = 70/1440

        # set parameters that are fixed (not in Morris)
        amt_gutSS <- (0.9 * Phi_Kin_ss) / kgut
        NKAbase <- (Vmax*Kecf_base)/(Km + Kecf_base)
        P_muscle <- NKAbase/(KMuscleBase - Kecf_base)

        fecal_exc = 0.1 # leave as fixed
        etapsKreab = 0.92

        # simulation settings
        meal_start <- 100 + 6*60 # time meal starts
        meal_time <- 30 # meal duration
        # Meal + KCl
        if (Time < 100){
            SS <- 1
        } else {
            SS <- 0
        }
        do_FF <- 1
        do_insulin <- 1 # Meal + KCl
        MKX <- 0
        if (Time < 100) {
            Kintake <- Phi_Kin_ss
        } else if (Time <= meal_start) {
            Kintake <- 0
        } else if (Time > (meal_start + meal_time)) {
            Kintake <- 0
        } else if (Time <= (meal_start + meal_time)) {
            Kintake <- 35/meal_time
        } else {
            print(sprintf("Time = %f", Time))
            stop("Kintake not defined due to time error")
        }
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
            if (SS) {
                t_insulin = -1 # will give SS
            } else {
                t_insulin = Time - meal_start
            }
            #C_insulin = get_ins(t_insulin)
            # C_insulin units are in nanomole/L
            if (t_insulin <= 0) {
                C_insulin <- 22.6/1000
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
        dinter <- (1 / V_inter) * (Plas2ECF - Inter2Muscle + Muscle2Inter)

        # conc_muscle (intracellular K)
        # d(conc_muscle)/dt
        dmuscle <- (1 / V_muscle) * (Inter2Muscle - Muscle2Inter)

        return(list(c(dgut, dplas, dinter, dmuscle)))
    })

}
