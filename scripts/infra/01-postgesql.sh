#!/usr/bin/env bash

# source "${OPS_WORKSHOP}/scripts/functions.sh"

# pushd "${OPS_WORKSHOP}/infrastructure/charts/" || exit

#
# install postgresql with helm
#
if helm upgrade --install postgresql infra/01-postgresql \
    --create-namespace --namespace infra \
    --values infra/values/01-postgres.yaml
then
    echo "Install postgresql successfully."
else
    echo "Failed to install postgresql." && exit
fi

# Get the NOTES.txt output
helm status postgresql -n infra

# EOF