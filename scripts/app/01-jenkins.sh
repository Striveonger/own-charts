#!/bin/bash

# source 00-env.sh

# pushd "${WORKSPACE}/app/" || exit

#
# install jenkins with helm
#
if helm upgrade --install jenkins app/01-jenkins \
    --create-namespace --namespace app \
    --values app/values/01-jenkins.yaml
then
    echo "Install jenkins successfully."
else
    echo "Failed to install jenkins." && exit
fi

# Get the NOTES.txt output
helm status jenkins -n app

# popd || exit
# EOF