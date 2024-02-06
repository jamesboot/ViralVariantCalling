#!/bin/bash

# 2-bowtie-build.sh
# Author: James Boot, Date: 01/02/2024
# Script for building bowtie2 reference for alignment
# 1) Adjust queue settings - change job name and email address
# 2) Specify the relevant fasta file and output directory in SECTION 1
# 3) Copy this script to the project analysis folder and qsub

#####
#$ -M j.boot@qmul.ac.uk             # Change to your email address
#$ -m bes                          
#$ -cwd
#$ -pe smp 4                       
#$ -l h_vmem=7.5G                   
#$ -l h_rt=240:00:00               
#$ -N GC-AAA-10836_Index             # Change the name of the job accordingly
#$ -j y
#####

# SECTION 1: Only edit here
FASTA=/data/WHRI-GenomeCentre/Genome/EBV1/NC_007605.fasta
OUTDIR=/data/WHRI-GenomeCentre/Genome/EBV1/bowtie2_index

# SECTION 2: Load the module 
module load bowtie2/2.4.5

# SECTION 3: Run bowtie2 build
# Building a small index
bowtie2-build ${FASTA} ${OUTDIR}