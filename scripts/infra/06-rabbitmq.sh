#!/bin/bash

# source 00-env.sh

# pushd "${WORKSPACE}/infra/" || exit

#
# install rabbitmq with helm
#
if helm upgrade --install rabbitmq infra/06-rabbitmq \
    --create-namespace --namespace infra \
    --values infra/values/06-rabbitmq.yaml
then
    echo "Install rabbitmq successfully."
else
    echo "Failed to install rabbitmq." && exit
fi

# Get the NOTES.txt output
helm status rabbitmq -n infra

# popd || exit
# EOF
