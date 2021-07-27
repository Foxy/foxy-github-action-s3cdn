#!/bin/bash

set -e 

echo "WELCOME TO MY ENTRYPOINT SH"

# GET Released tag
RELEASE_TAG="${GITHUB_REF#refs/*/}"
echo "Current release tag is: ${RELEASE_TAG}"

#Get previous tag
#Fetch all tags
# git fetch --all --tags
# PREVIOUS_TAG=$(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
# echo "Previous release tag is: ${PREVIOUS_TAG}"

#Set dir names to be created/synced with AWS S3 
# version="v1.2.3-beta.1"
IFS='.'     # space is set as delimiter
read -ra VER <<< "$RELEASE_TAG"   # str is read into an array as tokens separated by IFS
MAJOR=${VER[0]:1:1}
MINOR=${VER[1]}
PATCH=${VER[2]}

echo "major $MAJOR minor $MINOR patch $PATCH"


#Upload to S3
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Sync using our dedicated profile and suppress verbose messages.
# All other flags are optional via the `args:` directive.
# sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${DEST_DIR} \
#                 --profile s3-sync-action \
#                 --no-progress \
#                 ${ENDPOINT_APPEND} $*"

# # Clear out credentials after we're done.
# # We need to re-run `aws configure` with bogus input instead of
# # deleting ~/.aws in case there are other credentials living there.
# # https://forums.aws.amazon.com/thread.jspa?threadID=148833
# aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
# null 
# null
# null
# text
# EOF