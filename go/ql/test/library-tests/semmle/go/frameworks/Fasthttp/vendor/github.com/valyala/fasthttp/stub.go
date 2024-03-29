// Code generated by depstubber. DO NOT EDIT.
// This is a simple stub for github.com/valyala/fasthttp, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: github.com/valyala/fasthttp (exports: Args,Client,Cookie,FS,HostClient,LBClient,PathRewriteFunc,Request,RequestCtx,RequestHandler,RequestHeader,Response,ResponseHeader,Server,TCPDialer,URI,LBClient,PipelineClient; functions: AcquireURI,Serve,DialDualStack,Dial,DialTimeout,DialDualStackTimeout,Get,GetDeadline,GetTimeout,Post,Do,DoRedirects,AppendHTMLEscapeBytes,AppendHTMLEscape,AppendQuotedArg,ServeFileBytesUncompressed,ServeFileBytes,ServeFileUncompressed,ServeFile,SaveMultipartFile,DoTimeout,DoDeadline)

// Package fasthttp is a stub of github.com/valyala/fasthttp, generated by depstubber.
package fasthttp

import (
	bufio "bufio"
	context "context"
	tls "crypto/tls"
	io "io"
	fs "io/fs"
	multipart "mime/multipart"
	net "net"
	time "time"
)

func AcquireURI() *URI {
	return nil
}

func AppendHTMLEscape(_ []byte, _ string) []byte {
	return nil
}

func AppendHTMLEscapeBytes(_ []byte, _ []byte) []byte {
	return nil
}

func AppendQuotedArg(_ []byte, _ []byte) []byte {
	return nil
}

type Args struct{}

func (_ *Args) Add(_ string, _ string) {}

func (_ *Args) AddBytesK(_ []byte, _ string) {}

func (_ *Args) AddBytesKNoValue(_ []byte) {}

func (_ *Args) AddBytesKV(_ []byte, _ []byte) {}

func (_ *Args) AddBytesV(_ string, _ []byte) {}

func (_ *Args) AddNoValue(_ string) {}

func (_ *Args) AppendBytes(_ []byte) []byte {
	return nil
}

func (_ *Args) CopyTo(_ *Args) {}

func (_ *Args) Del(_ string) {}

func (_ *Args) DelBytes(_ []byte) {}

func (_ *Args) GetBool(_ string) bool {
	return false
}

func (_ *Args) GetUfloat(_ string) (float64, error) {
	return 0, nil
}

func (_ *Args) GetUfloatOrZero(_ string) float64 {
	return 0
}

func (_ *Args) GetUint(_ string) (int, error) {
	return 0, nil
}

func (_ *Args) GetUintOrZero(_ string) int {
	return 0
}

func (_ *Args) Has(_ string) bool {
	return false
}

func (_ *Args) HasBytes(_ []byte) bool {
	return false
}

func (_ *Args) Len() int {
	return 0
}

func (_ *Args) Parse(_ string) {}

func (_ *Args) ParseBytes(_ []byte) {}

func (_ *Args) Peek(_ string) []byte {
	return nil
}

func (_ *Args) PeekBytes(_ []byte) []byte {
	return nil
}

func (_ *Args) PeekMulti(_ string) [][]byte {
	return nil
}

func (_ *Args) PeekMultiBytes(_ []byte) [][]byte {
	return nil
}

func (_ *Args) QueryString() []byte {
	return nil
}

func (_ *Args) Reset() {}

func (_ *Args) Set(_ string, _ string) {}

func (_ *Args) SetBytesK(_ []byte, _ string) {}

func (_ *Args) SetBytesKNoValue(_ []byte) {}

func (_ *Args) SetBytesKV(_ []byte, _ []byte) {}

func (_ *Args) SetBytesV(_ string, _ []byte) {}

func (_ *Args) SetNoValue(_ string) {}

func (_ *Args) SetUint(_ string, _ int) {}

func (_ *Args) SetUintBytes(_ []byte, _ int) {}

func (_ *Args) Sort(_ func([]byte, []byte) int) {}

func (_ *Args) String() string {
	return ""
}

func (_ *Args) VisitAll(_ func([]byte, []byte)) {}

func (_ *Args) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}

type BalancingClient interface {
	DoDeadline(_ *Request, _ *Response, _ time.Time) error
	PendingRequests() int
}

type Client struct {
	Name                          string
	NoDefaultUserAgentHeader      bool
	Dial                          DialFunc
	DialDualStack                 bool
	TLSConfig                     *tls.Config
	MaxConnsPerHost               int
	MaxIdleConnDuration           time.Duration
	MaxConnDuration               time.Duration
	MaxIdemponentCallAttempts     int
	ReadBufferSize                int
	WriteBufferSize               int
	ReadTimeout                   time.Duration
	WriteTimeout                  time.Duration
	MaxResponseBodySize           int
	DisableHeaderNamesNormalizing bool
	DisablePathNormalizing        bool
	MaxConnWaitTimeout            time.Duration
	RetryIf                       RetryIfFunc
	ConnPoolStrategy              ConnPoolStrategyType
	StreamResponseBody            bool
	ConfigureClient               func(*HostClient) error
}

func (_ *Client) CloseIdleConnections() {}

func (_ *Client) Do(_ *Request, _ *Response) error {
	return nil
}

func (_ *Client) DoDeadline(_ *Request, _ *Response, _ time.Time) error {
	return nil
}

func (_ *Client) DoRedirects(_ *Request, _ *Response, _ int) error {
	return nil
}

func (_ *Client) DoTimeout(_ *Request, _ *Response, _ time.Duration) error {
	return nil
}

