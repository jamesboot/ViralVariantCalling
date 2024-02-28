#!/bin/bash

# kraken.sh
# Script for running kraken metagenomics analysis
# Author: James Boot, 08/02/2024
# 1) Edit SECTION 1 containing queue setting
# 2) Edit SECTION 2 defining parameters for analysis
# 3) Edit SECTION 3 with kraken parameters

# SECTION 1: Queue settings
# Check the number of lines in Samples.txt, R1Files.txt or R2Files.txt for number of arrays

##### Set queue options
#$ -cwd
#$ -V
#$ -pe smp 8									# Cores
#$ -l h_vmem=8G							# Memory
#$ -l h_rt=240:00:00						# Running time
#$ -N Kraken_GC-AAA	  				# Rename job
#$ -j y
#$ -t 1-41											# Set to number of array tasks to run - based on number of samples
#####

# SECTION 2: Define parameters
DATABASE=/data/WHRI-GenomeCentre/Genome/Kraken2_plus
OUTDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/5.kraken
R1FILES=${OUTDIR}/R1Files.txt
R2FILES=${OUTDIR}/R2Files.txt
SAMPLES=${OUTDIR}/Samples.txt

# SECTION 3: Define further params and run kraken

READ1=$(sed -n "${SGE_TASK_ID}p" ${R1FILES})
READ2=$(sed -n "${SGE_TASK_ID}p" ${R2FILES})
SAMPLE=$(sed -n "${SGE_TASK_ID}p" ${SAMPLES})

# Load the module
module load kraken/2.1.2

# Run KRAKEN
# See documentation for details on all options
# Use > to specify output to a file
# Add --gzip-compressed \ if fastq files are .gz
kraken2 --paired \
--threads ${NSLOTS} \
--fastq-input \
--db ${DATABASE} \
--use-names \
--report ${OUTDIR}/${SAMPLE}_report.txt \
${READ1} ${READ2} > ${OUTDIR}/${SAMPLE}.kraken
