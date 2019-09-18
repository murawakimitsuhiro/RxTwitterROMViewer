#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
REPO= git remote get-url origin | grep -Po '(?<=github.com/)[^.]*'

if [ -n "$GITHUB_TOKEN" ]
then
  echo "$REPO"
  # github-label-sync --access-token ${GITHUB_TOKEN} --labels ${SCRIPT_DIR}/../github-labels.json ispec-inc/Placy-iOS
else
  echo "Please setup environment variable GITHUB_TOKEN"
fi



