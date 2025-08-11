#!/bin/bash

# Loop through each file in the current directory that matches 'workspace' in its name
for file in $(ls namespaces/ | grep workspace); do
    # Extract the namespace name from the filename by removing the '.yaml' extension
    namespace=$(basename "$file" .yaml)
    
    # Execute the command pipeline for the current file
    cat "namespaces/$file" | auger encode | ETCDCTL_API=3 etcdctl \
        --endpoints='https://172.17.10.1:2379,https://172.17.10.2:2379,https://172.17.10.3:2379' \
        --cert=/etc/kubernetes/ssl/kubernetes.pem \
        --key=/etc/kubernetes/ssl/kubernetes-key.pem \
        --cacert=/etc/kubernetes/ssl/ca.pem \
        --insecure-skip-tls-verify put "/registry/namespaces/$namespace"
    
    # Optional: Print a message to confirm processing
    echo "Processed file: $file for namespace: $namespace"
done
