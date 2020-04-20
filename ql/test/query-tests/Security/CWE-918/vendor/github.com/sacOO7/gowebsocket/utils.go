package gowebsocket

import (
	"net/http"
	"net/url"
	"log"
)

func BuildProxy(Url string) func(*http.Request) (*url.URL, error) {
	uProxy, err := url.Parse(Url)
	if err != nil {
		log.Fatal("Error while parsing url ", err)
	}
	return http.ProxyURL(uProxy)
}
