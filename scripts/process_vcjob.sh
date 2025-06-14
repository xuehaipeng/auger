
#!/bin/bash

# List of etcd keys
etcd_keys=(
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-bmvralwpmp"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-fwdiaavgav"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-hsdgenvqck"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-oplnjauuap"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-oqxdlefueg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-rndnxynsfg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-tlfuwhlaco"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-xiqufmcpkn"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-28-shared/train-job-zqfehfxgqj"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-46-shared/train-job-cjkxbryykk"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-46-shared/train-job-mzuqhtgpxe"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-46/train-job-gmodvsnids"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-afwnjpeupm"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-dfebnqlfpu"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-eafrphudik"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-enjaywxkhg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-gejzosswfk"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-gfoogygyas"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-hagcxyrntm"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-hvcfwmgftf"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-hvlevkiykn"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-itjjixmlwt"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-jkhemaekup"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-kgdotzfktb"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-lctzxscqae"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-lffwgkspar"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-lfoohkxwds"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-lnpcnfcvtt"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-lyoldmwiwv"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-maqddseaoa"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-oignxnyttm"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-oxgboqgmuo"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-ozfjxxorpn"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-pbznodmunb"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-pretxmyaux"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-qggfujkbfr"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-qrpfvlmyfy"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-ryvvvrwuok"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-tgdhrqtmky"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-tglqtwaulh"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-tlrhznjytv"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-uepmcpfjbk"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-uffkemxebh"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-uhavkzhwsu"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-uhmpvxvmwp"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-upeumjphxx"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-vpcaricatw"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-vvvlsjilex"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-weaukjymth"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-wzpctojexu"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-wzvydgvnuj"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-xcbiavmrsn"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-xnhotvkhqn"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-xtyylyeoti"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-yhdlooklwg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-yiqtatguzx"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zpgpcetpzw"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zshxuytebs"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zwbtkxvjaj"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zxvvjgmura"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zxwzrqccsd"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zyrxewpikf"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75-shared/train-job-zywoekzjqc"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-abmgwmvchf"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-bwzbhqvlus"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-eejsdrrpid"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-epasmtjout"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-erysjqdfus"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-etgdkbyonl"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-hwlewxnyhr"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-isljfgvour"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-jonikqrymg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-kdpkoyjokg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-kxaucukixg"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-lloqfihycj"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-mxsztbtttz"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-obrybwnabm"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-okstwdtkkb"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-pnxhxfadzb"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-qkdleccnen"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-vyyvvjqnbf"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-wwbkdoveqj"
    "/registry/batch.volcano.sh/jobs/kubecube-workspace-75/train-job-zrphlcbrhn"
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