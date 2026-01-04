#!/usr/bin/env bash

# source "${OPS_WORKSHOP}/scripts/functions.sh"

# pushd "${OPS_WORKSHOP}/infrastructure/charts/" || exit

#
# install postgresql with helm
#
if helm upgrade --install dispatch-notice apps/dispatch-notice-1.0.0.tgz \
    --create-namespace --namespace apps \
    --values apps/values/dispatch-notice.yaml
then
    echo "Install dispatch-notice successfully."
else
    echo "Failed to install dispatch-notice." && exit
fi

# Get the NOTES.txt output
helm status dispatch-notice -n apps

# EOF