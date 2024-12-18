// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public class ApplicationBuilder : Microsoft.AspNetCore.Builder.IApplicationBuilder
            {
                public System.IServiceProvider ApplicationServices { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.RequestDelegate Build() => throw null;
                public ApplicationBuilder(System.IServiceProvider serviceProvider) => throw null;
                public ApplicationBuilder(System.IServiceProvider serviceProvider, object server) => throw null;
                public Microsoft.AspNetCore.Builder.IApplicationBuilder New() => throw null;
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public Microsoft.AspNetCore.Http.Features.IFeatureCollection ServerFeatures { get => throw null; }
                public Microsoft.AspNetCore.Builder.IApplicationBuilder Use(System.Func<Microsoft.AspNetCore.Http.RequestDelegate, Microsoft.AspNetCore.Http.RequestDelegate> middleware) => throw null;
            }
            public static partial class RequestTimeoutsIApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestTimeouts(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }
            public static partial class RequestTimeoutsIEndpointConventionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder DisableRequestTimeout(this Microsoft.AspNetCore.Builder.IEndpointConventionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder WithRequestTimeout(this Microsoft.AspNetCore.Builder.IEndpointConventionBuilder builder, System.TimeSpan timeout) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder WithRequestTimeout(this Microsoft.AspNetCore.Builder.IEndpointConventionBuilder builder, string policyName) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder WithRequestTimeout(this Microsoft.AspNetCore.Builder.IEndpointConventionBuilder builder, Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutPolicy policy) => throw null;
            }
        }
        namespace Http
        {
            public class BindingAddress
            {
                public BindingAddress() => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string Host { get => throw null; }
                public bool IsNamedPipe { get => throw null; }
                public bool IsUnixPipe { get => throw null; }
                public string NamedPipeName { get => throw null; }
                public static Microsoft.AspNetCore.Http.BindingAddress Parse(string address) => throw null;
                public string PathBase { get => throw null; }
                public int Port { get => throw null; }
                public string Scheme { get => throw null; }
                public override string ToString() => throw null;
                public string UnixPipePath { get => throw null; }
            }
            public sealed class DefaultHttpContext : Microsoft.AspNetCore.Http.HttpContext
            {
                public override void Abort() => throw null;
                public override Microsoft.AspNetCore.Http.ConnectionInfo Connection { get => throw null; }
                public DefaultHttpContext() => throw null;
                public DefaultHttpContext(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                public override Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                public Microsoft.AspNetCore.Http.Features.FormOptions FormOptions { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public void Initialize(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                public override System.Collections.Generic.IDictionary<object, object> Items { get => throw null; set { } }
                public override Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                public override System.Threading.CancellationToken RequestAborted { get => throw null; set { } }
                public override System.IServiceProvider RequestServices { get => throw null; set { } }
                public override Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.IServiceScopeFactory ServiceScopeFactory { get => throw null; set { } }
                public override Microsoft.AspNetCore.Http.ISession Session { get => throw null; set { } }
                public override string TraceIdentifier { get => throw null; set { } }
                public void Uninitialize() => throw null;
                public override System.Security.Claims.ClaimsPrincipal User { get => throw null; set { } }
                public override Microsoft.AspNetCore.Http.WebSocketManager WebSockets { get => throw null; }
            }
            namespace Features
            {
                namespace Authentication
                {
                    public class HttpAuthenticationFeature : Microsoft.AspNetCore.Http.Features.Authentication.IHttpAuthenticationFeature
                    {
                        public HttpAuthenticationFeature() => throw null;
                        public System.Security.Claims.ClaimsPrincipal User { get => throw null; set { } }
                    }
                }
                public class DefaultSessionFeature : Microsoft.AspNetCore.Http.Features.ISessionFeature
                {
                    public DefaultSessionFeature() => throw null;
                    public Microsoft.AspNetCore.Http.ISession Session { get => throw null; set { } }
                }
                public class FormFeature : Microsoft.AspNetCore.Http.Features.IFormFeature
                {
                    public FormFeature(Microsoft.AspNetCore.Http.IFormCollection form) => throw null;
                    public FormFeature(Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                    public FormFeature(Microsoft.AspNetCore.Http.HttpRequest request, Microsoft.AspNetCore.Http.Features.FormOptions options) => throw null;
                    public Microsoft.AspNetCore.Http.IFormCollection Form { get => throw null; set { } }
                    public bool HasFormContentType { get => throw null; }
                    public Microsoft.AspNetCore.Http.IFormCollection ReadForm() => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync() => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                }
                public class FormOptions
                {
                    public bool BufferBody { get => throw null; set { } }
                    public long BufferBodyLengthLimit { get => throw null; set { } }
                    public FormOptions() => throw null;
                    public const int DefaultBufferBodyLengthLimit = 134217728;
                    public const int DefaultMemoryBufferThreshold = 65536;
                    public const long DefaultMultipartBodyLengthLimit = 134217728;
                    public const int DefaultMultipartBoundaryLengthLimit = 128;
                    public int KeyLengthLimit { get => throw null; set { } }
                    public int MemoryBufferThreshold { get => throw null; set { } }
                    public long MultipartBodyLengthLimit { get => throw null; set { } }
                    public int MultipartBoundaryLengthLimit { get => throw null; set { } }
                    public int MultipartHeadersCountLimit { get => throw null; set { } }
                    public int MultipartHeadersLengthLimit { get => throw null; set { } }
                    public int ValueCountLimit { get => throw null; set { } }
                    public int ValueLengthLimit { get => throw null; set { } }
                }
                public class HttpConnectionFeature : Microsoft.AspNetCore.Http.Features.IHttpConnectionFeature
                {
                    public string ConnectionId { get => throw null; set { } }
                    public HttpConnectionFeature() => throw null;
                    public System.Net.IPAddress LocalIpAddress { get => throw null; set { } }
                    public int LocalPort { get => throw null; set { } }
                    public System.Net.IPAddress RemoteIpAddress { get => throw null; set { } }
                    public int RemotePort { get => throw null; set { } }
                }
                public class HttpRequestFeature : Microsoft.AspNetCore.Http.Features.IHttpRequestFeature
                {
                    public System.IO.Stream Body { get => throw null; set { } }
                    public HttpRequestFeature() => throw null;
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; set { } }
                    public string Method { get => throw null; set { } }
                    public string Path { get => throw null; set { } }
                    public string PathBase { get => throw null; set { } }
                    public string Protocol { get => throw null; set { } }
                    public string QueryString { get => throw null; set { } }
                    public string RawTarget { get => throw null; set { } }
                    public string Scheme { get => throw null; set { } }
                }
                public class HttpRequestIdentifierFeature : Microsoft.AspNetCore.Http.Features.IHttpRequestIdentifierFeature
                {
                    public HttpRequestIdentifierFeature() => throw null;
                    public string TraceIdentifier { get => throw null; set { } }
                }
                public class HttpRequestLifetimeFeature : Microsoft.AspNetCore.Http.Features.IHttpRequestLifetimeFeature
                {
                    public void Abort() => throw null;
                    public HttpRequestLifetimeFeature() => throw null;
                    public System.Threading.CancellationToken RequestAborted { get => throw null; set { } }
                }
                public class HttpResponseFeature : Microsoft.AspNetCore.Http.Features.IHttpResponseFeature
                {
                    public System.IO.Stream Body { get => throw null; set { } }
                    public HttpResponseFeature() => throw null;
                    public virtual bool HasStarted { get => throw null; }
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; set { } }
                    public virtual void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state) => throw null;
                    public virtual void OnStarting(System.Func<object, System.Threading.Tasks.Task> callback, object state) => throw null;
                    public string ReasonPhrase { get => throw null; set { } }
                    public int StatusCode { get => throw null; set { } }
                }
                public interface IHttpActivityFeature
                {
                    System.Diagnostics.Activity Activity { get; set; }
                }
                public class ItemsFeature : Microsoft.AspNetCore.Http.Features.IItemsFeature
                {
                    public ItemsFeature() => throw null;
                    public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; set { } }
                }
                public class QueryFeature : Microsoft.AspNetCore.Http.Features.IQueryFeature
                {
                    public QueryFeature(Microsoft.AspNetCore.Http.IQueryCollection query) => throw null;
                    public QueryFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                    public Microsoft.AspNetCore.Http.IQueryCollection Query { get => throw null; set { } }
                }
                public class RequestBodyPipeFeature : Microsoft.AspNetCore.Http.Features.IRequestBodyPipeFeature
                {
                    public RequestBodyPipeFeature(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public System.IO.Pipelines.PipeReader Reader { get => throw null; }
                }
                public class RequestCookiesFeature : Microsoft.AspNetCore.Http.Features.IRequestCookiesFeature
                {
                    public Microsoft.AspNetCore.Http.IRequestCookieCollection Cookies { get => throw null; set { } }
                    public RequestCookiesFeature(Microsoft.AspNetCore.Http.IRequestCookieCollection cookies) => throw null;
                    public RequestCookiesFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                }
                public class RequestServicesFeature : System.IAsyncDisposable, System.IDisposable, Microsoft.AspNetCore.Http.Features.IServiceProvidersFeature
                {
                    public RequestServicesFeature(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.Extensions.DependencyInjection.IServiceScopeFactory scopeFactory) => throw null;
                    public void Dispose() => throw null;
                    public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                    public System.IServiceProvider RequestServices { get => throw null; set { } }
                }
                public class ResponseCookiesFeature : Microsoft.AspNetCore.Http.Features.IResponseCookiesFeature
                {
                    public Microsoft.AspNetCore.Http.IResponseCookies Cookies { get => throw null; }
                    public ResponseCookiesFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                    public ResponseCookiesFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features, Microsoft.Extensions.ObjectPool.ObjectPool<System.Text.StringBuilder> builderPool) => throw null;
                }
                public class RouteValuesFeature : Microsoft.AspNetCore.Http.Features.IRouteValuesFeature
                {
                    public RouteValuesFeature() => throw null;
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                }
                public class ServiceProvidersFeature : Microsoft.AspNetCore.Http.Features.IServiceProvidersFeature
                {
                    public ServiceProvidersFeature() => throw null;
                    public System.IServiceProvider RequestServices { get => throw null; set { } }
                }
                public class TlsConnectionFeature : Microsoft.AspNetCore.Http.Features.ITlsConnectionFeature
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCertificate { get => throw null; set { } }
                    public TlsConnectionFeature() => throw null;
                    public System.Threading.Tasks.Task<System.Security.Cryptography.X509Certificates.X509Certificate2> GetClientCertificateAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                }
            }
            public class FormCollection : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerable, Microsoft.AspNetCore.Http.IFormCollection
            {
                public bool ContainsKey(string key) => throw null;
                public int Count { get => throw null; }
                public FormCollection(System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> fields, Microsoft.AspNetCore.Http.IFormFileCollection files = default(Microsoft.AspNetCore.Http.IFormFileCollection)) => throw null;
                public static readonly Microsoft.AspNetCore.Http.FormCollection Empty;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerator
                {
                    public System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public Microsoft.AspNetCore.Http.IFormFileCollection Files { get => throw null; }
                public Microsoft.AspNetCore.Http.FormCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                public Microsoft.Extensions.Primitives.StringValues this[string key] { get => throw null; }
                public bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value) => throw null;
            }
            public class FormFile : Microsoft.AspNetCore.Http.IFormFile
            {
                public string ContentDisposition { get => throw null; set { } }
                public string ContentType { get => throw null; set { } }
                public void CopyTo(System.IO.Stream target) => throw null;
                public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream target, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public FormFile(System.IO.Stream baseStream, long baseStreamOffset, long length, string name, string fileName) => throw null;
                public string FileName { get => throw null; }
                public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; set { } }
                public long Length { get => throw null; }
                public string Name { get => throw null; }
                public System.IO.Stream OpenReadStream() => throw null;
            }
            public class FormFileCollection : System.Collections.Generic.List<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.IEnumerable, Microsoft.AspNetCore.Http.IFormFileCollection, System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile>
            {
                public FormFileCollection() => throw null;
                public Microsoft.AspNetCore.Http.IFormFile GetFile(string name) => throw null;
                public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile> GetFiles(string name) => throw null;
                public Microsoft.AspNetCore.Http.IFormFile this[string name] { get => throw null; }
            }
            public class HeaderDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerable, Microsoft.AspNetCore.Http.IHeaderDictionary
            {
                public void Add(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> item) => throw null;
                public void Add(string key, Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public void Clear() => throw null;
                public bool Contains(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> item) => throw null;
                public bool ContainsKey(string key) => throw null;
                public long? ContentLength { get => throw null; set { } }
                public void CopyTo(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public HeaderDictionary() => throw null;
                public HeaderDictionary(System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> store) => throw null;
                public HeaderDictionary(int capacity) => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerator
                {
                    public System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public Microsoft.AspNetCore.Http.HeaderDictionary.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsReadOnly { get => throw null; set { } }
                Microsoft.Extensions.Primitives.StringValues System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>.this[string key] { get => throw null; set { } }
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                public bool Remove(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> item) => throw null;
                public bool Remove(string key) => throw null;
                public Microsoft.Extensions.Primitives.StringValues this[string key] { get => throw null; set { } }
                public bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public System.Collections.Generic.ICollection<Microsoft.Extensions.Primitives.StringValues> Values { get => throw null; }
            }
            public class HttpContextAccessor : Microsoft.AspNetCore.Http.IHttpContextAccessor
            {
                public HttpContextAccessor() => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set { } }
            }
            public static partial class HttpRequestRewindExtensions
            {
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request, int bufferThreshold) => throw null;
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request, long bufferLimit) => throw null;
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request, int bufferThreshold, long bufferLimit) => throw null;
            }
            public class MiddlewareFactory : Microsoft.AspNetCore.Http.IMiddlewareFactory
            {
                public Microsoft.AspNetCore.Http.IMiddleware Create(System.Type middlewareType) => throw null;
                public MiddlewareFactory(System.IServiceProvider serviceProvider) => throw null;
                public void Release(Microsoft.AspNetCore.Http.IMiddleware middleware) => throw null;
            }
            public class QueryCollection : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerable, Microsoft.AspNetCore.Http.IQueryCollection
            {
                public bool ContainsKey(string key) => throw null;
                public int Count { get => throw null; }
                public QueryCollection() => throw null;
                public QueryCollection(System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> store) => throw null;
                public QueryCollection(Microsoft.AspNetCore.Http.QueryCollection store) => throw null;
                public QueryCollection(int capacity) => throw null;
                public static readonly Microsoft.AspNetCore.Http.QueryCollection Empty;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.IEnumerator
                {
                    public System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public Microsoft.AspNetCore.Http.QueryCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                public Microsoft.Extensions.Primitives.StringValues this[string key] { get => throw null; }
                public bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value) => throw null;
            }
            public static partial class RequestFormReaderExtensions
            {
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(this Microsoft.AspNetCore.Http.HttpRequest request, Microsoft.AspNetCore.Http.Features.FormOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public static class SendFileFallback
            {
                public static System.Threading.Tasks.Task SendFileAsync(System.IO.Stream destination, string filePath, long offset, long? count, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public class StreamResponseBodyFeature : Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature
            {
                public virtual System.Threading.Tasks.Task CompleteAsync() => throw null;
                public StreamResponseBodyFeature(System.IO.Stream stream) => throw null;
                public StreamResponseBodyFeature(System.IO.Stream stream, Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature priorFeature) => throw null;
                public virtual void DisableBuffering() => throw null;
                public void Dispose() => throw null;
                public Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature PriorFeature { get => throw null; }
                public virtual System.Threading.Tasks.Task SendFileAsync(string path, long offset, long? count, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.IO.Stream Stream { get => throw null; }
                public System.IO.Pipelines.PipeWriter Writer { get => throw null; }
            }
            namespace Timeouts
            {
                [System.AttributeUsage((System.AttributeTargets)68)]
                public sealed class DisableRequestTimeoutAttribute : System.Attribute
                {
                    public DisableRequestTimeoutAttribute() => throw null;
                }
                public interface IHttpRequestTimeoutFeature
                {
                    void DisableTimeout();
                    System.Threading.CancellationToken RequestTimeoutToken { get; }
                }
                [System.AttributeUsage((System.AttributeTargets)68)]
                public sealed class RequestTimeoutAttribute : System.Attribute
                {
                    public RequestTimeoutAttribute(int milliseconds) => throw null;
                    public RequestTimeoutAttribute(string policyName) => throw null;
                    public string PolicyName { get => throw null; }
                    public System.TimeSpan? Timeout { get => throw null; }
                }
                public sealed class RequestTimeoutOptions
                {
                    public Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutOptions AddPolicy(string policyName, System.TimeSpan timeout) => throw null;
                    public Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutOptions AddPolicy(string policyName, Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutPolicy policy) => throw null;
                    public RequestTimeoutOptions() => throw null;
                    public Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutPolicy DefaultPolicy { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutPolicy> Policies { get => throw null; }
                }
                public sealed class RequestTimeoutPolicy
                {
                    public RequestTimeoutPolicy() => throw null;
                    public System.TimeSpan? Timeout { get => throw null; set { } }
                    public int? TimeoutStatusCode { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.RequestDelegate WriteTimeoutResponse { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class HttpServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpContextAccessor(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }
            public static partial class RequestTimeoutsIServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestTimeouts(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestTimeouts(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Http.Timeouts.RequestTimeoutOptions> configure) => throw null;
            }
        }
    }
}
