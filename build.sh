#!/usr/bin/env bash

# Building web-application before containers
# instead of rm -rf
rm -rf target
mkdir target
mkdir target/reflectcal
git clone https://github.com/reflectcal/reflectcal target/reflectcal
cd target/reflectcal
npm install
grunt build --dev
cd ../..

# Building web server
mkdir target/web-server-container
git clone https://github.com/reflectcal/web-server-container target/web-server-container
cp -r target/reflectcal/build/static target/web-server-container/src/
cp ~/.ssh/id_rsa_cont.pub target/web-server-container/id_rsa_cont.pub
docker buildx build --platform=linux/amd64 --tag ghcr.io/reflectcal/web-server-container:1.0.5 target/web-server-container --push --load

# Building app server
mkdir target/app-server-container
git clone https://github.com/reflectcal/app-server-container target/app-server-container
cp -r target/reflectcal/build/app target/app-server-container/src/
cp -r target/reflectcal/build/logs target/app-server-container/src/
cp target/reflectcal/build/app.js target/app-server-container/src/
cp target/reflectcal/build/package.json target/app-server-container/src/
cp ~/.ssh/id_rsa_cont.pub target/app-server-container/id_rsa_cont.pub
docker buildx build --platform=linux/amd64 --tag ghcr.io/reflectcal/app-server-container:1.0.9 target/app-server-container --push --load

# Building mailer daemon
mkdir target/reflectcal-mailer
git clone https://github.com/reflectcal/reflectcal-mailer target/reflectcal-mailer
mkdir target/mail-daemon-container
git clone https://github.com/reflectcal/mail-daemon-container target/mail-daemon-container

cd target/reflectcal-mailer
npm install
gulp babel
cd ../..

cp -r target/reflectcal-mailer/js target/mail-daemon-container/src/
cp -r target/reflectcal-mailer/src target/mail-daemon-container/src/
cp -r target/reflectcal-mailer/templates target/mail-daemon-container/src/
cp -r target/reflectcal-mailer/logs target/mail-daemon-container/src/
cp target/reflectcal-mailer/package.json target/mail-daemon-container/src/

cp ~/.ssh/id_rsa_cont.pub target/mail-daemon-container/id_rsa_cont.pub
docker buildx build --platform=linux/amd64 --tag ghcr.io/reflectcal/mail-daemon-container:1.0.2 target/mail-daemon-container --push --load

