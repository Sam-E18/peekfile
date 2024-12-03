#!/bin/bash

# This script produces a report about the .fasta or .fa files in a folder or subfolder.
# If you want to take a look at the content of the file without viewing it all, you can display only a specific number of lines.
# Example: bash fastascan.sh directory/ 4 (Displays the first 4 and last 4 lines of each file).
# If you do not want to display the above, you can use the script without the line argument or add zero.
# Example: bash fastascan.sh directory/ 0.

# Check if the directory was provided
if [[ $1 ]]; then
    D="$1" # Use the provided directory
else
    D="." # Use the current directory
fi

# Print general summary
echo "=============> Summary of the fasta files in general <============="

# Count .fa or .fasta files
fa_fasta_count=$(find "$D" -type f \( -name "*.fa" -o -name "*.fasta" \) | wc -l)
if [[ $fa_fasta_count -gt 0 ]]; then
    echo "====> There are $fa_fasta_count FASTA files (.fa or .fasta)."
else
    echo "There are no .fa or .fasta files. :("
fi

# Search for fasta files without counting
fa_fasta_count3=$(find $D -type f \( -name "*.fa" -o -name "*.fasta" -o -name ".*.fa" -o -name ".*.fasta" \))

# Count unique FASTA IDs across all files
uniq_ids=$(grep -h '^>' $fa_fasta_count3 | sed 's/^>//' | sort | uniq | wc -l)
echo "====> Total unique FASTA IDs: $uniq_ids"

echo "======================================================"
echo "===========> FASTA FILE INDIVIDUAL REPORT <==========="

# Loop through each fasta file and generate a report
for file in $fa_fasta_count3; do
    echo "======================================================"

    # Extract and print the file name
    filename=$(echo "$file" | awk -F'/' '{print $NF}')
    echo "File name: $filename"

    # Check if the file is regular or a symlink
    if [[ -h "$filename" ]]; then
        echo "Regular or Symlink File: $filename is a symlink file."
    else
        echo "Regular or Symlink File: $filename is a regular file."
    fi

    # Count the sequences in the file
    seq_count=$(grep -h '^>' "$file" | wc -l)
    echo "Number of sequences: $seq_count"

    # Calculate the total length of sequences
    length=$(grep -v '^>' "$file" | sed 's/-//g; s/ //g; s/@//g; s/%//g; s/#//g; s/\n//g' | wc -c)
    echo "Total length: $length"

    # Determine if the file contains amino acid or nucleotide sequences
    amino_acids="EFILPQZ"
    if grep -q -v '^>' "$file" | grep -iq "[$amino_acids]"; then
        echo "The file '$filename' contains amino acid sequences."
    else
        echo "The file '$filename' contains nucleotide sequences."
    fi

    # Display content of the file based on line count
    numlines="$2" # Number of lines to display
    line_count=$(wc -l < "$file")
    if [[ "$numlines" -eq 0 ]]; then
        echo "Skip display the lines of the file"
    else
        if [[ "$line_count" -le $((2 * numlines)) ]]; then
            echo "Full content of $file"
            cat "$file"
        else
            echo "$filename is long, showing first and last $numlines lines."
            head -n "$numlines" "$file"
            echo "..."
            tail -n "$numlines" "$file"
        fi
    fi

    echo "======================================================"
done
