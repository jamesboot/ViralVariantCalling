#!/bin/bash

# 2i-MSA241-cons.sh
# Author: James Boot, Date: 06/02/2024
# Script for creating consensus sequence from MSA using 'emboss cons'
# 1) Adjust queue settings - change job name and email address
# 2) Specify parameters in SECTION 1
# 3) Submit

##### Set queue options
#$ -M j.boot@qmul.ac.uk				            # Change to your email address
#$ -m bes
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=240:0:0
#$ -l h_vmem=8G
#$ -N GC-AAA-10836_emboss_cons					# Change the name of the job accordingly
#$ -j y
#####

# SECTION 1: Define parameters
SEQS=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/241_MSA.fasta
OUTFILE=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/241_MSA_Cons.fasta

# SECTION 2: Load module
module load emboss/6.6.0

# SECTION 3: Run emboss cons
cons ${SEQS} ${OUTFILE}