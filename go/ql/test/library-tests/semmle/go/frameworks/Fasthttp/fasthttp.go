package main

// go:generate depstubber -vendor  "github.com/valyala/fasthttp" Args,Client,Cookie,FS,HostClient,LBClient,PathRewriteFunc,Request,RequestCtx,RequestHandler,RequestHeader,Response,ResponseHeader,Server,TCPDialer,URI,LBClient,PipelineClient AcquireURI,Serve,DialDualStack,Dial,DialTimeout,DialDualStackTimeout,Get,GetDeadline,GetTimeout,Post,Do,DoRedirects,AppendHTMLEscapeBytes,AppendHTMLEscape,AppendQuotedArg,ServeFileBytesUncompressed,ServeFileBytes,ServeFileUncompressed,ServeFile,SaveMultipartFile,DoTimeout,DoDeadline

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"net"
	"time"

	"github.com/valyala/fasthttp"
)

func source() interface{} {
	return make([]byte, 1)
}

func sink(interface{}) {
}

func fasthttpClient() {
	userInput := "127.0.0.1:8909"
	fasthttp.DialDualStack(userInput)           // $ SsrfSink=userInput
	fasthttp.Dial(userInput)                    // $ SsrfSink=userInput
	fasthttp.DialTimeout(userInput, 5)          // $ SsrfSink=userInput
	fasthttp.DialDualStackTimeout(userInput, 5) // $ SsrfSink=userInput

	req := &fasthttp.Request{}

	uri1 := fasthttp.AcquireURI()
	userInput = "UserControlled.com:80"
	uri1.SetHost(source().(string))
	sink(uri1) // $ hasTaintFlow="uri1"
	uri2 := fasthttp.AcquireURI()
	uri2.SetHostBytes(source().([]byte))
	sink(uri2) // $ hasTaintFlow="uri2"
	userInput = "http://UserControlled.com"
	uri3 := fasthttp.AcquireURI()
	uri3.Update(source().(string))
	sink(uri3) // $ hasTaintFlow="uri3"
	uri4 := fasthttp.AcquireURI()
	uri4.UpdateBytes(source().([]byte))
	sink(uri4) // $ hasTaintFlow="uri4"
	uri5 := fasthttp.AcquireURI()
	uri5.Parse(source().([]byte), nil)
	sink(uri5) // $ hasTaintFlow="uri5"
	uri6 := fasthttp.AcquireURI()
	uri6.Parse(nil, source().([]byte))
	sink(uri6) // $ hasTaintFlow="uri6"

	resByte := make([]byte, 1000)
	userInput = "http://127.0.0.1:8909"
	userInputBytes := []byte("http://127.0.0.1:8909")
	req.SetURI(uri5)                                      // $ SsrfSink=uri5
	req.SetHost(userInput)                                // $ SsrfSink=userInput
	req.SetHostBytes(userInputBytes)                      // $ SsrfSink=userInputBytes
	req.SetRequestURI(userInput)                          // $ SsrfSink=userInput
	req.SetRequestURIBytes(userInputBytes)                // $ SsrfSink=userInputBytes
	fasthttp.Get(resByte, userInput)                      // $ SsrfSink=userInput
	fasthttp.GetDeadline(resByte, userInput, time.Time{}) // $ SsrfSink=userInput
	fasthttp.GetTimeout(resByte, userInput, 5)            // $ SsrfSink=userInput
	fasthttp.Post(resByte, userInput, nil)                // $ SsrfSink=userInput

	hostClient := &fasthttp.HostClient{
		Addr: "localhost:8080",
	}
	hostClient.Get(resByte, userInput)                      // $ SsrfSink=userInput
	hostClient.GetDeadline(resByte, userInput, time.Time{}) // $ SsrfSink=userInput
	hostClient.GetTimeout(resByte, userInput, 5)            // $ SsrfSink=userInput
	hostClient.Post(resByte, userInput, nil)                // $ SsrfSink=userInput

	var lbclient fasthttp.LBClient
	lbclient.Clients = append(lbclient.Clients, hostClient)

	client := fasthttp.Client{}
	client.Get(resByte, userInput)                      // $ SsrfSink=userInput
	client.GetDeadline(resByte, userInput, time.Time{}) // $ SsrfSink=userInput
	client.GetTimeout(resByte, userInput, 5)            // $ SsrfSink=userInput
	client.Post(resByte, userInput, nil)                // $ SsrfSink=userInput

	tcpDialer := fasthttp.TCPDialer{}
	userInput = "127.0.0.1:8909"
	tcpDialer.Dial(userInput)                    // $ SsrfSink=userInput
	tcpDialer.DialTimeout(userInput, 5)          // $ SsrfSink=userInput
	tcpDialer.DialDualStack(userInput)           // $ SsrfSink=userInput
	tcpDialer.DialDualStackTimeout(userInput, 5) // $ SsrfSink=userInput
}

