#!/usr/bin/env bash
# =============================================================================
## Main script for CAFE5 pipeline:
#- Convert species tree to ultrametric (using ape.r)
#- Parse OrthoFinder gene counts into CAFE5 input format
#- Filter gene families by clade and size
#- Estimate error model
#- Run CAFE5 with the error model
#
## Usage:
#   bash main.sh <gene_count.tsv> <species_tree> <output_dir>
#
## Where:
#   gene_count.tsv   OrthoFinder's Orthogroups.GeneCount.tsv
#   species_tree     Input species tree (Newick)
#   output_dir       Outoput directory
#
## Dependencies:
#- CAFE5       (cafe5)
#- R, ape      (ape.r script)
#- Python 3    (clade_and_size_filter.py, script included in CAFE5)
#- Scripts in the same directory: ape.r, cafe_input_parsing.sh
# =============================================================================

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### Argument parsing 
if [[ $# -lt 3 ]]; then
  echo "Usage: bash main.sh <gene_count_tsv> <species_tree> <output_dir>"
  exit 1
fi

### Paths
counts_path="$1"
species_tree="$2"
out_dir="$3"

ultra_tree="${out_dir}/species_tree_ultrametric.nwk"
cafe_input="${out_dir}/cafe_input.tsv"
filtered_input="${out_dir}/filtered_cafe_input.txt"
large_filtered_input="${out_dir}/large_filtered_cafe_input.txt"
error_model="${out_dir}/Base_error_model.txt"
results_base="${out_dir}/base_results"
results_large="${out_dir}/large_results"

mkdir -p "$out_dir"

### Make species tree ultrametric 
echo "Converting species tree to ultrametric..."
Rscript "${script_dir}/ape.r" "$species_tree" "$ultra_tree"

### Parse OrthoFinder output for CAFE5 input 
echo "Parsing OrthoFinder gene counts..."
bash "${script_dir}/main_cafe_parsing.sh" "$counts_path" "$cafe_input"

### Filter large gene families 
echo "Filtering gene families by clade and size..."
python3 "${script_dir}/clade_and_size_filter.py" -i "$cafe_input" -o "$filtered_input"

### Estimate error model 
# Running CAFE5 without -l first to estimate a single lambda and error model.
# Note: families with very large size differentials are filtered separately
# into $large_filtered_input before this step if needed.

echo "Estimating lambda and error model..."
cafe5 -i "$filtered_input" -t "$ultra_tree" -e -o "$results_base"

cp "${results_base}/Base_error_model.txt" "$error_model"

### Estimate single lambda for whole tree using filtered gene families
### Run CAFE5 with error model 
echo "Running CAFE5 with error model..."
cafe5 -i "$filtered_input" -t "$ultra_tree" -e"${error_model}" -o "$results_base"

echo "Estimated single lambda."

### Run CAFE for large gene families using fixed lambda
# Uncomment and set LAMBDA to the value estimated in previous step.
# LAMBDA="ex. 0.60499211226818"
# cafe5 -i "$large_filtered_input" -t "$ultra_tree" -l "$LAMBDA" -e"${error_model}" -o "$results_large"

#echo "Pipeline complete. Results written to: $out_dir"
