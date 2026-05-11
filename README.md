# CAFE5-Gene-Family-Evolution-from-OrthoFinder-Results
A set of scripts for running a CAFE5 gene family evolution analysis from OrthoFinder's output.

## Overview
This set of scripts uses Parse OrthoFinder's *Orthogroups.GeneCount.tsv* output and a species tree to run
a CAFE5 gene family evolution analysis using the following steps:

### 1. Converts species tree to ultrametric using the "ape" R package
- Uses the *ape.r* script.

### 2. Parses the OrthoFinder output into CAFE5 input format
- Uses the *cafe_input_parsing.sh* script.

### 3. Inputs the parsed file into the CAFE5 pipeline
- Filters gene families by clade and size, using the *clade_and_size_filter.py* script included in CAFE5.
- Estimates error model.
- Runs CAFE5.

## Dependencies
* [CAFE5](https://github.com/hahnlab/CAFE5) (Computational Analysis of gene Family Evolution)
* [ape](https://emmanuelparadis.github.io/) (Analysis of Phylogenetics and Evolution)
* Python
* bash
* R

