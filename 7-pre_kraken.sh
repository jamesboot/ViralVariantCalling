#!/bin/bash

# pre_kraken.sh
# Script for locating files and samples ahead of kraken metagenomics analysis
# Author: James Boot, 08/02/2024
# 1) Edit SECTION 1 containing queue setting
# 2) Edit SECTION 2 defining parameters for analysis
# 3) Leave all other sections and submit

# SECTION 1: Queue settings

##### Set queue options
#$ -cwd
#$ -pe smp 1									# Cores
#$ -l h_vmem=7.5G							# Memory
#$ -l h_rt=240:00:00						# Running time
#$ -N Pre-Kraken							# Rename job
#$ -j y
#$ -M j.boot@qmul.ac.uk				# Change to your email address
#$ -m bes
#####

# SECTION 2: Define parameters
FASTQDIR1=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/Saliva_S-LCL_sequencing/MiSeq_run_661_RUN00011-401132587
FASTQDIR2=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/Saliva_S-LCL_sequencing/MiSeq_run_662_RUN00012-401434266
OUTDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/5.kraken
R1FILES=${OUTDIR}/R1Files.txt
R2FILES=${OUTDIR}/R2Files.txt
SAMPLES=${OUTDIR}/Samples.txt

# SECTION 3: Only edit fastq file suffix - .fastq or .fastq.gz

# Make OUTDIR
mkdir -p ${OUTDIR}

# For first directory:
# Find read 1's
find ${FASTQDIR1} -regex ".*_R1_.*\.fastq.gz" ! -name "1M-*" | sort >> ${R1FILES}

# Find read 2's
find ${FASTQDIR1} -regex ".*_R2_.*\.fastq.gz" ! -name "1M-*" | sort >> ${R2FILES}

# For second directory:
# Find read 1's
find ${FASTQDIR2} -regex ".*_R1_.*\.fastq.gz" ! -name "1M-*" | sort >> ${R1FILES}

# Find read 2's
find ${FASTQDIR2} -regex ".*_R2_.*\.fastq.gz" ! -name "1M-*" | sort >> ${R2FILES}

# Get sample names
sed 's:.*/::' ${R1FILES} | sed 's:_.*::' >> ${SAMPLES}