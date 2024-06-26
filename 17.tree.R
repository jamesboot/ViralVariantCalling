# Script for plotting phylogeny trees from RAxML output

# Set working directory
setwd('/Users/hmy961/Documents/projects/GC-AAA-10836/v2/')

# Packages
library(ggtree)
library(ape)
library(treeio)

# Load NC76 file
treeFile <- 'phylogenies/RAxML_bipartitionsBranchLabels.raxml-NC76'
tree <- read.raxml(treeFile)

# Make lookup
ms <- c(
  '024',
  '028',
  '029',
  '031',
  '032',
  '033',
  '034',
  '035',
  '036',
  '037',
  '038',
  '039',
  '041',
  '042',
  '043',
  '044',
  '045',
  '048'
)

# Locate EBV samples
msPos <- grep(paste(ms, collapse = "|"),
              tree@phylo$tip.label)

status <- c(rep('Non-MS', length(tree@phylo$tip.label)))
status[msPos] <- 'MS'

# Make meta data dataframe to add to tree
meta <- data.frame(label = tree@phylo$tip.label,
                   Status = status) 
rownames(meta) <- meta$label

# Plot
plt <- ggtree(tree) %<+% meta + geom_tiplab(aes(color=Status))
plt
ggsave(plot = plt,
       filename = 'phylogenies/NC76_tree.tiff',
       height = 8,
       width = 14,
       units = 'in',
       dpi = 300)

# Load MSA241 file
treeFile <- 'phylogenies/RAxML_bipartitionsBranchLabels.raxml-MSA241'
tree <- read.raxml(treeFile)

# Make lookup
ms <- c(
  '024',
  '028',
  '029',
  '031',
  '032',
  '033',
  '034',
  '035',
  '036',
  '037',
  '038',
  '039',
  '041',
  '042',
  '043',
  '044',
  '045',
  '048'
)

# Locate EBV samples
msPos <- grep(paste(ms, collapse = "|"),
     tree@phylo$tip.label)

status <- c(rep('Non-MS', length(tree@phylo$tip.label)))
status[msPos] <- 'MS'

# Make meta data dataframe to add to tree
meta <- data.frame(label = tree@phylo$tip.label,
                   Status = status) 
rownames(meta) <- meta$label

# Plot
plt <- ggtree(tree) %<+% meta + geom_tiplab(aes(color=Status))
plt
ggsave(plot = plt,
       filename = 'phylogenies/MSA241_tree.tiff',
       height = 8,
       width = 14,
       units = 'in',
       dpi = 300)





