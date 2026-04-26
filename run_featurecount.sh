#!/bin/bash
#SBATCH --job-name=dunn_featurecounts
#SBATCH --partition=am-gpu-1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=6:00:00
#SBATCH --output=/data2/masino_lab/jkbrook/Dunn_lab/logs/dunn_featurecounts.%j.out
#SBATCH --error=/data2/masino_lab/jkbrook/Dunn_lab/logs/dunn_featurecounts.%j.err

# ============================
# CONFIGURATION
# ============================

# Input folder containing BAMs
INPUT_DIR="/data2/masino_lab/jkbrook/Dunn_lab/Samples"
# Annotation file
GTF="/data/databases/h_sap/grch38/ensembl/Homo_sapiens.GRCh38.99.gtf"
# Output base directory
OUTPUT_BASE="/data2/masino_lab/jkbrook/Dunn_lab/featurecounts_results"

# Load required modules
module load subread/1.6.4
module load samtools/1.10

# Create logs and output folders if they don’t exist
mkdir -p logs "$OUTPUT_BASE"

# ============================
# MAIN LOOP
# ============================

echo "Starting featureCounts run..."
echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_BASE"
echo "Annotation file: $GTF"

for BAM in "$INPUT_DIR"/*.bam; do
    # Skip if no BAMs found
    [ -e "$BAM" ] || { echo "No BAM files found in $INPUT_DIR"; exit 1; }

    # Extract sample name (e.g. CU32)
    SAMPLE=$(basename "$BAM" | cut -d'_' -f1)
    OUTDIR="$OUTPUT_BASE/$SAMPLE"
    mkdir -p "$OUTDIR"

    echo "Processing sample: $SAMPLE"
    echo "  BAM file: $BAM"
    echo "  Output folder: $OUTDIR"

    featureCounts \
        -a "$GTF" \
        -o "$OUTDIR/${SAMPLE}_counts.txt" \
        -T 8 \
        -g gene_id \
        -t exon \
        "$BAM"

    echo "Finished $SAMPLE"
    echo "---------------------------------------"
done

echo "All samples processed!"
