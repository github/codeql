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
	res := &fasthttp.Response{}
	req := &fasthttp.Request{}
	uri := fasthttp.AcquireURI()
	uri2 := fasthttp.AcquireURI()
	fasthttp.Get(resByte, "http://127.0.0.1:8909")
	fasthttp.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	fasthttp.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	fasthttp.Post(resByte, "http://127.0.0.1:8909", nil)
	log.Println(string(resByte))
	fasthttp.Do(req, res)
	fasthttp.DoRedirects(req, res, 2)
	fasthttp.DoDeadline(req, res, time.Time{})
	fasthttp.DoTimeout(req, res, 5)

	// additional steps
	uri.SetHost("UserControlled.com:80")
	uri.SetHostBytes([]byte("UserControlled.com:80"))
	uri.Update("http://httpbin.org/ip")
	uri.UpdateBytes([]byte("http://httpbin.org/ip"))
	uri.Parse(nil, []byte("http://httpbin.org/ip"))
	uri.CopyTo(uri2)

	req.SetHost("UserControlled.com:80")
	req.SetHostBytes([]byte("UserControlled.com:80"))
	req.SetRequestURI("https://UserControlled.com")
	req.SetRequestURIBytes([]byte("https://UserControlled.com"))
	req.SetURI(uri)

	hostClient := &fasthttp.HostClient{
		Addr: "localhost:8080",
	}
	hostClient.Get(resByte, "http://127.0.0.1:8909")
	hostClient.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	hostClient.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	hostClient.Post(resByte, "http://127.0.0.1:8909", nil)
	hostClient.Do(req, res)
	hostClient.DoDeadline(req, res, time.Time{})
	hostClient.DoRedirects(req, res, 2)
	hostClient.DoTimeout(req, res, 5)

	var lbclient fasthttp.LBClient
	lbclient.Clients = append(lbclient.Clients, hostClient)
	lbclient.Do(req, res)
	lbclient.DoDeadline(req, res, time.Time{})
	lbclient.DoTimeout(req, res, 5)

	client := fasthttp.Client{}
	client.Get(resByte, "http://127.0.0.1:8909")
	client.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	client.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	client.Post(resByte, "http://127.0.0.1:8909", nil)
	client.Do(req, res)
	client.DoDeadline(req, res, time.Time{})
	client.DoRedirects(req, res, 2)
	client.DoTimeout(req, res, 5)

	pipelineClient := fasthttp.PipelineClient{}
	pipelineClient.Do(req, res)
	pipelineClient.DoDeadline(req, res, time.Time{})
	pipelineClient.DoTimeout(req, res, 5)

	tcpDialer := fasthttp.TCPDialer{}
	tcpDialer.Dial("127.0.0.1:8909")
	tcpDialer.DialTimeout("127.0.0.1:8909", 5)
	tcpDialer.DialDualStack("127.0.0.1:8909")
	tcpDialer.DialDualStackTimeout("127.0.0.1:8909", 5)
}

func main() {
	fasthttpServer()
	fasthttpClient()
}

