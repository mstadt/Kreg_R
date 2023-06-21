library(deSolve)
library(reshape)
library(lattice)

source("set_params.r")
source("model_eqns.r")
source("init_conds.r")
source("varnames.r")

kmod <- list(init = init_conds(),
            params = set_params(),
            cmt = varnames(),
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


# names(out) # this will gives the names
# nrow(out) # how many rows in data frame
# dim(out) # dimension of data frame
# out[n,] # gives row n

# Plot trajectories