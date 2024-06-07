# Script for analysing the output from variant calling (VCF)

# Install packages
#install.packages('vcfR')

# Load packages
library(vcfR)

# Set working directory
setwd('/Users/hmy961/Documents/projects/GC-AAA-10836/v2/')

# Create saving directory
if (!dir.exists('vcfR_outs')) {
  dir.create('vcfR_outs')
}
save.dir <- 'vcfR_outs'

# Load vcf
vcf <- read.vcfR('cohort_variants.vcf')
vcf[1:4,]

# Get names of samples 
samples <- colnames(vcf@gt)
memSamples <- samples[c(1, grep('Mems', samples))]
nonMemSamples <- samples[-grep('Mems', samples)]

# Box plot of sequencing depth
dp <- extract.gt(vcf, element='DP', as.numeric=TRUE)
tiff(filename = paste0(save.dir, '/depth_bar.tiff'),
     width = 8,
     height = 8,
     units = 'in',
     res = 300)
par(mar=c(8,4,1,1))
par(cex.axis=1)
boxplot(dp, las=3, col=c("#C0C0C0", "#808080"), ylab="Depth")
abline(h=seq(0,1e4, by=100), col="#C0C0C088")
dev.off()

# Load fasta
dna <- ape::read.dna('/Users/hmy961/Documents/projects/GC-AAA-10836/fasta/NC_007605.fasta', format = "fasta")

# Load gff
gff <- read.table('/Users/hmy961/Documents/projects/GC-AAA-10836/fasta/NC76.gff', sep="\t", quote="")

# Create chromR object
chrom <- create.chromR(name='EBV1', vcf=vcf, seq=dna, ann=gff)

# Initial plot
tiff(filename = paste0(save.dir, '/qc1.tiff'),
     width = 8,
     height = 8,
     units = 'in',
     res = 300)
plot(chrom)
dev.off()

tiff(filename = paste0(save.dir, '/qc2.tiff'),
     width = 8,
     height = 8,
     units = 'in',
     res = 300)
chromoqc(chrom, dp.alpha=20)
dev.off()

# Filter and replot
# Remove low coverage 
# Remove variant with exceptionally high coverage. 
# These typically come from repetetive regions that have reads which map to multiple locations in the genome.
chrom <- masker(chrom,
                min_QUAL = 1,
                min_DP = 350,
                max_DP = 6000)

write.vcf(chrom, file="good_variants.vcf.gz", mask=TRUE)

# Process
chrom <- proc.chromR(chrom, verbose=TRUE)
tiff(filename = paste0(save.dir, '/postFiltQC1.tiff'),
     width = 8,
     height = 8,
     units = 'in',
     res = 300)
plot(chrom)
dev.off()

tiff(filename = paste0(save.dir, '/postFiltQC2.tiff'),
     width = 8,
     height = 8,
     units = 'in',
     res = 300)
chromoqc(chrom, dp.alpha=20)
dev.off()

# Look at sample level
head(chrom)
dp <- extract.gt(chrom, element="DP", as.numeric=TRUE)
rownames(dp) <- 1:nrow(dp)
head(dp)

tiff(filename = paste0(save.dir, '/depth_heatmap.tiff'),
     width = 8,
     height = 8,
     units = 'in',
     res = 300)
heatmap.bp(dp)
dev.off()