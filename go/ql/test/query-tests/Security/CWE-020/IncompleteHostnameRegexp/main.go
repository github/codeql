//go:generate depstubber -vendor github.com/elazarl/goproxy ProxyCtx NewProxyHttpServer,NewResponse,AlwaysReject,ContentTypeText,ReqHostMatches

package main

import (
	"github.com/elazarl/goproxy"
	"net/http"
	"regexp"
	"time"
)

func Match(notARegex string) bool {
	return notARegex != ""
}

func stdlibreject(w http.ResponseWriter, r *http.Request) {
	if matched, _ := regexp.MatchString(`test.github.com`, r.URL.String()); matched {
		http.Error(w, "Bad request!", http.StatusBadRequest)
	}
}

func sometimesReject(req *http.Request, ctx *goproxy.ProxyCtx) (*http.Request, *http.Response) {
	if h, _, _ := time.Now().Clock(); h >= 8 && h <= 17 {
		return req, goproxy.NewResponse(req, goproxy.ContentTypeText, http.StatusForbidden, "Bad request!")
	}
	return req, nil
}

func reject(req *http.Request, ctx *goproxy.ProxyCtx) (*http.Request, *http.Response) {
	return req, goproxy.NewResponse(req, goproxy.ContentTypeText, http.StatusForbidden, "Bad request!")
}

func proxy() {
	proxy := goproxy.NewProxyHttpServer()
	proxy.OnRequest(goproxy.ReqHostMatches(regexp.MustCompile("^test.github.com$"))).
		HandleConnect(goproxy.AlwaysReject) // OK (rejecting all requests)
	proxy.OnRequest(goproxy.ReqHostMatches(regexp.MustCompile("^test1.github.com$"))).
		DoFunc(reject) // OK (rejecting all requests)
	proxy.OnRequest(goproxy.ReqHostMatches(regexp.MustCompile("^test2.github.com$"))).
		DoFunc(sometimesReject) // NOT OK (sometimes accepts requests)
}

func main() {
	regexp.Match(`https://www.example.com`, []byte(""))   // NOT OK
	regexp.Match(`https://www\.example\.com`, []byte("")) // OK
}
