#!/bin/bash -v
aws s3 cp s3://my-tf-test-bucket-erbay/index.html index.html

chmod 755 index.html
cp index.html /var/www/html/index.html
service nginx restart