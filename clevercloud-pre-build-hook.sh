#!/bin/bash

export storage__s3__accessKeyId=${CELLAR_ACCESS_KEY}
export storage__s3__secretAccessKey=${CELLAR_SECRET_KEY}
export storage__s3__assetHost=${CELLAR_ADDON_HOST}
export storage__s3__bucket=${BUCKET_NAME}
export storage__s3__region="fr"
export database__connection__host=${MYSQL_ADDON_HOST}
export database__connection__user=${MYSQL_ADDON_USER}
export database__connection__password=${MYSQL_ADDON_PASSWORD}
export database__connection__database=${MYSQL_ADDON_DB}
export database__connection__port=${MYSQL_ADDON_PORT}
export url=${BUCKET_NAME}
#SMTP
export mail__from=${SMTP_FROM}
export mail__options__host=${SMTP_HOST}
export mail__options__port=${SMTP_PORT}
export mail__options__auth__user=${SMTP_USER}
export mail__options__auth__password=${SMTP_PASSWORD}
export mail__options__service=${SMTP_SERVICE}
export mail__options__secureConnection=${SMTP_SECURE_CONNECTION}
