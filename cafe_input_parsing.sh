#!/usr/bin/env bash
# =============================================================================
# Reformats the OrthoFinder gene count table into the CAFE5 input format.
#
## Usage: bash main_cafe_parsing.sh <gene_count.tsv> <output.tsv>
#
## Where:
#- gene_count.tsv: Path to OrthoFinder's Orthogroups.GeneCount.tsv
#- output.tsv: Path to write the formatted CAFE5 input file
# =============================================================================

set -euo pipefail

### Parse arguments 
if [[ $# -lt 2 ]]; then
  echo "Usage: bash main_cafe_parsing.sh <gene_count_tsv> <output_tsv>"
  exit 1
fi

counts_path="$1"
out_path="$2"
tmp_path="$(mktemp)"

### Check input file exists
if [[ ! -f "$counts_path" ]]; then
  echo "Error: input file not found: $counts_path"
  exit 1
fi

### Parse file 
awk -F'\t' '{print "(null)\t"$0}' "$counts_path" > "$tmp_path"
sed '0,/(null)/s/(null)/Desc/' "$tmp_path" | awk -F'\t' '{$NF=""; print $0}' | rev | sed 's/^\s*//g' | rev | tr ' ' '\t' > "$out_path"

rm -f "$tmp_path"

echo "Done. CAFE5 input written to: $out_path"
