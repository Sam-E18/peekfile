#!/bin/bash

# This script produce a report about the .fasta or .fa files in a folder or subfolder.
#How many fasta files there are.
#count the fastafiles hidden or symlinks.

#Print the summary report
echo "Summary:"
# Count .fa or .fasta files
fa_fasta_count=$(find . -type f -name "*.fa" | wc -l)
echo "Number of .fa files: $fa_fasta_count"

fasta_count=$(find . -type f -name "*.fasta" | wc -l)
echo "Number of .fasta files: $fasta_count"

#Find the hidden and symlink files fasta files
NHIDDEN=$(find . -type f -type l -o -name "*.fa"  | wc -l); 
if [[ $NHIDDEN -gt 0 ]]; then echo "There are $NHIDDEN hidden .fa files." ; else echo "No hidden files :/"; fi


NHIDDEN=$(find . -type f -type l -o -name "*.fasta"  | wc -l); 
if [[ $NHIDDEN -gt 0 ]]; then echo "There are $NHIDDEN hidden .fasta files." ; else echo "No hidden files :/"; fi

####How many unique fasta IDs contains


