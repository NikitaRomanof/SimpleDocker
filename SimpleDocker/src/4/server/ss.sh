#!/bin/bash
gcc hello.c -lfcgi -o hello
spawn-fcgi -a 127.0.0.1 -p 8080 hello
nginx -g "daemon off;"
nginx -s reload
