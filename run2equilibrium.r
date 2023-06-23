library(deSolve)
library(reshape)
library(lattice)

source("set_params.r")
source("model_eqns.r")
source("init_conds.r")
source("varnames.r")

## set options for simulation
set_opts <- list(SS = 1,
                 doFF = 1,
                 doins = 1,
                 Kin = 0,
                 MKX = 0)

kmod <- list(init = init_conds(),
            params = set_params(),
            cmt = get_varnames(),
            model = model_eqns,
            opts = set_opts
            )

times <- seq(0, 2000, 0.1)

# Run the model
out <- as.data.frame(lsoda(
                            unlist(kmod$init[kmod$cmt]),
                            times,
                            kmod$model,
                            kmod$params,
                            opts = kmod$opts,
                            rtol = 1e-10,
                            atol = 1e-10
                        )
                    )

eql <- subset(out[nrow(out),], select = -c(time))
print(kmod$init)
print(eql)

sprintf("Plasma [K]: %0.3f", eql$amt_plas/kmod$params$V_plas)
sprintf("Interstitial [K]: %0.3f", eql$amt_inter/kmod$params$V_inter)
sprintf("Muscle [K]: %0.3f", eql$amt_muscle/kmod$params$V_muscle)

# Plot trajectories
## Optional plotting routine
## REQUIRES loading of reshape and lattice libraries
# print(xyplot(value~time|variable,
#        data=melt(out,measure.vars=c(kmod$cmt),id.vars="time"),
#        type='l',par.strip.text=list(cex=0.8),
#        scales=list(y=list(relation='free')),
#        xlab="Time",
#        ylab="Variable"
#        )
# )
#plot(out[,'time'], out[,'amt_plas'])
#plot(out[,'time'], out[,'amt_gut'])
#plot(out[,'time'], out[,'amt_inter'])
#plot(out[,'time'], out[,'amt_muscle'])

#barplot(unlist(eql))