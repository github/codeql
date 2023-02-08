package main

//go:generate depstubber -vendor github.com/sirupsen/logrus Fields,Logger,JSONFormatter,TextFormatter SetFormatter,StandardLogger,WithFields
//go:generate depstubber -vendor github.com/elazarl/goproxy ProxyCtx ""

import (
	"net/http"

	"github.com/elazarl/goproxy"
	"github.com/sirupsen/logrus"
)

func initLogger(useJSON bool) {
	if useJSON {
		logrus.SetFormatter(&logrus.JSONFormatter{})
	}
}

func logUserData(req *http.Request, ctx *goproxy.ProxyCtx) {
	username := req.URL.Query()["username"][0]
	logrus.WithFields(logrus.Fields{ // $ hasTaintFlow="map literal"
		"USERNAME": username,
	})
}
