#!/bin/sh

echo "WELCOME TO MY ENTRYPOINT SH"
output=$(git status) 
output2=$(ls)
output3=$(git rev-list --tags --max-count=1)
echo $(git --version)
echo $(git branch)
echo $(aws s3 --version)
echo "$output3"
echo "$output2"