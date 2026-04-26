# Bulk RNA-Seq Pipeline
This repo contains code and scripts for performing Bulk RNA Seq analysis on triple-negative breast cancer (TNBC) samples in collaboration with the [Dunn Lab](https://dunnresearchlab1.wixsite.com/dunnresearch) at Clemson University.

This analysis was completed using Clemson's Center for Human Genetics (CHG) HPC Cluster, Secretariat.

### Feature Count Aggregation
Feature count aggregation was completed using the following files (in listed order):
- `run_fastqc.sh`: Runs fastqc on all sample files
- `build_star_index.sh`: Builds index needed for STAR program if one is not available
- `run_star.sh`: Runs [STAR](https://github.com/alexdobin/STAR) aligner
- `run_featurecount.sh`: Runs feature count on all sample files
- `merge_featurecounts.py`: Aggregates results across individual featurecount files into a single file, ***featurecounts_final.txt***
