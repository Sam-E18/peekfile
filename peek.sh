#!/bin/bash

#Print the first three and the las three lines(per default) of an input file
#(You need to put the numeber of lines after the file).
#Ejm. bash peek.sh tables/target_prokaryotes.txt 4(put the number of lines you want 3 or 4 or etc)


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