func (_ *Client) Get(_ []byte, _ string) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *Client) GetDeadline(_ []byte, _ string, _ time.Time) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *Client) GetTimeout(_ []byte, _ string, _ time.Duration) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *Client) Post(_ []byte, _ string, _ *Args) (int, []byte, error) {
	return 0, nil, nil
}

type ConnPoolStrategyType int

type ConnState int

func (_ ConnState) String() string {
	return ""
}

type Cookie struct{}

func (_ *Cookie) AppendBytes(_ []byte) []byte {
	return nil
}

func (_ *Cookie) Cookie() []byte {
	return nil
}

func (_ *Cookie) CopyTo(_ *Cookie) {}

func (_ *Cookie) Domain() []byte {
	return nil
}

func (_ *Cookie) Expire() time.Time {
	return time.Time{}
}

func (_ *Cookie) HTTPOnly() bool {
	return false
}

func (_ *Cookie) Key() []byte {
	return nil
}

func (_ *Cookie) MaxAge() int {
	return 0
}

func (_ *Cookie) Parse(_ string) error {
	return nil
}

func (_ *Cookie) ParseBytes(_ []byte) error {
	return nil
}

func (_ *Cookie) Path() []byte {
	return nil
}

func (_ *Cookie) Reset() {}

func (_ *Cookie) SameSite() CookieSameSite {
	return 0
}

func (_ *Cookie) Secure() bool {
	return false
}

func (_ *Cookie) SetDomain(_ string) {}

func (_ *Cookie) SetDomainBytes(_ []byte) {}

func (_ *Cookie) SetExpire(_ time.Time) {}

func (_ *Cookie) SetHTTPOnly(_ bool) {}

func (_ *Cookie) SetKey(_ string) {}

func (_ *Cookie) SetKeyBytes(_ []byte) {}

func (_ *Cookie) SetMaxAge(_ int) {}

func (_ *Cookie) SetPath(_ string) {}

func (_ *Cookie) SetPathBytes(_ []byte) {}

func (_ *Cookie) SetSameSite(_ CookieSameSite) {}

func (_ *Cookie) SetSecure(_ bool) {}

func (_ *Cookie) SetValue(_ string) {}

func (_ *Cookie) SetValueBytes(_ []byte) {}

func (_ *Cookie) String() string {
	return ""
}

func (_ *Cookie) Value() []byte {
	return nil
}

func (_ *Cookie) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}

type CookieSameSite int

func Dial(_ string) (net.Conn, error) {
	return nil, nil
}

func DialDualStack(_ string) (net.Conn, error) {
	return nil, nil
}

func DialDualStackTimeout(_ string, _ time.Duration) (net.Conn, error) {
	return nil, nil
}

type DialFunc func(string) (net.Conn, error)

func DialTimeout(_ string, _ time.Duration) (net.Conn, error) {
	return nil, nil
}

func Do(_ *Request, _ *Response) error {
	return nil
}

func DoDeadline(_ *Request, _ *Response, _ time.Time) error {
	return nil
}

func DoRedirects(_ *Request, _ *Response, _ int) error {
	return nil
}

func DoTimeout(_ *Request, _ *Response, _ time.Duration) error {
	return nil
}

type FS struct {
	Root                   string
	AllowEmptyRoot         bool
	IndexNames             []string
	GenerateIndexPages     bool
	Compress               bool
	CompressBrotli         bool
	CompressRoot           string
	AcceptByteRange        bool
	PathRewrite            PathRewriteFunc
	PathNotFound           RequestHandler
	CacheDuration          time.Duration
	CompressedFileSuffix   string
	CompressedFileSuffixes map[string]string
	CleanStop              chan struct{}
}

func (_ *FS) NewRequestHandler() RequestHandler {
	return nil
}

type FormValueFunc func(*RequestCtx, string) []byte

func Get(_ []byte, _ string) (int, []byte, error) {
	return 0, nil, nil
}

func GetDeadline(_ []byte, _ string, _ time.Time) (int, []byte, error) {
	return 0, nil, nil
}

func GetTimeout(_ []byte, _ string, _ time.Duration) (int, []byte, error) {
	return 0, nil, nil
}

type HijackHandler func(net.Conn)

type HostClient struct {
	Addr                          string
	Name                          string
	NoDefaultUserAgentHeader      bool
	Dial                          DialFunc
	DialDualStack                 bool
	IsTLS                         bool
	TLSConfig                     *tls.Config
	MaxConns                      int
	MaxConnDuration               time.Duration
	MaxIdleConnDuration           time.Duration
	MaxIdemponentCallAttempts     int
	ReadBufferSize                int
	WriteBufferSize               int
	ReadTimeout                   time.Duration
	WriteTimeout                  time.Duration
	MaxResponseBodySize           int
	DisableHeaderNamesNormalizing bool
	DisablePathNormalizing        bool
	SecureErrorLogMessage         bool
	MaxConnWaitTimeout            time.Duration
	RetryIf                       RetryIfFunc
	Transport                     RoundTripper
	ConnPoolStrategy              ConnPoolStrategyType
	StreamResponseBody            bool
}

func (_ *HostClient) CloseIdleConnections() {}

func (_ *HostClient) ConnsCount() int {
	return 0
}

func (_ *HostClient) Do(_ *Request, _ *Response) error {
	return nil
}

func (_ *HostClient) DoDeadline(_ *Request, _ *Response, _ time.Time) error {
	return nil
}

func (_ *HostClient) DoRedirects(_ *Request, _ *Response, _ int) error {
	return nil
}

func (_ *HostClient) DoTimeout(_ *Request, _ *Response, _ time.Duration) error {
	return nil
}

func (_ *HostClient) Get(_ []byte, _ string) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *HostClient) GetDeadline(_ []byte, _ string, _ time.Time) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *HostClient) GetTimeout(_ []byte, _ string, _ time.Duration) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *HostClient) LastUseTime() time.Time {
	return time.Time{}
}

