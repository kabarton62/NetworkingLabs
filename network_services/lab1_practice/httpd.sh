#!/bin/bash

echo "running httpd.sh"
python3 -m http.server 80 &> /dev/null & pid=$!
echo "httpd.sh complete"
