library(deSolve)
library(reshape)
library(lattice)

source("set_params.r")
source("model_eqns.r")
source("init_conds.r")
source("varnames.r")

kmod <- list(init = init_conds(),
            params = set_params(),
            cmt = get_varnames(),
            model = model_eqns
            )

times <- seq(0, 5000, 0.1)

# Run the model
out <- as.data.frame(lsoda(
                            unlist(kmod$init[kmod$cmt]),
                            times,
                            kmod$model,
                            kmod$params,
                            rtol = 1e-10,
                            atol = 1e-10
                        )
                    )

eql <- out[nrow(out),]
print(kmod$init)
print(eql)

sprintf("Plasma [K]: %0.3f", eql$amt_plas/kmod$params$V_plas)
sprintf("Interstitial [K]: %0.3f", eql$amt_inter/kmod$params$V_inter)
sprintf("Muscle [K]: %0.3f", eql$amt_muscle/kmod$params$V_muscle)

# Plot trajectories
