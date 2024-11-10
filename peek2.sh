#!/bin/bash

#Script to print every text files
#if conteins 20 lines or less displays full content
#if not print a warning message followed by first and last 10 lines.

# Set default number of lines to print from the start and end if not specified
if [[ -z "$1" ]]; then
  num_of_lines=10
else
  num_of_lines=$1
fi

# Find all .txt files in the current directory and its subdir
# If file has 20 lines or less, print its full content

find . -type f -name "*.txt" | while read -r file; do
  total_lines=$(wc -l < "$file")
  if [[ "$total_lines" -le 20 ]]; then
    echo "The full content of $file:"
    cat "$file"
  else
    # If file has more than 20 lines, display a warning and show first and last N lines
    echo "Warning: $file is very long :). Showing the first and last $num_of_lines lines:"
    head -n "$num_of_lines" "$file"
    echo "..."
    tail -n "$num_of_lines" "$file"
  fi
  
  echo 
done
