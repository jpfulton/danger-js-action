FROM node:18.18.0-slim

ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=$GITHUB_TOKEN

# Install modern yarn
RUN corepack enable && yarn set version stable

# Install curl and jq
RUN apt-get update && apt-get install -y curl jq

# Copy repo files to container and install dependencies
WORKDIR /action/workspace
COPY .yarnrc.yml package.json yarn.lock /action/workspace/
RUN yarn install

# Copy entrypoint script to container
COPY entrypoint.sh /action/workspace/entrypoint.sh

ENTRYPOINT [ "bash", "/action/workspace/entrypoint.sh", "${GITHUB_TOKEN}" ]
