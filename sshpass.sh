#!/bin/bash

# Loop, get parameters & remove any spaces from input
while getopts "s:u:p:a:i:v:" opt; do
    case $opt in
        s)
            # ACR Name
            sshPassword=${OPTARG// /}
        ;;    
        u)
            # ACR Name
            acrAdminUsername=${OPTARG// /}
        ;; 
        p)
            # ACR Name
            acrAdminPassword=${OPTARG// /}
        ;;            
        a)
            # ACR Name
            acrName=${OPTARG// /}
        ;;
        i)
            # Name of the container image
            acrImage=${OPTARG// /}
        ;;
        v)
            # Tag the image
            acrImageTag=${OPTARG// /}
        ;;
        \?)            
            # If user did not provide required parameters then show usage.
            echo "Invalid parameters! Required parameters are:  [-r] Resource Group [-n] ACI Name [-l] location [-d] ACI DNS Label [-a] ACR Name [-i] ACR Image Name [-v] ACR Image Tag [-k] ACR SKU [-s] Signaler Address [-t] Turn Address [-c] Turn Credential [-u] Turn Username"
        ;;   
    esac
done

sshpass -p $sshPassword ssh -o StrictHostKeyChecking=no mgreen@40.122.119.188 <<EOF

echo "logging into acr"

az acr login -u $acrAdminUsername -p $acrAdminPassword -n $acrName

echo "pulling tagged version $acrImageTag"

docker pull "$acrName.azurecr.io/$acrImage:$acrImageTag"

echo "attempting to stop existing container"

docker stop browser

docker rm browser

echo "attempting to run new container"

docker run --name browser -d "$acrName.azurecr.io/$acrImage:$acrImageTag"

exit

EOF