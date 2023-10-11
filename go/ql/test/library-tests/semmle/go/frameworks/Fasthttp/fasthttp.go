package main

//go:generate depstubber -vendor  "github.com/valyala/fasthttp" Args,Client,Cookie,FS,HostClient,LBClient,PathRewriteFunc,Request,RequestCtx,RequestHandler,RequestHeader,Response,ResponseHeader,Server,TCPDialer,URI,LBClient,PipelineClient AcquireURI,Serve,DialDualStack,Dial,DialTimeout,DialDualStackTimeout,Get,GetDeadline,GetTimeout,Post,Do,DoRedirects,AppendHTMLEscapeBytes,AppendHTMLEscape,AppendQuotedArg,ServeFileBytesUncompressed,ServeFileBytes,ServeFileUncompressed,ServeFile,SaveMultipartFile,DoTimeout,DoDeadline
import (
	"bufio"
	"net"
	"time"

	"github.com/valyala/fasthttp"
)

func fasthttpClient() {
	// #SSRF
	response, _ := fasthttp.DialDualStack("127.0.0.1:8909")
	response, _ = fasthttp.Dial("google.com:80")
	response, _ = fasthttp.DialTimeout("google.com:80", 5)
	response, _ = fasthttp.DialDualStackTimeout("google.com:80", 5)
	resByte := make([]byte, 1000)
	_, _ = response.Read(resByte)

	// #SSRF
	res := &fasthttp.Response{}
	req := &fasthttp.Request{}
	uri := fasthttp.AcquireURI()
	uri2 := fasthttp.AcquireURI()
	fasthttp.Get(resByte, "http://127.0.0.1:8909")                      // $ SSRF="http://127.0.0.1:8909"
	fasthttp.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{}) // $ SSRF="http://127.0.0.1:8909"
	fasthttp.GetTimeout(resByte, "http://127.0.0.1:8909", 5)            // $ SSRF="http://127.0.0.1:8909"
	fasthttp.Post(resByte, "http://127.0.0.1:8909", nil)                // $ SSRF="http://127.0.0.1:8909"
	fasthttp.Do(req, res)                                               // $ req=req
	fasthttp.DoRedirects(req, res, 2)                                   // $ req=req
	fasthttp.DoDeadline(req, res, time.Time{})                          // $ req=req
	fasthttp.DoTimeout(req, res, 5)                                     // $ req=req

	// additional steps
	uri.SetHost("UserControlled.com:80")              // $ URI=uri
	uri.SetHostBytes([]byte("UserControlled.com:80")) // $ URI=uri
	uri.Update("http://httpbin.org/ip")               // $ URI=uri
	uri.UpdateBytes([]byte("http://httpbin.org/ip"))  // $ URI=uri
	uri.Parse(nil, []byte("http://httpbin.org/ip"))   // $ URI=uri
	uri.CopyTo(uri2)                                  // $ URI=uri

	req.SetHost("UserControlled.com:80")                         // $ req=req
	req.SetHostBytes([]byte("UserControlled.com:80"))            // $ req=req
	req.SetRequestURI("https://UserControlled.com")              // $ req=req
	req.SetRequestURIBytes([]byte("https://UserControlled.com")) // $ req=req
	req.SetURI(uri)                                              // $ req=req  URI=uri

	hostClient := &fasthttp.HostClient{
		Addr: "localhost:8080",
	}
	hostClient.Get(resByte, "http://127.0.0.1:8909")                      // $ SSRF="http://127.0.0.1:8909"
	hostClient.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{}) // $ SSRF="http://127.0.0.1:8909"
	hostClient.GetTimeout(resByte, "http://127.0.0.1:8909", 5)            // $ SSRF="http://127.0.0.1:8909"
	hostClient.Post(resByte, "http://127.0.0.1:8909", nil)                // $ SSRF="http://127.0.0.1:8909"
	hostClient.Do(req, res)                                               // $ req=req
	hostClient.DoDeadline(req, res, time.Time{})                          // $ req=req
	hostClient.DoRedirects(req, res, 2)                                   // $ req=req
	hostClient.DoTimeout(req, res, 5)                                     // $ req=req

	var lbclient fasthttp.LBClient
	lbclient.Clients = append(lbclient.Clients, hostClient)
	lbclient.Do(req, res)                      // $ req=req
	lbclient.DoDeadline(req, res, time.Time{}) // $ req=req
	lbclient.DoTimeout(req, res, 5)            // $ req=req

	client := fasthttp.Client{}
	client.Get(resByte, "http://127.0.0.1:8909")                      // $ SSRF="http://127.0.0.1:8909"
	client.GetDeadline(resByte, "http://127.0.0.1:8909", time.Time{}) // $ SSRF="http://127.0.0.1:8909"
	client.GetTimeout(resByte, "http://127.0.0.1:8909", 5)            // $ SSRF="http://127.0.0.1:8909"
	client.Post(resByte, "http://127.0.0.1:8909", nil)                // $ SSRF="http://127.0.0.1:8909"
	client.Do(req, res)                                               // $ req=req SSRF=req
	client.DoDeadline(req, res, time.Time{})                          // $ req=req SSRF=req
	client.DoRedirects(req, res, 2)                                   // $ req=req SSRF=req
	client.DoTimeout(req, res, 5)                                     // $ req=req SSRF=req

	pipelineClient := fasthttp.PipelineClient{}
	pipelineClient.Do(req, res)                      // $ req=req SSRF=req
	pipelineClient.DoDeadline(req, res, time.Time{}) // $ req=req SSRF=req
	pipelineClient.DoTimeout(req, res, 5)            // $ req=req SSRF=req

	tcpDialer := fasthttp.TCPDialer{}
	tcpDialer.Dial("127.0.0.1:8909")                    // $ SSRF="127.0.0.1:8909"
	tcpDialer.DialTimeout("127.0.0.1:8909", 5)          // $ SSRF="127.0.0.1:8909"
	tcpDialer.DialDualStack("127.0.0.1:8909")           // $ SSRF="127.0.0.1:8909"
	tcpDialer.DialDualStackTimeout("127.0.0.1:8909", 5) // $ SSRF="127.0.0.1:8909"
}

