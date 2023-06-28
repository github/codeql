#!/bin/sh -eux
CGO_ENABLED=0 go test "$@"
CGO_ENABLED=0 go test -tags cgosqlite "$@"
CGO_ENABLED=1 go test "$@"
CGO_ENABLED=1 go test -tags cgosqlite "$@"

set +x && export PATH="$(go env GOROOT)/misc/wasm:$PATH" && set -x
GOOS=js GOARCH=wasm go test
