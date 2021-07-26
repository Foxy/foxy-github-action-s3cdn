#!/bin/sh

echo "WELCOME TO MY ENTRYPOINT SH"

HASH=$(git rev-list --tags --max-count=1)
git describe --abbrev=0 --tags $HASH




# output=$(git status) 
# output2=$(ls)
# output4=$(git rev-list --tags --max-count=1)
# output3=$(git fetch --all --tags)
# echo $(git --version)
# echo $(git branch)
# echo $(aws s3 --version)
# echo "$output4"
# echo "$output2"