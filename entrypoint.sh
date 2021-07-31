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

# Set dir names to be created/synced with AWS S3
IFS='.' # . is set as delimiter
read -ra VER <<< "$RELEASE_TAG"   # str is read into an array as tokens separated by IFS
if [ "${VER[0]:0:1}" == "v" ]
then
  MAJOR=${VER[0]:1:1}
else
  MAJOR=${VER[0]}
fi

MINOR="$MAJOR.${VER[1]}"
PATCH="$MINOR.${VER[2]}.${VER[3]}"

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

# Uploads major version to it's respective AWS S3 dir
aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${MAJOR} --profile s3cdn-sync --no-progress $*
# Uploads minor version to it's respective AWS S3 dir
if [ "$MINOR" != "" ] 
then
  aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${MINOR} --profile s3cdn-sync --no-progress 
  # Uploads PATCH version to it's respective AWS S3 dir
  if [ "$PATCH" != "" ] 
  then
    aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${PATCH}  --profile s3cdn-sync  --no-progress 
  fi
fi

# Clear out credentials after we're done.s
aws configure --profile s3cdn-sync <<-EOF > /dev/null 2>&1
null
null
null
text
EOF