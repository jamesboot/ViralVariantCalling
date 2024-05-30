# Script for analysing the output from variant calling (VCF)

# Install packages
#install.packages('vcfR')

# Load packages
library(vcfR)
library(tidyverse)

# Set working directory
setwd('/Users/hmy961/Documents/projects/GC-AAA-10836/v2/')

# Load meta
meta <-
  readxl::read_xlsx('../SNP analysis of Saliva and sLCL geneomes.xlsx',
                    sheet = 'Meta')

# Load vcf
vcf <- read.vcfR('good_variants.vcf.gz')

# Load fasta
dna <- ape::read.dna('/Users/hmy961/Documents/projects/GC-AAA-10836/fasta/NC_007605.fasta', format = "fasta")

# Load gff
gff <- read.table('/Users/hmy961/Documents/projects/GC-AAA-10836/fasta/NC76.gff', sep="\t", quote="")

# Choose region / entry in gff (LMLP1 = 635)
record <- 635
my_dnabin1 <-
  vcfR2DNAbin(
    vcf,
    consensus = TRUE,
    extract.haps = FALSE,
    ref.seq = dna[,
                  gff[record, 4]:gff[record, 5]],
    start.pos = gff[record, 4],
    verbose = FALSE
  )

# Visualise
par(mar=c(5,8,4,2))
ape::image.DNAbin(my_dnabin1[,ape::seg.sites(my_dnabin1)])
