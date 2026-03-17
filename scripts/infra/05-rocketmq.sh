#!/bin/bash

# source 00-env.sh

# pushd "${WORKSPACE}/infra/" || exit

#
# install rocketmq with helm
#
if helm upgrade --install rocketmq infra/05-rocketmq \
    --create-namespace --namespace infra \
    --values infra/values/05-rocketmq.yaml
then
    echo "Install rocketmq successfully."
else
    echo "Failed to install rocketmq." && exit
fi

# Get the NOTES.txt output
helm status rocketmq -n infra

# popd || exit
# EOF
