#!/bin/bash

set -e 

# Check that the environment variable has been set correctly
if [ -z "$AWS_S3_BUCKET" ]; then
  echo >&2 'error: missing AWS_S3_BUCKET environment variable'
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo >&2 'error: missing AWS_ACCESS_KEY_ID environment variable'
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo >&2 'error: missing AWS_SECRET_ACCESS_KEY environment variable'
  exit 1
fi

# GET Released tag
RELEASE_TAG="${GITHUB_REF#refs/*/}"
echo "Current release tag is: ${RELEASE_TAG}"
echo "GITHUB REF is: ${RELEASE_REF}"

if [ -z "$1" ]; then
  PACKAGE_NAME="myrepo"
else
  PACKAGE_NAME=$1
fi

# Set dir names to be created/synced with AWS S3
IFS='.' # . is set as delimiter
read -ra VER <<< "$RELEASE_TAG"   # str is read into an array as tokens separated by IFS
if [ "${VER[0]:0:1}" == "v" ]
then
  MAJOR="${PACKAGE_NAME}@${VER[0]:1:1}"
else
  MAJOR=${PACKAGE_NAME}@${VER[0]}
fi

if [ "${VER[3]}" == "" ]
then
  PATCH="$MINOR.${VER[2]}"
else
  PATCH="$MINOR.${VER[2]}.${VER[3]}"
fi

MINOR="$MAJOR.${VER[1]}"
LATEST="${PACKAGE_NAME}@latest"

echo "Major ver: $MAJOR \n Minor ver: $MINOR \n Patch ver:s $PATCH"

# Upload to S3
# Default to us-east-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
aws configure --profile s3cdn-sync <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Uploads dir content to it's respective AWS S3 `latest `dir
aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${LATEST} --profile s3cdn-sync --no-progress

# Uploads major version to it's respective AWS S3 dir
aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${MAJOR} --profile s3cdn-sync --no-progress
# Uploads minor version to it's respective AWS S3 dir
if [ "$MINOR" != "" ] 
then
  bash -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${MINOR} --profile s3cdn-sync --no-progress"
  # Uploads PATCH version to it's respective AWS S3 dir
  if [ "$PATCH" != "" ] 
  then
    bash -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${PATCH}  --profile s3cdn-sync  --no-progress" 
  fi
fi

# Clear out credentials after we're done.
aws configure --profile s3cdn-sync <<-EOF > /dev/null 2>&1
null
null
null
text
EOF