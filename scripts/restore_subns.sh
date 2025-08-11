#!/bin/bash

# restore-missing-subnamespaceanchors.sh
# Script to restore missing SubnamespaceAnchor resources

# List of missing SubnamespaceAnchor names
MISSING_ANCHORS=(
    "kubecube-tenant-1-shared"
    "kubecube-tenant-5-shared"
    "kubecube-tenant-569-shared"
    "kubecube-tenant-570-shared"
    "kubecube-workspace-1"
    "kubecube-workspace-1-shared"
    "kubecube-workspace-7"
    "kubecube-workspace-7-shared"
    "kubecube-workspace-8"
    "kubecube-workspace-8-shared"
    "kubecube-workspace-10"
    "kubecube-project-1"
    "kubecube-project-2"
    "kubecube-project-5"
    "kubecube-project-8"
    "kubecube-project-12"
    "kubecube-project-13"
    "kubecube-project-14"
    "kubecube-project-20"
    "kubecube-project-24"
    "kubecube-project-27"
)

# Directory where SubnamespaceAnchor YAMLs are stored
ANCHOR_DIR="subnamespaceanchors"

# Counter for summary
APPLIED_COUNT=0
FAILED_COUNT=0

echo "Starting restore of missing SubnamespaceAnchor resources..."
echo "Total to restore: ${#MISSING_ANCHORS[@]}"

# Loop through each anchor and apply its YAML
for anchor in "${MISSING_ANCHORS[@]}"; do
    yaml_file="$ANCHOR_DIR/${anchor}.yaml"
    
    if [[ -f "$yaml_file" ]]; then
        echo "Applying: $yaml_file"
        if kubectl apply -f "$yaml_file"; then
            ((APPLIED_COUNT++))
        else
            echo "❌ Failed to apply: $yaml_file"
            ((FAILED_COUNT++))
        fi
    else
        echo "❌ File not found: $yaml_file"
        ((FAILED_COUNT++))
    fi
done

# Final summary
echo
echo "✅ Successfully applied: $APPLIED_COUNT"
echo "❌ Failed: $FAILED_COUNT"
echo "Restore process completed."

if [[ $FAILED_COUNT -gt 0 ]]; then
    echo "Please check the errors above and ensure all YAML files exist and are valid."
    exit 1
fi