#!/bin/bash -e

# Loop, get parameters & remove any spaces from input
while getopts "a:i:v:" opt; do
    case $opt in
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

echo "logging into acr"

# get azure container registry username and password
acrUsername="$(az acr credential show -n $acrName --query username --output tsv)"
acrPassword="$(az acr credential show -n $acrName --query passwords[0].value --output tsv)"

az acr login -u $acrUsername -p $acrPassword -n headlessappsdev

echo "pulling tagged version $acrImageTag"

docker pull "$acrName.azurecr.io/$acrImage:$acrImageTag"

echo "attempting to stop existing container"

docker stop browser

docker rm browser

echo "attempting to run new container"

docker run --name browser -d "$acrName.azurecr.io/$acrImage:$acrImageTag"