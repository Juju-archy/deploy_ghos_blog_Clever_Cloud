#!/bin/bash

export storage__s3__accessKeyId=${CELLAR_ACCESS_KEY}
export storage__s3__secretAccessKey=${CELLAR_SECRET_KEY}
export storage__s3__assetHost=${CELLAR_ADDON_HOST}
export storage__s3__bucket="<your-bucket>"
export storage__s3__region="fr"
export database__connection__host=${MYSQL_ADDON_HOST}
export database__connection__user=${MYSQL_ADDON_USER}
export database__connection__password=${MYSQL_ADDON_PASSWORD}
export database__connection__database=${MYSQL_ADDON_DB}
export database__connection__port=${MYSQL_ADDON_PORT}
export url=${BUCKET_NAME}
#SMTP
export mail__from="<your-email>"
export mail__options__host="<your-smtp-host>"
export mail__options__port="<your-smtp-port>"
export mail__options__auth__user="<your-smtp-user>"
export mail__options__auth__password="<your-smtp-password>"
export mail__options__service="<your-smtp-service>"
export mail__options__secureConnection=true
