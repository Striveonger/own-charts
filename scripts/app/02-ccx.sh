#!/bin/bash

#
# install ccx with helm
#
if helm upgrade --install ccx app/02-ccx \
    --create-namespace --namespace app \
    --values app/values/02-ccx.yaml
then
    echo "Install ccx successfully." 
else
    echo "Failed to install ccx." && exit
fi

helm status ccx -n app
