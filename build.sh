#!/bin/bash
xcaddy build \
    --with github.com/cvhome-saas/caddy-storeidlookup
docker build -t saas-gateway -f Dockerfile .