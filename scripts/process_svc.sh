#!/bin/bash

# Function to check if a string is an IP address
is_ip_address() {
    local ip="$1"
    # Remove any quotes and whitespace
    ip=$(echo "$ip" | sed 's/[[:space:]]*//g' | sed 's/"//g')
    
    # Check if it's an IPv4 address
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0  # true - it's an IP address
    else
        return 1  # false - it's not an IP address
    fi
}

# Function to process a single YAML file
process_yaml_file() {
    local file="$1"
    local temp_file=$(mktemp)
    
    echo "Processing file: $file"
    
    # Read the file line by line
    local in_cluster_ips_array=false
    local cluster_ips_lines=()
    local line_num=0
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))
        
        # Handle clusterIP field (single line)
        if [[ $line =~ ^[[:space:]]*clusterIP:[[:space:]]*(.*) ]]; then
            local value="${BASH_REMATCH[1]}"
            if is_ip_address "$value"; then
                echo "  Removing clusterIP with IP address: $value"
                continue  # Skip this line
            else
                echo "$line" >> "$temp_file"
            fi
        # Handle clusterIPs array start
        elif [[ $line =~ ^[[:space:]]*clusterIPs:[[:space:]]*$ ]]; then
            in_cluster_ips_array=true
            cluster_ips_lines=("$line")
        # Handle clusterIPs array items
        elif [[ $in_cluster_ips_array == true ]] && [[ $line =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
            cluster_ips_lines+=("$line")
        # Handle end of clusterIPs array or other content
        else
            if [[ $in_cluster_ips_array == true ]]; then
                # We've reached the end of the clusterIPs array
                # Check if any of the array items contain IP addresses
                local has_ip=false
                for array_line in "${cluster_ips_lines[@]}"; do
                    if [[ $array_line =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
                        local array_value="${BASH_REMATCH[1]}"
                        if is_ip_address "$array_value"; then
                            has_ip=true
                            break
                        fi
                    fi
                done
                
                if [[ $has_ip == false ]]; then
                    # Keep the clusterIPs array since it doesn't contain IP addresses
                    for array_line in "${cluster_ips_lines[@]}"; do
                        echo "$array_line" >> "$temp_file"
                    done
                else
                    echo "  Removing clusterIPs array containing IP addresses"
                fi
                
                in_cluster_ips_array=false
                cluster_ips_lines=()
            fi
            
            # Add the current line
            echo "$line" >> "$temp_file"
        fi
    done < "$file"
    
    # Handle case where file ends while still in clusterIPs array
    if [[ $in_cluster_ips_array == true ]]; then
        local has_ip=false
        for array_line in "${cluster_ips_lines[@]}"; do
            if [[ $array_line =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
                local array_value="${BASH_REMATCH[1]}"
                if is_ip_address "$array_value"; then
                    has_ip=true
                    break
                fi
            fi
        done
        
        if [[ $has_ip == false ]]; then
            for array_line in "${cluster_ips_lines[@]}"; do
                echo "$array_line" >> "$temp_file"
            done
        else
            echo "  Removing clusterIPs array containing IP addresses"
        fi
    fi
    
    # Replace the original file with the processed content
    mv "$temp_file" "$file"
    echo "  Updated file: $file"
}

# Main script logic
echo "Starting service file processing..."

# Loop through each directory that matches 'kubecube-workspace-*'
for dir in kubecube-workspace-*/; do
    # Check if directory exists
    if [ ! -d "$dir" ]; then
        continue
    fi
    
    namespace=$(basename "$dir")
    echo "Processing namespace: $namespace"
    
    # Loop through each .yaml file in the current directory that starts with 'nb'
    for file in "$dir"nb*.yaml; do
        # Check if file exists (in case no matching files are found)
        if [ ! -f "$file" ]; then
            continue
        fi
        
        service_name=$(basename "$file" .yaml)
        echo "Found service: $service_name in namespace: $namespace"
        
        # Process the YAML file
        process_yaml_file "$file"
    done
done

echo "Service file processing completed!"
