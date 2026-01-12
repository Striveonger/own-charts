#!/bin/bash

# source 00-env.sh

# pushd "${WORKSPACE}/infra/" || exit

#
# install redis with helm
#
if helm upgrade --install redis infra/03-redis \
    --create-namespace --namespace infra \
    --values infra/values/03-redis.yaml
then
    echo "Install redis successfully."
else
    echo "Failed to install redis." && exit
fi

# Get the NOTES.txt output
helm status redis -n infra

# popd || exit
# EOF
