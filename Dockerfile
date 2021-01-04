# syntax=docker/dockerfile:experimental

## WARNING This build requires experimental features (native build and buildkit)
## run with the following command
## COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up --build

## If needed invalidate the cache with
#docker builder prune --filter type=exec.cachemount

ARG JRE=adoptopenjdk/openjdk11:jre-11.0.9_11-alpine

FROM brunoe/maven:3.6.3-jdk-11-openj9 as mavenbuild
# A Variable to indicate if the build is in CI Server
ARG CI

# Github Credentials
ARG GITHUBLOGIN
ENV GITHUBLOGIN=$GITHUBLOGIN
ARG GITHUBPASSWORD
ENV GITHUBPASSWORD=$GITHUBPASSWORD

# Dockerhub Credentials
ARG DOCKER_USERNAME
ENV DOCKER_USERNAME=$DOCKER_USERNAME
ARG DOCKER_PASSWORD
ENV DOCKER_PASSWORD=$DOCKER_PASSWORD

WORKDIR /build
COPY . /build

ENV MAVEN_PARAM="--settings /build/.github/ci-settings.xml -B -e -T 1C"

RUN --mount=type=cache,target=/root/.m2 mvn $MAVEN_PARAM clean package

FROM mavenbuild as mavendeploy
RUN --mount=type=cache,target=/root/.m2 mvn $MAVEN_PARAM deploy
