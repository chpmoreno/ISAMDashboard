# This script download the data necessary for running the dashboard.
# Set the directory where you are going to save the data. The following is an example:
# If you open the project file ISAM.Rproj you just have to use setwd("Dashboard/Data")
# Else use something like setwd("~/ISAM/Dashboard/Data")
# setwd("Dashboard/Data")
# In case you are running this program in the shell you can go to the directory data
# (cd data/) and then sudo (if necessary) Rscript download_data.R

# Download the files and give them a name according to the global.R file
download.file("https://dl.dropboxusercontent.com/u/4039122/ISAM/sentimiento.csv", "sentimiento.csv")
download.file("https://dl.dropboxusercontent.com/u/4039122/ISAM/unifreqdist-bruto.csv", "unifreqdist-bruto.csv")
download.file("https://dl.dropboxusercontent.com/u/4039122/ISAM/bifreqdist-bruto.csv", "bifreqdist-bruto.csv")
download.file("https://dl.dropboxusercontent.com/u/4039122/ISAM/trifreqdist-bruto.csv", "trifreqdist-bruto.csv")
download.file("https://dl.dropboxusercontent.com/u/4039122/ISAM/Series.csv", "Series.csv")
download.file("https://dl.dropboxusercontent.com/u/4039122/ISAM/info_axis.csv", "info_axis.csv")

