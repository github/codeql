# Tunnel

[![build status](https://img.shields.io/github/workflow/status/kataras/tunnel/CI/master?style=for-the-badge)](https://github.com/kataras/tunnel/actions) [![report card](https://img.shields.io/badge/report%20card-a%2B-ff3333.svg?style=for-the-badge)](https://goreportcard.com/report/github.com/kataras/tunnel) [![godocs](https://img.shields.io/badge/go-%20docs-488AC7.svg?style=for-the-badge)](https://godoc.org/github.com/kataras/tunnel)

Public URLs for exposing your local web server using [ngrok's API](https://ngrok.com/).

## Installation

The only requirement is the [Go Programming Language](https://golang.org/dl).

```sh
$ go get github.com/kataras/tunnel@latest
```

## Getting Started

First of all, navigate to <https://ngrok.com/>, create an [account](https://dashboard.ngrok.com/signup) and [download](https://dashboard.ngrok.com/get-started/setup) ngrok. Extract the downloaded zip file anywhere you like and _optionally_ add it to your _PATH_ or _NGROK_ system environment variable. Test if installation successfully completed by running the following command:

```sh
$ ngrok version
```

Import the package:

```go
package main

import "github.com/kataras/tunnel"
```

Start a new local http Server and expose it to the internet using **just a single new line of code**:

```go
func main() {
    // [...http.HandleFunc]

    srv := &http.Server{Addr: ":8080"}
    // 1 LOC:
    go fmt.Printf("• Public Address: %s\n", tunnel.MustStart(tunnel.WithServers(srv)))
    //
    srv.ListenAndServe()
}
```

OR

```go
config := tunnel.Configuration{
    // AuthToken: "<YOUR_AUTHTOKEN>",
    // Bin: "C:/ngrok.exe",
    // WebInterface: "http://127.0.0.1:4040",
    // Region: "eu",
    Tunnels: []tunnel.Tunnel{
        {Name: "my-app", Addr: ":8080"},
    },
}
publicAddrs := tunnel.MustStart(config)
fmt.Printf("• Public Address: %s\n", publicAddrs)
```

Example output:

```sh
• Public Address: https://ef02b1377b65.ngrok.io
```

> The [Web Interface](https://ngrok.com/docs#inspect) is also available.

Please navigate through [_examples](_examples) directory for more.

## License

This software is licensed under the [MIT License](LICENSE).
