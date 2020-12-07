#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${DIR}/env.sh

for image in $IMAGES; do
imageLower=`echo ${image}|tr '[:upper:]' '[:lower:]'`
echo "# Building docker image (${IMAGE_NAME}.${imageLower}:$SHA) (${IMAGE_NAME}.${imageLower}:$BRANCH)"
DOCKER_BUILDKIT=1 docker build \
  --progress plain \
  --build-arg GITHUBLOGIN=$GITHUBLOGIN \
  --build-arg GITHUBPASSWORD=$GITHUBPASSWORD \
  --build-arg BINTRAY_USERNAME=$BINTRAY_USERNAME \
  --build-arg BINTRAY_API_KEY=$BINTRAY_API_KEY \
  --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
  --build-arg DOCKER_PASSWORD=$DOCKER_PASSWORD \
  --target $image \
	-t ${IMAGE_NAME}.${imageLower}:$SHA \
	-t ${IMAGE_NAME}.${imageLower}:$BRANCH \
	`[[ "$BRANCH" == "master" ]] && -t ${BASE}:latest` \
	.
done
exit 0


