# Use this image to build the executable
FROM golang:1.18-alpine AS build

WORKDIR /go/src/github.com/tdewolff/minify
COPY . /go/src/github.com/tdewolff/minify/

RUN apk add --no-cache git ca-certificates make bash
RUN /usr/bin/env bash -c make install


# Final image containing the executable from the previous step
FROM alpine:3

COPY --from=build /go/bin/minify /usr/bin/minify
COPY "containerfiles/container-entrypoint.sh" "/init.sh"

ENTRYPOINT ["/init.sh"]
