#!/bin/bash

# Loop through each file in the current directory that matches 'workspace' in its name
for file in $(ls namespaces/ | grep workspace); do
    # Extract the namespace name from the filename by removing the '.yaml' extension
    namespace=$(basename "$file" .yaml)
    
    # Execute the command pipeline for the current file
    cat "namespaces/$file" | auger encode | ETCDCTL_API=3 etcdctl \
        --endpoints='https://10.8.20.3:2379,https://10.8.20.4:2379,https://10.8.20.6:2379' \
        --cert=/etc/kubernetes/ssl/kubernetes.pem \
        --key=/etc/kubernetes/ssl/kubernetes-key.pem \
        --cacert=/etc/kubernetes/ssl/ca.pem \
        --insecure-skip-tls-verify put "/registry/namespaces/$namespace"
    
    # Optional: Print a message to confirm processing
    echo "Processed file: $file for namespace: $namespace"
done
