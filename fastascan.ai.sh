#!/bin/bash

# This script produces a report about the .fasta or .fa files in a folder or subfolder.
# If you want to take a look at the content of the file without viewing it all, you can display only a specific number of lines.
# Example: bash fastascan.sh directory/ 4 (Displays the first 4 and last 4 lines of each file).
# If you do not want to display the above, you can use the script without the line argument or add zero.
# Example: bash fastascan.sh directory/ 0.

#1 Check if the directory was provided
if [[ -z "$1" ]]; then
    D="$1" #Use the current directory
else
    D="." #Use the provided directory
fi

#check if the directory exist
if [[ ! -d "$D" ]]; then
    echo "Error: The directory '$D' does not exist or is not accessible." #error message
    exit 1  #End the script if the directory not exist
fi

#check if the directory provided is empty
if [[ ! "$(ls -A "$D")" ]]; then
    echo "Error: The directory '$D' is empty."
    exit 1
fi

#2 Validate the number of lines argument
if [[ -z "$2" ]]; then
    numlines=0 #default value
else
    if [[ "$2" =~ ^[0-9]+$ ]]; then #verify that the number is intger
       numlines="$2"
    else
        echo "Error: The second argument must be an integer." #show error if not 
    fi
fi

# Print general summary
echo "=============> Summary of the fasta files in general <============="

#3: Search for FASTA files
#Search the fasta files without count
fa_fasta_files=$(find "$D" -type f \( -name "*.fa" -o -name "*.fasta" -o -name ".*.fa" -o -name ".*.fasta" \))
if [[ -z "$fa_fasta_files" ]]; then
    echo "Error: No .fa or .fasta files found in the directory '$D'." #print error if no t a fasta file.
    exit 1
fi

fa_fasta_count=$(echo "$fa_fasta_files" | wc -l) ## Count .fa or .fasta files
echo "====> There are $fa_fasta_count FASTA files in the directory."

#4 Count unique FASTA IDs across all files
uniq_ids=$(grep -h '^>' $fa_fasta_files | sed 's/^>//' | sort | uniq | wc -l) #Print the amount of uniques ids of each sequence in all the files.

echo "====> Total unique FASTA IDs: $uniq_ids"

#Show the individual report for each fasta file 
echo "======================================================"
echo "===========> FASTA FILE INDIVIDUAL REPORT <==========="

#5 Loop through each fasta file and generate a report to every file 
for file in $fa_fasta_files; do
    echo "======================================================"

    # Extract and print the file name
    filename=$(echo "$file" | awk -F'/' '{print $NF}') # NF is use to show the last field in the line.
    echo "File name: $filename" #Print the filename

    # Check if the file is regular or a symlink
    if [[ -h "$file" ]]; then 
        echo "File type: Symlink"
    else
        echo "File type: Regular file"
    fi

    # Count the sequences in the file
    seq_count=$(grep -c '^>' "$file")
    echo "Number of sequences: $seq_count" #Print the number of sequences into the fastas files.

    # Calculate the total length of sequences
    length=$(grep -v '^>' "$file" | sed 's/-//g; s/ //g; s/@//g; s/%//g; s/#//g; s/\n//g' | wc -c) #sed to avoid count rare symbols.
         echo "Total length: $length"

    # Determine if the file contains amino acid or nucleotide sequences
    # Check if the file is text before processing
     if file "$file" | grep -q 'text'; then
    nucleotides=$(grep -v '^>' "$file" | grep -E -o -i '[CTAUG]' | wc -l) #Count nucleotides
    amino_acids=$(grep -v '^>' "$file" | grep -E -o -i '[ACDEFGHIKLMNPQRSTVWYBZX*]' | wc -l) #Count amino acids
    total_chars=$(grep -v '^>' "$file" | grep -E -o '[A-Za-z]' | wc -l) #Count total characters

     # Determine content
    if [[ $nucleotides -eq 0 && $amino_acids -eq 0 ]]; then
         echo "The file '$file' contains UNRECOGNIZABLE sequences."
    elif [[ $nucleotides -gt 0 && $amino_acids -eq 0 ]]; then
         echo "The file '$file' contains NUCLEOTIDES sequences."
    elif [[ $amino_acids -gt 0 && $nucleotides -eq 0 ]]; then
         echo "The file '$file' contains AMINO sequences."
    elif [[ $nucleotides -gt 0 && $amino_acids -gt 0 ]]; then
         echo "The file '$file' contains a combination of nucleotide and amino acid sequences."
    else
         echo "The file '$file' contains MIXED or UNCLEAR content."
    fi
    else
    # Handle binary or unreadable files
         echo "Warning: The file '$file' appears to be binary or unreadable."
         echo "The file '$file' contains UNRECOGNIZABLE sequences."
    fi
   

   #6 Display content of the file based on line count
    line_count=$(wc -l < "$file")
    if [[ "$numlines" -eq 0 ]]; then
        echo "Skip display the lines of the file"
    else
        # If file has 2N lines or fewer, shows the full content
        if [[ "$line_count" -le $((2 * numlines)) ]]; then
            echo "Full content of $file"
            cat "$file"
        else
            # For files with more than 2N lines shows N first and end lines.
            echo "$filename is long, showing first and last $numlines lines:"
            head -n "$numlines" "$file"
            echo "..."
            tail -n "$numlines" "$file"
        fi
    fi
    echo "======================================================"
done