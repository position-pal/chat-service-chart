#!/bin/bash
NEW_VERSION=$1
CHART_YAML="./Chart.yaml"
sed -i "s/^version:.*/version: \"$NEW_VERSION\"/" "$CHART_YAML"
sed -i "s/^appVersion:.*/appVersion: \"$NEW_VERSION\"/" "$CHART_YAML"
git add "$CHART_YAML"