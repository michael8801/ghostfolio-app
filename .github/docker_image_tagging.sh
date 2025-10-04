#!/bin/bash

SHORT_SHA="${GITHUB_SHA::7}"
TAG_LIST="$SHORT_SHA"

if [ "${GITHUB_REF_TYPE}" = "tag"  ] && [[ "${GITHUB_REF_NAME}" =~ ^v[0-9]+(\.[0-9]+){1,2}$ ]]; then
    TAG_LIST="${GITHUB_REF_NAME} ${TAG_LIST}"

elif [ "${GITHUB_REF_TYPE}" = "branch" ] && [ "${GITHUB_REF_NAME}" = "dev" ]; then
  TAG_LIST="dev ${TAG_LIST}"

elif [ "${GITHUB_REF_TYPE}" = "branch" ] && [ "${GITHUB_REF_NAME}" = "workflow-deploy-app" ]; then
  TAG_LIST="workflow-deploy-app ${TAG_LIST}"

elif [ "${GITHUB_REF_TYPE}" = "branch" ] && { [ "${GITHUB_REF_NAME}" = "main" ] || [ "${GITHUB_REF_NAME}" = "master" ]; }; then
  TAG_LIST="main ${TAG_LIST}"
fi

#docker build -t "${REGISTRY}/${REPOSITORY}:${SHORT_SHA}" .

for tag in ${TAG_LIST}; do
  docker tag  "${REGISTRY}/${REPOSITORY}:${SHORT_SHA}" "${REGISTRY}/${REPOSITORY}:${tag}"
  docker push "${REGISTRY}/${REPOSITORY}:${tag}"
done