#!/bin/sh

# version="v1.2.3-beta.1"
# #  Dir to upload 
# IFS='.'     # space is set as delimiter
# read -ra VER <<< "$version"   # str is read into an array as tokens separated by IFS
# MAJOR=${VER[0]:1:1}
# MINOR=${VER[1]}
# PATCH=${VER[2]}
RELEASE_TAG="v1.2.3-beta.1" 
IFS='.'     # space is set as delimiter
read -ra VER <<< "$RELEASE_TAG"   # str is read into an array as tokens separated by IFS

num="v1"
if [ "${VER[0]:0:1}" == "v" ]
then
  MAJOR=${VER[0]:1:1}
else
  MAJOR=${VER[0]}
fi

MINOR="$MAJOR.${VER[1]}"
PATCH="$MINOR.${VER[2]}"
echo "major: $MAJOR \nminor: $MINOR \npatch: $PATCH"
