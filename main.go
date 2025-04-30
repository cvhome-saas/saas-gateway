package main

import (
    _ "github.com/caddyserver/caddy/v2/modules/standard"
    _ "github.com/cvhome-saas/caddy-storeidlookup"
    "github.com/caddyserver/caddy/v2/cmd"
)

func main() {
    cmd.Main()
}