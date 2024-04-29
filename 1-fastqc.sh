#!/bin/bash

# 1-fastqc.sh
# Author: James Boot, Date: 01/02/2024
# Script for running fastqc on fastq files
# 1) Adjust queue settings - change job name and email address
# 2) Set the input directory in SECTION 1
# 3) If multiple input directories - define all and add relevant number of loops
# 4) Copy this script to the project analysis folder and qsub

#####
#$ -M j.boot@qmul.ac.uk                # Change to your email address 
#$ -m bes
#$ -cwd
#$ -pe smp 1
#$ -l h_vmem=8G  
#$ -j y
#$ -l h_rt=240:00:00
#$ -N GC-AAA-10836_FastQC              # Change the name of the job accordingly
#####

# SECTION 1: Only edit here
# Set the input directory (where fastq files are located)
# The out directory (output of fastqc) will be in a folder named fastqc within the input directory
INDIR1=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/Saliva_S-LCL_sequencing/MiSeq_run_661_RUN00011-401132587
INDIR2=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Data/Mems_resequencing
OUTDIR=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/1.fastqc

mkdir -p ${OUTDIR}

# SECTION 2: Load module
module load fastqc

# SECTION 3: Loop through files
for INPUT_FILE in ${INDIR1}/*.fastq.gz; do
  fastqc --outdir=$OUTDIR $INPUT_FILE
done

for INPUT_FILE in ${INDIR2}/*.fastq.gz; do
  fastqc --outdir=$OUTDIR $INPUT_FILE
done

# SECTION 4: Run multiqc on above output
# Load gcenv containing multiqc
. /data/WHRI-GenomeCentre/gcenv/bin/activate

# Run multiqc
cd ${OUTDIR}
multiqc .