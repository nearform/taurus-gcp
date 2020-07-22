FROM node:12-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./
COPY index.js ./index.js

RUN npm ci

USER node

CMD ["node", "index.js"]

EXPOSE 3000