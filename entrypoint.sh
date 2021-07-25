#!/bin/sh

echo "Printing text with newline"
output=$(git status) 
echo "PREV_TAG_HASH=$(git rev-list --tags --max-count=1)"
echo "PREV_TAG=$(git describe --abbrev=0 --tags ${{ PREV_TAG_HASH }} )"

echo "$output"