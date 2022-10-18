# STAGE BUILD PROJECT
FROM node:18-alpine as deps
# Install global modules
WORKDIR /app

# Install production modules
COPY package*.json ./
RUN npm install

FROM node:18-alpine AS builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules
RUN npm run build

FROM node:18-alpine 
WORKDIR /app
COPY --from=builder /app .
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN npm i -g pm2
USER node 

EXPOSE 3000/tcp

CMD [ "/bin/bash", "/usr/local/bin/entrypoint.sh" ]