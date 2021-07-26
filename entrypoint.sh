#!/bin/sh

echo "WELCOME TO MY ENTRYPOINT SH"

#Fetch all tags
git fetch --all --tags

# GET Released tag
RELEASE_TAG="${GITHUB_REF#refs/*/}"
echo "Current release tag is: ${RELEASE_TAG}"

#Get previous tag
PREVIOUS_TAG=$(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
echo "Previous release tag is: ${PREVIOUS_TAG}"

# Set dir names to be created/synced with AWS S3
VERSION=(${RELEASE_TAG//"."/ })
MAJOR=${VERSION[0]}
MINOR=${VERSION[1]}
PATCH=${VERSION[2]}

echo "MAJOR version is: ${MAJOR}"
echo "MINOR version is: ${MINOR}"
echo "PATCH version is: ${PATCH}"


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