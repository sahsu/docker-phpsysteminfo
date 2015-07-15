#!/bin/sh

cd /home/build/

#1. Git clone the repo (use REPO_URL env variable for this) to a workspace directory.
rm -Rf project
git clone $REPO_URL project

#2. Git checkout appropriate branch (use REPO_BRANCH to use a branch other than "master")
cd project
if ["" -ne "$REPO_BRANCH"]; then
    echo "...Changing to branch: $REPO_BRANCH"
    git checkout "$REPO_BRANCH"
fi
git status

#3. Change to the workspace directory (use REPO_PATH as a relative path to the workspace directory to change this)
if ["" -ne "$REPO_PATH"]; then
    echo "...Changing to directory: $REPO_PATH"
    cd "$REPO_PATH"
fi
echo "... CWD: " $(pwd)

#4. Docker build the repo (use DOCKER_TAG env variable)
echo "... docker build -t $DOCKER_TAG ."
docker build -t "$DOCKER_TAG" .

#5. Docker push
echo "... docker push $DOCKER_TAG"
docker push "$DOCKER_TAG"