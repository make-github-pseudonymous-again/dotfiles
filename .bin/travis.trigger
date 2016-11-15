#!/usr/bin/env sh

org=$1 && shift
repo=$1 && shift
branch=${1:-master} && shift
TRAVIS_TOKEN="$(travis token | cat)"

body="{
    \"request\": {
        \"branch\": \"${branch}\"
    }
}"

curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token $TRAVIS_TOKEN" \
    -d "$body" \
    "https://api.travis-ci.org/repo/${org}%2F${repo}/requests"