func (_ *HostClient) PendingRequests() int {
	return 0
}

func (_ *HostClient) Post(_ []byte, _ string, _ *Args) (int, []byte, error) {
	return 0, nil, nil
}

func (_ *HostClient) SetMaxConns(_ int) {}

type LBClient struct {
	Clients     []BalancingClient
	HealthCheck func(*Request, *Response, error) bool
	Timeout     time.Duration
}

func (_ *LBClient) AddClient(_ BalancingClient) int {
	return 0
}

func (_ *LBClient) Do(_ *Request, _ *Response) error {
	return nil
}

func (_ *LBClient) DoDeadline(_ *Request, _ *Response, _ time.Time) error {
	return nil
}

func (_ *LBClient) DoTimeout(_ *Request, _ *Response, _ time.Duration) error {
	return nil
}

func (_ *LBClient) RemoveClients(_ func(BalancingClient) bool) int {
	return 0
}

type Logger interface {
	Printf(_ string, _ ...interface{})
}

type PathRewriteFunc func(*RequestCtx) []byte

type PipelineClient struct {
	Addr                          string
	Name                          string
	NoDefaultUserAgentHeader      bool
	MaxConns                      int
	MaxPendingRequests            int
	MaxBatchDelay                 time.Duration
	Dial                          DialFunc
	DialDualStack                 bool
	DisableHeaderNamesNormalizing bool
	DisablePathNormalizing        bool
	IsTLS                         bool
	TLSConfig                     *tls.Config
	MaxIdleConnDuration           time.Duration
	ReadBufferSize                int
	WriteBufferSize               int
	ReadTimeout                   time.Duration
	WriteTimeout                  time.Duration
	Logger                        Logger
}

func (_ *PipelineClient) Do(_ *Request, _ *Response) error {
	return nil
}

func (_ *PipelineClient) DoDeadline(_ *Request, _ *Response, _ time.Time) error {
	return nil
}

func (_ *PipelineClient) DoTimeout(_ *Request, _ *Response, _ time.Duration) error {
	return nil
}

func (_ *PipelineClient) PendingRequests() int {
	return 0
}

func Post(_ []byte, _ string, _ *Args) (int, []byte, error) {
	return 0, nil, nil
}

type Request struct {
	Header        RequestHeader
	UseHostHeader bool
}

func (_ *Request) AppendBody(_ []byte) {}

func (_ *Request) AppendBodyString(_ string) {}

func (_ *Request) Body() []byte {
	return nil
}

func (_ *Request) BodyGunzip() ([]byte, error) {
	return nil, nil
}

func (_ *Request) BodyInflate() ([]byte, error) {
	return nil, nil
}

func (_ *Request) BodyStream() io.Reader {
	return nil
}

func (_ *Request) BodyUnbrotli() ([]byte, error) {
	return nil, nil
}

func (_ *Request) BodyUncompressed() ([]byte, error) {
	return nil, nil
}

func (_ *Request) BodyWriteTo(_ io.Writer) error {
	return nil
}

func (_ *Request) BodyWriter() io.Writer {
	return nil
}

func (_ *Request) CloseBodyStream() error {
	return nil
}

func (_ *Request) ConnectionClose() bool {
	return false
}

func (_ *Request) ContinueReadBody(_ *bufio.Reader, _ int, _ ...bool) error {
	return nil
}

func (_ *Request) ContinueReadBodyStream(_ *bufio.Reader, _ int, _ ...bool) error {
	return nil
}

func (_ *Request) CopyTo(_ *Request) {}

func (_ *Request) Host() []byte {
	return nil
}

func (_ *Request) IsBodyStream() bool {
	return false
}

func (_ *Request) MayContinue() bool {
	return false
}

func (_ *Request) MultipartForm() (*multipart.Form, error) {
	return nil, nil
}

func (_ *Request) PostArgs() *Args {
	return nil
}

func (_ *Request) Read(_ *bufio.Reader) error {
	return nil
}

func (_ *Request) ReadBody(_ *bufio.Reader, _ int, _ int) error {
	return nil
}

func (_ *Request) ReadLimitBody(_ *bufio.Reader, _ int) error {
	return nil
}

func (_ *Request) ReleaseBody(_ int) {}

func (_ *Request) RemoveMultipartFormFiles() {}

func (_ *Request) RequestURI() []byte {
	return nil
}

func (_ *Request) Reset() {}

func (_ *Request) ResetBody() {}

func (_ *Request) SetBody(_ []byte) {}

func (_ *Request) SetBodyRaw(_ []byte) {}

func (_ *Request) SetBodyStream(_ io.Reader, _ int) {}

func (_ *Request) SetBodyStreamWriter(_ StreamWriter) {}

func (_ *Request) SetBodyString(_ string) {}

func (_ *Request) SetConnectionClose() {}

func (_ *Request) SetHost(_ string) {}

func (_ *Request) SetHostBytes(_ []byte) {}

func (_ *Request) SetRequestURI(_ string) {}

func (_ *Request) SetRequestURIBytes(_ []byte) {}

func (_ *Request) SetTimeout(_ time.Duration) {}

func (_ *Request) SetURI(_ *URI) {}

func (_ *Request) String() string {
	return ""
}

func (_ *Request) SwapBody(_ []byte) []byte {
	return nil
}

func (_ *Request) URI() *URI {
	return nil
}

func (_ *Request) Write(_ *bufio.Writer) error {
	return nil
}

func (_ *Request) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}

type RequestConfig struct {
	ReadTimeout        time.Duration
	WriteTimeout       time.Duration
	MaxRequestBodySize int
}

