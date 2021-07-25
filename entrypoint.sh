#!/bin/sh

echo "Printing text with newline"
output=$(git status) 
echo $(git rev-list --tags --max-count=1)

echo "$output"