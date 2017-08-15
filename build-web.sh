#!/usr/bin/env bash
cd ./build
git clone https://github.com/reflectcal/reflectcal
cd ./reflectcal
grunt build
cd ..

git clone https://github.com/reflectcal/web-server-container
docker build web-server-container

git clone https://github.com/reflectcal/app-server-container
docker build app-server-container