type RequestCtx struct {
	Request  Request
	Response Response
}

func (_ *RequestCtx) Conn() net.Conn {
	return nil
}

func (_ *RequestCtx) ConnID() uint64 {
	return 0
}

func (_ *RequestCtx) ConnRequestNum() uint64 {
	return 0
}

func (_ *RequestCtx) ConnTime() time.Time {
	return time.Time{}
}

func (_ *RequestCtx) Deadline() (time.Time, bool) {
	return time.Time{}, false
}

func (_ *RequestCtx) Done() <-chan struct{} {
	return nil
}

func (_ *RequestCtx) Err() error {
	return nil
}

func (_ *RequestCtx) Error(_ string, _ int) {}

func (_ *RequestCtx) FormFile(_ string) (*multipart.FileHeader, error) {
	return nil, nil
}

func (_ *RequestCtx) FormValue(_ string) []byte {
	return nil
}

func (_ *RequestCtx) Hijack(_ HijackHandler) {}

func (_ *RequestCtx) HijackSetNoResponse(_ bool) {}

func (_ *RequestCtx) Hijacked() bool {
	return false
}

func (_ *RequestCtx) Host() []byte {
	return nil
}

func (_ *RequestCtx) ID() uint64 {
	return 0
}

func (_ *RequestCtx) IfModifiedSince(_ time.Time) bool {
	return false
}

func (_ *RequestCtx) Init(_ *Request, _ net.Addr, _ Logger) {}

func (_ *RequestCtx) Init2(_ net.Conn, _ Logger, _ bool) {}

func (_ *RequestCtx) IsBodyStream() bool {
	return false
}

func (_ *RequestCtx) IsConnect() bool {
	return false
}

func (_ *RequestCtx) IsDelete() bool {
	return false
}

func (_ *RequestCtx) IsGet() bool {
	return false
}

func (_ *RequestCtx) IsHead() bool {
	return false
}

func (_ *RequestCtx) IsOptions() bool {
	return false
}

func (_ *RequestCtx) IsPatch() bool {
	return false
}

func (_ *RequestCtx) IsPost() bool {
	return false
}

func (_ *RequestCtx) IsPut() bool {
	return false
}

func (_ *RequestCtx) IsTLS() bool {
	return false
}

func (_ *RequestCtx) IsTrace() bool {
	return false
}

func (_ *RequestCtx) LastTimeoutErrorResponse() *Response {
	return nil
}

func (_ *RequestCtx) LocalAddr() net.Addr {
	return nil
}

func (_ *RequestCtx) LocalIP() net.IP {
	return nil
}

func (_ *RequestCtx) Logger() Logger {
	return nil
}

func (_ *RequestCtx) Method() []byte {
	return nil
}

func (_ *RequestCtx) MultipartForm() (*multipart.Form, error) {
	return nil, nil
}

func (_ *RequestCtx) NotFound() {}

func (_ *RequestCtx) NotModified() {}

func (_ *RequestCtx) Path() []byte {
	return nil
}

func (_ *RequestCtx) PostArgs() *Args {
	return nil
}

func (_ *RequestCtx) PostBody() []byte {
	return nil
}

func (_ *RequestCtx) QueryArgs() *Args {
	return nil
}

func (_ *RequestCtx) Redirect(_ string, _ int) {}

func (_ *RequestCtx) RedirectBytes(_ []byte, _ int) {}

func (_ *RequestCtx) Referer() []byte {
	return nil
}

func (_ *RequestCtx) RemoteAddr() net.Addr {
	return nil
}

func (_ *RequestCtx) RemoteIP() net.IP {
	return nil
}

func (_ *RequestCtx) RemoveUserValue(_ interface{}) {}

func (_ *RequestCtx) RemoveUserValueBytes(_ []byte) {}

func (_ *RequestCtx) RequestBodyStream() io.Reader {
	return nil
}

func (_ *RequestCtx) RequestURI() []byte {
	return nil
}

func (_ *RequestCtx) ResetBody() {}

func (_ *RequestCtx) ResetUserValues() {}

func (_ *RequestCtx) SendFile(_ string) {}

func (_ *RequestCtx) SendFileBytes(_ []byte) {}

func (_ *RequestCtx) SetBody(_ []byte) {}

func (_ *RequestCtx) SetBodyStream(_ io.Reader, _ int) {}

func (_ *RequestCtx) SetBodyStreamWriter(_ StreamWriter) {}

func (_ *RequestCtx) SetBodyString(_ string) {}

func (_ *RequestCtx) SetConnectionClose() {}

func (_ *RequestCtx) SetContentType(_ string) {}

func (_ *RequestCtx) SetContentTypeBytes(_ []byte) {}

func (_ *RequestCtx) SetRemoteAddr(_ net.Addr) {}

func (_ *RequestCtx) SetStatusCode(_ int) {}

func (_ *RequestCtx) SetUserValue(_ interface{}, _ interface{}) {}

func (_ *RequestCtx) SetUserValueBytes(_ []byte, _ interface{}) {}

func (_ *RequestCtx) String() string {
	return ""
}

func (_ *RequestCtx) Success(_ string, _ []byte) {}

func (_ *RequestCtx) SuccessString(_ string, _ string) {}

func (_ *RequestCtx) TLSConnectionState() *tls.ConnectionState {
	return nil
}

func (_ *RequestCtx) Time() time.Time {
	return time.Time{}
}

func (_ *RequestCtx) TimeoutError(_ string) {}

func (_ *RequestCtx) TimeoutErrorWithCode(_ string, _ int) {}

func (_ *RequestCtx) TimeoutErrorWithResponse(_ *Response) {}

func (_ *RequestCtx) URI() *URI {
	return nil
}

