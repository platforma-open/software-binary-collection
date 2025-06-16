#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}/.."

if [ "$#" -ne 1 ]; then
    echo ""
    echo "Usage: '${0}' <version>"
    echo "       '${0}' 1.0.0"
    echo ""
    exit 1
fi

#
# Script parameters
#
version="${1}"

# Fast-track: make descriptors at the very beginning
pl-pkg build descriptors \
    --package-id="${version}"

pl-pkg build packages \
    --package-id="${version}" \
    --all-platforms 