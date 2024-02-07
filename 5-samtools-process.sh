#!/bin/bash

# 5-samtools-process.sh
# Author: James Boot, Date: 07/02/2024
# Script for running samtools functions on alignment output files (.SAM)
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
#$ -N GC-AAA-10836_Samtools						# Change the name of the job accordingly
#$ -j y
#####

# SECTION 1: Only edit here
SAMDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/4.bowtie2-MSA241_results
SAMFILES=${SAMDIR}/samfiles.txt

# SECTION 2: Load modules
module load samtools/1.10

# SECTION 3: Find files and sample names

# Find files
find ${SAMDIR} -regex ".*.sam" | sort >> ${SAMFILES}

# SECTION 4: Run samtools flagstat in for loop

# Number of lines in file defines iterations
ITERATIONS=$(wc -l < ${SAMFILES})

# For loop
for i in $(seq ${ITERATIONS})
do	
    # Log iteration
	echo "Iteration ${i}, file names and sample ID:"
	
    # Define file and log
	FILE=$(sed -n "${i}p" ${SAMFILES})
	echo "FILE: ${FILE}"
	
    # Define sample and log
	SAMPLE=$(basename ${FILE})
	echo "SAMPLE: ${SAMPLE}"
	
    # Log
	echo "Running samtools..."
    
    # Run samtools flagstat
    samtools flagstat ${FILE} -O tsv >> ${SAMPLE}.tsv
done