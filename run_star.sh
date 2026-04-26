#!/bin/bash
#SBATCH --job-name=star_grch38
#SBATCH --partition=am-gpu-1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/data2/masino_lab/jkbrook/Dunn_lab/logs/star_grch38.%j.out
#SBATCH --error=/data2/masino_lab/jkbrook/Dunn_lab/logs/star_grch38.%j.err

#!/usr/bin/env bash
set -euo pipefail

THREADS=16
FASTA="/data/databases/h_sap/grch38/ensembl/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
GTF="/data/databases/h_sap/grch38/ensembl/Homo_sapiens.GRCh38.99.gtf"
GENOME_DIR="/data2/masino_lab/jkbrook/Dunn_lab/star/STAR_2.7.10a_index"
FASTQ_DIR="/data2/masino_lab/jkbrook/Dunn_lab/Samples/fastq"
TRIM_DIR="/data2/masino_lab/jkbrook/Dunn_lab/Samples/trimmed"
OUT_DIR="/data2/masino_lab/jkbrook/Dunn_lab/Samples"

mkdir -p "$GENOME_DIR" "$TRIM_DIR" "$OUT_DIR"

module load star/2.7.10a
module load fastp

# Process single-end fastq files
for fq in "$FASTQ_DIR"/*_R1_*.fastq.gz; do
    fname=$(basename "$fq")                                # CU38_S1_R1_001.fastq.gz
    sample="${fname}"                                      # Keep entire name intact

    # Trimmed file naming
    trimmed_r1="$TRIM_DIR/${sample}_TRIMMED.fastq.gz"
    json_report="$TRIM_DIR/${sample}_fastp.json"
    html_report="$TRIM_DIR/${sample}_fastp.html"

    echo "[$(date)] Trimming reads for $sample..."
    fastp -i "$fq" \
          -o "$trimmed_r1" \
          -j "$json_report" \
          -h "$html_report" \
          -w $THREADS \
          --detect_adapter_for_pe \
          --length_required 30

    echo "[$(date)] Aligning $sample with STAR..."
    STAR \
        --runThreadN $THREADS \
        --genomeDir "$GENOME_DIR" \
        --readFilesIn "$trimmed_r1" \
        --readFilesCommand zcat \
        --outFileNamePrefix "$OUT_DIR/${sample}_TRIMMED.fastq.gz" \
        --outSAMtype BAM SortedByCoordinate \
        --quantMode GeneCounts

    echo "[$(date)] Completed $sample"
done

echo "[$(date)] All trimming and alignments complete."
