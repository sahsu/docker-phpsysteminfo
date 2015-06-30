# PHP-Nginx 

This creates a Docker container running Nginx and PHP-FPM on 
[Alpine Linux](https://github.com/gliderlabs/docker-alpine).

### Critical Files

If you'd like to override any of these files, you can volume-mount over them

### Expected file structure

Websites/www.example.com/.config/nginx.conf (optional. provide a custom nginx "server{}" block)
Websites/www.example.com/web/index.php
Websites/www.example.com/

### Example Usage:

    docker run --rm -it \
        -p 8888:80 \
        -v ~/Websites:/var/www \
        stevepacker/php-nginx-alpine
