#!/bin/bash
nginx -v

mkdir -p /var/www/test_domain.com/html
chown -R $USER:$USER /var/www/test_domain.com
chmod -R 755 /var/www/test_domain.com

echo '
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Hello!</title>
    </head>

    <body>
        <h1>Hello World!</h1>
        <p>This is a simple paragraph.</p>
    </body>

</html>
' > /var/www/test_domain.com/html/index.html

echo '
server {
listen 80;

root /var/www/test_domain.com/html;
index index.html index.htm index.nginx.debian.html;

server_name test_domain.com www.test_domain.com;
location / {
    try_files $uri $uri/ =404;
    }
}

' > /etc/nginx/sites-available/test_domain.com

ln –s /etc/nginx/sites-available/test_domain.com /etc/nginx/sites-enabled
service nginx restart