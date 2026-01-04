#!/bin/bash

# source 00-env.sh

# pushd "${WORKSPACE}/infra/" || exit

#
# install minio with helm
#
if helm upgrade --install minio infra/02-minio \
    --create-namespace --namespace infra \
    --values infra/values/02-minio.yaml
then
    echo "Install minio successfully."
else
    echo "Failed to install minio." && exit
fi

# Get the NOTES.txt output
helm status minio -n infra

# popd || exit
# EOF