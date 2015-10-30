# PHP-Nginx 

This creates a Docker container running Nginx and PHP-FPM on Ubuntu
### Critical Files

If you'd like to override any of these files, you can volume-mount over them

### Expected file structure

/webroot/www.example.com/.config/nginx.conf (optional. provide a custom nginx "server{}" block)
/webroot/www.example.com/web/index.php
/webroot/www.example.com/

### Example Usage:

Development purposes:

    docker run --rm -it \
        -p 8888:80 \
        -v ~/Website:/webroot/www.example.com \
        stevepacker/php-nginx

Release purposes:

    docker run -d \
        --restart=always \
        --name=blog \
        -p 8888:80 \
        -e GIT_CLONE=https://github.com/WordPress/WordPress.git \
        -e GIT_DEST=/webroot/blog.example.com \
        stevepacker/php-nginx-alpine

If the git repo has a "composer.lock" file at its root project directory, this will
run "composer install" before turning the site on.