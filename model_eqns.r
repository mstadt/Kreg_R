model_eqns <- function(t, y, params, opts) {
    
    # simulation settings
    SS = opts$SS
    do_FF = opts$doFF
    do_insulin = opts$doins
    MKX = opts$MKX
    Kintake = opts$Kin

    # variable names
    amt_gut <- y[1]
    amt_plas <- y[2]
    amt_inter <- y[3]
    amt_muscle <- y[4]

    dydt <- c()
    with(params, {
        # concentrations
        Kplas = amt_plas/V_plasma
        Kinter = amt_inter/V_inter
        Kmuscle = amt_muscle/V_muscle
        K_ECFtot = (amt_plas + amt_inter)/(V_plasma + V_inter)

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

        # amt_plas (Plasma K)
        Plas2ECF = P_ECF*(Kplas - Kinter)

        # GI FF effect
        if (do_FF) {
            temp = FF * (amt_gut - amt_gutSS) + 1
            gamma_Kin = max(1,temp)
        } else {
            gamma_Kin = 1
        }

        # renal K handling
        filK = GFR * Kplas
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

        # d(amt_plas)/dt
        dydt[2] <- Gut2plasma - Plas2ECF - UrineK

        # amt_inter (Interstitial K)
        rho_al = (66.4 + 0.273 * C_al)/89.6050

        # insulin
        if (do_insulin){
            if (SS) {
                t_insulin = t_insulin_ss
            } else {
                t_insulin = t
            }
            C_insulin = get_ins(t_insulin)
            L = 100
            x0 = 0.5381
            k = 1.069
            ins_A = A_insulin
            ins_B = 100 * B_insulin
            temp = (ins_A*(L/(1+exp(-k*(log10(C_insulin)-log10(x0)))))+ ins_B)/100
            rho_insulin = max(1.0, temp)
        } else {
            # set insulin to SS amount
            C_insulin = 22.6/1000
            rho_insulin = 1
        }

        eta_NKA = rho_insulin * rho_al

        Inter2Muscle = eta_NKA * ((Vmax * Kinter)/(Km + Kinter))
        Muscle2Inter = P_muscle * (Kmuscle - Kinter)

        # d(amt_inter)/dt
        dydt[3] <- Plas2ECF - Inter2Muscle + Muscle2Inter

        # amt_muscle (intracellular K)
        # d(amt_muscle)/dt
        dydt[4] <- Inter2Muscle - Muscle2Inter

        list(c(dydt))
    })

}

get_ins <- function(t_insulin) {
    # C_insulin units are in nanomole/L
    if (t_insulin <= 0) {
        C_insulin <- 22.6/1000
    } else if ((t_insulin > 0) & (t_insulin < 1.5*60)) {
        C_insulin <- ((325 - 22.6)/(1.5*60)*(t_insulin) + 22.6)/1000
    } else if ((t_insulin >= 1.5*60) & (t_insulin < 6*60)) {
        C_insulin <- ((22.6-325)/((6-1.5)*60)*(t_insulin - 6*60) + 22.6)/1000
    } else if (t_insulin >= 6*60) {
        C_insulin <- 22.6/1000
    } else {
        print("something went wrong in get_Cinsulin")
    }
}