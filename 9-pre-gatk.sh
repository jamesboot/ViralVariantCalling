#!/bin/bash

##### Set queue options
#$ -M j.boot@qmul.ac.uk						# Email address
#$ -m bes									# Send email
#$ -cwd
#$ -pe smp 1								# Cores
#$ -l h_vmem=1G								# Memory
#$ -l h_rt=1:00:00						# Running time
#$ -N Pre-GATK							# Rename this
#$ -j y
#####

# Specify inputs and outputs
OUTPUT_DIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/4.GATK-NC76
SAMDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/3.bowtie2-NC7605_results
SAMFILES=${OUTPUT_DIR}/samfiles.txt
SAMPLE_NAMES=${OUTPUT_DIR}/samples.txt

# Create output folders
mkdir -p ${OUTPUT_DIR}

# Find SAM files
find ${SAMDIR} -regex ".*.sam" | sort >> ${SAMFILES}

# Get sample names 
sed 's:.*/::' ${SAMFILES} | sed 's:.sam::' >> ${SAMPLE_NAMES}