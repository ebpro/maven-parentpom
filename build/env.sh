#!/bin/bash

## We read the config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${DIR}/config.sh

## The project name is the name of git repository
PROJECT_NAME=`git remote -v|grep fetch|sed 's/.*:\(.*\).git.*/\1/'|cut -f 2 -d '/'`
echo "# The project name is ($PROJECT_NAME)"

## The image name by default the project directory in lowercase
IMAGE_NAME=`echo ${PROJECT_NAME}| tr '[:upper:]' '[:lower:]'`
echo "# The docker image name will be ($IMAGE_NAME)"
echo "# The docker image base name will be (${REGISTRY}/${IMAGE_NAME})"
CURRENT=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
BRANCH=`git rev-parse --abbrev-ref HEAD|tr '/' '_' `
SHA=`git log -1 --pretty=%h`
cd $CURRENT
echo "# The current branch is ($BRANCH)"
echo "# The current commit is ($SHA)"
