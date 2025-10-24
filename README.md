# Bulk RNA-Seq Pipeline
This repo contains code and scripts for performing Bulk RNA Seq analysis on triple-negative breast cancer (TNBC) samples in collaboration with the [Dunn Lab](https://dunnresearchlab1.wixsite.com/dunnresearch) at Clemson University.

This analysis was completed using Clemson's Center for Human Genetics (CHG) HPC Cluster, Secretariat.

### Feature Count Aggregation
Feature count aggregation was completed using the following files:
- `run_files.sh`: Runs initial feature count on all Sample Files
- `merge_featurecounts`: Aggregates results across individual featurecount files into a single file, ***featurecounts_final.txt***
