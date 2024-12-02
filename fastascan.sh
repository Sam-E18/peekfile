#!/bin/bash

# This script produce a report about the .fasta or .fa files in a folder or subfolder.

#Check if the directory was provided
if [[ $1 ]]; then
    D="$1" #use the directory
else
    D="." #use the actual directory
fi

#How many fasta files there are.
#count the fastafiles hidden.

#Print the summary report
echo "Summary of the fasta files in general:"

# Count .fa or .fasta files
fa_fasta_count=$(find "$D" -type f  \( -name "*.fa" -o -name "*.fasta" \) | wc -l)
#If the number of fasta file is greater than 0, then echo the number of file, 
#if not then print there are no files 
if [[ $fa_fasta_count -gt 0 ]]; then echo "There are $fa_fasta_count Fasta files (.fa or .fasta)." ; else echo "There are no .fa or .fasta files. :("; fi

#Count the fasta files that are hidden.
fa_fasta_count2=$(find "$D" -type f  \( -name ".*.fa" -o -name ".*.fasta" \) | wc -l)
if [[ $fa_fasta_count -gt 0 ]]; then echo "There are $fa_fasta_count2 hidden Fasta files (.fa or .fasta)." ; else echo "There are no fasta files hidden . :("; fi


#Count the IDs uniques into the each fasta file
fa_fasta_count3=$(find $D -type f \( -name "*.fa" -o -name "*.fasta" -o -name ".*.fa" -o -name ".*.fasta" \))
uniq_ids=$(grep -h '^>' $fa_fasta_count3 | sed 's/^>//' | sort | uniq | wc -l)
#shows the amount of uniqs ids
echo "Total unique FASTA IDs: $uniq_ids"

#Show the individual report for each fasta file 
echo "==========================="
echo "FASTA FILE INDIVIDUAL REPORT:"

#using a loop iterate to each file and print a header to every file 
for file in $fa_fasta_count3; do
	#using awk print the name of the file
	filename=$(echo "$file" | awk -F'/' '{print $NF}') #NF is ude to show the last field in the line
    #count sequences of each file
    seq_count=$(grep -h '^>' "$file" |wc -l)

	echo "==========================="
	
    echo "File name: $filename"
    if [[ -h "$filename" ]]; then
        echo "Status: $filename is a symlink file"
    else
        echo "Status: $filename is a regular file"
    fi
    
    echo "Number of sequences: $seq_count"
    echo "==========================="
    
done
