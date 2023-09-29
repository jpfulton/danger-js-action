FROM node:18.18.0-slim

# Install modern yarn
RUN corepack enable && yarn set version stable

# Copy repo files to container and install dependecies
COPY .yarnrc.yml package.json yarn.lock ./
RUN yarn install

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
