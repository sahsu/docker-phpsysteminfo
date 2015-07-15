#!/bin/sh

cd $HOME

#1. Git clone the repo (use REPO_URL env variable for this) to a workspace directory.
git clone $REPO_URL project

#2. Git checkout appropriate branch (use REPO_BRANCH to use a branch other than "master")
cd project
if ["" -ne "$REPO_BRANCH"]; then
    git checkout "$REPO_BRANCH"
fi

#3. Change to the workspace directory (use REPO_PATH as a relative path to the workspace directory to change this)
if ["" -ne "$REPO_PATH"]; then
    cd "$REPO_PATH"
fi

#4. Docker build the repo (use DOCKER_TAG env variable)
docker build -t "$DOCKER_TAG" .

#5. Docker push
docker push "$DOCKER_TAG"