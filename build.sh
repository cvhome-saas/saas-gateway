#!/bin/bash
xcaddy build \
    --with github.com/cvhome-saas/certmagic-s3\
    --with github.com/cvhome-saas/caddy-domainlookup
docker build -t saas-gateway -f Dockerfile .