set_params <- function() {
    # set parameters for model
    # PhiKinSS <- 70/1440
    # kgut <- 0.01
    # MKgutSS <- (0.9 * PhiKinSS) / kgut
    # KMuscleBase = 130
    # KECF_base <- 4.2
    #VMAX = 130
    #KM = 1.4
    list(
        V_plasma = 4.5,
        V_inter = 10,
        V_muscle = 24,
        m_K_ALDO = 0.5,
        ALD_eq = 85,
        Phi_Kin_ss = 70 / 1440,
        kgut = 0.01,
        fecal_exc = 0.1,
        P_ECF = 0.3,
        FF = 0.250274,
        Kecf_base = 4.2,
        GFR = 0.125,
        etapsKreab = 0.92,
        dtKsec_eq = 0.041,
        A_dtKsec = 0.3475,
        B_dtKsec = 0.23792,
        cdKsec_eq = 0.0022,
        A_cdKsec = 0.161275,
        B_cdKsec = 0.410711,
        A_cdKreab = 0.499994223625298,
        A_insulin = 0.999789,
        B_insulin = 0.6645,
        t_insulin_ss = 270,
        Vmax = 130,
        Km = 1.4,
        KMuscleBase = 130
    )
}