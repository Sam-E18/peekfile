#!/bin/bash

#Print the first 3 and the last 3 lines(per default) of an input file
#Ejm. bash peek.sh tables/target_prokaryotes.txt 4( You can put the number of lines you want to print, 3 or 4 or etc).
#This script print the full imput file if contain 2x or less lines, if not, print a warning message saying that the file is long.


if [[ -z "$2" ]]; then
 num_of_lines=3
else
 num_of_lines=$2
fi

total_lines=$(wc -l < "$1")

if [[ "$total_lines" -le $((2 * num_lines)) ]]; then
 cat "$1"
else
 echo "Warning: The file is very long. Showing the first and last $num_lines:"
 head -n "$num_of_lines" "$1"

 echo "..."

 tail -n "$num_of_lines" "$1"
fi