func main() {
	fasthttpServer()
	fasthttpClient()
}

func fasthttpServer() {
	ln, _ := net.Listen("tcp4", "127.0.0.1:8080")
	requestHandler := func(requestCtx *fasthttp.RequestCtx) {
		filePath := requestCtx.QueryArgs().Peek("filePath") // $ UntrustedFlowSource='call to Peek'
		// File System Access
		_ = requestCtx.Response.SendFile(string(filePath)) // $ FileSystemAccess=string(filePath)
		requestCtx.SendFile(string(filePath))              // $ FileSystemAccess=string(filePath)
		requestCtx.SendFileBytes(filePath)                 // $ FileSystemAccess=filePath
		fileHeader, _ := requestCtx.FormFile("file")
		_ = fasthttp.SaveMultipartFile(fileHeader, string(filePath)) // $ FileSystemAccess=string(filePath)
		fasthttp.ServeFile(requestCtx, string(filePath))             // $ FileSystemAccess=string(filePath)
		fasthttp.ServeFileUncompressed(requestCtx, string(filePath)) // $ FileSystemAccess=string(filePath)
		fasthttp.ServeFileBytes(requestCtx, filePath)                // $ FileSystemAccess=filePath
		fasthttp.ServeFileBytesUncompressed(requestCtx, filePath)    // $ FileSystemAccess=filePath

		dstWriter := &bufio.Writer{}
		dstReader := &bufio.Reader{}
		// user controlled methods as source
		requestHeader := &fasthttp.RequestHeader{}
		requestCtx.Request.Header.CopyTo(requestHeader) // $ UntrustedFlowSource=requestHeader
		requestHeader.Write(dstWriter)                  // $ UntrustedFlowSource=dstWriter
		requestHeader.Header()                          // $ UntrustedFlowSource=Header
		requestHeader.TrailerHeader()                   // $ UntrustedFlowSource=TrailerHeader
		requestHeader.String()                          // $ UntrustedFlowSource=String
		requestHeader.RequestURI()                      // $ UntrustedFlowSource=RequestURI
		requestHeader.Host()                            // $ UntrustedFlowSource=Host
		requestHeader.UserAgent()                       // $ UntrustedFlowSource=UserAgent
		requestHeader.ContentEncoding()                 // $ UntrustedFlowSource=ContentEncoding
		requestHeader.ContentType()                     // $ UntrustedFlowSource=ContentType
		requestHeader.Cookie("ACookie")                 // $ UntrustedFlowSource=Cookie
		requestHeader.CookieBytes([]byte("ACookie"))    // $ UntrustedFlowSource=CookieBytes
		requestHeader.MultipartFormBoundary()           // $ UntrustedFlowSource=MultipartFormBoundary
		requestHeader.Peek("AHeaderName")               // $ UntrustedFlowSource=Peek
		requestHeader.PeekAll("AHeaderName")            // $ UntrustedFlowSource=PeekAll
		requestHeader.PeekBytes([]byte("AHeaderName"))  // $ UntrustedFlowSource=PeekBytes
		requestHeader.PeekKeys()                        // $ UntrustedFlowSource=PeekKeys
		requestHeader.PeekTrailerKeys()                 // $ UntrustedFlowSource=PeekTrailerKeys
		requestHeader.Referer()                         // $ UntrustedFlowSource=Referer
		requestHeader.RawHeaders()                      // $ UntrustedFlowSource=RawHeaders
		// multipart.Form is already implemented
		// requestCtx.MultipartForm()
		requestCtx.URI().Path()         // $ UntrustedFlowSource=newArgs
		requestCtx.URI().PathOriginal() // $ UntrustedFlowSource=newArgs
		newURI := &fasthttp.URI{}
		requestCtx.URI().CopyTo(newURI)     // $ UntrustedFlowSource=CopyTo
		requestCtx.URI().FullURI()          // $ UntrustedFlowSource=FullURI
		requestCtx.URI().LastPathSegment()  // $ UntrustedFlowSource=LastPathSegment
		requestCtx.URI().QueryString()      // $ UntrustedFlowSource=QueryString
		requestCtx.URI().String()           // $ UntrustedFlowSource=String
		requestCtx.URI().WriteTo(dstWriter) // $ UntrustedFlowSource=WriteTo

		newArgs := &fasthttp.Args{}
		//or requestCtx.PostArgs()
		requestCtx.URI().QueryArgs().CopyTo(newArgs)                // $ UntrustedFlowSource=newArgs
		requestCtx.URI().QueryArgs().Peek("arg1")                   // $ UntrustedFlowSource=Peek
		requestCtx.URI().QueryArgs().PeekBytes([]byte("arg1"))      // $ UntrustedFlowSource=PeekBytes
		requestCtx.URI().QueryArgs().PeekMulti("arg1")              // $ UntrustedFlowSource=PeekMulti
		requestCtx.URI().QueryArgs().PeekMultiBytes([]byte("arg1")) // $ UntrustedFlowSource=PeekMultiBytes
		requestCtx.URI().QueryArgs().QueryString()                  // $ UntrustedFlowSource=QueryString
		requestCtx.URI().QueryArgs().String()                       // $ UntrustedFlowSource=String
		requestCtx.URI().QueryArgs().WriteTo(dstWriter)             // $ UntrustedFlowSource=dstWriter
		// not sure what is the best way to write query for following
		//requestCtx.URI().QueryArgs().VisitAll(type func(,))

		requestCtx.Path()
		// multipart.Form is already implemented
		// requestCtx.FormFile("FileName")
		// requestCtx.FormValue("ValueName")
		requestCtx.Referer()           // $ UntrustedFlowSource=Referer
		requestCtx.PostBody()          // $ UntrustedFlowSource=PostBody
		requestCtx.RequestBodyStream() // $ UntrustedFlowSource=RequestBodyStream
		requestCtx.RequestURI()        // $ UntrustedFlowSource=RequestURI
		requestCtx.UserAgent()         // $ UntrustedFlowSource=UserAgent
		requestCtx.Host()              // $ UntrustedFlowSource=Host

		requestCtx.Request.Host()                                       // $ UntrustedFlowSource=Host
		requestCtx.Request.Body()                                       // $ UntrustedFlowSource=Body
		requestCtx.Request.RequestURI()                                 // $ UntrustedFlowSource=RequestURI
		requestCtx.Request.BodyGunzip()                                 // $ UntrustedFlowSource=BodyGunzip
		requestCtx.Request.BodyInflate()                                // $ UntrustedFlowSource=BodyInflate
		requestCtx.Request.BodyUnbrotli()                               // $ UntrustedFlowSource=BodyUnbrotli
		requestCtx.Request.BodyStream()                                 // $ UntrustedFlowSource=BodyStream
		requestCtx.Request.BodyWriteTo(dstWriter)                       // $ UntrustedFlowSource=dstWriter
		requestCtx.Request.WriteTo(dstWriter)                           // $ UntrustedFlowSource=dstWriter
		requestCtx.Request.BodyUncompressed()                           // $ UntrustedFlowSource=BodyUncompressed
		requestCtx.Request.ReadBody(dstReader, 100, 1000)               // $ UntrustedFlowSource=dstReader
		requestCtx.Request.ReadLimitBody(dstReader, 100)                // $ UntrustedFlowSource=dstReader
		requestCtx.Request.ContinueReadBodyStream(dstReader, 100, true) // $ UntrustedFlowSource=dstReader
		requestCtx.Request.ContinueReadBody(dstReader, 100)             // $ UntrustedFlowSource=dstReader
		// not sure what is the best way to write query for following
		//requestCtx.Request.Header.VisitAllCookie()

		// Response methods
		// Xss Sinks Related method
		requestCtx.Response.AppendBody([]byte("user Controlled")) // $ XSS=[]byte("user Controlled")
		requestCtx.Response.AppendBodyString("user Controlled")   // $ XSS="user Controlled"
		rspWriter := requestCtx.Response.BodyWriter()
		rspWriter.Write([]byte("XSS"))                            // $ XSS=[]byte("XSS")
		requestCtx.Response.SetBody([]byte("user Controlled"))    // $ XSS=[]byte("XSS")
		requestCtx.Response.SetBodyString("user Controlled")      // $ XSS=[]byte("XSS")
		requestCtx.Response.SetBodyRaw([]byte("user Controlled")) // $ XSS=[]byte("XSS")
		requestCtx.Response.SetBodyStream(dstReader, 100)         // $ XSS=[]byte("XSS")
		// mostly related to header writers
		requestCtx.Response.Header.Set("Content-Type", "")
		requestCtx.Response.Header.Add("Content-Type", "")
		requestCtx.Response.Header.SetContentTypeBytes([]byte(""))
		requestCtx.Response.Header.SetContentType("")
		requestCtx.Success("", []byte("body")) // $ XSS=[]byte("body")
		requestCtx.SuccessString("", "body")   // $ XSS="body"
		requestCtx.SetContentType("")
		requestCtx.SetContentTypeBytes([]byte(""))

		// sanitizers
		requestCtx.Response.AppendBody(fasthttp.AppendQuotedArg([]byte(""), []byte("<>\"':()&"))) // $ Sanitizer=AppendBody
		// %3C%3E%22%27%3A%28%29%26
		requestCtx.Response.AppendBody(fasthttp.AppendHTMLEscape([]byte(""), "<>\"':()&")) // $ Sanitizer=AppendBody
		// &lt;&gt;&#34;&#39;:()&amp;
		requestCtx.Response.AppendBody(fasthttp.AppendHTMLEscapeBytes([]byte(""), []byte("<>\"':()&"))) // $ Sanitizer=AppendBody
		// &lt;&gt;&#34;&#39;:()&amp;

		// open redirect Sinks
		requestCtx.Redirect("https://userControlled.com", 301)              // $ OpenRedirect="https://userControlled.com"
		requestCtx.RedirectBytes([]byte("https://userControlled.com"), 301) // $ OpenRedirect=[]byte("https://userControlled.com")
	}
	fasthttp.Serve(ln, requestHandler)
}
