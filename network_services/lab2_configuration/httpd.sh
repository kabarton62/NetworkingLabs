#!/bin/bash

echo "running httpd.sh"
python3 -m http.server 80 &> /dev/null & pid=$!
echo "httpd.sh complete, verifying that TCP 80 is listening"
netstat -antp
