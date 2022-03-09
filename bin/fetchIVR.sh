#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2017/12/20

set -e
set -u
set -v       

# ===================================================== Check Dependencies
CODEDIR=~/Desktop/Swine_Survey/code

# ===================================================== Fetch Data from IVR
echo "===== Fetch entire nucleotide dataset from IVR"
[[ -f influenza.fna ]] || curl -O "ftp://ftp.ncbi.nih.gov/genomes/INFLUENZA/influenza.fna.gz"
[[ -f influenza.fna ]] || gunzip influenza.fna.gz
sleep 1    # to be nice

echo "===== Fetch annotations for nucelotides from IVR"
[[ -f influenza_na.dat ]] || curl -O "ftp://ftp.ncbi.nih.gov/genomes/INFLUENZA/influenza_na.dat.gz"
[[ -f influenza_na.dat ]] || gunzip influenza_na.dat.gz

echo "===== Fixing the missing IVR strain names and format the dates"
[[ -f influenza_na.dat2 ]] || perl ${CODEDIR}/fix_influenza_na.pl influenza_na.dat influenza.fna > temp.dat
[[ -f influenza_na.dat2 ]] || perl ${CODEDIR}/fixdates.pl temp.dat > influenza_na.dat2
[[ -f temp.dat ]] && rm temp.dat

echo "IVR data in influenza_na.dat2"