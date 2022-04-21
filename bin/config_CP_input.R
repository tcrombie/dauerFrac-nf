#!/usr/bin/env Rscript
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(glue)
library(purrr)
library(data.table)

#==============================================#
# Arguments                                    #
#==============================================#
# [1]: full path to project directory
# [2]: profile for pipeline usage - NEED TO IMPLEMENT
args <- "/projects/b1059/projects/Tim/dauerFrac-nf/CP_test" # for debugging
# args <- commandArgs(trailingOnly = TRUE)

#==============================================#
# Make Metadata                                #
#==============================================#
projDir <- args[1]
raw_imagesDir <- paste0(projDir, "/raw_images")

