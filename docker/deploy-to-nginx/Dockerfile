FROM nginx:stable

WORKDIR /usr/src/app

# Copy source code to container
COPY ./build-todeploy/ /usr/src/app/

# Copy nginx config to container
COPY ./docker/conf.d/default.conf /etc/nginx/conf.d
COPY ./docker/conf.d/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx"]