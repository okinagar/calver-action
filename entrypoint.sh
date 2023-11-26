#!/bin/bash

set -e

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "Error: GITHUB_TOKEN is not defined"
  exit 1
fi

# Set TimeZone
if [ -n "$TZ" ]; then
  echo "TZ: $TZ"
  cp /usr/share/zoneinfo/"${TZ}" /etc/localtime
fi

TARGET_BRANCH="$1"
SCHEMA="$2"

cd /github/workspace || exit 1
git config --global --add safe.directory /github/workspace

# Exit if the latest commit is tagged
git checkout "$TARGET_BRANCH"
LATEST_COMMIT_HASH=$(git rev-parse HEAD)
TAGS=$(git tag --contains "$LATEST_COMMIT_HASH")
if [ -n "$TAGS" ]; then
    echo "The latest commit is tagged"
    exit 1
fi

# Exit if SCHEMA contains MICRO but does not end with MICRO
if [[ $SCHEMA == *MICRO* && $SCHEMA != *MICRO ]]; then
    echo "Error: SCHEMA does not end with MICRO"
    exit 1
fi

LATEST_TAG=$(git describe --tags --abbrev=0 || echo "")
echo "LATEST_TAG: $LATEST_TAG"
echo "CURRENT: $(date)"
CURRENT=$(date +'%Y %y %-y %m %-m %U %d %-d')
IFS=' ' read -ra CURRENT_PARTS <<< "$CURRENT"

NEW_VERSION_NUMBER="${SCHEMA//YYYY/${CURRENT_PARTS[0]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//YY/${CURRENT_PARTS[1]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//0Y/${CURRENT_PARTS[2]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//MM/${CURRENT_PARTS[3]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//0M/${CURRENT_PARTS[4]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//0W/${CURRENT_PARTS[5]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//DD/${CURRENT_PARTS[6]}}"
NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//0D/${CURRENT_PARTS[7]}}"

if [[ $SCHEMA == *"MICRO" ]]; then
  NEW_VERSION_NUMBER_WITHOUT_MICRO=$(echo "$NEW_VERSION_NUMBER" | sed -E 's/\.MICRO$//')
  echo "NEW_VERSION_NUMBER_WITHOUT_MICRO: $NEW_VERSION_NUMBER_WITHOUT_MICRO"
  LATEST_VERSION_NUMBER=$(echo "$LATEST_TAG" | sed -E 's/\.[0-9]+$//')
  echo "LATEST_VERSION_NUMBER: $LATEST_VERSION_NUMBER"
  if [[ $LATEST_TAG =~ ([0-9]+)$ ]]; then
    LATEST_VERSION_MICRO="${BASH_REMATCH[1]}"
  else
    LATEST_VERSION_MICRO=0
  fi
  echo "LATEST_VERSION_MICRO: $LATEST_VERSION_MICRO"
  if [ "$NEW_VERSION_NUMBER_WITHOUT_MICRO" == "$LATEST_VERSION_NUMBER" ]; then
    MICRO=$((LATEST_VERSION_MICRO + 1))
  else
    MICRO=0
  fi
  echo "MICRO: $MICRO"
  NEW_VERSION_NUMBER="${NEW_VERSION_NUMBER//MICRO/$MICRO}"
fi
echo "version_number: $NEW_VERSION_NUMBER"

echo "version_number=$NEW_VERSION_NUMBER" >> "$GITHUB_OUTPUT"
