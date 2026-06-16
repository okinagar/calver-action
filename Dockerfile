FROM alpine:3.24.1

RUN apk add git bash tzdata

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
