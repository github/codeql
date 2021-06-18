// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            // Generated from `Microsoft.AspNetCore.Http.CookieOptions` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CookieOptions
            {
                public CookieOptions() => throw null;
                public string Domain { get => throw null; set => throw null; }
                public System.DateTimeOffset? Expires { get => throw null; set => throw null; }
                public bool HttpOnly { get => throw null; set => throw null; }
                public bool IsEssential { get => throw null; set => throw null; }
                public System.TimeSpan? MaxAge { get => throw null; set => throw null; }
                public string Path { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.SameSiteMode SameSite { get => throw null; set => throw null; }
                public bool Secure { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.IFormCollection` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IFormCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
            {
                bool ContainsKey(string key);
                int Count { get; }
                Microsoft.AspNetCore.Http.IFormFileCollection Files { get; }
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; }
                System.Collections.Generic.ICollection<string> Keys { get; }
                bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value);
            }

            // Generated from `Microsoft.AspNetCore.Http.IFormFile` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IFormFile
            {
                string ContentDisposition { get; }
                string ContentType { get; }
                void CopyTo(System.IO.Stream target);
                System.Threading.Tasks.Task CopyToAsync(System.IO.Stream target, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                string FileName { get; }
                Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                System.Int64 Length { get; }
                string Name { get; }
                System.IO.Stream OpenReadStream();
            }

            // Generated from `Microsoft.AspNetCore.Http.IFormFileCollection` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IFormFileCollection : System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.IFormFile>
            {
                Microsoft.AspNetCore.Http.IFormFile GetFile(string name);
                System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile> GetFiles(string name);
                Microsoft.AspNetCore.Http.IFormFile this[string name] { get; }
            }

            // Generated from `Microsoft.AspNetCore.Http.IHeaderDictionary` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHeaderDictionary : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
            {
                System.Int64? ContentLength { get; set; }
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.IQueryCollection` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IQueryCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
            {
                bool ContainsKey(string key);
                int Count { get; }
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; }
                System.Collections.Generic.ICollection<string> Keys { get; }
                bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value);
            }

            // Generated from `Microsoft.AspNetCore.Http.IRequestCookieCollection` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRequestCookieCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>
            {
                bool ContainsKey(string key);
                int Count { get; }
                string this[string key] { get; }
                System.Collections.Generic.ICollection<string> Keys { get; }
                bool TryGetValue(string key, out string value);
            }

            // Generated from `Microsoft.AspNetCore.Http.IResponseCookies` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IResponseCookies
            {
                void Append(string key, string value, Microsoft.AspNetCore.Http.CookieOptions options);
                void Append(string key, string value);
                void Delete(string key, Microsoft.AspNetCore.Http.CookieOptions options);
                void Delete(string key);
            }

            // Generated from `Microsoft.AspNetCore.Http.ISession` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISession
            {
                void Clear();
                System.Threading.Tasks.Task CommitAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                string Id { get; }
                bool IsAvailable { get; }
                System.Collections.Generic.IEnumerable<string> Keys { get; }
                System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                void Remove(string key);
                void Set(string key, System.Byte[] value);
                bool TryGetValue(string key, out System.Byte[] value);
            }

            // Generated from `Microsoft.AspNetCore.Http.SameSiteMode` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum SameSiteMode
            {
                Lax,
                None,
                Strict,
                Unspecified,
            }

            // Generated from `Microsoft.AspNetCore.Http.WebSocketAcceptContext` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WebSocketAcceptContext
            {
                public virtual string SubProtocol { get => throw null; set => throw null; }
                public WebSocketAcceptContext() => throw null;
            }

            namespace Features
            {
                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureCollection` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FeatureCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.Type, object>>, Microsoft.AspNetCore.Http.Features.IFeatureCollection
                {
                    public FeatureCollection(Microsoft.AspNetCore.Http.Features.IFeatureCollection defaults) => throw null;
                    public FeatureCollection() => throw null;
                    public TFeature Get<TFeature>() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<System.Type, object>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public object this[System.Type key] { get => throw null; set => throw null; }
                    public virtual int Revision { get => throw null; }
                    public void Set<TFeature>(TFeature instance) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureReference<>` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct FeatureReference<T>
                {
                    public static Microsoft.AspNetCore.Http.Features.FeatureReference<T> Default;
                    // Stub generator skipped constructor 
                    public T Fetch(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                    public T Update(Microsoft.AspNetCore.Http.Features.IFeatureCollection features, T feature) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureReferences<>` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct FeatureReferences<TCache>
                {
                    public TCache Cache;
                    public Microsoft.AspNetCore.Http.Features.IFeatureCollection Collection { get => throw null; }
                    public FeatureReferences(Microsoft.AspNetCore.Http.Features.IFeatureCollection collection) => throw null;
                    // Stub generator skipped constructor 
                    public TFeature Fetch<TFeature>(ref TFeature cached, System.Func<Microsoft.AspNetCore.Http.Features.IFeatureCollection, TFeature> factory) where TFeature : class => throw null;
                    public TFeature Fetch<TFeature, TState>(ref TFeature cached, TState state, System.Func<TState, TFeature> factory) where TFeature : class => throw null;
                    public void Initalize(Microsoft.AspNetCore.Http.Features.IFeatureCollection collection, int revision) => throw null;
                    public void Initalize(Microsoft.AspNetCore.Http.Features.IFeatureCollection collection) => throw null;
                    public int Revision { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.HttpsCompressionMode` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum HttpsCompressionMode
                {
                    Compress,
                    Default,
                    DoNotCompress,
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IFeatureCollection` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFeatureCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.Type, object>>
                {
                    TFeature Get<TFeature>();
                    bool IsReadOnly { get; }
                    object this[System.Type key] { get; set; }
                    int Revision { get; }
                    void Set<TFeature>(TFeature instance);
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IFormFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFormFeature
                {
                    Microsoft.AspNetCore.Http.IFormCollection Form { get; set; }
                    bool HasFormContentType { get; }
                    Microsoft.AspNetCore.Http.IFormCollection ReadForm();
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(System.Threading.CancellationToken cancellationToken);
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpBodyControlFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpBodyControlFeature
                {
                    bool AllowSynchronousIO { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpBufferingFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpBufferingFeature
                {
                    void DisableRequestBuffering();
                    void DisableResponseBuffering();
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpConnectionFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpConnectionFeature
                {
                    string ConnectionId { get; set; }
                    System.Net.IPAddress LocalIpAddress { get; set; }
                    int LocalPort { get; set; }
                    System.Net.IPAddress RemoteIpAddress { get; set; }
                    int RemotePort { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpMaxRequestBodySizeFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpMaxRequestBodySizeFeature
                {
                    bool IsReadOnly { get; }
                    System.Int64? MaxRequestBodySize { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpRequestBodyDetectionFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpRequestBodyDetectionFeature
                {
                    bool CanHaveBody { get; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpRequestFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpRequestIdentifierFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpRequestIdentifierFeature
                {
                    string TraceIdentifier { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpRequestLifetimeFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpRequestLifetimeFeature
                {
                    void Abort();
                    System.Threading.CancellationToken RequestAborted { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpRequestTrailersFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpRequestTrailersFeature
                {
                    bool Available { get; }
                    Microsoft.AspNetCore.Http.IHeaderDictionary Trailers { get; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpResetFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpResetFeature
                {
                    void Reset(int errorCode);
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpResponseBodyFeature
                {
                    System.Threading.Tasks.Task CompleteAsync();
                    void DisableBuffering();
                    System.Threading.Tasks.Task SendFileAsync(string path, System.Int64 offset, System.Int64? count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.IO.Stream Stream { get; }
                    System.IO.Pipelines.PipeWriter Writer { get; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpResponseFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpResponseTrailersFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpResponseTrailersFeature
                {
                    Microsoft.AspNetCore.Http.IHeaderDictionary Trailers { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpSendFileFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpSendFileFeature
                {
                    System.Threading.Tasks.Task SendFileAsync(string path, System.Int64 offset, System.Int64? count, System.Threading.CancellationToken cancellation);
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpUpgradeFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpUpgradeFeature
                {
                    bool IsUpgradableRequest { get; }
                    System.Threading.Tasks.Task<System.IO.Stream> UpgradeAsync();
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpWebSocketFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpWebSocketFeature
                {
                    System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptAsync(Microsoft.AspNetCore.Http.WebSocketAcceptContext context);
                    bool IsWebSocketRequest { get; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IHttpsCompressionFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpsCompressionFeature
                {
                    Microsoft.AspNetCore.Http.Features.HttpsCompressionMode Mode { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IItemsFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IItemsFeature
                {
                    System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IQueryFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IQueryFeature
                {
                    Microsoft.AspNetCore.Http.IQueryCollection Query { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IRequestBodyPipeFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRequestBodyPipeFeature
                {
                    System.IO.Pipelines.PipeReader Reader { get; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IRequestCookiesFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRequestCookiesFeature
                {
                    Microsoft.AspNetCore.Http.IRequestCookieCollection Cookies { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IResponseCookiesFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IResponseCookiesFeature
                {
                    Microsoft.AspNetCore.Http.IResponseCookies Cookies { get; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IServerVariablesFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IServerVariablesFeature
                {
                    string this[string variableName] { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IServiceProvidersFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IServiceProvidersFeature
                {
                    System.IServiceProvider RequestServices { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ISessionFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ISessionFeature
                {
                    Microsoft.AspNetCore.Http.ISession Session { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ITlsConnectionFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITlsConnectionFeature
                {
                    System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCertificate { get; set; }
                    System.Threading.Tasks.Task<System.Security.Cryptography.X509Certificates.X509Certificate2> GetClientCertificateAsync(System.Threading.CancellationToken cancellationToken);
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ITlsTokenBindingFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITlsTokenBindingFeature
                {
                    System.Byte[] GetProvidedTokenBindingId();
                    System.Byte[] GetReferredTokenBindingId();
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ITrackingConsentFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITrackingConsentFeature
                {
                    bool CanTrack { get; }
                    string CreateConsentCookie();
                    void GrantConsent();
                    bool HasConsent { get; }
                    bool IsConsentNeeded { get; }
                    void WithdrawConsent();
                }

                namespace Authentication
                {
                    // Generated from `Microsoft.AspNetCore.Http.Features.Authentication.IHttpAuthenticationFeature` in `Microsoft.AspNetCore.Http.Features, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IHttpAuthenticationFeature
                    {
                        System.Security.Claims.ClaimsPrincipal User { get; set; }
                    }

                }
            }
        }
    }
}
