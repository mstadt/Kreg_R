library(rootSolve)
library(sensitivity)
source("model_eqns_baseSS.r")
source("computeSS_1var_Sobol.r")
source("set_params.r")

# get testpars, parsbinf, parsbsup
p <- set_params()
source("set_sobol.r")

set.seed(151)

rargs = paste0("min = ", parsbinf,", max = ", parsbsup)
rfuncs = "runif"
rfunc_calls <- paste0(rfuncs, "(n, ", rargs, ")", collapse = ", ")
k <- length(testpars)
n <- 10000
X1 <- matrix(eval(parse(text = paste0("c(", rfunc_calls, ")"))), ncol = k)
X2 <- matrix(eval(parse(text = paste0("c(", rfunc_calls, ")"))), ncol = k)

start_all <- Sys.time()
start_pc <- Sys.time()
print('start plas conc sobol')
x_plasconc <- sobolmartinez(model = computeSS_plasconc,
                                X1,
                                X2,
                                nboot = 0,
                                pnames = testpars)
end_pc <- Sys.time()
print(difftime(end_pc, start_pc, units = "mins"))

start_mc <- Sys.time()
print('start musc conc sobol')
x_muscconc <- sobolmartinez(model = computeSS_muscleconc,
                                X1,
                                X2,
                                nboot = 0,
                                pnames = testpars)
end_musc <- Sys.time()
print(difftime(end_musc, start_mc, units = "mins"))


print('all sobol complete')
end_all <- Sys.time()
print(difftime(end_all, start_all, units= "mins"))

save_info = 1
if (save_info) {
    today <- Sys.Date()
    fname <- paste(today,
                    "_Sobol_SS",
                    ".RData",
                    sep = "")
    save.image(fname)
    print("results saved to:")
    print(sprintf("%s", fname))
}