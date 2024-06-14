#!/bin/bash

##### Set queue options
#$ -M j.boot@qmul.ac.uk			# Email address
#$ -m bes									# Send email
#$ -cwd
#$ -pe smp 4								# Cores
#$ -l h_vmem=8G						# Memory
#$ -l h_rt=240:00:00					# Running time
#$ -N dict_index_EBV1			# Rename this
#$ -j y
#####

# Specify input
FASTA=/data/WHRI-GenomeCentre/Genome/EBV-241MSA/241_MSA_Cons.fasta

## Load the module gatk
module load gatk

## Create a dictionary file of the reference fasta file
gatk --java-options "-Xmx4g" CreateSequenceDictionary -R ${FASTA}

## Load the module samtools
module load samtools

## Create a fasta index (fai) file
samtools faidx ${FASTA}