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

# Convert to tibble
vcfTibble <- vcfR2tidy(vcf) 

# Extract GT tibble
gtTibble <- vcfTibble$gt

# Summarise number of variants in all samples
allSummary1 <- gtTibble %>%
  mutate(status = case_when(gt_DP > 0 ~ 1,
                            .default = 0)) %>%
  group_by(Indiv) %>%
  summarise(n = sum(status))

colnames(allSummary1) <- c('Sample', 'nVariants')

# Add meta data
allSummary2 <- merge(allSummary1, meta, by = 'Sample')

# Box plot of nVariants for salivas
ggplot(allSummary2[allSummary2$Type == 'Saliva', ],
       aes(x = Group, y = nVariants)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y',
               stackdir = 'center',
               dotsize = 0.5) +
  labs(title = 'nVariants by Group in Saliva samples')

# Box plot of nVariants for LCL
ggplot(allSummary2[allSummary2$Type == 'LCL',],
       aes(x = Group, y = nVariants)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y',
               stackdir = 'center',
               dotsize = 0.5) +
  labs(title = 'nVariants by Group in LCL samples')

# Filter down to region of interest LMP1 + LMP2

# LMP1 NC_007605.1, ID=gene-HHV4_LMP-1, 166483-169088
# Filter and make a new column with mutation status (0 = ref, 1 = variant)
lmp1Summary <- gtTibble %>%
  filter(POS > 166483 & POS < 169088) %>%
  mutate(status = case_when(gt_DP > 0 ~ 1,
                            .default = 0)) %>%
  group_by(Indiv) %>%
  summarise(n = sum(status))

colnames(lmp1Summary) <- c('Sample', 'nVariants')

# Add meta data
lmp1Summary <- merge(lmp1Summary, meta, by = 'Sample')

# Box plot of nVariants for salivas
ggplot(lmp1Summary[lmp1Summary$Type == 'Saliva',],
       aes(x = Group, y = nVariants)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y',
               stackdir = 'center',
               dotsize = 0.5) +
  labs(title = 'nVariants in LMP1 by Group in Saliva samples')

# Box plot of nVariants for LCL
ggplot(lmp1Summary[lmp1Summary$Type == 'LCL',],
       aes(x = Group, y = nVariants)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y',
               stackdir = 'center',
               dotsize = 0.5) +
  labs(title = 'nVariants in LMP1 by Group in LCL samples')

# LMP2 NC_007605.1, ID=gene-HHV4_LMP-2B, 169294	177679
# Filter and make a new column with mutation status (0 = ref, 1 = variant)
lmp2Summary <- gtTibble %>%
  filter(POS > 169294 & POS < 177679) %>%
  mutate(status = case_when(gt_DP > 0 ~ 1,
                            .default = 0)) %>%
  group_by(Indiv) %>%
  summarise(n = sum(status))

colnames(lmp2Summary) <- c('Sample', 'nVariants')

# Add meta data
lmp2Summary <- merge(lmp2Summary, meta, by = 'Sample')

# Box plot of nVariants for salivas
ggplot(lmp2Summary[lmp2Summary$Type == 'Saliva',],
       aes(x = Group, y = nVariants)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y',
               stackdir = 'center',
               dotsize = 0.5) +
  labs(title = 'nVariants in LMP2 by Group in Saliva samples')

# Box plot of nVariants for LCL
ggplot(lmp2Summary[lmp2Summary$Type == 'LCL',],
       aes(x = Group, y = nVariants)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y',
               stackdir = 'center',
               dotsize = 0.5) +
  labs(title = 'nVariants in LMP2 by Group in LCL samples')




