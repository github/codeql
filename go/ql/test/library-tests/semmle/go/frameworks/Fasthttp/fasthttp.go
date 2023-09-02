package main

import (
	"bufio"
	"github.com/valyala/fasthttp"
	"log"
	"net"
	"time"
)

func fasthttpClient() {
	// #SSRF
	response, err := fasthttp.DialDualStack("127.0.0.1:8909")
	response, err = fasthttp.Dial("google.com:80")
	response, err = fasthttp.DialTimeout("google.com:80", 5)
	response, err = fasthttp.DialDualStackTimeout("google.com:80", 5)
	log.Println(err)
	resByte := make([]byte, 1000)
	_, err = response.Read(resByte)
	log.Println(resByte)

	// #SSRF
	fasthttp.Get(resByte, "http://127.0.0.1:8909")
	fasthttp.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	fasthttp.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	fasthttp.Post(resByte, "http://127.0.0.1:8909", nil)
	log.Println(string(resByte))

	// #SSRF
	client := fasthttp.Client{}
	client.Get(resByte, "http://127.0.0.1:8909")
	client.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	client.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	client.Post(resByte, "http://127.0.0.1:8909", nil)

	res := &fasthttp.Response{}
	req := &fasthttp.Request{}
	uri := fasthttp.URI{}
	// additional steps
	uri.SetHost("UserControlled.com:80")
	uri.SetHostBytes([]byte("UserControlled.com:80"))
	req.SetHost("UserControlled.com:80")
	req.SetHostBytes([]byte("UserControlled.com:80"))
	req.SetRequestURI("https://UserControlled.com")
	req.SetRequestURIBytes([]byte("https://UserControlled.com"))
	req.SetURI(&uri)
	fasthttp.Do(req, res)
	fasthttp.DoDeadline(req, res, time.Time{})
	fasthttp.DoTimeout(req, res, 5)
	client.Do(req, res)
	client.DoDeadline(req, res, time.Time{})
	client.DoTimeout(req, res, 5)

	// #SSRF
	tcpDialer := fasthttp.TCPDialer{}
	tcpDialer.Dial("127.0.0.1:8909")
	tcpDialer.DialTimeout("127.0.0.1:8909", 5)
	tcpDialer.DialDualStack("127.0.0.1:8909")
	tcpDialer.DialDualStackTimeout("127.0.0.1:8909", 5)
}

