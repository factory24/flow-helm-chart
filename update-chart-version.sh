#!/bin/bash

CHART_FILE="flow/Chart.yaml"
TMP_FILE="/tmp/Chart.yaml.tmp"
VERSION_REGEX="^version: ([0-9]+\.[0-9]+\.[0-9]+)$"

if [[ -f "$CHART_FILE" ]]; then
  while IFS= read -r line
  do
    if [[ $line =~ $VERSION_REGEX ]]; then
      CURRENT_VERSION="${BASH_REMATCH[1]}"
      NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."$2"."$3+1}')
      sed "s/^version: .*/version: $NEW_VERSION/" $CHART_FILE > $TMP_FILE && mv $TMP_FILE $CHART_FILE
      echo "Version updated from $CURRENT_VERSION to $NEW_VERSION"
    fi
  done < "$CHART_FILE"
else
  echo "Chart file not found"
  exit 1
fi