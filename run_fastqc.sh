#!/bin/bash
#SBATCH --job-name=fastqc_dunn
#SBATCH --partition=am-gpu-1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=/data2/masino_lab/jkbrook/Dunn_lab/logs/fastqc.%j.out
#SBATCH --error=/data2/masino_lab/jkbrook/Dunn_lab/logs/fastqc.%j.err


RAW_DIR="/data2/masino_lab/jkbrook/Dunn_lab/Samples/fastq"
OUT_DIR="/data2/masino_lab/jkbrook/Dunn_lab/1_fastqc"

mkdir -p "$OUT_DIR"

module load fastqc/0.11.9

echo "Running FastQC on FASTQ files in: $RAW_DIR"
echo "Output directory: $OUT_DIR"
echo "Threads: $SLURM_CPUS_PER_TASK"
echo "--------------------------------------------"

fastqc -t "$SLURM_CPUS_PER_TASK" -o "$OUT_DIR" "$RAW_DIR"/*.fastq.gz

echo "--------------------------------------------"
echo "FastQC analysis complete!"
echo "Reports written to: $OUT_DIR"
