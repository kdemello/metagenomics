#!/bin/bash

# Set the input and reference filenames
reference1_filename="panBacterial_16s_Reference.fasta"
reference2_filename="gg_13_5_with_taxonomy8fasta_with_truefalsefalse.fasta"

# Create the new directory
mkdir new

# Extract the reference names from the FASTA files
awk '/^>/ {print substr($0,2)}' "$reference1_filename" > new/reference1_references.list
awk '/^>/ {print substr($0,2)}' "$reference2_filename" > new/reference2_references.list

# Convert all BAM files to SAM files and move them to the new directory
for bam_filename in *.bam; do
  # Extract the base name of the BAM file (without the .bam extension)
  base_name=$(basename "$bam_filename" .bam)

  # Convert the BAM file to SAM and write to a new file
  samtools view -h "$bam_filename" -o "new/${base_name}.sam"
done

# Create the list of SAM filenames
ls new/*.sam > new/sam_filenames.list

# Make a list of the reference names that are in each SAM file
while read sam_filename; do
  # Extract the reference names from the SAM file
  awk '$3 ~ /^[^*]/ {print $3}' "$sam_filename" > "${sam_filename}_references.list"

  # Write the SAM filename to the appropriate output file
  while read reference_name; do
    if grep -q "$reference_name" new/reference1_references.list; then
      # Extract the base name of the SAM file (without the .sam extension)
      base_name=$(basename "$sam_filename" .sam)
      # Write the SAM file to a new file with the reference1 reference list name
      awk -v ref="$reference_name" '$3 == ref' "$sam_filename" >> "new/${base_name}_reference1.sam"
    elif grep -q "$reference_name" new/reference2_references.list; then
      # Extract the base name of the SAM file (without the .sam extension)
      base_name=$(basename "$sam_filename" .sam)
      # Write the SAM file to a new file with the reference2 reference list name
      awk -v ref="$reference_name" '$3 == ref' "$sam_filename" >> "new/${base_name}_reference2.sam"
    fi
  done < "${sam_filename}_references"
done
