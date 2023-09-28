package main

//go:generate depstubber -vendor  "github.com/valyala/fasthttp" Args,Client,Cookie,FS,HostClient,LBClient,PathRewriteFunc,Request,RequestCtx,RequestHandler,RequestHeader,Response,ResponseHeader,Server,TCPDialer,URI,LBClient,PipelineClient AcquireURI,Serve,DialDualStack,Dial,DialTimeout,DialDualStackTimeout,Get,GetDeadline,GetTimeout,Post,Do,DoRedirects,AppendHTMLEscapeBytes,AppendHTMLEscape,AppendQuotedArg,ServeFileBytesUncompressed,ServeFileBytes,ServeFileUncompressed,ServeFile,SaveMultipartFile,DoTimeout,DoDeadline
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
	fasthttp.Do(req, res)                      // $ req=req
	fasthttp.DoRedirects(req, res, 2)          // $ req=req
	fasthttp.DoDeadline(req, res, time.Time{}) // $ req=req
	fasthttp.DoTimeout(req, res, 5)            // $ req=req

	// additional steps
	uri.SetHost("UserControlled.com:80")              // $ URI=uri
	uri.SetHostBytes([]byte("UserControlled.com:80")) // $ URI=uri
	uri.Update("http://httpbin.org/ip")               // $ URI=uri
	uri.UpdateBytes([]byte("http://httpbin.org/ip"))  // $ URI=uri
	uri.Parse(nil, []byte("http://httpbin.org/ip"))   // $ URI=uri
	uri.CopyTo(uri2)                                  // $ URI=uri

	req.SetHost("UserControlled.com:80")                         // $ req=req
	req.SetHostBytes([]byte("UserControlled.com:80"))            // $ req=req
	req.SetRequestURI("https://UserControlled.com")              // $ req=req// $ req=req
	req.SetRequestURIBytes([]byte("https://UserControlled.com")) // $ req=req
	req.SetURI(uri)                                              // $ req=req  URI=uri

	hostClient := &fasthttp.HostClient{
		Addr: "localhost:8080",
	}
	hostClient.Get(resByte, "http://127.0.0.1:8909")
	hostClient.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	hostClient.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	hostClient.Post(resByte, "http://127.0.0.1:8909", nil)
	hostClient.Do(req, res)                      // $ req=req
	hostClient.DoDeadline(req, res, time.Time{}) // $ req=req
	hostClient.DoRedirects(req, res, 2)          // $ req=req
	hostClient.DoTimeout(req, res, 5)            // $ req=req

	var lbclient fasthttp.LBClient
	lbclient.Clients = append(lbclient.Clients, hostClient)
	lbclient.Do(req, res)                      // $ req=req
	lbclient.DoDeadline(req, res, time.Time{}) // $ req=req
	lbclient.DoTimeout(req, res, 5)            // $ req=req

	client := fasthttp.Client{}
	client.Get(resByte, "http://127.0.0.1:8909")
	client.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{})
	client.GetTimeout(resByte, "http://127.0.0.1:8909", 5)
	client.Post(resByte, "http://127.0.0.1:8909", nil)
	client.Do(req, res)                      // $ req=req
	client.DoDeadline(req, res, time.Time{}) // $ req=req
	client.DoRedirects(req, res, 2)          // $ req=req
	client.DoTimeout(req, res, 5)            // $ req=req

	pipelineClient := fasthttp.PipelineClient{}
	pipelineClient.Do(req, res)                      // $ req=req
	pipelineClient.DoDeadline(req, res, time.Time{}) // $ req=req
	pipelineClient.DoTimeout(req, res, 5)            // $ req=req

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

		// Response methods
		// Xss Sinks Related method
		requestCtx.Response.AppendBody([]byte("user Controlled"))
		requestCtx.Response.AppendBodyString("user Controlled")
		rspWriter := requestCtx.Response.BodyWriter()
		rspWriter.Write([]byte("XSS"))
		requestCtx.Response.SetBody([]byte("user Controlled"))
		requestCtx.Response.SetBodyString("user Controlled")
		requestCtx.Response.SetBodyRaw([]byte("user Controlled"))
		requestCtx.Response.SetBodyStream(dstReader, 100)
		// mostly related to header writers
		requestCtx.Response.Header.Set("Content-Type", "")
		requestCtx.Response.Header.Add("Content-Type", "")
		requestCtx.Response.Header.SetContentTypeBytes([]byte(""))
		requestCtx.Response.Header.SetContentType("")
		requestCtx.Success("", []byte("body"))
		requestCtx.SuccessString("", "body")
		requestCtx.SetContentType("")
		requestCtx.SetContentTypeBytes([]byte(""))

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
