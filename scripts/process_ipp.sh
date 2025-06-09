
#!/bin/bash

# List of etcd keys
etcd_keys=(
    "/registry/ipam.metal3.io/ippools/baremetal/ippool-system"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1725417948859786385"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1725420983014248615"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1725421016477092949"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1725422026584920890"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1725441456004813280"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1725614231880250195"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726055090185497012"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726055090244914889"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726055722633240901"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726216503968603253"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726216625480425333"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726716562674202975"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726736288521620404"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726736589545297784"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726736589621980427"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726814103247810100"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726816682422461789"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726816682490788182"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726816682534869855"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726817081011523705"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726817081082645216"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726817081122485074"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1726817081163449409"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1730704823095230203"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1731379512526875382"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1743320704278839794"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1743320704337570824"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1743322125111457672"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1743322125179993026"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1743490287900620243"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1744251449593024875"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1744687370417991834"
    "/registry/ipam.metal3.io/ippools/baremetal/subnet-1747034450703135572"
)

# Iterate through each key and execute the command
for key in "${etcd_keys[@]}"; do
    echo "Processing key: $key"
    auger extract -f uat-etcd_2506051355.db -k "$key" | auger encode | ETCDCTL_API=3 etcdctl \
        --endpoints='https://10.8.20.3:2379,https://10.8.20.4:2379,https://10.8.20.6:2379' \
        --cert=/etc/kubernetes/ssl/kubernetes.pem \
        --key=/etc/kubernetes/ssl/kubernetes-key.pem \
        --cacert=/etc/kubernetes/ssl/ca.pem \
        --insecure-skip-tls-verify put "$key"
    
    # Check if the command was successful
    if [ $? -eq 0 ]; then
        echo "Successfully processed key: $key"
    else
        echo "Failed to process key: $key"
    fi
    echo "----------------------------------------"
done