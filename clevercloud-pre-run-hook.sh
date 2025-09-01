#!/bin/sh
set -e
set -x

cat <<EOF > ghost/config.production.json
{
    "url": "https://app-1810b6d4-876d-4fcf-9211-15b153ff902b.cleverapps.io/",
    "server": {
	"port": 8080,
	"host": "0.0.0.0"
    },
    "storage": {
	"active": "s3",
	"s3": {
	    "accessKeyId": "$CELLAR_ADDON_KEY_ID",
	    "secretAccessKey": "$CELLAR_ADDON_KEY_SECRET",
	    "region": "auto",
	    "bucket": "$BUCKET_NAME",
	    "endpoint": "$CELLAR_ADDON_HOST",
	    "assetHost": "$S3_ASSET_HOST"
	}
    },
    "database": {
	"client": "mysql",
	"connection": {
	    "host": "$MYSQL_ADDON_HOST",
	    "port": $MYSQL_ADDON_PORT,
	    "user": "$MYSQL_ADDON_USER",
	    "password": "$MYSQL_ADDON_PASSWORD",
	    "database": "$MYSQL_ADDON_DB"
	},
	"pool": {
	    "min": 2,
	    "max": 50
	}
    },
    "mail": {
	"transport": "SMTP",
	"from": "$SMTP_FROM",
        "options": {
            "service": "Mailgun",
            "host": "$SMTP_SERVER",
            "port": $SMTP_PORT,
            "secureConnection": true,
            "auth": {
		"user": "$SMTP_USER",
		"pass": "$SMTP_PASSWORD"
            }
	}
    },
    "process": "local",
    "logging": {
	"level": "debug",
	"transports": [
	    "stdout"
	]
    },
    "paths": {
	"contentPath": "../../../content/"
    }
}
EOF
