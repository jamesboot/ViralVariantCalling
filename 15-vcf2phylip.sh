#!/bin/bash

# Script for converting vcf file to phylip
# 15-vcf2phylip.py script is required to run this script
# Save .py script in same directory that this submission script is saved in

##### Set queue options
#$ -M j.boot@qmul.ac.uk				# Email address
#$ -m bes										# Send email
#$ -cwd
#$ -pe smp 2									# Cores
#$ -l h_vmem=4G							# Memory
#$ -l h_rt=240:00:00						# Running time
#$ -N vcf2phylip								# Rename this
#$ -j y
#####

# Edit here: Define inputs and outputs
# FILE should be the input vcf
# OUTS should be the output folder (full path)
# PREFIX should be the prefix required on the output file
FILE=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/4.GATK-MSA241/cohort_variants.vcf.gz
OUTS=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/5.vcf2phylip
PREFIX=Cohort_MSA241

# Do not edit
# Load python
module load python/3.8.5

# Run python script
python 15-vcf2phylip.py --input $FILE --fasta --output-folder $OUTS --output-prefix $PREFIX