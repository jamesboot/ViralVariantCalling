#!/bin/bash

# This script will find VCF files are merge them together and produce csv

##### Set queue options
#$ -M j.boot@qmul.ac.uk						# Email address
#$ -m bes									# Send email
#$ -cwd
#$ -V
#$ -pe smp 2								# Cores
#$ -l h_vmem=8G								# Memory
#$ -l h_rt=240:00:00						# Running time
#$ -N gatk_VariantsToTable					# Rename this
#$ -j y
#####

## Load the module gatk and samtools
module load gatk
module load bcftools
module load htslib/1.10.2
module load samtools/1.10

# bgzip the vcf files
for FILE in *_filter_final.vcf; do bgzip $FILE; done

# Index vcf.gz files
for FILE in *_filter_final.vcf.gz; do tabix $FILE; done

# Find files and store in list 
find -name "*_filter_final.vcf.gz" > vcfgz_file_list.txt

# Merge VCF
bcftools merge --file-list vcfgz_file_list.txt \
-o cohort_variants.vcf.gz

# Index the new feature file
gatk --java-options "-Xmx4g" IndexFeatureFile \
-I cohort_variants.vcf.gz

# Save a summary to a CSV file
gatk --java-options "-Xmx4g" VariantsToTable \
-V cohort_variants.vcf.gz \
-F CHROM -F POS -F REF -F ALT -F ID -F TYPE -GF GT -GF AD -GF DP \
-O cohort_variant.table