func main() {
	fasthttpServer()
	fasthttpClient()
}

func fasthttpServer() {
	ln, _ := net.Listen("tcp4", "127.0.0.1:8080")
	requestHandler := func(requestCtx *fasthttp.RequestCtx) {
		filePath := requestCtx.QueryArgs().Peek("filePath") // $ RemoteFlowSource="call to Peek"
		// File System Access
		filePath_string := string(filePath)
		_ = requestCtx.Response.SendFile(filePath_string) // $ FileSystemAccess=filePath_string
		requestCtx.SendFile(filePath_string)              // $ FileSystemAccess=filePath_string
		requestCtx.SendFileBytes(filePath)                // $ FileSystemAccess=filePath
		fileHeader, _ := requestCtx.FormFile("file")
		_ = fasthttp.SaveMultipartFile(fileHeader, filePath_string) // $ FileSystemAccess=filePath_string
		fasthttp.ServeFile(requestCtx, filePath_string)             // $ FileSystemAccess=filePath_string
		fasthttp.ServeFileUncompressed(requestCtx, filePath_string) // $ FileSystemAccess=filePath_string
		fasthttp.ServeFileBytes(requestCtx, filePath)               // $ FileSystemAccess=filePath
		fasthttp.ServeFileBytesUncompressed(requestCtx, filePath)   // $ FileSystemAccess=filePath

		dstReader := &bufio.Reader{}
		// user controlled methods as source
		requestHeader := &fasthttp.RequestHeader{}
		requestHeader.Header()                         // $ RemoteFlowSource="call to Header"
		requestHeader.TrailerHeader()                  // $ RemoteFlowSource="call to TrailerHeader"
		requestHeader.String()                         // $ RemoteFlowSource="call to String"
		requestHeader.RequestURI()                     // $ RemoteFlowSource="call to RequestURI"
		requestHeader.Host()                           // $ RemoteFlowSource="call to Host"
		requestHeader.UserAgent()                      // $ RemoteFlowSource="call to UserAgent"
		requestHeader.ContentEncoding()                // $ RemoteFlowSource="call to ContentEncoding"
		requestHeader.ContentType()                    // $ RemoteFlowSource="call to ContentType"
		requestHeader.Cookie("ACookie")                // $ RemoteFlowSource="call to Cookie"
		requestHeader.CookieBytes([]byte("ACookie"))   // $ RemoteFlowSource="call to CookieBytes"
		requestHeader.MultipartFormBoundary()          // $ RemoteFlowSource="call to MultipartFormBoundary"
		requestHeader.Peek("AHeaderName")              // $ RemoteFlowSource="call to Peek"
		requestHeader.PeekAll("AHeaderName")           // $ RemoteFlowSource="call to PeekAll"
		requestHeader.PeekBytes([]byte("AHeaderName")) // $ RemoteFlowSource="call to PeekBytes"
		requestHeader.PeekKeys()                       // $ RemoteFlowSource="call to PeekKeys"
		requestHeader.PeekTrailerKeys()                // $ RemoteFlowSource="call to PeekTrailerKeys"
		requestHeader.Referer()                        // $ RemoteFlowSource="call to Referer"
		requestHeader.RawHeaders()                     // $ RemoteFlowSource="call to RawHeaders"
		// multipart.Form is already implemented
		// requestCtx.MultipartForm()
		requestCtx.URI().Path()            // $ RemoteFlowSource="call to Path"
		requestCtx.URI().PathOriginal()    // $ RemoteFlowSource="call to PathOriginal"
		requestCtx.URI().FullURI()         // $ RemoteFlowSource="call to FullURI"
		requestCtx.URI().LastPathSegment() // $ RemoteFlowSource="call to LastPathSegment"
		requestCtx.URI().QueryString()     // $ RemoteFlowSource="call to QueryString"
		requestCtx.URI().String()          // $ RemoteFlowSource="call to String"

		//or requestCtx.PostArgs()
		requestCtx.URI().QueryArgs().Peek("arg1")                   // $ RemoteFlowSource="call to Peek"
		requestCtx.URI().QueryArgs().PeekBytes([]byte("arg1"))      // $ RemoteFlowSource="call to PeekBytes"
		requestCtx.URI().QueryArgs().PeekMulti("arg1")              // $ RemoteFlowSource="call to PeekMulti"
		requestCtx.URI().QueryArgs().PeekMultiBytes([]byte("arg1")) // $ RemoteFlowSource="call to PeekMultiBytes"
		requestCtx.URI().QueryArgs().QueryString()                  // $ RemoteFlowSource="call to QueryString"
		requestCtx.URI().QueryArgs().String()                       // $ RemoteFlowSource="call to String"
		requestCtx.String()                                         // $ RemoteFlowSource="call to String"

		requestCtx.Path() // $ RemoteFlowSource="call to Path"
		// multipart.Form is already implemented
		// requestCtx.FormFile("FileName")
		// requestCtx.FormValue("ValueName")
		requestCtx.Referer()           // $ RemoteFlowSource="call to Referer"
		requestCtx.PostBody()          // $ RemoteFlowSource="call to PostBody"
		requestCtx.RequestBodyStream() // $ RemoteFlowSource="call to RequestBodyStream"
		requestCtx.RequestURI()        // $ RemoteFlowSource="call to RequestURI"
		requestCtx.UserAgent()         // $ RemoteFlowSource="call to UserAgent"
		requestCtx.Host()              // $ RemoteFlowSource="call to Host"

		requestCtx.Request.Host()                         // $ RemoteFlowSource="call to Host"
		requestCtx.Request.Body()                         // $ RemoteFlowSource="call to Body"
		requestCtx.Request.RequestURI()                   // $ RemoteFlowSource="call to RequestURI"
		body1, _ := requestCtx.Request.BodyGunzip()       // $ RemoteFlowSource="... := ...[0]"
		body2, _ := requestCtx.Request.BodyInflate()      // $ RemoteFlowSource="... := ...[0]"
		body3, _ := requestCtx.Request.BodyUnbrotli()     // $ RemoteFlowSource="... := ...[0]"
		body4, _ := requestCtx.Request.BodyUncompressed() // $ RemoteFlowSource="... := ...[0]"
		fmt.Println(body1, body2, body3, body4)
		requestCtx.Request.BodyStream() // $ RemoteFlowSource="call to BodyStream"

		requestCtx.Request.ReadBody(&bufio.Reader{}, 100, 1000)               // $ RemoteFlowSource="&..."
		requestCtx.Request.ReadLimitBody(&bufio.Reader{}, 100)                // $ RemoteFlowSource="&..."
		requestCtx.Request.ContinueReadBodyStream(&bufio.Reader{}, 100, true) // $ RemoteFlowSource="&..."
		requestCtx.Request.ContinueReadBody(&bufio.Reader{}, 100)             // $ RemoteFlowSource="&..."

		// Response methods
		// Xss Sinks Related method
		userInput := "user Controlled input"
		requestCtx.SetContentType("text/html")
		userInputByte := []byte("user Controlled input")
		userInputReader := bytes.NewReader(userInputByte)
		requestCtx.Response.AppendBody(userInputByte)   // $ XssSink=userInputByte
		requestCtx.Response.AppendBodyString(userInput) // $ XssSink=userInput
		rspWriter := requestCtx.Response.BodyWriter()
		rspWriter.Write(userInputByte)              // $ XssSink=userInputByte
		fmt.Fprintf(rspWriter, "%s", userInputByte) // $ XssSink=userInputByte
		io.WriteString(rspWriter, userInput)        // $ XssSink=userInput
		io.TeeReader(userInputReader, rspWriter)    // $ XssSink=userInputReader
		bufioReader := bufio.NewReader(dstReader)
		bufioReader.WriteTo(rspWriter) // $ XssSink=bufioReader
		bytesUserInput := bytes.NewBuffer(userInputByte)
		bytesUserInput.WriteTo(rspWriter)                 // $ XssSink=bytesUserInput
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