func (_ *RequestCtx) UserAgent() []byte {
	return nil
}

func (_ *RequestCtx) UserValue(_ interface{}) interface{} {
	return nil
}

func (_ *RequestCtx) UserValueBytes(_ []byte) interface{} {
	return nil
}

func (_ *RequestCtx) Value(_ interface{}) interface{} {
	return nil
}

func (_ *RequestCtx) VisitUserValues(_ func([]byte, interface{})) {}

func (_ *RequestCtx) VisitUserValuesAll(_ func(interface{}, interface{})) {}

func (_ *RequestCtx) Write(_ []byte) (int, error) {
	return 0, nil
}

func (_ *RequestCtx) WriteString(_ string) (int, error) {
	return 0, nil
}

type RequestHandler func(*RequestCtx)

type RequestHeader struct{}

func (_ *RequestHeader) Add(_ string, _ string) {}

func (_ *RequestHeader) AddBytesK(_ []byte, _ string) {}

func (_ *RequestHeader) AddBytesKV(_ []byte, _ []byte) {}

func (_ *RequestHeader) AddBytesV(_ string, _ []byte) {}

func (_ *RequestHeader) AddTrailer(_ string) error {
	return nil
}

func (_ *RequestHeader) AddTrailerBytes(_ []byte) error {
	return nil
}

func (_ *RequestHeader) AppendBytes(_ []byte) []byte {
	return nil
}

func (_ *RequestHeader) ConnectionClose() bool {
	return false
}

func (_ *RequestHeader) ConnectionUpgrade() bool {
	return false
}

func (_ *RequestHeader) ContentEncoding() []byte {
	return nil
}

func (_ *RequestHeader) ContentLength() int {
	return 0
}

func (_ *RequestHeader) ContentType() []byte {
	return nil
}

func (_ *RequestHeader) Cookie(_ string) []byte {
	return nil
}

func (_ *RequestHeader) CookieBytes(_ []byte) []byte {
	return nil
}

func (_ *RequestHeader) CopyTo(_ *RequestHeader) {}

func (_ *RequestHeader) Del(_ string) {}

func (_ *RequestHeader) DelAllCookies() {}

func (_ *RequestHeader) DelBytes(_ []byte) {}

func (_ *RequestHeader) DelCookie(_ string) {}

func (_ *RequestHeader) DelCookieBytes(_ []byte) {}

func (_ *RequestHeader) DisableNormalizing() {}

func (_ *RequestHeader) DisableSpecialHeader() {}

func (_ *RequestHeader) EnableNormalizing() {}

func (_ *RequestHeader) EnableSpecialHeader() {}

func (_ *RequestHeader) HasAcceptEncoding(_ string) bool {
	return false
}

func (_ *RequestHeader) HasAcceptEncodingBytes(_ []byte) bool {
	return false
}

func (_ *RequestHeader) Header() []byte {
	return nil
}

func (_ *RequestHeader) Host() []byte {
	return nil
}

func (_ *RequestHeader) IsConnect() bool {
	return false
}

func (_ *RequestHeader) IsDelete() bool {
	return false
}

func (_ *RequestHeader) IsGet() bool {
	return false
}

func (_ *RequestHeader) IsHTTP11() bool {
	return false
}

func (_ *RequestHeader) IsHead() bool {
	return false
}

func (_ *RequestHeader) IsOptions() bool {
	return false
}

func (_ *RequestHeader) IsPatch() bool {
	return false
}

func (_ *RequestHeader) IsPost() bool {
	return false
}

func (_ *RequestHeader) IsPut() bool {
	return false
}

func (_ *RequestHeader) IsTrace() bool {
	return false
}

func (_ *RequestHeader) Len() int {
	return 0
}

func (_ *RequestHeader) Method() []byte {
	return nil
}

func (_ *RequestHeader) MultipartFormBoundary() []byte {
	return nil
}

func (_ *RequestHeader) Peek(_ string) []byte {
	return nil
}

func (_ *RequestHeader) PeekAll(_ string) [][]byte {
	return nil
}

func (_ *RequestHeader) PeekBytes(_ []byte) []byte {
	return nil
}

func (_ *RequestHeader) PeekKeys() [][]byte {
	return nil
}

func (_ *RequestHeader) PeekTrailerKeys() [][]byte {
	return nil
}

func (_ *RequestHeader) Protocol() []byte {
	return nil
}

func (_ *RequestHeader) RawHeaders() []byte {
	return nil
}

func (_ *RequestHeader) Read(_ *bufio.Reader) error {
	return nil
}

func (_ *RequestHeader) ReadTrailer(_ *bufio.Reader) error {
	return nil
}

func (_ *RequestHeader) Referer() []byte {
	return nil
}

func (_ *RequestHeader) RequestURI() []byte {
	return nil
}

func (_ *RequestHeader) Reset() {}

func (_ *RequestHeader) ResetConnectionClose() {}

func (_ *RequestHeader) Set(_ string, _ string) {}

func (_ *RequestHeader) SetByteRange(_ int, _ int) {}

func (_ *RequestHeader) SetBytesK(_ []byte, _ string) {}

func (_ *RequestHeader) SetBytesKV(_ []byte, _ []byte) {}

func (_ *RequestHeader) SetBytesV(_ string, _ []byte) {}

func (_ *RequestHeader) SetCanonical(_ []byte, _ []byte) {}

func (_ *RequestHeader) SetConnectionClose() {}

func (_ *RequestHeader) SetContentEncoding(_ string) {}

func (_ *RequestHeader) SetContentEncodingBytes(_ []byte) {}

func (_ *RequestHeader) SetContentLength(_ int) {}

func (_ *RequestHeader) SetContentType(_ string) {}

