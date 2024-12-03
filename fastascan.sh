#!/bin/bash

# This script produce a report about the .fasta or .fa files in a folder or subfolder.
#If you want to take a look at the content of the file without viewing it all, you can display only a specific number of lines, as follows. Example: bash fastascan.sh directory/ 4 .  
#(Display the first 4 and last 4 lines of each file).
#If you do not want to display the above, you can use the script without the line argument or add zero. Example: bash fastascan.sh directory/ 0.

#How many fasta files there are.
#How many uniques IDs files there are.

#Check if the directory was provided
if [[ $1 ]]; then
    D="$1" #use the directory
else
    D="." #use the actual directory
fi

#Print the summary report
echo "=============> Summary of the fasta files in general <============="

# Count .fa or .fasta files
fa_fasta_count=$(find "$D" -type f  \( -name "*.fa" -o -name "*.fasta" \) | wc -l)
#If the number of fasta file is greater than 0, then echo the number of file, if not then print there are no files.
if [[ $fa_fasta_count -gt 0 ]]; then echo "====> There are $fa_fasta_count Fasta files (.fa or .fasta)." ; else echo "There are no .fa or .fasta files. :("; fi

fa_fasta_count3=$(find $D -type f \( -name "*.fa" -o -name "*.fasta" -o -name ".*.fa" -o -name ".*.fasta" \))

#Count the IDs uniques into the each fasta file
uniq_ids=$(grep -h '^>' $fa_fasta_count3 | sed 's/^>//' | sort | uniq | wc -l)
echo "====> Total unique FASTA IDs: $uniq_ids" #Print the amount of uniques ids of each sequence in all the files.

#Show the individual report for each fasta file 
echo "======================================================"
echo "===========> FASTA FILE INDIVIDUAL REPORT <==========="

#using a loop iterate to each file and print a header to every file 
for file in $fa_fasta_count3; do
	echo "======================================================"
	#using awk print the name of the file
	filename=$(echo "$file" | awk -F'/' '{print $NF}') #NF is use to show the last field in the line.
	
    echo "File name: $filename" #Print the filename
    #Shows if the file is a regular or symlink file.
    if [[ -h "$filename" ]]; then
        echo "Regular or Symlink File: $filename is a symlink file."
    else
        echo "Regular or Symlink File: $filename is a regular file."
    fi

    #Count the sequences of each file
    seq_count=$(grep -h '^>' "$file" |wc -l)
    echo "Number of sequences: $seq_count" #Print the number of sequences into the fastas files.
    
    #Search with grep the amount of 
    length=$(grep -v '^>' "$file" | sed 's/-//g; s/\n//g' | wc -c)
    echo "Total length: $length" #Print the lenght of the file

    #This part, display or not a specific amount of lines of each file.
    numlines="$2" #Define the number of lines to display
    line_count=$(wc -l < "$file") #Count the number of total lines

    #If the number of lines is zero then skip the display of the lines.
    if [[ "$numlines" -eq 0 ]]; then
        echo " Skip display the lines of the file"
    else
          # If file has 2N lines or fewer, shows the full content
          if [[ "$line_count" -le $((2 * numlines)) ]]; then
              echo " Full content of $file "
              cat "$file"
           else
                  # For files with more than 2N lines
                  echo " $filename is long, showing first and last $numlines lines. "
                   head -n "$numlines" "$file"
                   echo "..."
                   tail -n "$numlines" "$file"
            fi
    fi 

    echo "======================================================"
    
done
