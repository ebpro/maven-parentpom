#!/bin/bash

## MAKE SURE YOU HAVE enviroment variables
# GITHUBACTOR
# GITHUBTOKEN
# DOCKERHUB_USERNAME
# DOCKERHUB_TOKEN
# SONAR_TOKEN

mvn --errors \
    --show-version \
    --batch-mode \
    org.apache.maven.plugins:maven-wrapper-plugin:3.2.0:wrapper \
        "-Dmaven=3.8.8"

./mvnw --errors \
              --show-version \
              --batch-mode \
              --update-snapshots \
              --color always \
              --settings ci-settings.xml \
              --activate-profiles jacoco \
              verify

 ./mvnw --errors \
              --show-version \
              --batch-mode \
              --color always \
              --settings ci-settings.xml \
              site:site 