# /usr/bin/Rscript

########################
### Script Arguments ###
########################
# [1] = Assay Name in Project Directory i.e. 20200626_toxin08B
#args <- commandArgs(trailingOnly = TRUE)
#require(tidyverse)
#basedir <-paste0(getwd(),"/")
#setwd(paste(basedir, "projects/", as.character(args[1]), "/raw_images", sep = ""))

#----------
# make metadata
setwd("~/Desktop/CP_test/")
basedir <- getwd()
list.files(path = paste0(basedir, "/input"), pattern = "*.TIF")

###################
# Image File Path #
###################
Image_FileName_RawBF <- data.frame(list.files(path = paste0(basedir, "/input"), pattern = "*_w1.TIF"))
colnames(Image_FileName_RawBF) <- c("Image_FileName_RawBF")
Image_FileName_RawBF$path.copy <- Image_FileName_RawBF$Image_FileName_RawBF
images <- Image_FileName_RawBF %>% 
  tidyr::separate(col = path.copy, 
                  into = c("date","experiment","plate","magnification"), 
                  sep = "-") %>%
  tidyr::separate(col = magnification, 
                  into = c("magnification","well", "wavelength"),
                  sep = "_") %>%
  tidyr::separate(col = wavelength, 
                  into = c("wavelength","TIF"),
                  sep = "[.]") %>%
  dplyr::select(-TIF)



images$Image_PathName_RawBF <- paste(basedir,"/input/") ## CLUSTER
images <- images %>% 
  dplyr::select(Image_FileName_RawBF, Image_PathName_RawBF, date, experiment, plate, magnification, well, wavelength)

#######################
# Well Mask File Path #
#######################
images$Image_PathName_wellmask_98.png <- paste(basedir,"/well_masks/",sep = "") ## CLUSTER
images$Image_FileName_wellmask_98.png <- "wellmask_98.png"
colnames(images) <- c(colnames(images)[1:2], 
                      "Metadata_Date",
                      "Metadata_Experiment",
                      "Metadata_Plate",
                      "Metadata_Magnification",
                      "Metadata_Well",
                      "Metadata_Wavelength",
                      colnames(images)[8:9])

########################
# Add wavelength 2
########################
images2 <- images %>%
  dplyr::mutate(Image_PathName_RawRFP = stringr::str_replace(Image_PathName_RawBF, pattern = "_w1", replacement = "_w2"),
                Image_FileName_RawRFP = stringr::str_replace(Image_FileName_RawBF, pattern = "_w1", replacement = "_w2"))

########################
# Export Metadata File #
########################
today <- format(Sys.time(), '%Y%m%d')
filename <- paste("metadata",
                  today,
                  sep = "_")
setwd(paste0(basedir, "/metadata"))
write.csv(x = images2, file = paste(filename,".csv",sep = ""), row.names = F)

