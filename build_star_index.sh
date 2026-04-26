#!/bin/bash
#SBATCH --job-name=build_star_index_grch38
#SBATCH --partition=am-gpu-1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/data2/masino_lab/jkbrook/Dunn_lab/logs/build_star_index.%j.out
#SBATCH --error=/data2/masino_lab/jkbrook/Dunn_lab/logs/build_star_index.%j.err


# Genome FASTA (from NCBI GRCh38)
FASTA="/data/databases/h_sap/grch38/ensembl/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

# Gene annotation (from Ensembl or Gencode)
GTF="/data/databases/h_sap/grch38/ensembl/Homo_sapiens.GRCh38.99.gtf"

# Output directory for the STAR genome index
STAR_INDEX_DIR="/data2/masino_lab/jkbrook/Dunn_lab/star/STAR_2.7.10a_index"

module load star/2.7.10a

echo "Starting STAR genome index generation..."
echo "FASTA: $FASTA"
echo "GTF:   $GTF"
echo "Index directory: $STAR_INDEX_DIR"
echo "Threads: $SLURM_CPUS_PER_TASK"
echo "--------------------------------------------"

mkdir -p "$STAR_INDEX_DIR"

STAR --runMode genomeGenerate \
     --runThreadN "$SLURM_CPUS_PER_TASK" \
     --genomeDir "$STAR_INDEX_DIR" \
     --genomeFastaFiles "$FASTA" \
     --sjdbGTFfile "$GTF" \
     --sjdbOverhang 100

echo "--------------------------------------------"
echo "STAR genome index successfully generated!"
echo "Index files located in: $STAR_INDEX_DIR"
