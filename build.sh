#!/bin/bash
xcaddy version
xcaddy build \
    --with github.com/cvhome-saas/certmagic-s3\
    --with github.com/cvhome-saas/caddy-domainlookup
./caddy version    
docker build -t saas-gateway -f Dockerfile .