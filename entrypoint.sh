#!/bin/sh

echo "WELCOME TO MY ENTRYPOINT SH"
# GET Released tag
echo "RELEASE_TAG=${GITHUB_REF#refs/*/}"

#Get previous tag
git fetch --all --tags
git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1)

# Set dir names to be created/synced with AWS S3

#Upload to S3


# output=$(git status) 
# output2=$(ls)
# output4=$(git rev-list --tags --max-count=1)
# output3=$(git fetch --all --tags)
# echo $(git --version)
# echo $(git branch)
# echo $(aws s3 --version)
# echo "$output4"
# echo "$output2"