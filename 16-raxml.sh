#!/bin/bash

##### Set queue options
#$ -M j.boot@qmul.ac.uk				# Email address
#$ -m bes										# Send email
#$ -cwd
#$ -pe smp 8									# Cores
#$ -l h_vmem=32G							# Memory
#$ -l h_rt=240:00:00						# Running time
#$ -N raxml-btstrp			# Rename this
#$ -j y
#$ -l highmem
#####

# Define file
FILE=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/5.vcf2phylip/Cohort_NC67.min4.phy
OUT=raxml-NC76

# Load module
module load raxml

# Run RAxML
# -m : model
# -p : random seed
# -s : input file
# -N : number of alternative runs on distinct starting trees. If combined with -x or -b specifies number of bootstraps
# -n : name of output files
# -x : rapid bootstrapping random seed

# With rapid bootstrapping (100btsrps)
raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s $FILE -n $OUT
