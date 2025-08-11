#!/bin/bash

# Define the list of subnamespaceanchors to restore
TARGET_NAMES=(
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

# Function to check if a name is in the target list
is_target_name() {
    local name="$1"
    for target in "${TARGET_NAMES[@]}"; do
        if [[ "$name" == "$target" ]]; then
            return 0
        fi
    done
    return 1
}

# Counter for processed files
processed_count=0

echo "Starting subnamespaceanchors restoration process..."
echo "Looking for YAML files in subnamespaceanchors directory and subdirectories..."

# Find all YAML files in subnamespaceanchors directory and subdirectories
while IFS= read -r -d '' filepath; do
    # Extract the filename without path and extension
    filename=$(basename "$filepath" .yaml)
    
    # Check if this filename is in our target list
    if is_target_name "$filename"; then
        echo "Processing: $filepath (name: $filename)"
        
        # Get the parent directory to determine namespace context
        parent_dir=$(basename "$(dirname "$filepath")")
        
        # Execute the command pipeline for the current file
        if cat "$filepath" | auger encode | ETCDCTL_API=3 etcdctl \
            --endpoints='https://172.17.10.1:2379,https://172.17.10.2:2379,https://172.17.10.3:2379' \
            --cert=/etc/kubernetes/ssl/kubernetes.pem \
            --key=/etc/kubernetes/ssl/kubernetes-key.pem \
            --cacert=/etc/kubernetes/ssl/ca.pem \
            --insecure-skip-tls-verify put "/registry/subnamespaceanchors.hnc.x-k8s.io/$parent_dir/$filename"; then
            echo "✓ Successfully restored subnamespaceanchor: $filename in namespace: $parent_dir"
            ((processed_count++))
        else
            echo "✗ Failed to restore subnamespaceanchor: $filename in namespace: $parent_dir"
        fi
        echo "---"
    fi
done < <(find subnamespaceanchors -name "*.yaml" -type f -print0 2>/dev/null)

echo "Restoration process completed."
echo "Total subnamespaceanchors processed: $processed_count"
