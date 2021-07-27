#!/bin/bash

set -e 

# GET Released tag
RELEASE_TAG="${GITHUB_REF#refs/*/}"
echo "Current release tag is: ${RELEASE_TAG}"

#Get previous tag
#Fetch all tags
# git fetch --all --tags
# PREVIOUS_TAG=$(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
# echo "Previous release tag is: ${PREVIOUS_TAG}"

#Set dir names to be created/synced with AWS S3 dir major v1, v1.2 v1.2.3
#version="v1.2.3-beta.1" 
IFS='.'     # space is set as delimiter
read -ra VER <<< "$RELEASE_TAG"   # str is read into an array as tokens separated by IFS
MAJOR=${VER[0]:1:1} 
MINOR=${VER[1]}
PATCH=${VER[2]}

echo "major $MAJOR minor $MINOR patch $PATCH"
# echo " $AWS_S3_ENDPOINT $AWS_REGION $AWS_SECRET_ACCESS_KEY $AWS_S3_BUCKET "


#Upload to S3
if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

# Default to us-east-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT.
if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Sync using our dedicated profile and suppress verbose messages.
# All other flags are optional via the `args:` directive.

#Uploads major version to it's respective AWS S3 dir
  sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${MAJOR} \
      --profile s3-sync-action \
      --no-progress \
    ${ENDPOINT_APPEND} $*"

#Uploads minor version to it's respective AWS S3 dir
if [ "$MINOR" -ne "" -o ] then
  sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${MINOR} \
      --profile s3-sync-action \
      --no-progress \
      ${ENDPOINT_APPEND} $*"
  #Uploads PATCH version to it's respective AWS S3 dir
  if [ "$PATCH" -ne "" ] then
  sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${PATCH} \
      --profile s3-sync-action \
      --no-progress \
      ${ENDPOINT_APPEND} $*"
  fi
fi

# Clear out credentials after we're done.
# We need to re-run `aws configure` with bogus input instead of
# deleting ~/.aws in case there are other credentials living there.
# https://forums.aws.amazon.com/thread.jspa?threadID=148833
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF