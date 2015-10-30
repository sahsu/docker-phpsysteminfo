#!/usr/bin/php
<?php
const BASEDIR = '/webroot';

$output     = file_get_contents("/root/build/nginx.conf");

$sites      = glob(BASEDIR . "/*", GLOB_ONLYDIR);
$siteOutput = '';
foreach ($sites as $dir) {
    if (file_exists("$dir/.config/nginx.conf")) {
        $output .= file_get_contents("$dir/.config/nginx.conf");
        continue;
    }

    $siteOutput .= siteConfig($dir);
}
echo str_replace(
    [
        '{{SERVERS}}',
    ],
    [
        $siteOutput,
    ],
    $output
);

function siteConfig($baseDir)
{
    $config = <<<'NGINX'
    server {
      listen 80;

      root  {{BASEDIR}};
      index index.php;

      {{SSL}}

      server_name {{SERVERNAME}};

      location = /robots.txt {
          allow all;
          log_not_found off;
      }

      location / {
          try_files $uri $uri/ /index.php;
      }

      location ~ \.php(?:$|/) {
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          include fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param PATH_INFO $fastcgi_path_info;
          fastcgi_pass php-fpm;
      }
  }
NGINX;

    $webDir = $baseDir;
    foreach (['web', 'www', 'html', 'htdocs'] as $subDir) {
        $subDir = "$baseDir/$subDir";
        if (is_dir($subDir) && file_exists($subDir)) {
            $webDir = $subDir;
            break;
        }
    }

    return str_replace(
        [
            '{{BASEDIR}}',
            '{{SERVERNAME}}',
            '{{SSL}}',
        ],
        [
            $webDir,
            basename($baseDir),
            '',
        ],
        $config
    );
}

function buildSsl($baseDir)
{
    $password = uniqid(true);
    $bashCode = <<<'BASH'
# Defined in ENV variables, or use these defaults
COUNTRY=${COUNTRY:-"US"}
STATE=${STATE:-"Oregon"}
CITY=${CITY:-"Boring"}
DOMAIN=${DOMAIN:-"example.com"}
SSL_PASSWD=${SSL_PASSWD:-"Y8gkrxDZErQQAp4bpWI"}

# Generates SSL files (CSR, KEY, and CRT)
# $1 string filename prefix to SSL files; extensions are appended
gen_ssl () {
mkdir -p /etc/nginx/ssl/
cd /etc/nginx/ssl/

openssl genrsa -des3 -passout pass:${SSL_PASSWD} -out server.pass.key 2048
openssl rsa -passin pass:${SSL_PASSWD} -in server.pass.key -out "server.key"
rm server.pass.key
openssl req -new -key "server.key" -out "server.csr" \
-subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=$1/OU=IT Department/CN=*.$1"
openssl x509 -req -days 365 -in "server.csr" -signkey "server.key" -out "server.crt"
}

#if [ ! -f /etc/nginx/ssl/server.crt ]; then
#    gen_ssl "$DOMAIN"
#fi
BASH;

}