func (_ *RequestHeader) SetContentTypeBytes(_ []byte) {}

func (_ *RequestHeader) SetCookie(_ string, _ string) {}

func (_ *RequestHeader) SetCookieBytesK(_ []byte, _ string) {}

func (_ *RequestHeader) SetCookieBytesKV(_ []byte, _ []byte) {}

func (_ *RequestHeader) SetHost(_ string) {}

func (_ *RequestHeader) SetHostBytes(_ []byte) {}

func (_ *RequestHeader) SetMethod(_ string) {}

func (_ *RequestHeader) SetMethodBytes(_ []byte) {}

func (_ *RequestHeader) SetMultipartFormBoundary(_ string) {}

func (_ *RequestHeader) SetMultipartFormBoundaryBytes(_ []byte) {}

func (_ *RequestHeader) SetNoDefaultContentType(_ bool) {}

func (_ *RequestHeader) SetProtocol(_ string) {}

func (_ *RequestHeader) SetProtocolBytes(_ []byte) {}

func (_ *RequestHeader) SetReferer(_ string) {}

func (_ *RequestHeader) SetRefererBytes(_ []byte) {}

func (_ *RequestHeader) SetRequestURI(_ string) {}

func (_ *RequestHeader) SetRequestURIBytes(_ []byte) {}

func (_ *RequestHeader) SetTrailer(_ string) error {
	return nil
}

func (_ *RequestHeader) SetTrailerBytes(_ []byte) error {
	return nil
}

func (_ *RequestHeader) SetUserAgent(_ string) {}

func (_ *RequestHeader) SetUserAgentBytes(_ []byte) {}

func (_ *RequestHeader) String() string {
	return ""
}

func (_ *RequestHeader) TrailerHeader() []byte {
	return nil
}

func (_ *RequestHeader) UserAgent() []byte {
	return nil
}

func (_ *RequestHeader) VisitAll(_ func([]byte, []byte)) {}

func (_ *RequestHeader) VisitAllCookie(_ func([]byte, []byte)) {}

func (_ *RequestHeader) VisitAllInOrder(_ func([]byte, []byte)) {}

func (_ *RequestHeader) VisitAllTrailer(_ func([]byte)) {}

func (_ *RequestHeader) Write(_ *bufio.Writer) error {
	return nil
}

func (_ *RequestHeader) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}

type Resolver interface {
	LookupIPAddr(_ context.Context, _ string) ([]net.IPAddr, error)
}

type Response struct {
	Header               ResponseHeader
	ImmediateHeaderFlush bool
	StreamBody           bool
	SkipBody             bool
}

func (_ *Response) AppendBody(_ []byte) {}

func (_ *Response) AppendBodyString(_ string) {}

func (_ *Response) Body() []byte {
	return nil
}

func (_ *Response) BodyGunzip() ([]byte, error) {
	return nil, nil
}

func (_ *Response) BodyInflate() ([]byte, error) {
	return nil, nil
}

func (_ *Response) BodyStream() io.Reader {
	return nil
}

func (_ *Response) BodyUnbrotli() ([]byte, error) {
	return nil, nil
}

func (_ *Response) BodyUncompressed() ([]byte, error) {
	return nil, nil
}

func (_ *Response) BodyWriteTo(_ io.Writer) error {
	return nil
}

func (_ *Response) BodyWriter() io.Writer {
	return nil
}

func (_ *Response) CloseBodyStream() error {
	return nil
}

func (_ *Response) ConnectionClose() bool {
	return false
}

func (_ *Response) CopyTo(_ *Response) {}

func (_ *Response) IsBodyStream() bool {
	return false
}

func (_ *Response) LocalAddr() net.Addr {
	return nil
}

func (_ *Response) Read(_ *bufio.Reader) error {
	return nil
}

func (_ *Response) ReadBody(_ *bufio.Reader, _ int) error {
	return nil
}

func (_ *Response) ReadLimitBody(_ *bufio.Reader, _ int) error {
	return nil
}

func (_ *Response) ReleaseBody(_ int) {}

func (_ *Response) RemoteAddr() net.Addr {
	return nil
}

func (_ *Response) Reset() {}

func (_ *Response) ResetBody() {}

func (_ *Response) SendFile(_ string) error {
	return nil
}

func (_ *Response) SetBody(_ []byte) {}

func (_ *Response) SetBodyRaw(_ []byte) {}

func (_ *Response) SetBodyStream(_ io.Reader, _ int) {}

func (_ *Response) SetBodyStreamWriter(_ StreamWriter) {}

func (_ *Response) SetBodyString(_ string) {}

func (_ *Response) SetConnectionClose() {}

func (_ *Response) SetStatusCode(_ int) {}

func (_ *Response) StatusCode() int {
	return 0
}

func (_ *Response) String() string {
	return ""
}

func (_ *Response) SwapBody(_ []byte) []byte {
	return nil
}

func (_ *Response) Write(_ *bufio.Writer) error {
	return nil
}

func (_ *Response) WriteDeflate(_ *bufio.Writer) error {
	return nil
}

func (_ *Response) WriteDeflateLevel(_ *bufio.Writer, _ int) error {
	return nil
}

func (_ *Response) WriteGzip(_ *bufio.Writer) error {
	return nil
}

func (_ *Response) WriteGzipLevel(_ *bufio.Writer, _ int) error {
	return nil
}

func (_ *Response) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}

type ResponseHeader struct{}

func (_ *ResponseHeader) Add(_ string, _ string) {}

func (_ *ResponseHeader) AddBytesK(_ []byte, _ string) {}

func (_ *ResponseHeader) AddBytesKV(_ []byte, _ []byte) {}

func (_ *ResponseHeader) AddBytesV(_ string, _ []byte) {}

