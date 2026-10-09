
#!/bin/sh
set -eu

DRIVER="${MY_DATABASE_DRIVER:?Falta MY_DATABASE_DRIVER}"
DB_HOST="${DB_HOST:?Falta DB_HOST}"
DB_PORT="${DB_PORT:?Falta DB_PORT}"
DB_NAME="${DB_NAME:?Falta DB_NAME}"

BUCKET="${S3_BUCKET:?Falta S3_BUCKET}"
APELLIDO="${APELLIDO_ALUMNO:?Falta APELLIDO_ALUMNO}"

FECHA="$(date -u +%Y%m%d%H%M%S)"
DESTINO="${APELLIDO}/database/${FECHA}"
ARCHIVO="/tmp/backup-${FECHA}.archive"

case "$DRIVER" in
  postgres)
    export PGPASSWORD="${DB_PASSWORD:?Falta DB_PASSWORD}"
    pg_dump \
      -h "$DB_HOST" \
      -p "$DB_PORT" \
      -U "${DB_USER_NAME:?Falta DB_USER_NAME}" \
      -d "$DB_NAME" \
      -Fc \
      -f "$ARCHIVO"
    ;;

  mysql)
    export MYSQL_PWD="${DB_PASSWORD:?Falta DB_PASSWORD}"
    mysqldump \
      -h "$DB_HOST" \
      -P "$DB_PORT" \
      -u "${DB_USER_NAME:?Falta DB_USER_NAME}" \
      --single-transaction \
      "$DB_NAME" > "$ARCHIVO"
    ;;

  mongo)
    mongodump \
      --host "$DB_HOST" \
      --port "$DB_PORT" \
      --db "$DB_NAME" \
      --archive="$ARCHIVO"
    ;;

  *)
    echo "Driver no soportado: $DRIVER" >&2
    exit 1
    ;;
esac

test -s "$ARCHIVO"

if [ -n "${AWS_ENDPOINT_URL:-}" ]; then
  aws --endpoint-url "$AWS_ENDPOINT_URL" s3 cp \
    "$ARCHIVO" "s3://${BUCKET}/${DESTINO}/backup"
else
 if [ -n "${AWS_ENDPOINT_URL:-}" ]; then
  aws --endpoint-url "$AWS_ENDPOINT_URL" s3 cp \
    "$ARCHIVO" "s3://${BUCKET}/${DESTINO}/backup"
else
  aws s3 cp \
    "$ARCHIVO" "s3://${BUCKET}/${DESTINO}/backup"
fi
fi

rm -f "$ARCHIVO"

echo "Backup enviado correctamente a S3."
echo "Destino: s3://${BUCKET}/${DESTINO}/backup"
