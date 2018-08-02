#!/usr/bin/env bash

set -e

cd ./opt

curl -O https://storage.googleapis.com/twsg-data-eng-bootcamp-data/data.zip
unzip data.zip -d .. > /dev/null

cd ..
rm -rf __MACOSX