func (_ *ResponseHeader) AddTrailer(_ string) error {
	return nil
}

func (_ *ResponseHeader) AddTrailerBytes(_ []byte) error {
	return nil
}

func (_ *ResponseHeader) AppendBytes(_ []byte) []byte {
	return nil
}

func (_ *ResponseHeader) ConnectionClose() bool {
	return false
}

func (_ *ResponseHeader) ConnectionUpgrade() bool {
	return false
}

func (_ *ResponseHeader) ContentEncoding() []byte {
	return nil
}

func (_ *ResponseHeader) ContentLength() int {
	return 0
}

func (_ *ResponseHeader) ContentType() []byte {
	return nil
}

func (_ *ResponseHeader) Cookie(_ *Cookie) bool {
	return false
}

func (_ *ResponseHeader) CopyTo(_ *ResponseHeader) {}

func (_ *ResponseHeader) Del(_ string) {}

func (_ *ResponseHeader) DelAllCookies() {}

func (_ *ResponseHeader) DelBytes(_ []byte) {}

func (_ *ResponseHeader) DelClientCookie(_ string) {}

func (_ *ResponseHeader) DelClientCookieBytes(_ []byte) {}

func (_ *ResponseHeader) DelCookie(_ string) {}

func (_ *ResponseHeader) DelCookieBytes(_ []byte) {}

func (_ *ResponseHeader) DisableNormalizing() {}

func (_ *ResponseHeader) EnableNormalizing() {}

func (_ *ResponseHeader) Header() []byte {
	return nil
}

func (_ *ResponseHeader) IsHTTP11() bool {
	return false
}

func (_ *ResponseHeader) Len() int {
	return 0
}

func (_ *ResponseHeader) Peek(_ string) []byte {
	return nil
}

func (_ *ResponseHeader) PeekAll(_ string) [][]byte {
	return nil
}

func (_ *ResponseHeader) PeekBytes(_ []byte) []byte {
	return nil
}

func (_ *ResponseHeader) PeekCookie(_ string) []byte {
	return nil
}

func (_ *ResponseHeader) PeekKeys() [][]byte {
	return nil
}

func (_ *ResponseHeader) PeekTrailerKeys() [][]byte {
	return nil
}

func (_ *ResponseHeader) Protocol() []byte {
	return nil
}

func (_ *ResponseHeader) Read(_ *bufio.Reader) error {
	return nil
}

func (_ *ResponseHeader) ReadTrailer(_ *bufio.Reader) error {
	return nil
}

func (_ *ResponseHeader) Reset() {}

func (_ *ResponseHeader) ResetConnectionClose() {}

func (_ *ResponseHeader) Server() []byte {
	return nil
}

func (_ *ResponseHeader) Set(_ string, _ string) {}

func (_ *ResponseHeader) SetBytesK(_ []byte, _ string) {}

func (_ *ResponseHeader) SetBytesKV(_ []byte, _ []byte) {}

func (_ *ResponseHeader) SetBytesV(_ string, _ []byte) {}

func (_ *ResponseHeader) SetCanonical(_ []byte, _ []byte) {}

func (_ *ResponseHeader) SetConnectionClose() {}

func (_ *ResponseHeader) SetContentEncoding(_ string) {}

func (_ *ResponseHeader) SetContentEncodingBytes(_ []byte) {}

func (_ *ResponseHeader) SetContentLength(_ int) {}

func (_ *ResponseHeader) SetContentRange(_ int, _ int, _ int) {}

func (_ *ResponseHeader) SetContentType(_ string) {}

func (_ *ResponseHeader) SetContentTypeBytes(_ []byte) {}

func (_ *ResponseHeader) SetCookie(_ *Cookie) {}

func (_ *ResponseHeader) SetLastModified(_ time.Time) {}

func (_ *ResponseHeader) SetNoDefaultContentType(_ bool) {}

func (_ *ResponseHeader) SetProtocol(_ []byte) {}

func (_ *ResponseHeader) SetServer(_ string) {}

func (_ *ResponseHeader) SetServerBytes(_ []byte) {}

func (_ *ResponseHeader) SetStatusCode(_ int) {}

func (_ *ResponseHeader) SetStatusMessage(_ []byte) {}

func (_ *ResponseHeader) SetTrailer(_ string) error {
	return nil
}

func (_ *ResponseHeader) SetTrailerBytes(_ []byte) error {
	return nil
}

func (_ *ResponseHeader) StatusCode() int {
	return 0
}

func (_ *ResponseHeader) StatusMessage() []byte {
	return nil
}

func (_ *ResponseHeader) String() string {
	return ""
}

func (_ *ResponseHeader) TrailerHeader() []byte {
	return nil
}

func (_ *ResponseHeader) VisitAll(_ func([]byte, []byte)) {}

func (_ *ResponseHeader) VisitAllCookie(_ func([]byte, []byte)) {}

func (_ *ResponseHeader) VisitAllTrailer(_ func([]byte)) {}

func (_ *ResponseHeader) Write(_ *bufio.Writer) error {
	return nil
}

func (_ *ResponseHeader) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}

type RetryIfFunc func(*Request) bool

type RoundTripper interface {
	RoundTrip(_ *HostClient, _ *Request, _ *Response) (bool, error)
}

func SaveMultipartFile(_ *multipart.FileHeader, _ string) error {
	return nil
}

func Serve(_ net.Listener, _ RequestHandler) error {
	return nil
}

func ServeFile(_ *RequestCtx, _ string) {}

func ServeFileBytes(_ *RequestCtx, _ []byte) {}

func ServeFileBytesUncompressed(_ *RequestCtx, _ []byte) {}

func ServeFileUncompressed(_ *RequestCtx, _ string) {}

