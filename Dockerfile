FROM node:18.18.0-slim

# Set maintainer
LABEL maintainer="J. Patrick Fulton"

# Set labels for GHCR
LABEL "com.github.actions.name"="danger-js-action-base"
LABEL "com.github.actions.description"="Runs JavaScript/TypeScript Dangerfiles with a collection of plugins."
LABEL "com.github.actions.icon"="green-square"
LABEL "com.github.actions.color"="green"

# Install modern yarn
RUN corepack enable && yarn set version stable

# Install curl
RUN apt-get update && apt-get install -y curl

# Copy repo files to container and install dependencies
WORKDIR /action/workspace
COPY .yarnrc.yml package.json yarn.lock /action/workspace/

# Install dependencies
RUN yarn install

# Expand the PATH environment variable to include /action/workspace/node_modules/.bin
ENV PATH="/action/workspace/node_modules/.bin:${PATH}"

# Create a symlink to the danger binary
RUN ln -s /action/workspace/node_modules/.bin/danger /usr/local/bin/danger

# Copy entrypoint script to container
COPY entrypoint.sh /action/workspace/entrypoint.sh
RUN chmod +x /action/workspace/entrypoint.sh

ENTRYPOINT [ "bash", "/action/workspace/entrypoint.sh"]