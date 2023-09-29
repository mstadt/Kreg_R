library(rootSolve)
library(sensitivity)
source("model_eqns_baseSS.r")
source("computeSS_1var.r")
source("computeSS_all.r")
source("set_params.r")

# get testpars, parsbinf, parsbsup
p <- set_params()
source("set_morris.r")

set.seed(151)

rval = 10000

# plasma concentration
start_all <- Sys.time()
start_pconc <- Sys.time()
print(start_pconc)
print('start plas conc morris method')
x_plasconc <- morris(model = computeSS_plasconc,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup,
                            scale = TRUE)
end_pconc <- Sys.time()
print(end_pconc)
print(difftime(end_pconc, start_pconc, units= "secs"))

# compute mu, mu*, sigma
x <- x_plasconc
x_plasconc$mu <- apply(x$ee, 2, mean)
x_plasconc$mu.star <- apply(x$ee, 2, function(x) mean(abs(x)))
x_plasconc$sigma <- apply(x$ee, 2, sd)
# NOTE: can used x_plasconc$ee to get the elementary effects
# NOTE: I can get X by using x_plasconc$X

# interstitial space conc
start_iconc <- Sys.time()
print(start_iconc)
print('start inter conc morris method')
x_interconc <- morris(model = computeSS_interconc,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup,
                            scale = TRUE)
end_iconc <- Sys.time()
print(end_iconc)
print(difftime(end_iconc, start_iconc, units= "secs"))

# compute mu, mu*, sigma
x <- x_interconc
x_interconc$mu <- apply(x$ee, 2, mean)
x_interconc$mu.star <- apply(x$ee, 2, function(x) mean(abs(x)))
x_interconc$sigma <- apply(x$ee, 2, sd)

# muscle concentration
start_mconc <- Sys.time()
print(start_mconc)
print('start muscle conc morris method')
x_muscle <- morris(model = computeSS_muscleconc,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup,
                            scale = TRUE)
end_mconc <- Sys.time()
print(end_mconc)
print(difftime(end_mconc, start_mconc, units= "secs"))

# compute mu, mu*, sigma
x <- x_muscle
x_muscle$mu <- apply(x$ee, 2, mean)
x_muscle$mu.star <- apply(x$ee, 2, function(x) mean(abs(x)))
x_muscle$sigma <- apply(x$ee, 2, sd)

# amount gut
start_agut <- Sys.time()
print(start_agut)
print('start amt gut morris method')
x_amtgut <- morris(model = computeSS_amtgut,
                            factors = testpars,
                            r = rval,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup,
                            scale = TRUE)
end_amtgut <- Sys.time()
print(end_amtgut)
print(difftime(end_amtgut, start_agut, units= "secs"))
# compute mu, mu*, sigma
x <- x_amtgut
x_amtgut$mu <- apply(x$ee, 2, mean)
x_amtgut$mu.star <- apply(x$ee, 2, function(x) mean(abs(x)))
x_amtgut$sigma <- apply(x$ee, 2, sd)



# compute based on all variables
start_allvars <- Sys.time()
print(start_allvars)
print('start all morris method')
x_all <- morrisMultOut(model = computeSS_all,
                            factors = testpars,
                            r = 100,
                            design = list(type = "oat",
                                            levels = 10,
                                            grid.jump = 1),
                            binf = parsbinf,
                            bsup = parsbsup,
                            scale = TRUE)

print('all morris complete')
end <- Sys.time()
print(end)
print(difftime(end, start_all, units= "mins"))

# compute mu, mu*, sigma
x <- x_all
x_all$mu <- apply(x$ee, 2, mean)
x_all$mu.star <- apply(x$ee, 2, function(x) mean(abs(x)))
x_all$sigma <- apply(x$ee, 2, sd)

save_info = 1
if (save_info) {
    today <- Sys.Date()
    fname <- paste(today,
                    "_MorrisAnalysis_SS",
                    ".RData",
                    sep = "")
    save.image(fname)
    print("results saved to:")
    print(sprintf("%s", fname))
}