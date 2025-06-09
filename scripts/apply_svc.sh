#!/bin/bash

echo "Starting service file application using kubectl..."

# Loop through each directory that matches 'kubecube-workspace-*'
for dir in kubecube-workspace-*/; do
    # Check if directory exists
    if [ ! -d "$dir" ]; then
        continue
    fi
    
    # Remove trailing slash to get the directory name (which is the namespace)
    namespace=$(basename "$dir")
    echo "Processing namespace: $namespace"
    
    # Loop through each .yaml file in the current directory that starts with 'nb'
    for file in "$dir"nb*.yaml; do
        # Check if file exists (in case no matching files are found)
        if [ ! -f "$file" ]; then
            continue
        fi
        
        # Extract the service name from the filename by removing the '.yaml' extension
        service_name=$(basename "$file" .yaml)
        echo "Found service: $service_name in namespace: $namespace"
        
        # Apply the service file using kubectl
        kubectl apply -f "$file"
        
        # Check if the command was successful
        if [ $? -eq 0 ]; then
            echo "Successfully applied service: $service_name in namespace: $namespace"
        else
            echo "Failed to apply service: $service_name in namespace: $namespace"
        fi
        echo "----------------------------------------"
    done
done

echo "Service file application completed!"
