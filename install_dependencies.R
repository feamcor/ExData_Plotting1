##
## Coursera Data Science Specialization
## Course: Exploratory Data Analysis
## Course Instance: exdata-034
## Assignment: Course Project 1
## Student: Fabio Correa (feamcor)
##

##
## Install all required packages that
## are missing on current R instalation
## as specified on <packages.required>
##

install_dependencies <- function(packages.required) {
    packages.missing <- packages.required[!(packages.required %in% installed.packages()[, "Package"])]
    if(length(packages.missing) > 0) {
        message(paste(Sys.time(), "WARNING: Some required packages are missing and will be installed!"))
        install.packages(packages.missing)
    }
}