func fasthttpServer() {
	ln, err := net.Listen("tcp4", "127.0.0.1:8080")
	if err != nil {
		log.Fatalf("error in net.Listen: %v", err)
	}
	requestHandler := func(ctx *fasthttp.RequestCtx) {
		filePath := ctx.QueryArgs().Peek("filePath")
		// File System Access
		_ = ctx.Response.SendFile(string(filePath))
		ctx.SendFile(string(filePath))
		ctx.SendFileBytes(filePath)
		fileHeader, _ := ctx.FormFile("file")
		_ = fasthttp.SaveMultipartFile(fileHeader, string(filePath))
		fasthttp.ServeFile(ctx, string(filePath))
		fasthttp.ServeFileUncompressed(ctx, string(filePath))
		fasthttp.ServeFileBytes(ctx, filePath)
		fasthttp.ServeFileBytesUncompressed(ctx, filePath)

		dstWriter := &bufio.Writer{}
		dstReader := &bufio.Reader{}
		// user controlled methods as source
		requestHeader := &fasthttp.RequestHeader{}
		ctx.Request.Header.CopyTo(requestHeader)
		requestHeader.Write(dstWriter)
		requestHeader.Header()
		requestHeader.TrailerHeader()
		requestHeader.String()
		requestHeader.RequestURI()
		requestHeader.Host()
		requestHeader.UserAgent()
		requestHeader.ContentEncoding()
		requestHeader.ContentType()
		requestHeader.Cookie("ACookie")
		requestHeader.CookieBytes([]byte("ACookie"))
		requestHeader.MultipartFormBoundary()
		requestHeader.Peek("AHeaderName")
		requestHeader.PeekAll("AHeaderName")
		requestHeader.PeekBytes([]byte("AHeaderName"))
		requestHeader.PeekKeys()
		requestHeader.PeekTrailerKeys()
		requestHeader.Referer()
		requestHeader.RawHeaders()
		// multipart.Form is already implemented
		//ctx.MultipartForm()
		ctx.URI().Path()
		ctx.URI().PathOriginal()
		newURI := &fasthttp.URI{}
		ctx.URI().CopyTo(newURI)
		ctx.URI().FullURI()
		ctx.URI().LastPathSegment()
		ctx.URI().QueryString()
		ctx.URI().String()
		ctx.URI().WriteTo(dstWriter)

		newArgs := &fasthttp.Args{}
		//or ctx.PostArgs()
		ctx.URI().QueryArgs().CopyTo(newArgs)
		ctx.URI().QueryArgs().Peek("arg1")
		ctx.URI().QueryArgs().PeekBytes([]byte("arg1"))
		ctx.URI().QueryArgs().PeekMulti("arg1")
		ctx.URI().QueryArgs().PeekMultiBytes([]byte("arg1"))
		ctx.URI().QueryArgs().QueryString()
		ctx.URI().QueryArgs().String()
		ctx.URI().QueryArgs().WriteTo(dstWriter)
		// not sure what is the best way to write query for following
		//ctx.URI().QueryArgs().VisitAll(type func(,))

		ctx.Path()
		// multipart.Form is already implemented
		// ctx.FormFile("FileName")
		// ctx.FormValue("ValueName")
		ctx.Referer()
		ctx.PostBody()
		ctx.RequestBodyStream()
		ctx.RequestURI()
		ctx.UserAgent()
		ctx.Host()

		ctx.Request.Host()
		ctx.Request.Body()
		ctx.Request.RequestURI()
		ctx.Request.BodyGunzip()
		ctx.Request.BodyInflate()
		ctx.Request.BodyUnbrotli()
		ctx.Request.BodyStream()
		ctx.Request.BodyWriteTo(dstWriter)
		ctx.Request.WriteTo(dstWriter)
		ctx.Request.BodyUncompressed()
		ctx.Request.ReadBody(dstReader, 100, 1000)
		ctx.Request.ReadLimitBody(dstReader, 100)
		ctx.Request.ContinueReadBodyStream(dstReader, 100, true)
		ctx.Request.ContinueReadBody(dstReader, 100)
		// not sure what is the best way to write query for following
		//ctx.Request.Header.VisitAllCookie()

		// Xss Sinks
		ctx.Response.AppendBody([]byte("user Controlled"))
		ctx.Response.AppendBodyString("user Controlled")
		rspWriter := ctx.Response.BodyWriter()
		rspWriter.Write([]byte("XSS"))
		ctx.Response.SetBody([]byte("user Controlled"))
		ctx.Response.SetBodyString("user Controlled")
		ctx.Response.SetBodyRaw([]byte("user Controlled"))
		ctx.Response.SetBodyStream(dstReader, 100)
		dstByte := []byte("init")
		// sanitizers
		fasthttp.AppendQuotedArg(dstByte, []byte("xsss"))
		fasthttp.AppendHTMLEscape(dstByte, "xss")
		fasthttp.AppendHTMLEscapeBytes(dstByte, []byte("xss"))

		// TODO: unstrusted Remote IP from Header?
		// TODO: open redirect Sinks
		req := &fasthttp.Request{}
		res := &fasthttp.Response{}
		// there are additional steps from other scope
		req.SetRequestURI("https://userControlled.com")
		fasthttp.DoRedirects(req, res, 2)
		ctx.Redirect("https://userControlled.com", 301)
		ctx.RedirectBytes([]byte("https://userControlled.com"), 301)
	}
	if err := fasthttp.Serve(ln, requestHandler); err != nil {
		log.Fatalf("error in Serve: %v", err)
	}
}
