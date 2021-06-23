// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.EndpointBuilder` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class EndpointBuilder
            {
                public abstract Microsoft.AspNetCore.Http.Endpoint Build();
                public string DisplayName { get => throw null; set => throw null; }
                protected EndpointBuilder() => throw null;
                public System.Collections.Generic.IList<object> Metadata { get => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate RequestDelegate { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.IApplicationBuilder` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IApplicationBuilder
            {
                System.IServiceProvider ApplicationServices { get; set; }
                Microsoft.AspNetCore.Http.RequestDelegate Build();
                Microsoft.AspNetCore.Builder.IApplicationBuilder New();
                System.Collections.Generic.IDictionary<string, object> Properties { get; }
                Microsoft.AspNetCore.Http.Features.IFeatureCollection ServerFeatures { get; }
                Microsoft.AspNetCore.Builder.IApplicationBuilder Use(System.Func<Microsoft.AspNetCore.Http.RequestDelegate, Microsoft.AspNetCore.Http.RequestDelegate> middleware);
            }

            // Generated from `Microsoft.AspNetCore.Builder.IEndpointConventionBuilder` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IEndpointConventionBuilder
            {
                void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention);
            }

            // Generated from `Microsoft.AspNetCore.Builder.MapExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MapExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Map(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString pathMatch, bool preserveMatchedPathSegment, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Map(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString pathMatch, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.MapWhenExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MapWhenExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder MapWhen(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> predicate, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.RunExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RunExtensions
            {
                public static void Run(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.UseExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class UseExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Use(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Func<System.Threading.Tasks.Task>, System.Threading.Tasks.Task> middleware) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.UseMiddlewareExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class UseMiddlewareExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMiddleware<TMiddleware>(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, params object[] args) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMiddleware(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Type middleware, params object[] args) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.UsePathBaseExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class UsePathBaseExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UsePathBase(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString pathBase) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.UseWhenExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class UseWhenExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWhen(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> predicate, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
            }

            namespace Extensions
            {
                // Generated from `Microsoft.AspNetCore.Builder.Extensions.MapMiddleware` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MapMiddleware
                {
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public MapMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Builder.Extensions.MapOptions options) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Builder.Extensions.MapOptions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MapOptions
                {
                    public Microsoft.AspNetCore.Http.RequestDelegate Branch { get => throw null; set => throw null; }
                    public MapOptions() => throw null;
                    public Microsoft.AspNetCore.Http.PathString PathMatch { get => throw null; set => throw null; }
                    public bool PreserveMatchedPathSegment { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Builder.Extensions.MapWhenMiddleware` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MapWhenMiddleware
                {
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public MapWhenMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Builder.Extensions.MapWhenOptions options) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Builder.Extensions.MapWhenOptions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MapWhenOptions
                {
                    public Microsoft.AspNetCore.Http.RequestDelegate Branch { get => throw null; set => throw null; }
                    public MapWhenOptions() => throw null;
                    public System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> Predicate { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Builder.Extensions.UsePathBaseMiddleware` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UsePathBaseMiddleware
                {
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public UsePathBaseMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Http.PathString pathBase) => throw null;
                }

            }
        }
        namespace Cors
        {
            namespace Infrastructure
            {
                // Generated from `Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICorsMetadata
                {
                }

            }
        }
        namespace Http
        {
            // Generated from `Microsoft.AspNetCore.Http.BadHttpRequestException` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BadHttpRequestException : System.IO.IOException
            {
                public BadHttpRequestException(string message, int statusCode, System.Exception innerException) => throw null;
                public BadHttpRequestException(string message, int statusCode) => throw null;
                public BadHttpRequestException(string message, System.Exception innerException) => throw null;
                public BadHttpRequestException(string message) => throw null;
                public int StatusCode { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.ConnectionInfo` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ConnectionInfo
            {
                public abstract System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCertificate { get; set; }
                protected ConnectionInfo() => throw null;
                public abstract System.Threading.Tasks.Task<System.Security.Cryptography.X509Certificates.X509Certificate2> GetClientCertificateAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract string Id { get; set; }
                public abstract System.Net.IPAddress LocalIpAddress { get; set; }
                public abstract int LocalPort { get; set; }
                public abstract System.Net.IPAddress RemoteIpAddress { get; set; }
                public abstract int RemotePort { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.CookieBuilder` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CookieBuilder
            {
                public virtual Microsoft.AspNetCore.Http.CookieOptions Build(Microsoft.AspNetCore.Http.HttpContext context, System.DateTimeOffset expiresFrom) => throw null;
                public Microsoft.AspNetCore.Http.CookieOptions Build(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public CookieBuilder() => throw null;
                public virtual string Domain { get => throw null; set => throw null; }
                public virtual System.TimeSpan? Expiration { get => throw null; set => throw null; }
                public virtual bool HttpOnly { get => throw null; set => throw null; }
                public virtual bool IsEssential { get => throw null; set => throw null; }
                public virtual System.TimeSpan? MaxAge { get => throw null; set => throw null; }
                public virtual string Name { get => throw null; set => throw null; }
                public virtual string Path { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Http.SameSiteMode SameSite { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Http.CookieSecurePolicy SecurePolicy { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.CookieSecurePolicy` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum CookieSecurePolicy
            {
                Always,
                None,
                SameAsRequest,
            }

            // Generated from `Microsoft.AspNetCore.Http.Endpoint` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class Endpoint
            {
                public string DisplayName { get => throw null; }
                public Endpoint(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Http.EndpointMetadataCollection metadata, string displayName) => throw null;
                public Microsoft.AspNetCore.Http.EndpointMetadataCollection Metadata { get => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate RequestDelegate { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.EndpointHttpContextExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EndpointHttpContextExtensions
            {
                public static Microsoft.AspNetCore.Http.Endpoint GetEndpoint(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static void SetEndpoint(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Http.Endpoint endpoint) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.EndpointMetadataCollection` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class EndpointMetadataCollection : System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<object>, System.Collections.Generic.IReadOnlyCollection<object>, System.Collections.Generic.IEnumerable<object>
            {
                public int Count { get => throw null; }
                public static Microsoft.AspNetCore.Http.EndpointMetadataCollection Empty;
                public EndpointMetadataCollection(params object[] items) => throw null;
                public EndpointMetadataCollection(System.Collections.Generic.IEnumerable<object> items) => throw null;
                // Generated from `Microsoft.AspNetCore.Http.EndpointMetadataCollection+Enumerator` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<object>
                {
                    public object Current { get => throw null; }
                    public void Dispose() => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }


                public Microsoft.AspNetCore.Http.EndpointMetadataCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<object> System.Collections.Generic.IEnumerable<object>.GetEnumerator() => throw null;
                public T GetMetadata<T>() where T : class => throw null;
                public System.Collections.Generic.IReadOnlyList<T> GetOrderedMetadata<T>() where T : class => throw null;
                public object this[int index] { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.FragmentString` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct FragmentString : System.IEquatable<Microsoft.AspNetCore.Http.FragmentString>
            {
                public static bool operator !=(Microsoft.AspNetCore.Http.FragmentString left, Microsoft.AspNetCore.Http.FragmentString right) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.FragmentString left, Microsoft.AspNetCore.Http.FragmentString right) => throw null;
                public static Microsoft.AspNetCore.Http.FragmentString Empty;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.FragmentString other) => throw null;
                public FragmentString(string value) => throw null;
                // Stub generator skipped constructor 
                public static Microsoft.AspNetCore.Http.FragmentString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.FragmentString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HeaderDictionaryExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HeaderDictionaryExtensions
            {
                public static void Append(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public static void AppendCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, params string[] values) => throw null;
                public static string[] GetCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key) => throw null;
                public static void SetCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, params string[] values) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HostString` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct HostString : System.IEquatable<Microsoft.AspNetCore.Http.HostString>
            {
                public static bool operator !=(Microsoft.AspNetCore.Http.HostString left, Microsoft.AspNetCore.Http.HostString right) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.HostString left, Microsoft.AspNetCore.Http.HostString right) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.HostString other) => throw null;
                public static Microsoft.AspNetCore.Http.HostString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.HostString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public string Host { get => throw null; }
                public HostString(string value) => throw null;
                public HostString(string host, int port) => throw null;
                // Stub generator skipped constructor 
                public static bool MatchesAny(Microsoft.Extensions.Primitives.StringSegment value, System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> patterns) => throw null;
                public int? Port { get => throw null; }
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpContext` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class HttpContext
            {
                public abstract void Abort();
                public abstract Microsoft.AspNetCore.Http.ConnectionInfo Connection { get; }
                public abstract Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                protected HttpContext() => throw null;
                public abstract System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                public abstract Microsoft.AspNetCore.Http.HttpRequest Request { get; }
                public abstract System.Threading.CancellationToken RequestAborted { get; set; }
                public abstract System.IServiceProvider RequestServices { get; set; }
                public abstract Microsoft.AspNetCore.Http.HttpResponse Response { get; }
                public abstract Microsoft.AspNetCore.Http.ISession Session { get; set; }
                public abstract string TraceIdentifier { get; set; }
                public abstract System.Security.Claims.ClaimsPrincipal User { get; set; }
                public abstract Microsoft.AspNetCore.Http.WebSocketManager WebSockets { get; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpMethods` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpMethods
            {
                public static string Connect;
                public static string Delete;
                public static bool Equals(string methodA, string methodB) => throw null;
                public static string Get;
                public static string GetCanonicalizedValue(string method) => throw null;
                public static string Head;
                public static bool IsConnect(string method) => throw null;
                public static bool IsDelete(string method) => throw null;
                public static bool IsGet(string method) => throw null;
                public static bool IsHead(string method) => throw null;
                public static bool IsOptions(string method) => throw null;
                public static bool IsPatch(string method) => throw null;
                public static bool IsPost(string method) => throw null;
                public static bool IsPut(string method) => throw null;
                public static bool IsTrace(string method) => throw null;
                public static string Options;
                public static string Patch;
                public static string Post;
                public static string Put;
                public static string Trace;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpProtocol` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpProtocol
            {
                public static string GetHttpProtocol(System.Version version) => throw null;
                public static string Http10;
                public static string Http11;
                public static string Http2;
                public static string Http3;
                public static bool IsHttp10(string protocol) => throw null;
                public static bool IsHttp11(string protocol) => throw null;
                public static bool IsHttp2(string protocol) => throw null;
                public static bool IsHttp3(string protocol) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpRequest` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class HttpRequest
            {
                public abstract System.IO.Stream Body { get; set; }
                public virtual System.IO.Pipelines.PipeReader BodyReader { get => throw null; }
                public abstract System.Int64? ContentLength { get; set; }
                public abstract string ContentType { get; set; }
                public abstract Microsoft.AspNetCore.Http.IRequestCookieCollection Cookies { get; set; }
                public abstract Microsoft.AspNetCore.Http.IFormCollection Form { get; set; }
                public abstract bool HasFormContentType { get; }
                public abstract Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                public abstract Microsoft.AspNetCore.Http.HostString Host { get; set; }
                public abstract Microsoft.AspNetCore.Http.HttpContext HttpContext { get; }
                protected HttpRequest() => throw null;
                public abstract bool IsHttps { get; set; }
                public abstract string Method { get; set; }
                public abstract Microsoft.AspNetCore.Http.PathString Path { get; set; }
                public abstract Microsoft.AspNetCore.Http.PathString PathBase { get; set; }
                public abstract string Protocol { get; set; }
                public abstract Microsoft.AspNetCore.Http.IQueryCollection Query { get; set; }
                public abstract Microsoft.AspNetCore.Http.QueryString QueryString { get; set; }
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public abstract string Scheme { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpResponse` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class HttpResponse
            {
                public abstract System.IO.Stream Body { get; set; }
                public virtual System.IO.Pipelines.PipeWriter BodyWriter { get => throw null; }
                public virtual System.Threading.Tasks.Task CompleteAsync() => throw null;
                public abstract System.Int64? ContentLength { get; set; }
                public abstract string ContentType { get; set; }
                public abstract Microsoft.AspNetCore.Http.IResponseCookies Cookies { get; }
                public abstract bool HasStarted { get; }
                public abstract Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                public abstract Microsoft.AspNetCore.Http.HttpContext HttpContext { get; }
                protected HttpResponse() => throw null;
                public virtual void OnCompleted(System.Func<System.Threading.Tasks.Task> callback) => throw null;
                public abstract void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                public virtual void OnStarting(System.Func<System.Threading.Tasks.Task> callback) => throw null;
                public abstract void OnStarting(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                public virtual void Redirect(string location) => throw null;
                public abstract void Redirect(string location, bool permanent);
                public virtual void RegisterForDispose(System.IDisposable disposable) => throw null;
                public virtual void RegisterForDisposeAsync(System.IAsyncDisposable disposable) => throw null;
                public virtual System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract int StatusCode { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpResponseWritingExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpResponseWritingExtensions
            {
                public static System.Threading.Tasks.Task WriteAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string text, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string text, System.Text.Encoding encoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.IHttpContextAccessor` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHttpContextAccessor
            {
                Microsoft.AspNetCore.Http.HttpContext HttpContext { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.IHttpContextFactory` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHttpContextFactory
            {
                Microsoft.AspNetCore.Http.HttpContext Create(Microsoft.AspNetCore.Http.Features.IFeatureCollection featureCollection);
                void Dispose(Microsoft.AspNetCore.Http.HttpContext httpContext);
            }

            // Generated from `Microsoft.AspNetCore.Http.IMiddleware` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IMiddleware
            {
                System.Threading.Tasks.Task InvokeAsync(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Http.RequestDelegate next);
            }

            // Generated from `Microsoft.AspNetCore.Http.IMiddlewareFactory` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IMiddlewareFactory
            {
                Microsoft.AspNetCore.Http.IMiddleware Create(System.Type middlewareType);
                void Release(Microsoft.AspNetCore.Http.IMiddleware middleware);
            }

            // Generated from `Microsoft.AspNetCore.Http.PathString` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct PathString : System.IEquatable<Microsoft.AspNetCore.Http.PathString>
            {
                public static bool operator !=(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public static string operator +(string left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public static string operator +(Microsoft.AspNetCore.Http.PathString left, string right) => throw null;
                public static string operator +(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public static Microsoft.AspNetCore.Http.PathString operator +(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public string Add(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public Microsoft.AspNetCore.Http.PathString Add(Microsoft.AspNetCore.Http.PathString other) => throw null;
                public static Microsoft.AspNetCore.Http.PathString Empty;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.PathString other) => throw null;
                public static Microsoft.AspNetCore.Http.PathString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.PathString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public PathString(string value) => throw null;
                // Stub generator skipped constructor 
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, out Microsoft.AspNetCore.Http.PathString matched, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType, out Microsoft.AspNetCore.Http.PathString matched, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other) => throw null;
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
                public static implicit operator string(Microsoft.AspNetCore.Http.PathString path) => throw null;
                public static implicit operator Microsoft.AspNetCore.Http.PathString(string s) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.QueryString` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct QueryString : System.IEquatable<Microsoft.AspNetCore.Http.QueryString>
            {
                public static bool operator !=(Microsoft.AspNetCore.Http.QueryString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString operator +(Microsoft.AspNetCore.Http.QueryString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.QueryString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public Microsoft.AspNetCore.Http.QueryString Add(string name, string value) => throw null;
                public Microsoft.AspNetCore.Http.QueryString Add(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Create(string name, string value) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Create(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> parameters) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Create(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> parameters) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Empty;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public QueryString(string value) => throw null;
                // Stub generator skipped constructor 
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Http.RequestDelegate` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public delegate System.Threading.Tasks.Task RequestDelegate(Microsoft.AspNetCore.Http.HttpContext context);

            // Generated from `Microsoft.AspNetCore.Http.RequestTrailerExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RequestTrailerExtensions
            {
                public static bool CheckTrailersAvailable(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static Microsoft.Extensions.Primitives.StringValues GetDeclaredTrailers(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static Microsoft.Extensions.Primitives.StringValues GetTrailer(this Microsoft.AspNetCore.Http.HttpRequest request, string trailerName) => throw null;
                public static bool SupportsTrailers(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.ResponseTrailerExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ResponseTrailerExtensions
            {
                public static void AppendTrailer(this Microsoft.AspNetCore.Http.HttpResponse response, string trailerName, Microsoft.Extensions.Primitives.StringValues trailerValues) => throw null;
                public static void DeclareTrailer(this Microsoft.AspNetCore.Http.HttpResponse response, string trailerName) => throw null;
                public static bool SupportsTrailers(this Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.StatusCodes` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class StatusCodes
            {
                public const int Status100Continue = default;
                public const int Status101SwitchingProtocols = default;
                public const int Status102Processing = default;
                public const int Status200OK = default;
                public const int Status201Created = default;
                public const int Status202Accepted = default;
                public const int Status203NonAuthoritative = default;
                public const int Status204NoContent = default;
                public const int Status205ResetContent = default;
                public const int Status206PartialContent = default;
                public const int Status207MultiStatus = default;
                public const int Status208AlreadyReported = default;
                public const int Status226IMUsed = default;
                public const int Status300MultipleChoices = default;
                public const int Status301MovedPermanently = default;
                public const int Status302Found = default;
                public const int Status303SeeOther = default;
                public const int Status304NotModified = default;
                public const int Status305UseProxy = default;
                public const int Status306SwitchProxy = default;
                public const int Status307TemporaryRedirect = default;
                public const int Status308PermanentRedirect = default;
                public const int Status400BadRequest = default;
                public const int Status401Unauthorized = default;
                public const int Status402PaymentRequired = default;
                public const int Status403Forbidden = default;
                public const int Status404NotFound = default;
                public const int Status405MethodNotAllowed = default;
                public const int Status406NotAcceptable = default;
                public const int Status407ProxyAuthenticationRequired = default;
                public const int Status408RequestTimeout = default;
                public const int Status409Conflict = default;
                public const int Status410Gone = default;
                public const int Status411LengthRequired = default;
                public const int Status412PreconditionFailed = default;
                public const int Status413PayloadTooLarge = default;
                public const int Status413RequestEntityTooLarge = default;
                public const int Status414RequestUriTooLong = default;
                public const int Status414UriTooLong = default;
                public const int Status415UnsupportedMediaType = default;
                public const int Status416RangeNotSatisfiable = default;
                public const int Status416RequestedRangeNotSatisfiable = default;
                public const int Status417ExpectationFailed = default;
                public const int Status418ImATeapot = default;
                public const int Status419AuthenticationTimeout = default;
                public const int Status421MisdirectedRequest = default;
                public const int Status422UnprocessableEntity = default;
                public const int Status423Locked = default;
                public const int Status424FailedDependency = default;
                public const int Status426UpgradeRequired = default;
                public const int Status428PreconditionRequired = default;
                public const int Status429TooManyRequests = default;
                public const int Status431RequestHeaderFieldsTooLarge = default;
                public const int Status451UnavailableForLegalReasons = default;
                public const int Status500InternalServerError = default;
                public const int Status501NotImplemented = default;
                public const int Status502BadGateway = default;
                public const int Status503ServiceUnavailable = default;
                public const int Status504GatewayTimeout = default;
                public const int Status505HttpVersionNotsupported = default;
                public const int Status506VariantAlsoNegotiates = default;
                public const int Status507InsufficientStorage = default;
                public const int Status508LoopDetected = default;
                public const int Status510NotExtended = default;
                public const int Status511NetworkAuthenticationRequired = default;
            }

            // Generated from `Microsoft.AspNetCore.Http.WebSocketManager` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class WebSocketManager
            {
                public virtual System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptWebSocketAsync() => throw null;
                public abstract System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptWebSocketAsync(string subProtocol);
                public abstract bool IsWebSocketRequest { get; }
                protected WebSocketManager() => throw null;
                public abstract System.Collections.Generic.IList<string> WebSocketRequestedProtocols { get; }
            }

            namespace Features
            {
                // Generated from `Microsoft.AspNetCore.Http.Features.IEndpointFeature` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IEndpointFeature
                {
                    Microsoft.AspNetCore.Http.Endpoint Endpoint { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IRouteValuesFeature` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRouteValuesFeature
                {
                    Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get; set; }
                }

            }
        }
        namespace Routing
        {
            // Generated from `Microsoft.AspNetCore.Routing.RouteValueDictionary` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteValueDictionary : System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyDictionary<string, object>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>
            {
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Add(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                public void Add(string key, object value) => throw null;
                public void Clear() => throw null;
                public System.Collections.Generic.IEqualityComparer<string> Comparer { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                public bool ContainsKey(string key) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                // Generated from `Microsoft.AspNetCore.Routing.RouteValueDictionary+Enumerator` in `Microsoft.AspNetCore.Http.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public System.Collections.Generic.KeyValuePair<string, object> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public Enumerator(Microsoft.AspNetCore.Routing.RouteValueDictionary dictionary) => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }


                public static Microsoft.AspNetCore.Routing.RouteValueDictionary FromArray(System.Collections.Generic.KeyValuePair<string, object>[] items) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.IsReadOnly { get => throw null; }
                public object this[string key] { get => throw null; set => throw null; }
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<string> System.Collections.Generic.IReadOnlyDictionary<string, object>.Keys { get => throw null; }
                public bool Remove(string key, out object value) => throw null;
                public bool Remove(string key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                public RouteValueDictionary(object values) => throw null;
                public RouteValueDictionary() => throw null;
                public bool TryAdd(string key, object value) => throw null;
                public bool TryGetValue(string key, out object value) => throw null;
                public System.Collections.Generic.ICollection<object> Values { get => throw null; }
                System.Collections.Generic.IEnumerable<object> System.Collections.Generic.IReadOnlyDictionary<string, object>.Values { get => throw null; }
            }

        }
    }
}
