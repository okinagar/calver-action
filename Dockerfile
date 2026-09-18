FROM alpine:3.24.2

RUN apk add git bash tzdata

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
