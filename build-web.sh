#!/usr/bin/env bash

# Building web-application before containers
# instead of rm -rf
mv -f target/ /tmp/.
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
сp target/reflectcal/build/static/* target/web-server-container/src/
docker build --tag reflectcal/web-server:latest target/web-server-container

# Building app server
mkdir target/app-server-container
git clone https://github.com/reflectcal/app-server-container target/app-server-container
cp -r target/reflectcal/build/app target/app-server-container/src/
cp -r target/reflectcal/build/logs target/app-server-container/src/
cp target/reflectcal/build/app.js target/app-server-container/src/
cp target/reflectcal/build/package.json target/app-server-container/src/
cp client_secret_* target/app-server-container/src/

docker build --tag reflectcal/app-server:latest target/app-server-container

# Building mailer daemon
mkdir target/mail-daemon-container
git clone https://github.com/reflectcal/mail-daemon-container target/mail-daemon-container
cp -r target/reflectcal/build/app target/mail-daemon-container/src/
cp -r target/reflectcal/build/logs target/mail-daemon-container/src/
cp target/reflectcal/build/app.js target/mail-daemon-container/src/
cp target/reflectcal/build/package.json target/mail-daemon-container/src/
cp client_secret_* target/mail-daemon-container/src/

docker build --tag reflectcal/app-server:latest target/mail-daemon-container

