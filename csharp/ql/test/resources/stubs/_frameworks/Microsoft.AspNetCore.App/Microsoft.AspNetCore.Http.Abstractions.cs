// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Antiforgery
        {
            public interface IAntiforgeryMetadata
            {
                bool RequiresValidation { get; }
            }
        }
        namespace Builder
        {
            public abstract class EndpointBuilder
            {
                public System.IServiceProvider ApplicationServices { get => throw null; set { } }
                public abstract Microsoft.AspNetCore.Http.Endpoint Build();
                protected EndpointBuilder() => throw null;
                public string DisplayName { get => throw null; set { } }
                public System.Collections.Generic.IList<System.Func<Microsoft.AspNetCore.Http.EndpointFilterFactoryContext, Microsoft.AspNetCore.Http.EndpointFilterDelegate, Microsoft.AspNetCore.Http.EndpointFilterDelegate>> FilterFactories { get => throw null; }
                public System.Collections.Generic.IList<object> Metadata { get => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate RequestDelegate { get => throw null; set { } }
            }
            namespace Extensions
            {
                public class MapMiddleware
                {
                    public MapMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Builder.Extensions.MapOptions options) => throw null;
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                }
                public class MapOptions
                {
                    public Microsoft.AspNetCore.Http.RequestDelegate Branch { get => throw null; set { } }
                    public MapOptions() => throw null;
                    public Microsoft.AspNetCore.Http.PathString PathMatch { get => throw null; set { } }
                    public bool PreserveMatchedPathSegment { get => throw null; set { } }
                }
                public class MapWhenMiddleware
                {
                    public MapWhenMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Builder.Extensions.MapWhenOptions options) => throw null;
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                }
                public class MapWhenOptions
                {
                    public Microsoft.AspNetCore.Http.RequestDelegate Branch { get => throw null; set { } }
                    public MapWhenOptions() => throw null;
                    public System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> Predicate { get => throw null; set { } }
                }
                public class UsePathBaseMiddleware
                {
                    public UsePathBaseMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Http.PathString pathBase) => throw null;
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                }
            }
            public interface IApplicationBuilder
            {
                System.IServiceProvider ApplicationServices { get; set; }
                Microsoft.AspNetCore.Http.RequestDelegate Build();
                Microsoft.AspNetCore.Builder.IApplicationBuilder New();
                System.Collections.Generic.IDictionary<string, object> Properties { get; }
                Microsoft.AspNetCore.Http.Features.IFeatureCollection ServerFeatures { get; }
                Microsoft.AspNetCore.Builder.IApplicationBuilder Use(System.Func<Microsoft.AspNetCore.Http.RequestDelegate, Microsoft.AspNetCore.Http.RequestDelegate> middleware);
            }
            public interface IEndpointConventionBuilder
            {
                void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention);
                virtual void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finallyConvention) => throw null;
            }
            public static partial class MapExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Map(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string pathMatch, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Map(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString pathMatch, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Map(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString pathMatch, bool preserveMatchedPathSegment, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
            }
            public static partial class MapWhenExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder MapWhen(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> predicate, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
            }
            public static partial class RunExtensions
            {
                public static void Run(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
            }
            public static partial class UseExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Use(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Func<System.Threading.Tasks.Task>, System.Threading.Tasks.Task> middleware) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder Use(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, Microsoft.AspNetCore.Http.RequestDelegate, System.Threading.Tasks.Task> middleware) => throw null;
            }
            public static partial class UseMiddlewareExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMiddleware<TMiddleware>(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, params object[] args) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMiddleware(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Type middleware, params object[] args) => throw null;
            }
            public static partial class UsePathBaseExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UsePathBase(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString pathBase) => throw null;
            }
            public static partial class UseWhenExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWhen(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> predicate, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
            }
        }
        namespace Cors
        {
            namespace Infrastructure
            {
                public interface ICorsMetadata
                {
                }
            }
        }
        namespace Http
        {
            [System.AttributeUsage((System.AttributeTargets)2048, Inherited = false, AllowMultiple = false)]
            public sealed class AsParametersAttribute : System.Attribute
            {
                public AsParametersAttribute() => throw null;
            }
            public class BadHttpRequestException : System.IO.IOException
            {
                public BadHttpRequestException(string message, int statusCode) => throw null;
                public BadHttpRequestException(string message) => throw null;
                public BadHttpRequestException(string message, int statusCode, System.Exception innerException) => throw null;
                public BadHttpRequestException(string message, System.Exception innerException) => throw null;
                public int StatusCode { get => throw null; }
            }
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
                public virtual void RequestClose() => throw null;
            }
            public class CookieBuilder
            {
                public Microsoft.AspNetCore.Http.CookieOptions Build(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public virtual Microsoft.AspNetCore.Http.CookieOptions Build(Microsoft.AspNetCore.Http.HttpContext context, System.DateTimeOffset expiresFrom) => throw null;
                public CookieBuilder() => throw null;
                public virtual string Domain { get => throw null; set { } }
                public virtual System.TimeSpan? Expiration { get => throw null; set { } }
                public System.Collections.Generic.IList<string> Extensions { get => throw null; }
                public virtual bool HttpOnly { get => throw null; set { } }
                public virtual bool IsEssential { get => throw null; set { } }
                public virtual System.TimeSpan? MaxAge { get => throw null; set { } }
                public virtual string Name { get => throw null; set { } }
                public virtual string Path { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Http.SameSiteMode SameSite { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Http.CookieSecurePolicy SecurePolicy { get => throw null; set { } }
            }
            public enum CookieSecurePolicy
            {
                SameAsRequest = 0,
                Always = 1,
                None = 2,
            }
            public sealed class DefaultEndpointFilterInvocationContext : Microsoft.AspNetCore.Http.EndpointFilterInvocationContext
            {
                public override System.Collections.Generic.IList<object> Arguments { get => throw null; }
                public DefaultEndpointFilterInvocationContext(Microsoft.AspNetCore.Http.HttpContext httpContext, params object[] arguments) => throw null;
                public override T GetArgument<T>(int index) => throw null;
                public override Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
            }
            public class Endpoint
            {
                public Endpoint(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Http.EndpointMetadataCollection metadata, string displayName) => throw null;
                public string DisplayName { get => throw null; }
                public Microsoft.AspNetCore.Http.EndpointMetadataCollection Metadata { get => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate RequestDelegate { get => throw null; }
                public override string ToString() => throw null;
            }
            public delegate System.Threading.Tasks.ValueTask<object> EndpointFilterDelegate(Microsoft.AspNetCore.Http.EndpointFilterInvocationContext context);
            public sealed class EndpointFilterFactoryContext
            {
                public System.IServiceProvider ApplicationServices { get => throw null; set { } }
                public EndpointFilterFactoryContext() => throw null;
                public System.Reflection.MethodInfo MethodInfo { get => throw null; set { } }
            }
            public abstract class EndpointFilterInvocationContext
            {
                public abstract System.Collections.Generic.IList<object> Arguments { get; }
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T>(Microsoft.AspNetCore.Http.HttpContext httpContext, T arg) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2, T3>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2, T3 arg3) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2, T3, T4>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2, T3 arg3, T4 arg4) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2, T3, T4, T5>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2, T3, T4, T5, T6>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2, T3, T4, T5, T6, T7>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7) => throw null;
                public static Microsoft.AspNetCore.Http.EndpointFilterInvocationContext Create<T1, T2, T3, T4, T5, T6, T7, T8>(Microsoft.AspNetCore.Http.HttpContext httpContext, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8) => throw null;
                protected EndpointFilterInvocationContext() => throw null;
                public abstract T GetArgument<T>(int index);
                public abstract Microsoft.AspNetCore.Http.HttpContext HttpContext { get; }
            }
            public static partial class EndpointHttpContextExtensions
            {
                public static Microsoft.AspNetCore.Http.Endpoint GetEndpoint(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static void SetEndpoint(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Http.Endpoint endpoint) => throw null;
            }
            public sealed class EndpointMetadataCollection : System.Collections.Generic.IEnumerable<object>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<object>, System.Collections.Generic.IReadOnlyList<object>
            {
                public int Count { get => throw null; }
                public EndpointMetadataCollection(System.Collections.Generic.IEnumerable<object> items) => throw null;
                public EndpointMetadataCollection(params object[] items) => throw null;
                public static readonly Microsoft.AspNetCore.Http.EndpointMetadataCollection Empty;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<object>, System.Collections.IEnumerator
                {
                    public object Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public Microsoft.AspNetCore.Http.EndpointMetadataCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<object> System.Collections.Generic.IEnumerable<object>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public T GetMetadata<T>() where T : class => throw null;
                public System.Collections.Generic.IReadOnlyList<T> GetOrderedMetadata<T>() where T : class => throw null;
                public T GetRequiredMetadata<T>() where T : class => throw null;
                public object this[int index] { get => throw null; }
            }
            namespace Features
            {
                public interface IEndpointFeature
                {
                    Microsoft.AspNetCore.Http.Endpoint Endpoint { get; set; }
                }
                public interface IRouteValuesFeature
                {
                    Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get; set; }
                }
            }
            public struct FragmentString : System.IEquatable<Microsoft.AspNetCore.Http.FragmentString>
            {
                public FragmentString(string value) => throw null;
                public static readonly Microsoft.AspNetCore.Http.FragmentString Empty;
                public bool Equals(Microsoft.AspNetCore.Http.FragmentString other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static Microsoft.AspNetCore.Http.FragmentString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.FragmentString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public static bool operator ==(Microsoft.AspNetCore.Http.FragmentString left, Microsoft.AspNetCore.Http.FragmentString right) => throw null;
                public static bool operator !=(Microsoft.AspNetCore.Http.FragmentString left, Microsoft.AspNetCore.Http.FragmentString right) => throw null;
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }
            public static partial class HeaderDictionaryExtensions
            {
                public static void Append(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public static void AppendCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, params string[] values) => throw null;
                public static string[] GetCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key) => throw null;
                public static void SetCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, params string[] values) => throw null;
            }
            public struct HostString : System.IEquatable<Microsoft.AspNetCore.Http.HostString>
            {
                public HostString(string value) => throw null;
                public HostString(string host, int port) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.HostString other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static Microsoft.AspNetCore.Http.HostString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.HostString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public string Host { get => throw null; }
                public static bool MatchesAny(Microsoft.Extensions.Primitives.StringSegment value, System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> patterns) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.HostString left, Microsoft.AspNetCore.Http.HostString right) => throw null;
                public static bool operator !=(Microsoft.AspNetCore.Http.HostString left, Microsoft.AspNetCore.Http.HostString right) => throw null;
                public int? Port { get => throw null; }
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }
            public abstract class HttpContext
            {
                public abstract void Abort();
                public abstract Microsoft.AspNetCore.Http.ConnectionInfo Connection { get; }
                protected HttpContext() => throw null;
                public abstract Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
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
            public static class HttpMethods
            {
                public static readonly string Connect;
                public static readonly string Delete;
                public static bool Equals(string methodA, string methodB) => throw null;
                public static readonly string Get;
                public static string GetCanonicalizedValue(string method) => throw null;
                public static readonly string Head;
                public static bool IsConnect(string method) => throw null;
                public static bool IsDelete(string method) => throw null;
                public static bool IsGet(string method) => throw null;
                public static bool IsHead(string method) => throw null;
                public static bool IsOptions(string method) => throw null;
                public static bool IsPatch(string method) => throw null;
                public static bool IsPost(string method) => throw null;
                public static bool IsPut(string method) => throw null;
                public static bool IsTrace(string method) => throw null;
                public static readonly string Options;
                public static readonly string Patch;
                public static readonly string Post;
                public static readonly string Put;
                public static readonly string Trace;
            }
            public static class HttpProtocol
            {
                public static string GetHttpProtocol(System.Version version) => throw null;
                public static readonly string Http09;
                public static readonly string Http10;
                public static readonly string Http11;
                public static readonly string Http2;
                public static readonly string Http3;
                public static bool IsHttp09(string protocol) => throw null;
                public static bool IsHttp10(string protocol) => throw null;
                public static bool IsHttp11(string protocol) => throw null;
                public static bool IsHttp2(string protocol) => throw null;
                public static bool IsHttp3(string protocol) => throw null;
            }
            public abstract class HttpRequest
            {
                public abstract System.IO.Stream Body { get; set; }
                public virtual System.IO.Pipelines.PipeReader BodyReader { get => throw null; }
                public abstract long? ContentLength { get; set; }
                public abstract string ContentType { get; set; }
                public abstract Microsoft.AspNetCore.Http.IRequestCookieCollection Cookies { get; set; }
                protected HttpRequest() => throw null;
                public abstract Microsoft.AspNetCore.Http.IFormCollection Form { get; set; }
                public abstract bool HasFormContentType { get; }
                public abstract Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                public abstract Microsoft.AspNetCore.Http.HostString Host { get; set; }
                public abstract Microsoft.AspNetCore.Http.HttpContext HttpContext { get; }
                public abstract bool IsHttps { get; set; }
                public abstract string Method { get; set; }
                public abstract Microsoft.AspNetCore.Http.PathString Path { get; set; }
                public abstract Microsoft.AspNetCore.Http.PathString PathBase { get; set; }
                public abstract string Protocol { get; set; }
                public abstract Microsoft.AspNetCore.Http.IQueryCollection Query { get; set; }
                public abstract Microsoft.AspNetCore.Http.QueryString QueryString { get; set; }
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Http.IFormCollection> ReadFormAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public abstract string Scheme { get; set; }
            }
            public abstract class HttpResponse
            {
                public abstract System.IO.Stream Body { get; set; }
                public virtual System.IO.Pipelines.PipeWriter BodyWriter { get => throw null; }
                public virtual System.Threading.Tasks.Task CompleteAsync() => throw null;
                public abstract long? ContentLength { get; set; }
                public abstract string ContentType { get; set; }
                public abstract Microsoft.AspNetCore.Http.IResponseCookies Cookies { get; }
                protected HttpResponse() => throw null;
                public abstract bool HasStarted { get; }
                public abstract Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                public abstract Microsoft.AspNetCore.Http.HttpContext HttpContext { get; }
                public abstract void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                public virtual void OnCompleted(System.Func<System.Threading.Tasks.Task> callback) => throw null;
                public abstract void OnStarting(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                public virtual void OnStarting(System.Func<System.Threading.Tasks.Task> callback) => throw null;
                public virtual void Redirect(string location) => throw null;
                public abstract void Redirect(string location, bool permanent);
                public virtual void RegisterForDispose(System.IDisposable disposable) => throw null;
                public virtual void RegisterForDisposeAsync(System.IAsyncDisposable disposable) => throw null;
                public virtual System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract int StatusCode { get; set; }
            }
            public static partial class HttpResponseWritingExtensions
            {
                public static System.Threading.Tasks.Task WriteAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string text, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string text, System.Text.Encoding encoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            namespace HttpResults
            {
                public sealed class EmptyHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static Microsoft.AspNetCore.Http.HttpResults.EmptyHttpResult Instance { get => throw null; }
                }
            }
            public class HttpValidationProblemDetails : Microsoft.AspNetCore.Mvc.ProblemDetails
            {
                public HttpValidationProblemDetails() => throw null;
                public HttpValidationProblemDetails(System.Collections.Generic.IDictionary<string, string[]> errors) => throw null;
                public System.Collections.Generic.IDictionary<string, string[]> Errors { get => throw null; set { } }
            }
            public interface IBindableFromHttpContext<TSelf> where TSelf : class, Microsoft.AspNetCore.Http.IBindableFromHttpContext<TSelf>
            {
                abstract static System.Threading.Tasks.ValueTask<TSelf> BindAsync(Microsoft.AspNetCore.Http.HttpContext context, System.Reflection.ParameterInfo parameter);
            }
            public interface IContentTypeHttpResult
            {
                string ContentType { get; }
            }
            public interface IEndpointFilter
            {
                System.Threading.Tasks.ValueTask<object> InvokeAsync(Microsoft.AspNetCore.Http.EndpointFilterInvocationContext context, Microsoft.AspNetCore.Http.EndpointFilterDelegate next);
            }
            public interface IFileHttpResult
            {
                string ContentType { get; }
                string FileDownloadName { get; }
            }
            public interface IHttpContextAccessor
            {
                Microsoft.AspNetCore.Http.HttpContext HttpContext { get; set; }
            }
            public interface IHttpContextFactory
            {
                Microsoft.AspNetCore.Http.HttpContext Create(Microsoft.AspNetCore.Http.Features.IFeatureCollection featureCollection);
                void Dispose(Microsoft.AspNetCore.Http.HttpContext httpContext);
            }
            public interface IMiddleware
            {
                System.Threading.Tasks.Task InvokeAsync(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Http.RequestDelegate next);
            }
            public interface IMiddlewareFactory
            {
                Microsoft.AspNetCore.Http.IMiddleware Create(System.Type middlewareType);
                void Release(Microsoft.AspNetCore.Http.IMiddleware middleware);
            }
            public interface INestedHttpResult
            {
                Microsoft.AspNetCore.Http.IResult Result { get; }
            }
            public interface IProblemDetailsService
            {
                virtual System.Threading.Tasks.ValueTask<bool> TryWriteAsync(Microsoft.AspNetCore.Http.ProblemDetailsContext context) => throw null;
                System.Threading.Tasks.ValueTask WriteAsync(Microsoft.AspNetCore.Http.ProblemDetailsContext context);
            }
            public interface IProblemDetailsWriter
            {
                bool CanWrite(Microsoft.AspNetCore.Http.ProblemDetailsContext context);
                System.Threading.Tasks.ValueTask WriteAsync(Microsoft.AspNetCore.Http.ProblemDetailsContext context);
            }
            public interface IResult
            {
                System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext);
            }
            public interface IStatusCodeHttpResult
            {
                int? StatusCode { get; }
            }
            public interface IValueHttpResult
            {
                object Value { get; }
            }
            public interface IValueHttpResult<TValue>
            {
                TValue Value { get; }
            }
            namespace Metadata
            {
                public sealed class AcceptsMetadata : Microsoft.AspNetCore.Http.Metadata.IAcceptsMetadata
                {
                    public System.Collections.Generic.IReadOnlyList<string> ContentTypes { get => throw null; }
                    public AcceptsMetadata(string[] contentTypes, System.Type type = default(System.Type), bool isOptional = default(bool)) => throw null;
                    public bool IsOptional { get => throw null; }
                    public System.Type RequestType { get => throw null; }
                    public override string ToString() => throw null;
                }
                public class FormMappingOptionsMetadata
                {
                    public FormMappingOptionsMetadata(int? maxCollectionSize = default(int?), int? maxRecursionDepth = default(int?), int? maxKeySize = default(int?)) => throw null;
                    public int? MaxCollectionSize { get => throw null; }
                    public int? MaxKeySize { get => throw null; }
                    public int? MaxRecursionDepth { get => throw null; }
                }
                public interface IAcceptsMetadata
                {
                    System.Collections.Generic.IReadOnlyList<string> ContentTypes { get; }
                    bool IsOptional { get; }
                    System.Type RequestType { get; }
                }
                public interface IEndpointDescriptionMetadata
                {
                    string Description { get; }
                }
                public interface IEndpointMetadataProvider
                {
                    abstract static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder);
                }
                public interface IEndpointParameterMetadataProvider
                {
                    abstract static void PopulateMetadata(System.Reflection.ParameterInfo parameter, Microsoft.AspNetCore.Builder.EndpointBuilder builder);
                }
                public interface IEndpointSummaryMetadata
                {
                    string Summary { get; }
                }
                public interface IFormOptionsMetadata
                {
                    bool? BufferBody { get; }
                    long? BufferBodyLengthLimit { get; }
                    int? KeyLengthLimit { get; }
                    int? MemoryBufferThreshold { get; }
                    long? MultipartBodyLengthLimit { get; }
                    int? MultipartBoundaryLengthLimit { get; }
                    int? MultipartHeadersCountLimit { get; }
                    int? MultipartHeadersLengthLimit { get; }
                    int? ValueCountLimit { get; }
                    int? ValueLengthLimit { get; }
                }
                public interface IFromBodyMetadata
                {
                    virtual bool AllowEmpty { get => throw null; }
                }
                public interface IFromFormMetadata
                {
                    string Name { get; }
                }
                public interface IFromHeaderMetadata
                {
                    string Name { get; }
                }
                public interface IFromQueryMetadata
                {
                    string Name { get; }
                }
                public interface IFromRouteMetadata
                {
                    string Name { get; }
                }
                public interface IFromServiceMetadata
                {
                }
                public interface IProducesResponseTypeMetadata
                {
                    System.Collections.Generic.IEnumerable<string> ContentTypes { get; }
                    int StatusCode { get; }
                    System.Type Type { get; }
                }
                public interface IRequestSizeLimitMetadata
                {
                    long? MaxRequestBodySize { get; }
                }
                public interface IRouteDiagnosticsMetadata
                {
                    string Route { get; }
                }
                public interface ISkipStatusCodePagesMetadata
                {
                }
                public interface ITagsMetadata
                {
                    System.Collections.Generic.IReadOnlyList<string> Tags { get; }
                }
            }
            public struct PathString : System.IEquatable<Microsoft.AspNetCore.Http.PathString>
            {
                public Microsoft.AspNetCore.Http.PathString Add(Microsoft.AspNetCore.Http.PathString other) => throw null;
                public string Add(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public PathString(string value) => throw null;
                public static readonly Microsoft.AspNetCore.Http.PathString Empty;
                public bool Equals(Microsoft.AspNetCore.Http.PathString other) => throw null;
                public bool Equals(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType) => throw null;
                public override bool Equals(object obj) => throw null;
                public static Microsoft.AspNetCore.Http.PathString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.PathString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public static string operator +(string left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public static string operator +(Microsoft.AspNetCore.Http.PathString left, string right) => throw null;
                public static Microsoft.AspNetCore.Http.PathString operator +(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public static string operator +(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public static implicit operator Microsoft.AspNetCore.Http.PathString(string s) => throw null;
                public static implicit operator string(Microsoft.AspNetCore.Http.PathString path) => throw null;
                public static bool operator !=(Microsoft.AspNetCore.Http.PathString left, Microsoft.AspNetCore.Http.PathString right) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, out Microsoft.AspNetCore.Http.PathString matched, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public bool StartsWithSegments(Microsoft.AspNetCore.Http.PathString other, System.StringComparison comparisonType, out Microsoft.AspNetCore.Http.PathString matched, out Microsoft.AspNetCore.Http.PathString remaining) => throw null;
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }
            public sealed class ProblemDetailsContext
            {
                public Microsoft.AspNetCore.Http.EndpointMetadataCollection AdditionalMetadata { get => throw null; set { } }
                public ProblemDetailsContext() => throw null;
                public System.Exception Exception { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.ProblemDetails ProblemDetails { get => throw null; set { } }
            }
            public sealed class ProducesResponseTypeMetadata : Microsoft.AspNetCore.Http.Metadata.IProducesResponseTypeMetadata
            {
                public System.Collections.Generic.IEnumerable<string> ContentTypes { get => throw null; }
                public ProducesResponseTypeMetadata(int statusCode, System.Type type = default(System.Type), string[] contentTypes = default(string[])) => throw null;
                public int StatusCode { get => throw null; }
                public override string ToString() => throw null;
                public System.Type Type { get => throw null; }
            }
            public struct QueryString : System.IEquatable<Microsoft.AspNetCore.Http.QueryString>
            {
                public Microsoft.AspNetCore.Http.QueryString Add(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public Microsoft.AspNetCore.Http.QueryString Add(string name, string value) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Create(string name, string value) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Create(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> parameters) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString Create(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> parameters) => throw null;
                public QueryString(string value) => throw null;
                public static readonly Microsoft.AspNetCore.Http.QueryString Empty;
                public bool Equals(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString FromUriComponent(string uriComponent) => throw null;
                public static Microsoft.AspNetCore.Http.QueryString FromUriComponent(System.Uri uri) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public static Microsoft.AspNetCore.Http.QueryString operator +(Microsoft.AspNetCore.Http.QueryString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public static bool operator ==(Microsoft.AspNetCore.Http.QueryString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public static bool operator !=(Microsoft.AspNetCore.Http.QueryString left, Microsoft.AspNetCore.Http.QueryString right) => throw null;
                public override string ToString() => throw null;
                public string ToUriComponent() => throw null;
                public string Value { get => throw null; }
            }
            public delegate System.Threading.Tasks.Task RequestDelegate(Microsoft.AspNetCore.Http.HttpContext context);
            public sealed class RequestDelegateResult
            {
                public RequestDelegateResult(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, System.Collections.Generic.IReadOnlyList<object> metadata) => throw null;
                public System.Collections.Generic.IReadOnlyList<object> EndpointMetadata { get => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate RequestDelegate { get => throw null; }
            }
            public static partial class RequestTrailerExtensions
            {
                public static bool CheckTrailersAvailable(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static Microsoft.Extensions.Primitives.StringValues GetDeclaredTrailers(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static Microsoft.Extensions.Primitives.StringValues GetTrailer(this Microsoft.AspNetCore.Http.HttpRequest request, string trailerName) => throw null;
                public static bool SupportsTrailers(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
            }
            public static partial class ResponseTrailerExtensions
            {
                public static void AppendTrailer(this Microsoft.AspNetCore.Http.HttpResponse response, string trailerName, Microsoft.Extensions.Primitives.StringValues trailerValues) => throw null;
                public static void DeclareTrailer(this Microsoft.AspNetCore.Http.HttpResponse response, string trailerName) => throw null;
                public static bool SupportsTrailers(this Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
            }
            public static class StatusCodes
            {
                public const int Status100Continue = 100;
                public const int Status101SwitchingProtocols = 101;
                public const int Status102Processing = 102;
                public const int Status200OK = 200;
                public const int Status201Created = 201;
                public const int Status202Accepted = 202;
                public const int Status203NonAuthoritative = 203;
                public const int Status204NoContent = 204;
                public const int Status205ResetContent = 205;
                public const int Status206PartialContent = 206;
                public const int Status207MultiStatus = 207;
                public const int Status208AlreadyReported = 208;
                public const int Status226IMUsed = 226;
                public const int Status300MultipleChoices = 300;
                public const int Status301MovedPermanently = 301;
                public const int Status302Found = 302;
                public const int Status303SeeOther = 303;
                public const int Status304NotModified = 304;
                public const int Status305UseProxy = 305;
                public const int Status306SwitchProxy = 306;
                public const int Status307TemporaryRedirect = 307;
                public const int Status308PermanentRedirect = 308;
                public const int Status400BadRequest = 400;
                public const int Status401Unauthorized = 401;
                public const int Status402PaymentRequired = 402;
                public const int Status403Forbidden = 403;
                public const int Status404NotFound = 404;
                public const int Status405MethodNotAllowed = 405;
                public const int Status406NotAcceptable = 406;
                public const int Status407ProxyAuthenticationRequired = 407;
                public const int Status408RequestTimeout = 408;
                public const int Status409Conflict = 409;
                public const int Status410Gone = 410;
                public const int Status411LengthRequired = 411;
                public const int Status412PreconditionFailed = 412;
                public const int Status413PayloadTooLarge = 413;
                public const int Status413RequestEntityTooLarge = 413;
                public const int Status414RequestUriTooLong = 414;
                public const int Status414UriTooLong = 414;
                public const int Status415UnsupportedMediaType = 415;
                public const int Status416RangeNotSatisfiable = 416;
                public const int Status416RequestedRangeNotSatisfiable = 416;
                public const int Status417ExpectationFailed = 417;
                public const int Status418ImATeapot = 418;
                public const int Status419AuthenticationTimeout = 419;
                public const int Status421MisdirectedRequest = 421;
                public const int Status422UnprocessableEntity = 422;
                public const int Status423Locked = 423;
                public const int Status424FailedDependency = 424;
                public const int Status426UpgradeRequired = 426;
                public const int Status428PreconditionRequired = 428;
                public const int Status429TooManyRequests = 429;
                public const int Status431RequestHeaderFieldsTooLarge = 431;
                public const int Status451UnavailableForLegalReasons = 451;
                public const int Status499ClientClosedRequest = 499;
                public const int Status500InternalServerError = 500;
                public const int Status501NotImplemented = 501;
                public const int Status502BadGateway = 502;
                public const int Status503ServiceUnavailable = 503;
                public const int Status504GatewayTimeout = 504;
                public const int Status505HttpVersionNotsupported = 505;
                public const int Status506VariantAlsoNegotiates = 506;
                public const int Status507InsufficientStorage = 507;
                public const int Status508LoopDetected = 508;
                public const int Status510NotExtended = 510;
                public const int Status511NetworkAuthenticationRequired = 511;
            }
            public abstract class WebSocketManager
            {
                public virtual System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptWebSocketAsync() => throw null;
                public abstract System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptWebSocketAsync(string subProtocol);
                public virtual System.Threading.Tasks.Task<System.Net.WebSockets.WebSocket> AcceptWebSocketAsync(Microsoft.AspNetCore.Http.WebSocketAcceptContext acceptContext) => throw null;
                protected WebSocketManager() => throw null;
                public abstract bool IsWebSocketRequest { get; }
                public abstract System.Collections.Generic.IList<string> WebSocketRequestedProtocols { get; }
            }
        }
        namespace Mvc
        {
            public class ProblemDetails
            {
                public ProblemDetails() => throw null;
                public string Detail { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> Extensions { get => throw null; set { } }
                public string Instance { get => throw null; set { } }
                public int? Status { get => throw null; set { } }
                public string Title { get => throw null; set { } }
                public string Type { get => throw null; set { } }
            }
        }
        namespace Routing
        {
            public class RouteValueDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyDictionary<string, object>
            {
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Add(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                public void Add(string key, object value) => throw null;
                public void Clear() => throw null;
                public System.Collections.Generic.IEqualityComparer<string> Comparer { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                public bool ContainsKey(string key) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public RouteValueDictionary() => throw null;
                public RouteValueDictionary(object values) => throw null;
                public RouteValueDictionary(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> values) => throw null;
                public RouteValueDictionary(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> values) => throw null;
                public RouteValueDictionary(Microsoft.AspNetCore.Routing.RouteValueDictionary dictionary) => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerator
                {
                    public Enumerator(Microsoft.AspNetCore.Routing.RouteValueDictionary dictionary) => throw null;
                    public System.Collections.Generic.KeyValuePair<string, object> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public static Microsoft.AspNetCore.Routing.RouteValueDictionary FromArray(System.Collections.Generic.KeyValuePair<string, object>[] items) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.IsReadOnly { get => throw null; }
                public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<string> System.Collections.Generic.IReadOnlyDictionary<string, object>.Keys { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                public bool Remove(string key) => throw null;
                public bool Remove(string key, out object value) => throw null;
                public object this[string key] { get => throw null; set { } }
                public bool TryAdd(string key, object value) => throw null;
                public bool TryGetValue(string key, out object value) => throw null;
                public System.Collections.Generic.ICollection<object> Values { get => throw null; }
                System.Collections.Generic.IEnumerable<object> System.Collections.Generic.IReadOnlyDictionary<string, object>.Values { get => throw null; }
            }
        }
    }
}
