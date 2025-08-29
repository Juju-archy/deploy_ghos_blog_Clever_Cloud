# Ghost Blog Template on Clever Cloud

This project is a template for a [Ghost blog](https://ghost.org) running on Node.js 20 and deployed on [Clever Cloud](https://clever-cloud.com).

It is based on the [local installation](https://ghost.org/docs/install/local/) of Ghost, as well as its source code on [Github](https://github.com/TryGhost/Ghost/).

## What is Ghost?

Ghost is a modern, open-source publishing platform designed for professional bloggers, writers, and content creators. Built with Node.js, it offers a lightweight, fast, and flexible alternative to traditional CMS platforms. 

Ghost provides a clean, distraction-free writing experience, powerful SEO features, and extensive customization options through themes and integrations. It is often used for personal blogs, newsletters, and online publications.

## Prérequis

- **Node.js 20**
- **MySQL**
- **Cellar S3**
- **Ghost-CLI**
- **Clever Tools CLI** ([documentation](https://www.clever-cloud.com/developers/doc/cli/))
- **Git**

## Installation and configuration

### 1. Initialize your project

Create the project file and install locally Ghost:
```sh
# Create the project file
mkdir myblog && cd myblog
# Install Ghost-CLI
npm install -g ghost-cli@latest
# Install Ghost
ghost install local
ghost stop
```

Remove the default theme and add custom theme submodules:
```sh
rm -r content/themes/casper
cp -r current/content/themes/casper/ content/themes/
git init
cd content/themes/
git submodule add https://github.com/curiositry/mnml-ghost-theme
git submodule add https://github.com/zutrinken/attila/
wget https://github.com/TryGhost/Source/archive/refs/tags/<last-version>.zip -O source.zip #check and use the lastest version https://github.com/TryGhost/Source/releases
rm -R source
unzip source.zip -d temp
mkdir source
mv temp/*/* source/
rm -R temp source.zip
```

Add the S3 module to use Cellar S3:
```sh
npm install ghost-storage-adapter-s3
mkdir -p ./content/adapters/storage
cp -r ./node_modules/ghost-storage-adapter-s3 ./content/adapters/storage/s3
```

### 2. Create and configure Node application and addons

User the [clever tools CLI](https://www.clever-cloud.com/developers/doc/cli/install)

Create the Node.js app, MySQL and Cellar S3 on Clever Cloud:
```sh
clever create --type node myblog
clever addon create mysql-addon --plan s_sml myblogsql --link myblog
clever addon create cellar-addon --plan s_sml myblogcellar --link myblog
clever env set CC_PRE_BUILD_HOOK "./clevercloud-pre-build-hook.sh"
clever env set CC_PRE_RUN_HOOK "./clevercloud-pre-run-hook.sh"
clever env set CC_POST_BUILD_HOOK "./clevercloud-post-build-hook.sh"
clever env set NODE_ENV "production"
clever env set BUCKET_NAME "testghost" 
clever env set SMTP_FROM "pouny.julie@gmail.com"
clever env set SMTP_SERVICE "Mailgun" 
clever env set SMTP_HOST "smtp.gmail.com"
clever env set SMTP_PORT "465"
clever env set SMTP_SECURE_CONNECTION "true"
clever env set SMTP_USER "pouny.julie@gmail.com"
clever env set SMTP_PASSWORD "nbtprfhdpfngiilq"
```

Set the public read access policy for your Cellar bucket ([documentation](https://www.clever-cloud.com/developers/doc/addons/cellar/#public-bucket-policy)) :
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::<bucket>"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:PutObjectVersionAcl",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::<bucket>/*"
        },
        {
            "Sid": "PublicReadAccess",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::<bucket>/*",
            "Principal": "*"
        }
    ]
}
```

> 💡 **Note**: These environment variables allow Ghost to connect to your email service automatically.  
> For more details and supported options, see the [official Ghost SMTP configuration docs](https://ghost.org/docs/config/#mail).

### 8. Deploy on Clever Cloud

Initialize git, add files and push:
```sh
git add clevercloud.sh package.json config.production.json content
git commit -m "Initial commit"
git remote add clever <CLEVER_GIT_URL>
git push
```

## More information

For a small blog, you can use XS or S Node.js plan.