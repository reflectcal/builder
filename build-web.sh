#!/usr/bin/env bash

# instead of rm -rf
#mv -f target/ /tmp/.
#mkdir target
#mkdir target/reflectcal
#git clone https://github.com/reflectcal/reflectcal target/reflectcal
#cd target/reflectcal
#npm install
#grunt build --dev
#cd ../..

#mkdir target/web-server-container
#git clone https://github.com/reflectcal/web-server-container target/web-server-container
#сp target/reflectcal/build/static/* target/web-server-container/src/
#docker build web-server-container

#mkdir target/app-server-container
#git clone https://github.com/reflectcal/app-server-container target/app-server-container
cp -r target/reflectcal/build/app target/app-server-container/src/
cp -r target/reflectcal/build/logs target/app-server-container/src/
cp -r target/reflectcal/build/app.js target/app-server-container/src/
cp -r target/reflectcal/build/package.json target/app-server-container/src/

docker build --tag reflectcal/app-server:latest target/app-server-container

