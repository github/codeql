package main

//go:generate depstubber -vendor github.com/sirupsen/logrus Fields,Logger,JSONFormatter,TextFormatter SetFormatter,StandardLogger,WithFields
//go:generate depstubber -vendor github.com/elazarl/goproxy ProxyCtx ""

import (
	"net/http"

	"github.com/elazarl/goproxy"
	"github.com/sirupsen/logrus"
)

func main() {
	logrus.SetFormatter(&logrus.TextFormatter{})

	formatter := new(logrus.JSONFormatter)
	logrus.SetFormatter(formatter)

	logger := logrus.StandardLogger()
	logger.SetFormatter(&logrus.JSONFormatter{})
	logger.SetFormatter(formatter)
	logger.Formatter = &logrus.JSONFormatter{}
	logger.Formatter = formatter
}

func logUserData(req *http.Request, ctx *goproxy.ProxyCtx) {
	username := req.URL.Query()["username"][0]
	logrus.WithFields(logrus.Fields{ // $ hasTaintFlow="map literal"
		"USERNAME": username,
	})
}
