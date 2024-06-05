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

# Plot all variants in LCL samples
tileplot <- gtTibble
tileplot$POS <- as.factor(tileplot$POS)
tileplot <- tileplot[grep('EBV-Mems', tileplot$Indiv), ]
tileplot <- tileplot %>%
  mutate(gt_GT_alleles = replace(gt_GT_alleles, gt_GT_alleles == ".", NA)) %>%
  mutate(gt_GT_alleles = replace(gt_GT_alleles, nchar(gt_GT_alleles) > 20, 'Large'))

plt <- ggplot(tileplot, aes(x = Indiv, y = POS)) +
  geom_tile(aes(fill = gt_GT_alleles)) +
  theme(axis.text.x = element_text(angle = 90),
        axis.text.y = element_text(size = 2))

ggsave(plt,
       filename = 'LCL_Variants.tiff',
       height = 16,
       width = 8,
       units = 'in',
       dpi = 300)

# Plot all variants in Saliva samples
tileplot <- gtTibble
tileplot$POS <- as.factor(tileplot$POS)
tileplot <- tileplot[grep('EBV[0-9]', tileplot$Indiv), ]
tileplot <- tileplot %>%
  mutate(gt_GT_alleles = replace(gt_GT_alleles, gt_GT_alleles == ".", NA)) %>%
  mutate(gt_GT_alleles = replace(gt_GT_alleles, nchar(gt_GT_alleles) > 20, 'Large'))

plt <- ggplot(tileplot, aes(x = Indiv, y = POS)) +
  geom_tile(aes(fill = gt_GT_alleles)) +
  theme(axis.text.x = element_text(angle = 90),
        axis.text.y = element_text(size = 2))

ggsave(plt,
       filename = 'Saliva_Variants.tiff',
       height = 16,
       width = 8,
       units = 'in',
       dpi = 300)

# Find variants shared between paired samples ----
pairs <- list(s034 = c('EBV034', 'EBV-Mems034'),
              s035 = c('EBV035', 'EBV-Mems035'),
              s044 = c('EBV044', 'EBV-Mems044'),
              s048 = c('EBV048', 'EBV-Mems048'),
              s013 = c('EBV013', 'EBV-Mems013'),
              s063 = c('EBV063', 'EBV-Mems063'),
              s005 = c('EBV005', 'EBV-Mems005'))

for (x in names(pairs)) {
  # Filter down to variants in samples of interest
  trial <- gtTibble %>%
    mutate(status = case_when(gt_DP > 0 ~ 1,
                              .default = 0)) %>%
    filter(Indiv %in% pairs[[x]] &
             status == 1)
  
  # Identify common variants based on location
  commonVars <- intersect(trial$POS[trial$Indiv == pairs[[x]][1]],
                          trial$POS[trial$Indiv == pairs[[x]][2]])
  
  # Filter
  trial <-  trial %>%
    filter(POS %in% commonVars)
  
  # Factorise the position column for plotting
  trial$POS <- as.factor(trial$POS)
  
  # Plot
  plt <- ggplot(trial, aes(x = Indiv, y = POS)) +
    geom_tile(aes(fill = gt_GT_alleles))
  
  ggsave(plt,
         filename = paste0(x, '_commonVariants.tiff'),
         height = 16,
         width = 8,
         units = 'in',
         dpi = 300)
  
}

# Filter down to region of interest LMP1 + LMP2

# LMP1 NC_007605.1, ID=gene-HHV4_LMP-1, 166483-169088
# Plot variants across samples
tileplot <- gtTibble %>%
  filter(POS > 166483 & POS < 169088)
tileplot$POS <- as.factor(tileplot$POS)
tileplot <- tileplot %>%
  mutate(gt_GT_alleles = replace(gt_GT_alleles, gt_GT_alleles == ".", NA)) 

plt <- ggplot(tileplot, aes(x = Indiv, y = POS)) +
  geom_tile(aes(fill = gt_GT_alleles)) +
  theme(axis.text.x = element_text(angle = 90),
        axis.text.y = element_text(size = 10))

ggsave(plt,
       filename = 'LMP1_Variants.tiff',
       height = 8,
       width = 8,
       units = 'in',
       dpi = 300)


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
# Plot variants across samples
tileplot <- gtTibble %>%
  filter(POS > 169294 & POS < 177679)
tileplot$POS <- as.factor(tileplot$POS)
tileplot <- tileplot %>%
  mutate(gt_GT_alleles = replace(gt_GT_alleles, gt_GT_alleles == ".", NA)) 

plt <- ggplot(tileplot, aes(x = Indiv, y = POS)) +
  geom_tile(aes(fill = gt_GT_alleles)) +
  theme(axis.text.x = element_text(angle = 90),
        axis.text.y = element_text(size = 10))

ggsave(plt,
       filename = 'LMP2_Variants.tiff',
       height = 8,
       width = 8,
       units = 'in',
       dpi = 300)

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