func fasthttpServer() {
	ln, err := net.Listen("tcp4", "127.0.0.1:8080")
	if err != nil {
		log.Fatalf("error in net.Listen: %v", err)
	}
	requestHandler := func(requestCtx *fasthttp.RequestCtx) {
		filePath := requestCtx.QueryArgs().Peek("filePath")
		// File System Access
		_ = requestCtx.Response.SendFile(string(filePath))
		requestCtx.SendFile(string(filePath))
		requestCtx.SendFileBytes(filePath)
		fileHeader, _ := requestCtx.FormFile("file")
		_ = fasthttp.SaveMultipartFile(fileHeader, string(filePath))
		fasthttp.ServeFile(requestCtx, string(filePath))
		fasthttp.ServeFileUncompressed(requestCtx, string(filePath))
		fasthttp.ServeFileBytes(requestCtx, filePath)
		fasthttp.ServeFileBytesUncompressed(requestCtx, filePath)

		dstWriter := &bufio.Writer{}
		dstReader := &bufio.Reader{}
		// user controlled methods as source
		requestHeader := &fasthttp.RequestHeader{}
		requestCtx.Request.Header.CopyTo(requestHeader)
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
		// requestCtx.MultipartForm()
		requestCtx.URI().Path()
		requestCtx.URI().PathOriginal()
		newURI := &fasthttp.URI{}
		requestCtx.URI().CopyTo(newURI)
		requestCtx.URI().FullURI()
		requestCtx.URI().LastPathSegment()
		requestCtx.URI().QueryString()
		requestCtx.URI().String()
		requestCtx.URI().WriteTo(dstWriter)

		newArgs := &fasthttp.Args{}
		//or requestCtx.PostArgs()
		requestCtx.URI().QueryArgs().CopyTo(newArgs)
		requestCtx.URI().QueryArgs().Peek("arg1")
		requestCtx.URI().QueryArgs().PeekBytes([]byte("arg1"))
		requestCtx.URI().QueryArgs().PeekMulti("arg1")
		requestCtx.URI().QueryArgs().PeekMultiBytes([]byte("arg1"))
		requestCtx.URI().QueryArgs().QueryString()
		requestCtx.URI().QueryArgs().String()
		requestCtx.URI().QueryArgs().WriteTo(dstWriter)
		// not sure what is the best way to write query for following
		//requestCtx.URI().QueryArgs().VisitAll(type func(,))

		requestCtx.Path()
		// multipart.Form is already implemented
		// requestCtx.FormFile("FileName")
		// requestCtx.FormValue("ValueName")
		requestCtx.Referer()
		requestCtx.PostBody()
		requestCtx.RequestBodyStream()
		requestCtx.RequestURI()
		requestCtx.UserAgent()
		requestCtx.Host()

		requestCtx.Request.Host()
		requestCtx.Request.Body()
		requestCtx.Request.RequestURI()
		requestCtx.Request.BodyGunzip()
		requestCtx.Request.BodyInflate()
		requestCtx.Request.BodyUnbrotli()
		requestCtx.Request.BodyStream()
		requestCtx.Request.BodyWriteTo(dstWriter)
		requestCtx.Request.WriteTo(dstWriter)
		requestCtx.Request.BodyUncompressed()
		requestCtx.Request.ReadBody(dstReader, 100, 1000)
		requestCtx.Request.ReadLimitBody(dstReader, 100)
		requestCtx.Request.ContinueReadBodyStream(dstReader, 100, true)
		requestCtx.Request.ContinueReadBody(dstReader, 100)
		// not sure what is the best way to write query for following
		//requestCtx.Request.Header.VisitAllCookie()

		// Xss Sinks
		requestCtx.Response.AppendBody([]byte("user Controlled"))
		requestCtx.Response.AppendBodyString("user Controlled")
		rspWriter := requestCtx.Response.BodyWriter()
		rspWriter.Write([]byte("XSS"))
		requestCtx.Response.SetBody([]byte("user Controlled"))
		requestCtx.Response.SetBodyString("user Controlled")
		requestCtx.Response.SetBodyRaw([]byte("user Controlled"))
		requestCtx.Response.SetBodyStream(dstReader, 100)

		// sanitizers
		requestCtx.Response.AppendBody(fasthttp.AppendQuotedArg([]byte(""), []byte("<>\"':()&")))       // %3C%3E%22%27%3A%28%29%26
		requestCtx.Response.AppendBody(fasthttp.AppendHTMLEscape([]byte(""), "<>\"':()&"))              // &lt;&gt;&#34;&#39;:()&amp;
		requestCtx.Response.AppendBody(fasthttp.AppendHTMLEscapeBytes([]byte(""), []byte("<>\"':()&"))) // &lt;&gt;&#34;&#39;:()&amp;

		// open redirect Sinks
		requestCtx.Redirect("https://userControlled.com", 301)
		requestCtx.RedirectBytes([]byte("https://userControlled.com"), 301)
	}
	if err := fasthttp.Serve(ln, requestHandler); err != nil {
		log.Fatalf("error in Serve: %v", err)
	}
}
