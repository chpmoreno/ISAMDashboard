#!/bin/bash
echo "This scripts downloads data used in the dashboard"

wget "https://dl.dropboxusercontent.com/u/4039122/ISAM/sentimiento.csv"
wget "https://dl.dropboxusercontent.com/u/4039122/ISAM/unifreqdist-bruto.csv"
wget "https://dl.dropboxusercontent.com/u/4039122/ISAM/bifreqdist-bruto.csv"
wget "https://dl.dropboxusercontent.com/u/4039122/ISAM/trifreqdist-bruto.csv"
wget "https://dl.dropboxusercontent.com/u/4039122/ISAM/Series.csv"
wget "https://dl.dropboxusercontent.com/u/4039122/ISAM/info_axis.csv"

