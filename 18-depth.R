# Analyse depth

# Packages
library(tidyverse)

# Set working directory
setwd('/Users/hmy961/Documents/projects/GC-AAA-10836/v2/NC76_variants/depth/')

# List files
files <- list.files(path = '.',
                    pattern = '*.txt')

# Create sample names
samples <- gsub('_depth_out.txt', '', files)

# Read in files
input <- lapply(files, function(x){
  read.delim(x, header = F)
})

# Process input
names(input) <- samples

for (x in names(input)) {
  input[[x]] <- input[[x]][, c(2,3)]
  colnames(input[[x]]) <- c('Pos', paste0(x, '_depth'))
}

# Merge dataframes
depth <- input %>%
  reduce(left_join, by = 'Pos')

# Get mean coverage for each column
meanCov <- apply(depth[, 2:ncol(depth)], 2, 'mean')
meanCov <- data.frame(Sample = names(meanCov),
                      Depth = meanCov)

# Plot meanCov
ggplot(meanCov, aes(x = Sample, y = Depth)) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
  ggtitle('Mean read depth across all samples') +
  geom_hline(yintercept = 100, linetype = 'dashed', colour = 'blue', linewidth = 0.5)

ggsave(plot = last_plot(),
       filename = 'mean_depth1.tiff',
       height = 8,
       width = 8,
       units = 'in',
       dpi = 300)

# Get mean coverage for each column
medianCov <- apply(depth[, 2:ncol(depth)], 2, 'median')
medianCov <- data.frame(Sample = names(medianCov),
                      Depth = medianCov)

# Plot medianCov
ggplot(medianCov, aes(x = Sample, y = Depth)) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
  ggtitle('Median read depth across all samples') +
  geom_hline(yintercept = 100, linetype = 'dashed', colour = 'blue', linewidth = 0.5)

ggsave(plot = last_plot(),
       filename = 'median_depth1.tiff',
       height = 8,
       width = 8,
       units = 'in',
       dpi = 300)

