#!/bin/bash

# Loop through each directory that matches 'kubecube-workspace-*'
for dir in kubecube-workspace-*/; do
    # Remove trailing slash to get the directory name (which is the namespace)
    namespace=$(basename "$dir")
    
    # Loop through each .yaml file in the current directory
    for file in "$dir"*.yaml; do
        # Check if file exists (in case no .yaml files are found)
        if [ ! -f "$file" ]; then
            continue
        fi
        
        # Extract the name from the filename by removing the '.yaml' extension
        name=$(basename "$file" .yaml)
        
        # Execute the command pipeline for the current file
        cat "$file" | auger encode | ETCDCTL_API=3 etcdctl \
            --endpoints='https://172.17.10.1:2379,https://172.17.10.2:2379,https://172.17.10.3:2379' \
            --cert=/etc/kubernetes/ssl/kubernetes.pem \
            --key=/etc/kubernetes/ssl/kubernetes-key.pem \
            --cacert=/etc/kubernetes/ssl/ca.pem \
            --insecure-skip-tls-verify put "/registry/deployments/$namespace/$name"
        
        # Optional: Print a message to confirm processing
        echo "Processed file: $file for namespace: $namespace, name: $name"
    done
done
