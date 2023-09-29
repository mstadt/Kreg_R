library(xtable)
source("set_morris.r")
source("set_params.r")
p <- set_params()

vals_orig = c(p[testpars[1]],
                p[testpars[2]],
                p[testpars[3]],
                p[testpars[4]],
                p[testpars[5]],
                p[testpars[6]],
                p[testpars[7]],
                p[testpars[8]],
                p[testpars[9]],
                p[testpars[10]],
                p[testpars[11]],
                p[testpars[12]],
                p[testpars[13]],
                p[testpars[14]],
                p[testpars[15]],
                p[testpars[16]],
                p[testpars[17]],
                p[testpars[18]],
                p[testpars[19]],
                p[testpars[20]],
                p[testpars[21]],
                p[testpars[22]],
                p[testpars[23]]
                )
vals_orig <- as.numeric(vals_orig)

df1 <- data.frame(testpars, parsbinf, parsbsup, vals_orig)

latex_table <- xtable(df1)
print(latex_table, type = "latex")