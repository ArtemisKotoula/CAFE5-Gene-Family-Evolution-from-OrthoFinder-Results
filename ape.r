#!/usr/bin/env 
# =============================================================================
## Description:
#   Reads a rooted phylogenetic tree and converts it to an ultrametric tree
#   using the chronos() method from the ape package. The output is written
#   as a Newick file, ready for use as input to CAFE5.
#
## Usage:
#   Rscript ape.r <input_tree> <output_tree>
#
## Arguments:
#   input_tree   Path to the input tree file (Newick format, e.g. RAxML output)
#   output_tree  Path to write the ultrametric tree (Newick format)
#
## Dependencies:
#   R package: ape  (install with: install.packages("ape"))
#
# Example:
#   Rscript ape.r species_tree.raxml.support species_tree_ultrametric.nwk
# =============================================================================

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  cat("Usage: Rscript ape.r <input_tree> <output_tree>\n")
  quit(status = 1)
}

input_tree  <- args[1]
output_tree <- args[2]

library(ape)

tre <- read.tree(input_tree)

# Check tree properties
cat("Is rooted:", is.rooted(tre), "\n")
cat("Is binary:", is.binary(tre), "\n")

# Convert to ultrametric if needed
if (!is.ultrametric(tre)) {
  cat("Tree is not ultrametric. Applying chronos().\n")
  tre_ultra <- chronos(tre)
} else {
  cat("Tree is already ultrametric. No conversion needed.\n")
  tre_ultra <- tre
}

write.tree(tre_ultra, file = output_tree)
cat("Ultrametric tree written to:", output_tree, "\n")
