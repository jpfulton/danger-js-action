FROM node:18.18.0-slim

# Install modern yarn
RUN corepack enable && yarn set version stable

# Copy repo files to container and install dependencies
WORKDIR /action/workspace
COPY .yarnrc.yml package.json yarn.lock /action/workspace/
RUN yarn install

# Copy entrypoint script to container
COPY entrypoint.sh /action/workspace/entrypoint.sh

ENTRYPOINT [ "bash", "/action/workspace/entrypoint.sh" ]
