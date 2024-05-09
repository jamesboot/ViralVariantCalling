#!/bin/bash

##### Set queue options
#$ -cwd
#$ -pe smp 4								# Cores
#$ -l h_vmem=8G								# Memory
#$ -l h_rt=240:00:00						# Running time
#$ -N EBV1-GATK 							# Rename this
#$ -j y
#$ -t 1-41
#####

# Prior to running this script 3 things need to be performed:
# 1. The reference dictionary and fasta index need to be made. See the dictionary_index_script.sh to do this.
# 2. Run BWA alignment for samples.
# 3. Run pre-gatk script

# Load the modules GATK and samtools
module load gatk
module load samtools

# Define parameters from parameters file
FILELIST=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/4.GATK-NC76/samfiles.txt
SAMPLELIST=/data/WHRI-GenomeCentre/shares/Projects/NGS_Projects/DNA_Sequencing/Adeniran_Adekunle-Adeyinka/GC-AAA-10836/Analysis/v2/4.GATK-NC76/samples.txt
FILE=$(sed -n "${SGE_TASK_ID}p" ${FILELIST})
SAMPLE=$(sed -n "${SGE_TASK_ID}p" ${SAMPLELIST})
GENOME=/data/WHRI-GenomeCentre/Genome/EBV1/NC_007605.fasta

# Add read groups to SAM file or errors out later
gatk --java-options "-Xmx4g" AddOrReplaceReadGroups \
-I ${FILE} \
-O ${SAMPLE}_RG.bam \
--RGID ${SGE_TASK_ID} \
--RGLB lib_${SGE_TASK_ID} \
--RGPL ILLUMINA \
--RGPU unit_${SGE_TASK_ID} \
--RGSM ${SAMPLE}

# Run SortSam
gatk --java-options "-Xmx4g" SortSam \
-I ${SAMPLE}_RG.bam \
-O ${SAMPLE}_sorted.bam \
-SO coordinate

# _RG.bam file no longer needed - delete
rm ${SAMPLE}_RG.bam

# Mark duplicates
gatk --java-options "-Xmx4g" MarkDuplicates \
-I ${SAMPLE}_sorted.bam \
-O ${SAMPLE}_sorted_dedup_reads.bam \
-M ${SAMPLE}_metrics.txt

# _sorted.bam file no longer needed - delete
rm ${SAMPLE}_sorted.bam

# _sorted_dedup_reads.bam needs to be indexed for later use
samtools index ${SAMPLE}_sorted_dedup_reads.bam

# Collect alignment metrics
gatk --java-options "-Xmx4g"  CollectAlignmentSummaryMetrics \
-R ${GENOME} \
-I ${SAMPLE}_sorted_dedup_reads.bam \
-O ${SAMPLE}_alignment_metrics.txt

samtools depth -a ${SAMPLE}_sorted_dedup_reads.bam > ${SAMPLE}_depth_out.txt

# Run the GATK HaplotypeCaller function
gatk --java-options "-Xmx4g" HaplotypeCaller \
-R ${GENOME} \
-I ${SAMPLE}_sorted_dedup_reads.bam \
-O ${SAMPLE}_raw.vcf \
-bamout ${SAMPLE}_bamout.bam

# Hard filter the vcf using VariantFiltration - need to find some recommended thresholds
gatk --java-options "-Xmx4g" VariantFiltration \
-R ${GENOME} \
-V ${SAMPLE}_raw.vcf \
-O ${SAMPLE}_filter.vcf \
-filter-name "QD_filter" -filter "QD < 2.0" \
-filter-name "FS_filter" -filter "FS > 60.0" \
-filter-name "MQ_filter" -filter "MQ < 40.0" \
-filter-name "SOR_filter" -filter "SOR > 4.0" \
-filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
-filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0"

# Exclude filtered variants
gatk --java-options "-Xmx4g" SelectVariants \
--exclude-filtered \
-V ${SAMPLE}_filter.vcf \
-O ${SAMPLE}_bqsr.vcf

# Perform Base Quality Score Reclibration (BQSR)
gatk --java-options "-Xmx4g" BaseRecalibrator \
-R ${GENOME} \
-I ${SAMPLE}_sorted_dedup_reads.bam \
--known-sites ${SAMPLE}_bqsr.vcf \
-O ${SAMPLE}_recal_data.table

# Apply Base Quality Score Reclibration (BQSR)
gatk --java-options "-Xmx4g" ApplyBQSR \
-R ${GENOME} \
-I ${SAMPLE}_sorted_dedup_reads.bam \
-bqsr ${SAMPLE}_recal_data.table \
-O ${SAMPLE}_recal_reads.bam

# _sorted_dedup_reads.bam file no longer needed - delete
rm ${SAMPLE}_sorted_dedup_reads.bam

# Re-run the GATK HaplotypeCaller function on recalibrated BAM file
gatk --java-options "-Xmx4g" HaplotypeCaller \
-R ${GENOME} \
-I ${SAMPLE}_recal_reads.bam \
-O ${SAMPLE}_raw_recal.vcf \
-bamout ${SAMPLE}_bamout_recal.bam

# Hard filter the vcf using VariantFiltration - need to find some recommended thresholds
gatk --java-options "-Xmx4g" VariantFiltration \
-R ${GENOME} \
-V ${SAMPLE}_raw_recal.vcf \
-O ${SAMPLE}_filter_recal.vcf \
-filter-name "QD_filter" -filter "QD < 2.0" \
-filter-name "FS_filter" -filter "FS > 60.0" \
-filter-name "MQ_filter" -filter "MQ < 40.0" \
-filter-name "SOR_filter" -filter "SOR > 4.0" \
-filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
-filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0"

# Exclude filtered variants
gatk --java-options "-Xmx4g" SelectVariants \
--exclude-filtered \
-V ${SAMPLE}_filter_recal.vcf \
-O ${SAMPLE}_filter_final.vcf