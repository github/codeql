// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.ApplicationBuilder` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApplicationBuilder : Microsoft.AspNetCore.Builder.IApplicationBuilder
            {
                public ApplicationBuilder(System.IServiceProvider serviceProvider, object server) => throw null;
                public ApplicationBuilder(System.IServiceProvider serviceProvider) => throw null;
                public System.IServiceProvider ApplicationServices { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate Build() => throw null;
                public Microsoft.AspNetCore.Builder.IApplicationBuilder New() => throw null;
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public Microsoft.AspNetCore.Http.Features.IFeatureCollection ServerFeatures { get => throw null; }
                public Microsoft.AspNetCore.Builder.IApplicationBuilder Use(System.Func<Microsoft.AspNetCore.Http.RequestDelegate, Microsoft.AspNetCore.Http.RequestDelegate> middleware) => throw null;
            }

        }
        namespace Http
        {
            // Generated from `Microsoft.AspNetCore.Http.BindingAddress` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BindingAddress
            {
                public BindingAddress() => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string Host { get => throw null; }
                public bool IsUnixPipe { get => throw null; }
                public static Microsoft.AspNetCore.Http.BindingAddress Parse(string address) => throw null;
                public string PathBase { get => throw null; }
                public int Port { get => throw null; set => throw null; }
                public string Scheme { get => throw null; }
                public override string ToString() => throw null;
                public string UnixPipePath { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.DefaultHttpContext` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultHttpContext : Microsoft.AspNetCore.Http.HttpContext
            {
                public override void Abort() => throw null;
                public override Microsoft.AspNetCore.Http.ConnectionInfo Connection { get => throw null; }
                public DefaultHttpContext(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                public DefaultHttpContext() => throw null;
                public override Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                public Microsoft.AspNetCore.Http.Features.FormOptions FormOptions { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public void Initialize(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                public override System.Collections.Generic.IDictionary<object, object> Items { get => throw null; set => throw null; }
                public override Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                public override System.Threading.CancellationToken RequestAborted { get => throw null; set => throw null; }
                public override System.IServiceProvider RequestServices { get => throw null; set => throw null; }
                public override Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.IServiceScopeFactory ServiceScopeFactory { get => throw null; set => throw null; }
                public override Microsoft.AspNetCore.Http.ISession Session { get => throw null; set => throw null; }
                public override string TraceIdentifier { get => throw null; set => throw null; }
                public void Uninitialize() => throw null;
                public override System.Security.Claims.ClaimsPrincipal User { get => throw null; set => throw null; }
                public override Microsoft.AspNetCore.Http.WebSocketManager WebSockets { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.FormCollection` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, Microsoft.AspNetCore.Http.IFormCollection
            {
                public bool ContainsKey(string key) => throw null;
                public int Count { get => throw null; }
                public static Microsoft.AspNetCore.Http.FormCollection Empty;
                // Generated from `Microsoft.AspNetCore.Http.FormCollection+Enumerator` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
                {
                    public System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }


                public Microsoft.AspNetCore.Http.IFormFileCollection Files { get => throw null; }
                public FormCollection(System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> fields, Microsoft.AspNetCore.Http.IFormFileCollection files = default(Microsoft.AspNetCore.Http.IFormFileCollection)) => throw null;
                public Microsoft.AspNetCore.Http.FormCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>.GetEnumerator() => throw null;
                public Microsoft.Extensions.Primitives.StringValues this[string key] { get => throw null; }
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                public bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.FormFile` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormFile : Microsoft.AspNetCore.Http.IFormFile
            {
                public string ContentDisposition { get => throw null; set => throw null; }
                public string ContentType { get => throw null; set => throw null; }
                public void CopyTo(System.IO.Stream target) => throw null;
                public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream target, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public string FileName { get => throw null; }
                public FormFile(System.IO.Stream baseStream, System.Int64 baseStreamOffset, System.Int64 length, string name, string fileName) => throw null;
                public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; set => throw null; }
                public System.Int64 Length { get => throw null; }
                public string Name { get => throw null; }
                public System.IO.Stream OpenReadStream() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.FormFileCollection` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormFileCollection : System.Collections.Generic.List<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.Http.IFormFile>, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.IFormFile>, Microsoft.AspNetCore.Http.IFormFileCollection
            {
                public FormFileCollection() => throw null;
                public Microsoft.AspNetCore.Http.IFormFile GetFile(string name) => throw null;
                public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.IFormFile> GetFiles(string name) => throw null;
                public Microsoft.AspNetCore.Http.IFormFile this[string name] { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HeaderDictionary` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HeaderDictionary : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, Microsoft.AspNetCore.Http.IHeaderDictionary
            {
                public void Add(string key, Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public void Add(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> item) => throw null;
                public void Clear() => throw null;
                public bool Contains(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> item) => throw null;
                public bool ContainsKey(string key) => throw null;
                public System.Int64? ContentLength { get => throw null; set => throw null; }
                public void CopyTo(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                // Generated from `Microsoft.AspNetCore.Http.HeaderDictionary+Enumerator` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
                {
                    public System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }


                public Microsoft.AspNetCore.Http.HeaderDictionary.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>.GetEnumerator() => throw null;
                public HeaderDictionary(int capacity) => throw null;
                public HeaderDictionary(System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> store) => throw null;
                public HeaderDictionary() => throw null;
                public bool IsReadOnly { get => throw null; set => throw null; }
                public Microsoft.Extensions.Primitives.StringValues this[string key] { get => throw null; set => throw null; }
                Microsoft.Extensions.Primitives.StringValues System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>.this[string key] { get => throw null; set => throw null; }
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                public bool Remove(string key) => throw null;
                public bool Remove(System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> item) => throw null;
                public bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public System.Collections.Generic.ICollection<Microsoft.Extensions.Primitives.StringValues> Values { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpContextAccessor` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpContextAccessor : Microsoft.AspNetCore.Http.IHttpContextAccessor
            {
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set => throw null; }
                public HttpContextAccessor() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpContextFactory` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpContextFactory : Microsoft.AspNetCore.Http.IHttpContextFactory
            {
                public Microsoft.AspNetCore.Http.HttpContext Create(Microsoft.AspNetCore.Http.Features.IFeatureCollection featureCollection) => throw null;
                public void Dispose(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public HttpContextFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Http.Features.FormOptions> formOptions, Microsoft.Extensions.DependencyInjection.IServiceScopeFactory serviceScopeFactory, Microsoft.AspNetCore.Http.IHttpContextAccessor httpContextAccessor) => throw null;
                public HttpContextFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Http.Features.FormOptions> formOptions, Microsoft.Extensions.DependencyInjection.IServiceScopeFactory serviceScopeFactory) => throw null;
                public HttpContextFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Http.Features.FormOptions> formOptions, Microsoft.AspNetCore.Http.IHttpContextAccessor httpContextAccessor) => throw null;
                public HttpContextFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Http.Features.FormOptions> formOptions) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpRequestRewindExtensions` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpRequestRewindExtensions
            {
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request, int bufferThreshold, System.Int64 bufferLimit) => throw null;
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request, int bufferThreshold) => throw null;
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request, System.Int64 bufferLimit) => throw null;
                public static void EnableBuffering(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.MiddlewareFactory` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class MiddlewareFactory : Microsoft.AspNetCore.Http.IMiddlewareFactory
            {
                public Microsoft.AspNetCore.Http.IMiddleware Create(System.Type middlewareType) => throw null;
                public MiddlewareFactory(System.IServiceProvider serviceProvider) => throw null;
                public void Release(Microsoft.AspNetCore.Http.IMiddleware middleware) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.QueryCollection` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class QueryCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, Microsoft.AspNetCore.Http.IQueryCollection
            {
                public bool ContainsKey(string key) => throw null;
                public int Count { get => throw null; }
                public static Microsoft.AspNetCore.Http.QueryCollection Empty;
                // Generated from `Microsoft.AspNetCore.Http.QueryCollection+Enumerator` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
                {
                    public System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }


                public Microsoft.AspNetCore.Http.QueryCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>.GetEnumerator() => throw null;
                public Microsoft.Extensions.Primitives.StringValues this[string key] { get => throw null; }
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                public QueryCollection(int capacity) => throw null;
                public QueryCollection(System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> store) => throw null;
                public QueryCollection(Microsoft.AspNetCore.Http.QueryCollection store) => throw null;
                public QueryCollection() => throw null;
                public bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.RequestFormReaderExtensions` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RequestFormReaderExtensions
            {
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(this Microsoft.AspNetCore.Http.HttpRequest request, Microsoft.AspNetCore.Http.Features.FormOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.SendFileFallback` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class SendFileFallback
            {
                public static System.Threading.Tasks.Task SendFileAsync(System.IO.Stream destination, string filePath, System.Int64 offset, System.Int64? count, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.StreamResponseBodyFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StreamResponseBodyFeature : Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature
            {
                public virtual System.Threading.Tasks.Task CompleteAsync() => throw null;
                public virtual void DisableBuffering() => throw null;
                public void Dispose() => throw null;
                public Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature PriorFeature { get => throw null; }
                public virtual System.Threading.Tasks.Task SendFileAsync(string path, System.Int64 offset, System.Int64? count, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.IO.Stream Stream { get => throw null; }
                public StreamResponseBodyFeature(System.IO.Stream stream, Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature priorFeature) => throw null;
                public StreamResponseBodyFeature(System.IO.Stream stream) => throw null;
                public System.IO.Pipelines.PipeWriter Writer { get => throw null; }
            }

            namespace Features
            {
                // Generated from `Microsoft.AspNetCore.Http.Features.DefaultSessionFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultSessionFeature : Microsoft.AspNetCore.Http.Features.ISessionFeature
                {
                    public DefaultSessionFeature() => throw null;
                    public Microsoft.AspNetCore.Http.ISession Session { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FormFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormFeature : Microsoft.AspNetCore.Http.Features.IFormFeature
                {
                    public Microsoft.AspNetCore.Http.IFormCollection Form { get => throw null; set => throw null; }
                    public FormFeature(Microsoft.AspNetCore.Http.IFormCollection form) => throw null;
                    public FormFeature(Microsoft.AspNetCore.Http.HttpRequest request, Microsoft.AspNetCore.Http.Features.FormOptions options) => throw null;
                    public FormFeature(Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                    public bool HasFormContentType { get => throw null; }
                    public Microsoft.AspNetCore.Http.IFormCollection ReadForm() => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FormOptions` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormOptions
                {
                    public bool BufferBody { get => throw null; set => throw null; }
                    public System.Int64 BufferBodyLengthLimit { get => throw null; set => throw null; }
                    public const int DefaultBufferBodyLengthLimit = default;
                    public const int DefaultMemoryBufferThreshold = default;
                    public const System.Int64 DefaultMultipartBodyLengthLimit = default;
                    public const int DefaultMultipartBoundaryLengthLimit = default;
                    public FormOptions() => throw null;
                    public int KeyLengthLimit { get => throw null; set => throw null; }
                    public int MemoryBufferThreshold { get => throw null; set => throw null; }
                    public System.Int64 MultipartBodyLengthLimit { get => throw null; set => throw null; }
                    public int MultipartBoundaryLengthLimit { get => throw null; set => throw null; }
                    public int MultipartHeadersCountLimit { get => throw null; set => throw null; }
                    public int MultipartHeadersLengthLimit { get => throw null; set => throw null; }
                    public int ValueCountLimit { get => throw null; set => throw null; }
                    public int ValueLengthLimit { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.HttpConnectionFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpConnectionFeature : Microsoft.AspNetCore.Http.Features.IHttpConnectionFeature
                {
                    public string ConnectionId { get => throw null; set => throw null; }
                    public HttpConnectionFeature() => throw null;
                    public System.Net.IPAddress LocalIpAddress { get => throw null; set => throw null; }
                    public int LocalPort { get => throw null; set => throw null; }
                    public System.Net.IPAddress RemoteIpAddress { get => throw null; set => throw null; }
                    public int RemotePort { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.HttpRequestFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpRequestFeature : Microsoft.AspNetCore.Http.Features.IHttpRequestFeature
                {
                    public System.IO.Stream Body { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; set => throw null; }
                    public HttpRequestFeature() => throw null;
                    public string Method { get => throw null; set => throw null; }
                    public string Path { get => throw null; set => throw null; }
                    public string PathBase { get => throw null; set => throw null; }
                    public string Protocol { get => throw null; set => throw null; }
                    public string QueryString { get => throw null; set => throw null; }
                    public string RawTarget { get => throw null; set => throw null; }
                    public string Scheme { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.HttpRequestIdentifierFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpRequestIdentifierFeature : Microsoft.AspNetCore.Http.Features.IHttpRequestIdentifierFeature
                {
                    public HttpRequestIdentifierFeature() => throw null;
                    public string TraceIdentifier { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.HttpRequestLifetimeFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpRequestLifetimeFeature : Microsoft.AspNetCore.Http.Features.IHttpRequestLifetimeFeature
                {
                    public void Abort() => throw null;
                    public HttpRequestLifetimeFeature() => throw null;
                    public System.Threading.CancellationToken RequestAborted { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.HttpResponseFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpResponseFeature : Microsoft.AspNetCore.Http.Features.IHttpResponseFeature
                {
                    public System.IO.Stream Body { get => throw null; set => throw null; }
                    public virtual bool HasStarted { get => throw null; }
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; set => throw null; }
                    public HttpResponseFeature() => throw null;
                    public virtual void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state) => throw null;
                    public virtual void OnStarting(System.Func<object, System.Threading.Tasks.Task> callback, object state) => throw null;
                    public string ReasonPhrase { get => throw null; set => throw null; }
                    public int StatusCode { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ItemsFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ItemsFeature : Microsoft.AspNetCore.Http.Features.IItemsFeature
                {
                    public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; set => throw null; }
                    public ItemsFeature() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.QueryFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class QueryFeature : Microsoft.AspNetCore.Http.Features.IQueryFeature
                {
                    public Microsoft.AspNetCore.Http.IQueryCollection Query { get => throw null; set => throw null; }
                    public QueryFeature(Microsoft.AspNetCore.Http.IQueryCollection query) => throw null;
                    public QueryFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.RequestBodyPipeFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RequestBodyPipeFeature : Microsoft.AspNetCore.Http.Features.IRequestBodyPipeFeature
                {
                    public System.IO.Pipelines.PipeReader Reader { get => throw null; }
                    public RequestBodyPipeFeature(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.RequestCookiesFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RequestCookiesFeature : Microsoft.AspNetCore.Http.Features.IRequestCookiesFeature
                {
                    public Microsoft.AspNetCore.Http.IRequestCookieCollection Cookies { get => throw null; set => throw null; }
                    public RequestCookiesFeature(Microsoft.AspNetCore.Http.IRequestCookieCollection cookies) => throw null;
                    public RequestCookiesFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.RequestServicesFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RequestServicesFeature : System.IDisposable, System.IAsyncDisposable, Microsoft.AspNetCore.Http.Features.IServiceProvidersFeature
                {
                    public void Dispose() => throw null;
                    public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                    public System.IServiceProvider RequestServices { get => throw null; set => throw null; }
                    public RequestServicesFeature(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.Extensions.DependencyInjection.IServiceScopeFactory scopeFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ResponseCookiesFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ResponseCookiesFeature : Microsoft.AspNetCore.Http.Features.IResponseCookiesFeature
                {
                    public Microsoft.AspNetCore.Http.IResponseCookies Cookies { get => throw null; }
                    public ResponseCookiesFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features, Microsoft.Extensions.ObjectPool.ObjectPool<System.Text.StringBuilder> builderPool) => throw null;
                    public ResponseCookiesFeature(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.RouteValuesFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RouteValuesFeature : Microsoft.AspNetCore.Http.Features.IRouteValuesFeature
                {
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                    public RouteValuesFeature() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.ServiceProvidersFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ServiceProvidersFeature : Microsoft.AspNetCore.Http.Features.IServiceProvidersFeature
                {
                    public System.IServiceProvider RequestServices { get => throw null; set => throw null; }
                    public ServiceProvidersFeature() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.TlsConnectionFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TlsConnectionFeature : Microsoft.AspNetCore.Http.Features.ITlsConnectionFeature
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCertificate { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task<System.Security.Cryptography.X509Certificates.X509Certificate2> GetClientCertificateAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public TlsConnectionFeature() => throw null;
                }

                namespace Authentication
                {
                    // Generated from `Microsoft.AspNetCore.Http.Features.Authentication.HttpAuthenticationFeature` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class HttpAuthenticationFeature : Microsoft.AspNetCore.Http.Features.Authentication.IHttpAuthenticationFeature
                    {
                        public HttpAuthenticationFeature() => throw null;
                        public System.Security.Claims.ClaimsPrincipal User { get => throw null; set => throw null; }
                    }

                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.HttpServiceCollectionExtensions` in `Microsoft.AspNetCore.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpContextAccessor(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
