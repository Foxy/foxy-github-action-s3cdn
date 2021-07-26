#!/bin/sh

echo "WELCOME TO MY ENTRYPOINT SH"
output=$(git status) 
output2=$(ls)
echo $(git rev-list --tags --max-count=1)
echo $(git --version)
echo "$output"
echo "$output2"