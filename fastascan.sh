#!/bin/bash

# This script produce a report about the .fasta or .fa files in a folder or subfolder.
#How many fasta files there are.
#count the fastafiles hidden or symlinks.

#Print the summary report
echo "Summary:"
# Count .fa or .fasta files
fa_fasta_count=$(find . -type f  \( -name "*.fa" -o -name "*.fasta" \) | wc -l)
#If the number of fasta file is greater than 0, then echo the number of file, 
#if not then print there are no files 
if [[ $fa_fasta_count -gt 0 ]]; then echo "There are $fa_fasta_count Fasta files (.fa or .fasta)." ; else echo "There are no .fa or .fasta files. :("; fi


#Count the fasta files that are hidden.
fa_fasta_count2=$(find . -type f  \( -name ".*.fa" -o -name ".*.fasta" \) | wc -l)
if [[ $fa_fasta_count -gt 0 ]]; then echo "There are $fa_fasta_count2 hidden Fasta files (.fa or .fasta)." ; else echo "There are no fasta files hidden . :("; fi





