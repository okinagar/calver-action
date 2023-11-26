FROM alpine:3.18.4

RUN apk add git bash tzdata

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
