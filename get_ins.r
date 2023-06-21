
C_insulin = get_ins2(25)
C_insulin


# NOTE ADDED TO MY MODEL EQNS FUNCTION! THIS HOPEFULLY WILL WORK...
get_ins2 <- function(t_insulin) {
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

