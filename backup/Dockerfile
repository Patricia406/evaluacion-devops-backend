
FROM alpine:3.20

RUN apk add --no-cache \
    bash \
    ca-certificates \
    aws-cli \
    postgresql16-client \
    mysql-client \
    mongodb-tools \
    && update-ca-certificates

WORKDIR /app

COPY backup.sh /app/backup.sh

RUN sed -i 's/\r$//' /app/backup.sh && chmod +x /app/backup.sh

ENTRYPOINT ["/bin/sh", "/app/backup.sh"]
