#!/bin/sh

version="v1.2.3-beta.1"

IFS='.'     # space is set as delimiter
read -ra VER <<< "$version"   # str is read into an array as tokens separated by IFS
MAJOR=${VER[0]:1:1}
MINOR=${VER[1]}
PATCH=${VER[2]}

echo "major $MAJOR minor $MINOR patch $PATCH"
