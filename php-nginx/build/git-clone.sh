#!/usr/bin/env bash

if [ "" != "$GIT_DEST" ]; then
    mkdir -p "$GIT_DEST"
fi

if [ "" != "$GIT_CLONE" ]; then
    git clone "$GIT_CLONE" "$GIT_DEST"
    cd "$GIT_DEST"
    if [ -f "$GIT_DEST/composer.lock" ]; then
        HOME=/root composer install --no-ansi --no-interaction --optimize-autoloader
    fi
fi