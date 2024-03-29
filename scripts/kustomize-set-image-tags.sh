#!/bin/bash

set -e

OVERLAY=${1}

split_image() {
    export IMAGE_REPO="$(sed -En 's/([^:]*).*/\1/p' <<< ${1})"
    export IMAGE_TAG_SUFFIX="$(sed -En 's/.*:(.*)/\1/p' <<< ${1})"
    if [[ ! -z "${IMAGE_TAG_SUFFIX}" ]]
    then
        export IMAGE_TAG_SUFFIX="-${IMAGE_TAG_SUFFIX}"
    fi
}

cd ${OVERLAY}

for IMAGE in ${IMAGES}
do
    # ignore latest tag
    export IMAGE="$(sed 's/:latest//'<<< ${IMAGE})"

    split_image ${IMAGE}
    kustomize edit set image "${IMAGE}=*:${IMAGE_TAG}${IMAGE_TAG_SUFFIX}"
done