type ServeHandler func(net.Conn) error

type Server struct {
	Handler                            RequestHandler
	ErrorHandler                       func(*RequestCtx, error)
	HeaderReceived                     func(*RequestHeader) RequestConfig
	ContinueHandler                    func(*RequestHeader) bool
	Name                               string
	Concurrency                        int
	ReadBufferSize                     int
	WriteBufferSize                    int
	ReadTimeout                        time.Duration
	WriteTimeout                       time.Duration
	IdleTimeout                        time.Duration
	MaxConnsPerIP                      int
	MaxRequestsPerConn                 int
	MaxKeepaliveDuration               time.Duration
	MaxIdleWorkerDuration              time.Duration
	TCPKeepalivePeriod                 time.Duration
	MaxRequestBodySize                 int
	DisableKeepalive                   bool
	TCPKeepalive                       bool
	ReduceMemoryUsage                  bool
	GetOnly                            bool
	DisablePreParseMultipartForm       bool
	LogAllErrors                       bool
	SecureErrorLogMessage              bool
	DisableHeaderNamesNormalizing      bool
	SleepWhenConcurrencyLimitsExceeded time.Duration
	NoDefaultServerHeader              bool
	NoDefaultDate                      bool
	NoDefaultContentType               bool
	KeepHijackedConns                  bool
	CloseOnShutdown                    bool
	StreamRequestBody                  bool
	ConnState                          func(net.Conn, ConnState)
	Logger                             Logger
	TLSConfig                          *tls.Config
	FormValueFunc                      FormValueFunc
}

func (_ *Server) AppendCert(_ string, _ string) error {
	return nil
}

func (_ *Server) AppendCertEmbed(_ []byte, _ []byte) error {
	return nil
}

func (_ *Server) GetCurrentConcurrency() uint32 {
	return 0
}

func (_ *Server) GetOpenConnectionsCount() int32 {
	return 0
}

func (_ *Server) ListenAndServe(_ string) error {
	return nil
}

func (_ *Server) ListenAndServeTLS(_ string, _ string, _ string) error {
	return nil
}

func (_ *Server) ListenAndServeTLSEmbed(_ string, _ []byte, _ []byte) error {
	return nil
}

func (_ *Server) ListenAndServeUNIX(_ string, _ fs.FileMode) error {
	return nil
}

func (_ *Server) NextProto(_ string, _ ServeHandler) {}

func (_ *Server) Serve(_ net.Listener) error {
	return nil
}

func (_ *Server) ServeConn(_ net.Conn) error {
	return nil
}

func (_ *Server) ServeTLS(_ net.Listener, _ string, _ string) error {
	return nil
}

func (_ *Server) ServeTLSEmbed(_ net.Listener, _ []byte, _ []byte) error {
	return nil
}

func (_ *Server) Shutdown() error {
	return nil
}

func (_ *Server) ShutdownWithContext(_ context.Context) error {
	return nil
}

type StreamWriter func(*bufio.Writer)

type TCPDialer struct {
	Concurrency      int
	LocalAddr        *net.TCPAddr
	Resolver         Resolver
	DNSCacheDuration time.Duration
}

func (_ *TCPDialer) Dial(_ string) (net.Conn, error) {
	return nil, nil
}

func (_ *TCPDialer) DialDualStack(_ string) (net.Conn, error) {
	return nil, nil
}

func (_ *TCPDialer) DialDualStackTimeout(_ string, _ time.Duration) (net.Conn, error) {
	return nil, nil
}

func (_ *TCPDialer) DialTimeout(_ string, _ time.Duration) (net.Conn, error) {
	return nil, nil
}

type URI struct {
	DisablePathNormalizing bool
}

func (_ *URI) AppendBytes(_ []byte) []byte {
	return nil
}

func (_ *URI) CopyTo(_ *URI) {}

func (_ *URI) FullURI() []byte {
	return nil
}

func (_ *URI) Hash() []byte {
	return nil
}

func (_ *URI) Host() []byte {
	return nil
}

func (_ *URI) LastPathSegment() []byte {
	return nil
}

func (_ *URI) Parse(_ []byte, _ []byte) error {
	return nil
}

func (_ *URI) Password() []byte {
	return nil
}

func (_ *URI) Path() []byte {
	return nil
}

func (_ *URI) PathOriginal() []byte {
	return nil
}

func (_ *URI) QueryArgs() *Args {
	return nil
}

func (_ *URI) QueryString() []byte {
	return nil
}

func (_ *URI) RequestURI() []byte {
	return nil
}

func (_ *URI) Reset() {}

func (_ *URI) Scheme() []byte {
	return nil
}

func (_ *URI) SetHash(_ string) {}

func (_ *URI) SetHashBytes(_ []byte) {}

func (_ *URI) SetHost(_ string) {}

func (_ *URI) SetHostBytes(_ []byte) {}

func (_ *URI) SetPassword(_ string) {}

func (_ *URI) SetPasswordBytes(_ []byte) {}

func (_ *URI) SetPath(_ string) {}

func (_ *URI) SetPathBytes(_ []byte) {}

func (_ *URI) SetQueryString(_ string) {}

func (_ *URI) SetQueryStringBytes(_ []byte) {}

func (_ *URI) SetScheme(_ string) {}

func (_ *URI) SetSchemeBytes(_ []byte) {}

func (_ *URI) SetUsername(_ string) {}

func (_ *URI) SetUsernameBytes(_ []byte) {}

func (_ *URI) String() string {
	return ""
}

func (_ *URI) Update(_ string) {}

func (_ *URI) UpdateBytes(_ []byte) {}

func (_ *URI) Username() []byte {
	return nil
}

func (_ *URI) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}
