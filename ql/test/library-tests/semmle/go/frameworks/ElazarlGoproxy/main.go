//go:generate depstubber -vendor github.com/elazarl/goproxy ProxyCtx NewResponse,TextResponse,AlwaysReject,ContentTypeText,ContentTypeHtml,ReqHostMatches

package main

import (
	"fmt"
	"net/http"

	"github.com/elazarl/goproxy"
)

func handler(r *http.Request, ctx *goproxy.ProxyCtx) (*http.Request, *http.Response) {
	data := ctx.UserData // $ untrustedflowsource="selection of UserData"

	// note no content type result here because we don't seem to extract the value of `ContentTypeHtml`
	return r, goproxy.NewResponse(r, goproxy.ContentTypeHtml, http.StatusForbidden, fmt.Sprintf("<body>Bad request: %v</body>", data)) // $ headerwrite=status:403
}

func handler1(r *http.Request, ctx *goproxy.ProxyCtx) (*http.Request, *http.Response) {
	ctx.Logf("test")   // $ logger="test"
	ctx.Warnf("test1") // $ logger="test1"

	return r, goproxy.TextResponse(r, "Hello!") // $ headerwrite=status:200 headerwrite=content-type:text/plain
}

func main() {

}
