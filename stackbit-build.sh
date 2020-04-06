#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e8b7aa97cbfe70012b4122a/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e8b7aa97cbfe70012b4122a
curl -s -X POST https://api.stackbit.com/project/5e8b7aa97cbfe70012b4122a/webhook/build/ssgbuild > /dev/null
hugo
wait

curl -s -X POST https://api.stackbit.com/project/5e8b7aa97cbfe70012b4122a/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
