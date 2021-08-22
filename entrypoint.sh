#!/bin/sh

set -e

git config --global user.email "noop@github.com"
git config --global url."https://action:${INPUT_TOKEN}@github.com/".insteadOf https://github.com/

cd $INPUT_SOURCE_PATH
flutter packages get

flutter build web --${INPUT_BUILD_MODE} ${INPUT_BUILD_FLAGS}

mkdir pages
cd pages

git clone --branch $INPUT_REPO_BRANCH $INPUT_REPO_URL .
rm -rf $INPUT_DEPLOY_PATH
mkdir $INPUT_DEPLOY_PATH
cp -R ../build/web/* $INPUT_DEPLOY_PATH
git add .
git tag -a "v$INPUT_BUILD_NUMBER" -m "v$INPUT_BUILD_NUMBER" 
git commit -m "Pages $INPUT_BUILD_NUMBER"
git push -f origin HEAD:gh-pages
