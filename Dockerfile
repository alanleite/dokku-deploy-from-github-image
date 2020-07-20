FROM alpine:3.6

RUN apk add --no-cache bash openssh-client

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]