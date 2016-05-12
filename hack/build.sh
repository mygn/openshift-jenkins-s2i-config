#!/bin/bash -ex
# This script is used to build, test and squash the OpenShift Docker images.
#
# $1 - Specifies distribution - "rhel7" or "centos7"
# $2 - Specifies the image version - (must match with subdirectory in repo)# TEST_MODE - If set, build a candidate image and test it
# TEST_MODE - If set, build a candidate image and test it
# TAG_ON_SUCCESS - If set, tested image will be re-tagged as a non-candidate
#                  image, if the tests pass.
# VERSIONS - Must be set to a list with possible versions (subdirectories)

# Perform docker build but append the LABEL with GIT commit id at the end
function build_with_version {
  echo "-> Building ${IMAGE_NAME} ..."
  git_version=$(git rev-parse --short HEAD)
  s2i build . openshift/jenkins-1-centos7 $IMAGE_NAME -e io.openshift.builder-version=${git_version}
}

IMAGE_NAME="openshift/jenkins-1-centos7"
if [[ ! -z "${TEST_MODE}" ]]; then
  IMAGE_NAME+="-candidate"
fi
IMAGE_NAME+=":dev"

build_with_version

if [[ ! -z "${TEST_MODE}" ]]; then
  IMAGE_NAME=${IMAGE_NAME} test/run
  if [[ $? -eq 0 ]] && [[ "${TAG_ON_SUCCESS}" == "true" ]]; then
    echo "-> Re-tagging ${IMAGE_NAME} image to ${IMAGE_NAME/-candidate/}"
    docker tag -f $IMAGE_NAME ${IMAGE_NAME/-candidate/}
  fi

  if [[ ! -z "${REGISTRY}" ]]; then
    echo "-> Tagging image as" ${REGISTRY}/${IMAGE_NAME/-candidate/}
    docker tag -f $IMAGE_NAME ${REGISTRY}/${IMAGE_NAME/-candidate/}
  fi
fi
