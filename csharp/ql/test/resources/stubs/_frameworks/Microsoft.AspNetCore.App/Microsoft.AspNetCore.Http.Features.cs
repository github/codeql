// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Features, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Antiforgery
        {
            public interface IAntiforgeryValidationFeature
            {
                System.Exception Error { get; }
                bool IsValid { get; }
            }
        }
        namespace Http
        {
            public class CookieOptions
            {
                public Microsoft.Net.Http.Headers.SetCookieHeaderValue CreateCookieHeader(string name, string value) => throw null;
                public CookieOptions() => throw null;
                public CookieOptions(Microsoft.AspNetCore.Http.CookieOptions options) => throw null;
                public string Domain { get => throw null; set { } }
                public System.DateTimeOffset? Expires { get => throw null; set { } }
                public System.Collections.Generic.IList<string> Extensions { get => throw null; }
                public bool HttpOnly { get => throw null; set { } }
                public bool IsEssential { get => throw null; set { } }
                public System.TimeSpan? MaxAge { get => throw null; set { } }
                public string Path { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.SameSiteMode SameSite { get => throw null; set { } }
                public bool Secure { get => throw null; set { } }
            }
            namespace Features
            {
                namespace Authentication
                {
                    public interface IHttpAuthenticationFeature
                    {
                        System.Security.Claims.ClaimsPrincipal User { get; set; }
                    }
                }
                public enum HttpsCompressionMode
                {
                    Default = 0,
                    DoNotCompress = 1,
                    Compress = 2,
                }
                public interface IBadRequestExceptionFeature
                {
                    System.Exception Error { get; }
                }
                public interface IFormFeature
                {
                    Microsoft.AspNetCore.Http.IFormCollection Form { get; set; }
                    bool HasFormContentType { get; }
                    Microsoft.AspNetCore.Http.IFormCollection ReadForm();
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(System.Threading.CancellationToken cancellationToken);
                }
                public interface IHttpBodyControlFeature
                {
                    bool AllowSynchronousIO { get; set; }
                }
                public interface IHttpConnectionFeature
                {
                    string ConnectionId { get; set; }
                    System.Net.IPAddress LocalIpAddress { get; set; }
                    int LocalPort { get; set; }
                    System.Net.IPAddress RemoteIpAddress { get; set; }
                    int RemotePort { get; set; }
                }
                public interface IHttpExtendedConnectFeature
                {
                    System.Threading.Tasks.ValueTask<System.IO.Stream> AcceptAsync();
                    bool IsExtendedConnect { get; }
                    string Protocol { get; }
                }
                public interface IHttpMaxRequestBodySizeFeature
                {
                    bool IsReadOnly { get; }
                    long? MaxRequestBodySize { get; set; }
                }
                public interface IHttpMetricsTagsFeature
                {
                    System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>> Tags { get; }
                }
                public interface IHttpRequestBodyDetectionFeature
                {
                    bool CanHaveBody { get; }
                }
                public interface IHttpRequestFeature
                {
                    System.IO.Stream Body { get; set; }
                    Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; set; }
                    string Method { get; set; }
                    string Path { get; set; }
                    string PathBase { get; set; }
                    string Protocol { get; set; }
                    string QueryString { get; set; }
                    string RawTarget { get; set; }
                    string Scheme { get; set; }
                }
                public interface IHttpRequestIdentifierFeature
                {
                    string TraceIdentifier { get; set; }
                }
                public interface IHttpRequestLifetimeFeature
                {
                    void Abort();
                    System.Threading.CancellationToken RequestAborted { get; set; }
                }
                public interface IHttpRequestTrailersFeature
                {
                    bool Available { get; }
                    Microsoft.AspNetCore.Http.IHeaderDictionary Trailers { get; }
                }
                public interface IHttpResetFeature
                {
                    void Reset(int errorCode);
                }
                public interface IHttpResponseBodyFeature
                {
                    System.Threading.Tasks.Task CompleteAsync();
                    void DisableBuffering();
                    System.Threading.Tasks.Task SendFileAsync(string path, long offset, long? count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.IO.Stream Stream { get; }
                    System.IO.Pipelines.PipeWriter Writer { get; }
                }
                public interface IHttpResponseFeature
                {
                    System.IO.Stream Body { get; set; }
                    bool HasStarted { get; }
                    Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; set; }
                    void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                    void OnStarting(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                    string ReasonPhrase { get; set; }
                    int StatusCode { get; set; }
                }
                public interface IHttpResponseTrailersFeature
                {
                    Microsoft.AspNetCore.Http.IHeaderDictionary Trailers { get; set; }
                }
                public interface IHttpsCompressionFeature
                {
                    Microsoft.AspNetCore.Http.Features.HttpsCompressionMode Mode { get; set; }
                }
                public interface IHttpUpgradeFeature
                {
                    bool IsUpgradableRequest { get; }
                    System.Threading.Tasks.Task<System.IO.Stream> UpgradeAsync();
                }
                public interface IHttpWebSocketFeature
                {
                    System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptAsync(Microsoft.AspNetCore.Http.WebSocketAcceptContext context);
                    bool IsWebSocketRequest { get; }
                }
                public interface IHttpWebTransportFeature
                {
                    System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Http.Features.IWebTransportSession> AcceptAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    bool IsWebTransportRequest { get; }
                }
                public interface IItemsFeature
                {
                    System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                }
                public interface IQueryFeature
                {
                    Microsoft.AspNetCore.Http.IQueryCollection Query { get; set; }
                }
                public interface IRequestBodyPipeFeature
                {
                    System.IO.Pipelines.PipeReader Reader { get; }
                }
                public interface IRequestCookiesFeature
                {
                    Microsoft.AspNetCore.Http.IRequestCookieCollection Cookies { get; set; }
                }
                public interface IResponseCookiesFeature
                {
                    Microsoft.AspNetCore.Http.IResponseCookies Cookies { get; }
                }
                public interface IServerVariablesFeature
                {
                    string this[string variableName] { get; set; }
                }
                public interface IServiceProvidersFeature
                {
                    System.IServiceProvider RequestServices { get; set; }
                }
                public interface ISessionFeature
                {
                    Microsoft.AspNetCore.Http.ISession Session { get; set; }
                }
                public interface ITlsConnectionFeature
                {
                    System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCertificate { get; set; }
                    System.Threading.Tasks.Task<System.Security.Cryptography.X509Certificates.X509Certificate2> GetClientCertificateAsync(System.Threading.CancellationToken cancellationToken);
                }
                public interface ITlsTokenBindingFeature
                {
                    byte[] GetProvidedTokenBindingId();
                    byte[] GetReferredTokenBindingId();
                }
                public interface ITrackingConsentFeature
                {
                    bool CanTrack { get; }
                    string CreateConsentCookie();
                    void GrantConsent();
                    bool HasConsent { get; }
                    bool IsConsentNeeded { get; }
                    void WithdrawConsent();
                }
                public interface IWebTransportSession
                {
                    void Abort(int errorCode);
                    System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> AcceptStreamAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> OpenUnidirectionalStreamAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    long SessionId { get; }
                }
            }
            public interface IFormCollection : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerable
            {
                bool ContainsKey(string key);
                int Count { get; }
                Microsoft.AspNetCore.Http.IFormFileCollection Files { get; }
                System.Collections.Generic.ICollection<string> Keys { get; }
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; }
                bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value);
            }
            public interface IFormFile
            {
                string ContentDisposition { get; }
                string ContentType { get; }
                void CopyTo(System.IO.Stream target);
                System.Threading.Tasks.Task CopyToAsync(System.IO.Stream target, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                string FileName { get; }
                Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                long Length { get; }
                string Name { get; }
                System.IO.Stream OpenReadStream();
            }
            public interface IFormFileCollection : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile>
            {
                Microsoft.AspNetCore.Http.IFormFile GetFile(string name);
                System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile> GetFiles(string name);
                Microsoft.AspNetCore.Http.IFormFile this[string name] { get; }
            }
            public interface IHeaderDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerable
            {
                virtual Microsoft.Extensions.Primitives.StringValues Accept { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AcceptCharset { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AcceptEncoding { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AcceptLanguage { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AcceptRanges { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlAllowCredentials { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlAllowHeaders { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlAllowMethods { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlAllowOrigin { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlExposeHeaders { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlMaxAge { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlRequestHeaders { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AccessControlRequestMethod { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Age { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Allow { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues AltSvc { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Authorization { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Baggage { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues CacheControl { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Connection { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentDisposition { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentEncoding { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentLanguage { get => throw null; set { } }
                long? ContentLength { get; set; }
                virtual Microsoft.Extensions.Primitives.StringValues ContentLocation { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentMD5 { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentRange { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentSecurityPolicy { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentSecurityPolicyReportOnly { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ContentType { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Cookie { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues CorrelationContext { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Date { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ETag { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Expect { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Expires { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues From { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues GrpcAcceptEncoding { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues GrpcEncoding { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues GrpcMessage { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues GrpcStatus { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues GrpcTimeout { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Host { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues IfMatch { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues IfModifiedSince { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues IfNoneMatch { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues IfRange { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues IfUnmodifiedSince { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues KeepAlive { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues LastModified { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Link { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Location { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues MaxForwards { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Origin { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Pragma { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ProxyAuthenticate { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ProxyAuthorization { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues ProxyConnection { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Range { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Referer { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues RequestId { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues RetryAfter { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues SecWebSocketAccept { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues SecWebSocketExtensions { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues SecWebSocketKey { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues SecWebSocketProtocol { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues SecWebSocketVersion { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Server { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues SetCookie { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues StrictTransportSecurity { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues TE { get => throw null; set { } }
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; set; }
                virtual Microsoft.Extensions.Primitives.StringValues TraceParent { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues TraceState { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Trailer { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues TransferEncoding { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Translate { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Upgrade { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues UpgradeInsecureRequests { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues UserAgent { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Vary { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Via { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues Warning { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues WebSocketSubProtocols { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues WWWAuthenticate { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues XContentTypeOptions { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues XFrameOptions { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues XPoweredBy { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues XRequestedWith { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues XUACompatible { get => throw null; set { } }
                virtual Microsoft.Extensions.Primitives.StringValues XXSSProtection { get => throw null; set { } }
            }
            public interface IQueryCollection : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerable
            {
                bool ContainsKey(string key);
                int Count { get; }
                System.Collections.Generic.ICollection<string> Keys { get; }
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; }
                bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value);
            }
            public interface IRequestCookieCollection : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable
            {
                bool ContainsKey(string key);
                int Count { get; }
                System.Collections.Generic.ICollection<string> Keys { get; }
                string this[string key] { get; }
                bool TryGetValue(string key, out string value);
            }
            public interface IResponseCookies
            {
                void Append(string key, string value);
                void Append(string key, string value, Microsoft.AspNetCore.Http.CookieOptions options);
                virtual void Append(System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, string>> keyValuePairs, Microsoft.AspNetCore.Http.CookieOptions options) => throw null;
                void Delete(string key);
                void Delete(string key, Microsoft.AspNetCore.Http.CookieOptions options);
            }
            public interface ISession
            {
                void Clear();
                System.Threading.Tasks.Task CommitAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                string Id { get; }
                bool IsAvailable { get; }
                System.Collections.Generic.IEnumerable<string> Keys { get; }
                System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                void Remove(string key);
                void Set(string key, byte[] value);
                bool TryGetValue(string key, out byte[] value);
            }
            public enum SameSiteMode
            {
                Unspecified = -1,
                None = 0,
                Lax = 1,
                Strict = 2,
            }
            public class WebSocketAcceptContext
            {
                public WebSocketAcceptContext() => throw null;
                public bool DangerousEnableCompression { get => throw null; set { } }
                public bool DisableServerContextTakeover { get => throw null; set { } }
                public virtual System.TimeSpan? KeepAliveInterval { get => throw null; set { } }
                public int ServerMaxWindowBits { get => throw null; set { } }
                public virtual string SubProtocol { get => throw null; set { } }
            }
        }
    }
}
