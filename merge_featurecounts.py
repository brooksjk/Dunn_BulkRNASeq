import pandas as pd
import glob
import os

input_dir = "/data2/masino_lab/jkbrook/Dunn_lab/featurecounts_results"
output_file = "/data2/masino_lab/jkbrook/Dunn_lab/featurecounts_final.txt"

# Find all featureCounts output files (any *_counts.txt)
count_files = glob.glob(os.path.join(input_dir, "*", "*_counts.txt"))
print(f"Found {len(count_files)} count files.")

merged = None

for file in count_files:
    # Derive sample name (e.g., CU32)
    sample = os.path.basename(file).split("_counts.txt")[0]
    print(f"Processing {sample} ...")

    # Read featureCounts table (skip comment lines starting with #)
    df = pd.read_csv(file, comment="#", sep="\t")

    # Keep only Geneid and the sample column (last column)
    df = df[["Geneid", df.columns[-1]]]
    df.columns = ["Geneid", sample]

    # Merge across all samples
    if merged is None:
        merged = df
    else:
        merged = merged.merge(df, on="Geneid", how="outer")

# Fill missing values with 0 and convert to integers
merged = merged.fillna(0)
merged.iloc[:, 1:] = merged.iloc[:, 1:].astype(int)

# Save the merged count matrix
merged.to_csv(output_file, sep="\t", index=False)

print(f"\nMerged featureCounts table saved to:\n{output_file}")
