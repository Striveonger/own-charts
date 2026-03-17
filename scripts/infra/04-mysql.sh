#!/bin/bash

# source 00-env.sh

# pushd "${WORKSPACE}/infra/" || exit

#
# install mysql with helm
#
if helm upgrade --install mysql infra/04-mysql \
    --create-namespace --namespace infra \
    --values infra/values/04-mysql.yaml
then
    echo "Install mysql successfully."
else
    echo "Failed to install mysql." && exit
fi

# Get the NOTES.txt output
helm status mysql -n infra

# popd || exit
# EOF
