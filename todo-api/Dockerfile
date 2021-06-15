# Build API
FROM node:12-alpine3.12 as build

WORKDIR /app

COPY . .

RUN npm install \
    && npm run build \
    && npm prune --production

FROM node:12-alpine3.12 as final

WORKDIR /app

COPY --from=build --chown=1000:1000 /app/dist /app/dist
COPY --from=build --chown=1000:1000 /app/node_modules /app/node_modules
COPY --from=build --chown=1000:1000 /app/package.json /app/package.json

USER 1000:1000

CMD ["npm", "run", "start:prod"]
