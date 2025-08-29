# Ghost Blog Template on Clever Cloud

This project is a template for a [Ghost blog](https://ghost.org) running on Node.js 20 and deployed on [Clever Cloud](https://clever-cloud.com).

It is based on the [local installation](https://ghost.org/docs/install/local/) of Ghost, as well as its source code on [GitHub](https://github.com/TryGhost/Ghost/).

## What is Ghost?

Ghost is a modern, open-source publishing platform designed for professional bloggers, writers, and content creators. Built with Node.js, it offers a lightweight, fast, and flexible alternative to traditional CMS platforms. 

Ghost provides a clean, distraction-free writing experience, powerful SEO features, and extensive customization options through themes and integrations. It is often used for personal blogs, newsletters, and online publications.

## Prérequis

- **Node.js 20**
- **MySQL**
- **Cellar S3**
- **Ghost-CLI**
- **s3cmd**
- **SMTP server** (example: [MailPace](https://www.clever-cloud.com/developers/doc/addons/mailpace/))
- **Clever Tools CLI** ([documentation](https://www.clever-cloud.com/developers/doc/cli/))
- **Git**

## Installation and configuration

### 1. Initialize your project

Create the project folder and install Ghost locally:
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

### 2. Create and configure node application and addons

Use the [Clever Tools CLI](https://www.clever-cloud.com/developers/doc/cli/install).

Create the Node.js app, MySQL, and Cellar S3 on Clever Cloud:
```sh
# Create application and addons
clever create --type node myblog
clever addon create mysql-addon --plan s_sml myblogsql --link myblog
clever addon create cellar-addon --plan s_sml myblogcellar --link myblog
# Set environment variable
clever env set CC_PRE_BUILD_HOOK "./clevercloud-pre-build-hook.sh"
clever env set CC_PRE_RUN_HOOK "./clevercloud-pre-run-hook.sh"
clever env set CC_POST_BUILD_HOOK "./clevercloud-post-build-hook.sh"
clever env set NODE_ENV "production"
clever env set BUCKET_NAME "testghost" #or another bucket name
# SMTP (example: Mailpace)
clever env set SMTP_FROM "your-email@example.com"
clever env set SMTP_SERVICE "your-mail-service" 
clever env set SMTP_HOST "smtp.yourmail.com"
clever env set SMTP_PORT "587"
clever env set SMTP_SECURE_CONNECTION "true"
clever env set SMTP_USER "your-smtp-username"
clever env set SMTP_PASSWORD "your-smtp-password"
```

> 💡 **Note**: SMTP environment variables allow Ghost to connect to your email service automatically.  
> For more details and supported options, see the [official Ghost SMTP configuration docs](https://ghost.org/docs/config/#mail).

### 3. Configure your Cellar bucket addon

#### 3.1 Create a bucket

1. Go to your Cellar add-on dashboard from the Clever Cloud Console.  
2. Enter a **unique bucket name** (lowercase, no underscores `_`, must be unique per region).  
3. Click **Create bucket**.  
   → Your bucket should now appear in the list.

#### 3.2 Set bucket public read access policy

Ghost needs to serve uploaded images publicly.

To allow this, set the public read access policy on your bucket ([official doc](https://www.clever-cloud.com/developers/doc/addons/cellar/#public-bucket-policy)).

Create a policy.json file:
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
                "s3:GetObject"
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
Replace `<bucket>` with your bucket name in `policy.json` (keep `"Version": "2012-10-17"`).

Download the pre-filled `s3cfg` file from your Cellar add-on dashboard and place it in `~/.s3cfg`.

Then apply the policy:
```sh
s3cmd setpolicy ./policy.json s3://<bucket> -c ~/.s3cfg

```

### 8. Deploy on Clever Cloud

Initialize git, add files and push:
```sh
git add .
git commit -m "Initial commit"
clever deploy
```

## More information

For a small blog, you can use XS or S Node.js plan.