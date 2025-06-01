#!/bin/bash
xcaddy build \
    --with github.com/cvhome-saas/caddy-domainlookup\
    --with github.com/cvhome-saas/certmagic-s3
docker build -t saas-gateway -f Dockerfile .