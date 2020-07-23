FROM nginx:stable-alpine

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

COPY build/ /var/www

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80