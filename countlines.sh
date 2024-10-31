#!/bin/bash

#Script to print the numbers of lines of the input file,depending on if has zero,one or >1line.
#update to provide any nummber of files as arguments
#Example of input expected: bash countlines.sh name_ofthe_file.txt empanadas.txt azucaa.txt text_file.txt


if [[ $# -eq 0 ]]; then
  echo "Error: No file was provided :( "
  exit 1
fi

for filename in "$@"; do
  if [[ ! -f "$filename"  ]]; then
    echo "Error: The file '$filename' does not exist."
    continue 
fi

#Obtain the number of lines in the file.
line_count=$(wc -l < "$filename")

#In this part choose the nummber of lines and show differents messages.
if [[ $line_count -eq 0 ]]; then
  echo "The file '$filename' its empty."
elif [[ $line_count -eq 1 ]]; then
  echo "The file '$filename' have 1 line."
else
  echo "The file '$filename' have $line_count lines."
fi

done
