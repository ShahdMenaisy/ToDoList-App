#Use a build argument for Node.js version
ARG NODE_VERSION=19.6

# Stage1: Base Image
FROM node:${NODE_VERSION}-slim AS base
WORKDIR /usr/src/app
COPY package*.json* ./

# Stage 2: Dependencies
FROM base AS dependencies
ENV NODE_ENV production
RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm install --only=production

# Stage 3: Production
FROM base AS production
ENV NODE_ENV production
COPY --from=dependencies /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .
USER node 

# Exposes port 4000 for the application
EXPOSE 4000

# Sets the default command to run the production server
CMD [ "npm", "start" ]
