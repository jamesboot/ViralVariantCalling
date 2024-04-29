#!/bin/bash

# 3-trimgalore.sh
# Author: James Boot, Date: 01/02/2024
# Script for running trimgalore on fastq files
# 1) Adjust queue settings - change job name and email address
# 2) Specify parameters in SECTION 1

##### Set queue options
#$ -M j.boot@qmul.ac.uk				            # Change to your email address
#$ -m bes
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=240:0:0
#$ -l h_vmem=8G
#$ -N GC-AAA-10836_TrimGalore2								# Change the name of the job accordingly
#$ -j y
#####

# SECTION 1: Only edit here

ANALYSISDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2
FASTQDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/Mems_resequencing
R1FILES=${ANALYSISDIR}/R1_files2.txt
R2FILES=${ANALYSISDIR}/R2_files2.txt
SAMPLE_NAMES=${ANALYSISDIR}/sample_names2.txt
OUTPUT_DIR=${ANALYSISDIR}/2.trimgalore_results
FQC_OUTDIR=${OUTPUT_DIR}/post_trim_fastqc

# SECTION 2: Do not edit

# Find read 1's
find ${FASTQDIR} -regex ".*_R1_.*\.fastq.gz"  ! -name "1M-*" | sort >> ${R1FILES}

# Find read 2's
find ${FASTQDIR} -regex ".*_R2_.*\.fastq.gz"  ! -name "1M-*" | sort >> ${R2FILES}

# Get sample names 
sed 's:.*/::' R1_files2.txt | sed 's:_.*::' >> ${SAMPLE_NAMES}

# Create output folders
mkdir -p ${FQC_OUTDIR}
mkdir -p ${OUTPUT_DIR}

# SECTION 3: Load module

module load trimgalore/0.6.5

# SECTION 4: Run trimgalore in for loop

ITERATIONS=$(wc -l < ${SAMPLE_NAMES})

for i in $(seq ${ITERATIONS}); do
	
	echo "Iteration ${ITERATIONS}, file names and sample ID:"
	
	R1=$(sed -n "${i}p" ${R1FILES})
	echo "R1: ${R1}"
	
	R2=$(sed -n "${i}p" ${R2FILES})
	echo "R2: ${R2}"
	
	SAMPLE=$(sed -n "${i}p" ${SAMPLE_NAMES})
	echo "SAMPLE: ${SAMPLE}"
	
	echo "Running trim_galore..."
	
	# Run trimgalore
    # Options --length, -e, --stringency, --quality are set to default
	trim_galore --quality 20 \
	--length 20 \
	-j ${NSLOTS} \
	--paired \
	--stringency 1 \
	-e 0.1 \
	--fastqc --fastqc_args "-o ${FQC_OUTDIR} --noextract" \
	--output_dir ${OUTPUT_DIR} \
	${R1} ${R2}
	
done