FROM nginx:1.27-alpine

COPY bin/container-host-user /usr/local/bin/container-host-user
COPY tests/images/nginx-hook-entrypoint.sh /hook-entrypoint.sh
COPY tests/images/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /usr/local/bin/container-host-user /hook-entrypoint.sh \
  && apk add --no-cache su-exec \
  && mkdir -p /tmp/client_temp /tmp/proxy_temp /tmp/fastcgi_temp /tmp/uwsgi_temp /tmp/scgi_temp

ENTRYPOINT ["/hook-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
