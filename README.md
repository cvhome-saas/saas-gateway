# SaaS Gateway

This project provides a Caddy v2-based reverse proxy gateway specifically designed for multi-tenant SaaS applications.
It leverages custom Caddy plugins to handle dynamic routing based on domain names and uses AWS S3 for distributed TLS
certificate storage.

## Overview

The gateway acts as the primary entry point for customer traffic. Its main responsibilities are:

1. **Automatic HTTPS:** Provisioning and renewing TLS certificates automatically using Let's Encrypt (or other ACME
   CAs).
2. **Distributed Certificate Storage:** Storing ACME TLS certificates and related assets in an AWS S3 bucket using the
   `certmagic-s3` plugin. This allows the gateway instances to be stateless and scale horizontally without certificate
   conflicts.
3. **Dynamic Tenant Routing:** Using the custom `caddy-domainlookup` plugin to query an external API based on the
   incoming request's domain name. This lookup typically returns tenant-specific information (like a Tenant ID), which
   is then injected as request headers before proxying the request to the appropriate backend service.

## Features

* Powered by **Caddy v2** - Modern, powerful, and easy-to-configure web server.
* **Automatic HTTPS** via ACME (Let's Encrypt).
* **Stateless Certificate Management** using AWS S3 via `techknowlogick/certmagic-s3`.
* **Domain-to-Tenant Mapping** via the custom `cvhome-saas/caddy-domainlookup` plugin.
* **Containerized** for easy deployment (built via `build.sh`).

## Plugins Used

* **`github.com/techknowlogick/certmagic-s3`**: Enables storing Caddy's certificate data (managed by CertMagic) in an
  AWS S3 bucket. Essential for running multiple instances of the gateway behind a load balancer.
* **`github.com/cvhome-saas/caddy-domainlookup`**: A custom plugin developed for this gateway.
    * It intercepts incoming requests.
    * Extracts the domain name (e.g., `customer-a.saas.com`).
    * Calls a configured external API endpoint (`lookup_url` in the Caddyfile) with the domain.
    * Expects the API to return a JSON object (`map[string]string`).
    * Adds the key-value pairs from the JSON response as headers to the request (e.g., `X-Tenant-ID: tenant-123`).
    * Passes the modified request to the next handler (typically `reverse_proxy`).

## Prerequisites

* **Go** (version 1.21+ recommended) - Required for building Caddy with custom plugins using `xcaddy`.
* **`xcaddy`**: The Caddy build tool. Install via:
  ```bash
      go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
  ```
* **Docker**: Required for building the container image via build.sh.
* **AWS S3 Bucket**: An S3 bucket must exist to store the certificates.
* **AWS Credentials**: The environment where Caddy runs needs AWS credentials configured (e.g., via environment
  variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, or an IAM instance profile) with permissions to
  read/write to the specified S3 bucket.
* **Tenant Lookup API**: An HTTP API endpoint that the caddy-domainlookup plugin can query to get tenant information
  based on a domain.
  example `http://localhost:8080/public/lookup-by-domain`