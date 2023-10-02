FROM node:18.18.0-slim as build

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
RUN chmod +x /action/workspace/entrypoint.sh
RUN bash -c "exec /action/workspace/entrypoint.sh \"$GITHUB_TOKEN\" \"${@}\" --"

#ENTRYPOINT [ "bash", "/action/workspace/entrypoint.sh", "$GITHUB_TOKEN" ]
#ENTRYPOINT /action/workspace/entrypoint.sh "$GITHUB_TOKEN"
#ENTRYPOINT ["bash", "-c", "exec /action/workspace/entrypoint.sh \"$GITHUB_TOKEN\" \"${@}\"", "--"]

FROM node:18.18.0-slim
WORKDIR /usr/src/danger
ENV PATH="/usr/src/danger/node_modules/.bin:$PATH"
#COPY package.json ./
#COPY --from=build /usr/src/danger/distribution ./dist
COPY --from=build /action/workspace/package.json ./package.json
COPY --from=build /action/workspace/node_modules ./node_modules
#RUN ln -s /usr/src/danger/dist/commands/danger.js /usr/bin/danger
RUN ln -s /usr/src/danger/node_modules/.bin/danger /usr/bin/danger

ENTRYPOINT ["danger", "ci", "--verbose", "--fail-on-errors", "--newComment", "--removePreviousComments"]
