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
		filePath := requestCtx.QueryArgs().Peek("filePath") // $ UntrustedFlowSource="call to Peek"
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

		dstReader := &bufio.Reader{}
		// user controlled methods as source
		requestHeader := &fasthttp.RequestHeader{}
		requestHeader.Header()                         // $ UntrustedFlowSource="call to Header"
		requestHeader.TrailerHeader()                  // $ UntrustedFlowSource="call to TrailerHeader"
		requestHeader.String()                         // $ UntrustedFlowSource="call to String"
		requestHeader.RequestURI()                     // $ UntrustedFlowSource="call to RequestURI"
		requestHeader.Host()                           // $ UntrustedFlowSource="call to Host"
		requestHeader.UserAgent()                      // $ UntrustedFlowSource="call to UserAgent"
		requestHeader.ContentEncoding()                // $ UntrustedFlowSource="call to ContentEncoding"
		requestHeader.ContentType()                    // $ UntrustedFlowSource="call to ContentType"
		requestHeader.Cookie("ACookie")                // $ UntrustedFlowSource="call to Cookie"
		requestHeader.CookieBytes([]byte("ACookie"))   // $ UntrustedFlowSource="call to CookieBytes"
		requestHeader.MultipartFormBoundary()          // $ UntrustedFlowSource="call to MultipartFormBoundary"
		requestHeader.Peek("AHeaderName")              // $ UntrustedFlowSource="call to Peek"
		requestHeader.PeekAll("AHeaderName")           // $ UntrustedFlowSource="call to PeekAll"
		requestHeader.PeekBytes([]byte("AHeaderName")) // $ UntrustedFlowSource="call to PeekBytes"
		requestHeader.PeekKeys()                       // $ UntrustedFlowSource="call to PeekKeys"
		requestHeader.PeekTrailerKeys()                // $ UntrustedFlowSource="call to PeekTrailerKeys"
		requestHeader.Referer()                        // $ UntrustedFlowSource="call to Referer"
		requestHeader.RawHeaders()                     // $ UntrustedFlowSource="call to RawHeaders"
		// multipart.Form is already implemented
		// requestCtx.MultipartForm()
		requestCtx.URI().Path()            // $ UntrustedFlowSource="call to Path"
		requestCtx.URI().PathOriginal()    // $ UntrustedFlowSource="call to PathOriginal"
		requestCtx.URI().FullURI()         // $ UntrustedFlowSource="call to FullURI"
		requestCtx.URI().LastPathSegment() // $ UntrustedFlowSource="call to LastPathSegment"
		requestCtx.URI().QueryString()     // $ UntrustedFlowSource="call to QueryString"
		requestCtx.URI().String()          // $ UntrustedFlowSource="call to String"

		//or requestCtx.PostArgs()
		requestCtx.URI().QueryArgs().Peek("arg1")                   // $ UntrustedFlowSource="call to Peek"
		requestCtx.URI().QueryArgs().PeekBytes([]byte("arg1"))      // $ UntrustedFlowSource="call to PeekBytes"
		requestCtx.URI().QueryArgs().PeekMulti("arg1")              // $ UntrustedFlowSource="call to PeekMulti"
		requestCtx.URI().QueryArgs().PeekMultiBytes([]byte("arg1")) // $ UntrustedFlowSource="call to PeekMultiBytes"
		requestCtx.URI().QueryArgs().QueryString()                  // $ UntrustedFlowSource="call to QueryString"
		requestCtx.URI().QueryArgs().String()                       // $ UntrustedFlowSource="call to String"
		requestCtx.String()                                         // $ UntrustedFlowSource="call to String"
		// not sure what is the best way to write query for following
		//requestCtx.URI().QueryArgs().VisitAll(type func(,))

		requestCtx.Path() // $ UntrustedFlowSource="call to Path"
		// multipart.Form is already implemented
		// requestCtx.FormFile("FileName")
		// requestCtx.FormValue("ValueName")
		requestCtx.Referer()           // $ UntrustedFlowSource="call to Referer"
		requestCtx.PostBody()          // $ UntrustedFlowSource="call to PostBody"
		requestCtx.RequestBodyStream() // $ UntrustedFlowSource="call to RequestBodyStream"
		requestCtx.RequestURI()        // $ UntrustedFlowSource="call to RequestURI"
		requestCtx.UserAgent()         // $ UntrustedFlowSource="call to UserAgent"
		requestCtx.Host()              // $ UntrustedFlowSource="call to Host"

		requestCtx.Request.Host()             // $ UntrustedFlowSource="call to Host"
		requestCtx.Request.Body()             // $ UntrustedFlowSource="call to Body"
		requestCtx.Request.RequestURI()       // $ UntrustedFlowSource="call to RequestURI"
		requestCtx.Request.BodyGunzip()       // $ UntrustedFlowSource="call to BodyGunzip"
		requestCtx.Request.BodyInflate()      // $ UntrustedFlowSource="call to BodyInflate"
		requestCtx.Request.BodyUnbrotli()     // $ UntrustedFlowSource="call to BodyUnbrotli"
		requestCtx.Request.BodyStream()       // $ UntrustedFlowSource="call to BodyStream"
		requestCtx.Request.BodyUncompressed() // $ UntrustedFlowSource="call to BodyUncompressed"
		requestCtx.Request.ReadBody(dstReader, 100, 1000)
		requestCtx.Request.ReadLimitBody(dstReader, 100)
		requestCtx.Request.ContinueReadBodyStream(dstReader, 100, true)
		requestCtx.Request.ContinueReadBody(dstReader, 100)
		// not sure what is the best way to write query for following
		//requestCtx.Request.Header.VisitAllCookie()

		// Response methods
		// Xss Sinks Related method
		userInput := "user Controlled input"
		userInputByte := []byte("user Controlled input")
		requestCtx.Response.AppendBody(userInputByte)   // $ XssSink=userInputByte
		requestCtx.Response.AppendBodyString(userInput) // $ XssSink=userInput
		rspWriter := requestCtx.Response.BodyWriter()   // IDK how to handle this that returns a `io.Writer`
		rspWriter.Write(userInputByte)
		requestCtx.Response.SetBody(userInputByte)        // $ XssSink=userInputByte
		requestCtx.Response.SetBodyString(userInput)      // $ XssSink=userInput
		requestCtx.Response.SetBodyRaw(userInputByte)     // $ XssSink=userInputByte
		requestCtx.Response.SetBodyStream(dstReader, 100) // $ XssSink=dstReader
		// mostly related to header writers
		requestCtx.Success("", userInputByte)   // $ XssSink=userInputByte
		requestCtx.SuccessString("", userInput) // $ XssSink=userInput

		// sanitizers
		userInputByte = []byte("<>\"':()&")
		userInput = "<>\"':()&"
		fasthttp.AppendQuotedArg([]byte(""), userInputByte) // $ Sanitizer=userInputByte
		// %3C%3E%22%27%3A%28%29%26
		fasthttp.AppendHTMLEscape([]byte(""), userInput) // $ Sanitizer=userInput
		// &lt;&gt;&#34;&#39;:()&amp;
		fasthttp.AppendHTMLEscapeBytes([]byte(""), userInputByte) // $ Sanitizer=userInputByte
		// &lt;&gt;&#34;&#39;:()&amp;

		// open redirect Sinks
		userInput = "https://userControlled.com"
		requestCtx.Redirect(userInput, 301) // $ OpenRedirect=userInput
		userInputByte = []byte("https://userControlled.com")
		requestCtx.RedirectBytes(userInputByte, 301) // $ OpenRedirect=userInputByte
	}
	fasthttp.Serve(ln, requestHandler)
}
