#!/bin/bash

# 4-bowtie2-NC_007605.sh
# Author: James Boot, Date: 01/02/2024
# Script for running bowtie2 on trimmed fastq files, aligned to NC7605
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
#$ -N GC-AAA-10836_Bowtie2						# Change the name of the job accordingly
#$ -j y
#####

# SECTION 1: Only edit here

ANALYSISDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis
FASTQDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/3.trimgalore_results_hardtrim
OUTPUT_DIR=${ANALYSISDIR}/4.bowtie2-NC7605-hardtrim_results
GENOME=/data/WHRI-GenomeCentre/Genome/EBV1/bowtie2_index
R1FILES=${OUTPUT_DIR}/R1_files.txt
R2FILES=${OUTPUT_DIR}/R2_files.txt
SAMPLE_NAMES=${OUTPUT_DIR}/sample_names.txt

# SECTION 2: Do not edit

# Create output folders
mkdir -p ${OUTPUT_DIR}

# Find read 1's
find ${FASTQDIR} -regex ".*_R1_001.150bp_5prime.fq.gz"  ! -name "1M-*" | sort >> ${R1FILES}

# Find read 2's
find ${FASTQDIR} -regex ".*_R2_001.150bp_5prime.fq.gz"  ! -name "1M-*" | sort >> ${R2FILES}

# Get sample names 
sed 's:.*/::' ${R1FILES} | sed 's:_.*::' >> ${SAMPLE_NAMES}

# SECTION 3: Load module

module load bowtie2/2.4.5

# SECTION 4: Run bowtie2 in for loop

ITERATIONS=$(wc -l < ${SAMPLE_NAMES})

for i in $(seq ${ITERATIONS}); do
	
	echo "Iteration ${ITERATIONS}, file names and sample ID:"
	
	R1=$(sed -n "${i}p" ${R1FILES})
	echo "R1: ${R1}"
	
	R2=$(sed -n "${i}p" ${R2FILES})
	echo "R2: ${R2}"
	
	SAMPLE=$(sed -n "${i}p" ${SAMPLE_NAMES})
	echo "SAMPLE: ${SAMPLE}"
	
	echo "Running bowtie2..."
	
	# Run bowtie2
	bowtie2 -p ${NSLOTS} -x ${GENOME} -1 ${R1} -2 ${R2} -S ${OUTPUT_DIR}/${SAMPLE}.sam
	
done