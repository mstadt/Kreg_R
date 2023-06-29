# After getting results from "runODEMorris.r",
# use this script to save the results into a .csv format
# for making figures

# file where Morris results are saved
Rdat_fname = "./MorrisResults/2023-06-27_MorrisAnalysis_fullparams.RData"
load(Rdat_fname) # load data into workspace

date_to_save <- "2023-06-27"
notes <- readline(prompt = "notes for filename: ")

# amt_gut
var <- "amt_gut"
save_fname = paste("./MorrisResults/", 
                    date_to_save,
                    "_MorrisAnalysis",
                    "_var-", var,
                    "_notes-", notes,
                    ".csv",
                    sep = "")
write.csv(Kmod_res_morris$amt_gut, file = save_fname)

# amt_plas
var <- "amt_plas"
save_fname = paste("./MorrisResults/", 
                    date_to_save,
                    "_MorrisAnalysis",
                    "_var-", var,
                    "_notes-", notes,
                    ".csv",
                    sep = "")
write.csv(Kmod_res_morris$amt_plas, file = save_fname)

# amt_inter
var <- "amt_inter"
save_fname = paste("./MorrisResults/", 
                    date_to_save,
                    "_MorrisAnalysis",
                    "_var-", var,
                    "_notes-", notes,
                    ".csv",
                    sep = "")
write.csv(Kmod_res_morris$amt_inter, file = save_fname)

# amt_muscle
var <- "amt_muscle"
save_fname = paste("./MorrisResults/", 
                    date_to_save,
                    "_MorrisAnalysis",
                    "_var-", var,
                    "_notes-", notes,
                    ".csv",
                    sep = "")
write.csv(Kmod_res_morris$amt_muscle, file = save_fname)