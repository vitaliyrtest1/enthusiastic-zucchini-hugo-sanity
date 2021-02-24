#!/usr/bin/env bash

set -e
set -o pipefail
set -v

echo "stackbit-build.sh: start build"

# get the first commit hash and run studio-build.js, it will install and deploy sanity studio only if needed
# to optimize the build time, studio-build.js runs in background in parallel to site build command
initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

# fetch data from CMS through stackbit-pull
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://vitaliy-stackbit.ngrok.io/pull/6036671aaa49e034ef7edb15

# build site
hugo

# wait for studio-build.js
wait

echo "stackbit-build.sh: finished build"
