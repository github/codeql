// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Extensions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
            public sealed class EndpointDescriptionAttribute : System.Attribute, Microsoft.AspNetCore.Http.Metadata.IEndpointDescriptionMetadata
            {
                public EndpointDescriptionAttribute(string description) => throw null;
                public string Description { get => throw null; }
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
            public sealed class EndpointSummaryAttribute : System.Attribute, Microsoft.AspNetCore.Http.Metadata.IEndpointSummaryMetadata
            {
                public EndpointSummaryAttribute(string summary) => throw null;
                public string Summary { get => throw null; }
                public override string ToString() => throw null;
            }
            namespace Extensions
            {
                public static partial class HttpRequestMultipartExtensions
                {
                    public static string GetMultipartBoundary(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                }
                public class QueryBuilder : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable
                {
                    public void Add(string key, System.Collections.Generic.IEnumerable<string> values) => throw null;
                    public void Add(string key, string value) => throw null;
                    public QueryBuilder() => throw null;
                    public QueryBuilder(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> parameters) => throw null;
                    public QueryBuilder(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> parameters) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    public Microsoft.AspNetCore.Http.QueryString ToQueryString() => throw null;
                    public override string ToString() => throw null;
                }
                public static class StreamCopyOperation
                {
                    public static System.Threading.Tasks.Task CopyToAsync(System.IO.Stream source, System.IO.Stream destination, long? count, System.Threading.CancellationToken cancel) => throw null;
                    public static System.Threading.Tasks.Task CopyToAsync(System.IO.Stream source, System.IO.Stream destination, long? count, int bufferSize, System.Threading.CancellationToken cancel) => throw null;
                }
                public static class UriHelper
                {
                    public static string BuildAbsolute(string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.PathString path = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.QueryString query = default(Microsoft.AspNetCore.Http.QueryString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString)) => throw null;
                    public static string BuildRelative(Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.PathString path = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.QueryString query = default(Microsoft.AspNetCore.Http.QueryString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString)) => throw null;
                    public static string Encode(System.Uri uri) => throw null;
                    public static void FromAbsolute(string uri, out string scheme, out Microsoft.AspNetCore.Http.HostString host, out Microsoft.AspNetCore.Http.PathString path, out Microsoft.AspNetCore.Http.QueryString query, out Microsoft.AspNetCore.Http.FragmentString fragment) => throw null;
                    public static string GetDisplayUrl(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                    public static string GetEncodedPathAndQuery(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                    public static string GetEncodedUrl(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                }
            }
            public static partial class HeaderDictionaryTypeExtensions
            {
                public static void AppendList<T>(this Microsoft.AspNetCore.Http.IHeaderDictionary Headers, string name, System.Collections.Generic.IList<T> values) => throw null;
                public static Microsoft.AspNetCore.Http.Headers.RequestHeaders GetTypedHeaders(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static Microsoft.AspNetCore.Http.Headers.ResponseHeaders GetTypedHeaders(this Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
            }
            namespace Headers
            {
                public class RequestHeaders
                {
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.MediaTypeHeaderValue> Accept { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> AcceptCharset { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> AcceptEncoding { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> AcceptLanguage { get => throw null; set { } }
                    public void Append(string name, object value) => throw null;
                    public void AppendList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                    public Microsoft.Net.Http.Headers.CacheControlHeaderValue CacheControl { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.ContentDispositionHeaderValue ContentDisposition { get => throw null; set { } }
                    public long? ContentLength { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.ContentRangeHeaderValue ContentRange { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.MediaTypeHeaderValue ContentType { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.CookieHeaderValue> Cookie { get => throw null; set { } }
                    public RequestHeaders(Microsoft.AspNetCore.Http.IHeaderDictionary headers) => throw null;
                    public System.DateTimeOffset? Date { get => throw null; set { } }
                    public System.DateTimeOffset? Expires { get => throw null; set { } }
                    public T Get<T>(string name) => throw null;
                    public System.Collections.Generic.IList<T> GetList<T>(string name) => throw null;
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; }
                    public Microsoft.AspNetCore.Http.HostString Host { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> IfMatch { get => throw null; set { } }
                    public System.DateTimeOffset? IfModifiedSince { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> IfNoneMatch { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.RangeConditionHeaderValue IfRange { get => throw null; set { } }
                    public System.DateTimeOffset? IfUnmodifiedSince { get => throw null; set { } }
                    public System.DateTimeOffset? LastModified { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.RangeHeaderValue Range { get => throw null; set { } }
                    public System.Uri Referer { get => throw null; set { } }
                    public void Set(string name, object value) => throw null;
                    public void SetList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                }
                public class ResponseHeaders
                {
                    public void Append(string name, object value) => throw null;
                    public void AppendList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                    public Microsoft.Net.Http.Headers.CacheControlHeaderValue CacheControl { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.ContentDispositionHeaderValue ContentDisposition { get => throw null; set { } }
                    public long? ContentLength { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.ContentRangeHeaderValue ContentRange { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.MediaTypeHeaderValue ContentType { get => throw null; set { } }
                    public ResponseHeaders(Microsoft.AspNetCore.Http.IHeaderDictionary headers) => throw null;
                    public System.DateTimeOffset? Date { get => throw null; set { } }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue ETag { get => throw null; set { } }
                    public System.DateTimeOffset? Expires { get => throw null; set { } }
                    public T Get<T>(string name) => throw null;
                    public System.Collections.Generic.IList<T> GetList<T>(string name) => throw null;
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set { } }
                    public System.Uri Location { get => throw null; set { } }
                    public void Set(string name, object value) => throw null;
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.SetCookieHeaderValue> SetCookie { get => throw null; set { } }
                    public void SetList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                }
            }
            public static partial class HttpContextServerVariableExtensions
            {
                public static string GetServerVariable(this Microsoft.AspNetCore.Http.HttpContext context, string variableName) => throw null;
            }
            public static partial class HttpRequestJsonExtensions
            {
                public static bool HasJsonContentType(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> ReadFromJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpRequest request, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> ReadFromJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpRequest request, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> ReadFromJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpRequest request, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> ReadFromJsonAsync(this Microsoft.AspNetCore.Http.HttpRequest request, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> ReadFromJsonAsync(this Microsoft.AspNetCore.Http.HttpRequest request, System.Type type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> ReadFromJsonAsync(this Microsoft.AspNetCore.Http.HttpRequest request, System.Type type, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> ReadFromJsonAsync(this Microsoft.AspNetCore.Http.HttpRequest request, System.Type type, System.Text.Json.Serialization.JsonSerializerContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public static partial class HttpResponseJsonExtensions
            {
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Text.Json.JsonSerializerOptions options, string contentType, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, string contentType = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo, string contentType = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Text.Json.JsonSerializerOptions options, string contentType, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Text.Json.Serialization.JsonSerializerContext context, string contentType = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            namespace Json
            {
                public class JsonOptions
                {
                    public JsonOptions() => throw null;
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                }
            }
            public class ProblemDetailsOptions
            {
                public ProblemDetailsOptions() => throw null;
                public System.Action<Microsoft.AspNetCore.Http.ProblemDetailsContext> CustomizeProblemDetails { get => throw null; set { } }
            }
            public static class RequestDelegateFactory
            {
                public static Microsoft.AspNetCore.Http.RequestDelegateResult Create(System.Delegate handler, Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions options) => throw null;
                public static Microsoft.AspNetCore.Http.RequestDelegateResult Create(System.Delegate handler, Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions options = default(Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions), Microsoft.AspNetCore.Http.RequestDelegateMetadataResult metadataResult = default(Microsoft.AspNetCore.Http.RequestDelegateMetadataResult)) => throw null;
                public static Microsoft.AspNetCore.Http.RequestDelegateResult Create(System.Reflection.MethodInfo methodInfo, System.Func<Microsoft.AspNetCore.Http.HttpContext, object> targetFactory, Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions options) => throw null;
                public static Microsoft.AspNetCore.Http.RequestDelegateResult Create(System.Reflection.MethodInfo methodInfo, System.Func<Microsoft.AspNetCore.Http.HttpContext, object> targetFactory = default(System.Func<Microsoft.AspNetCore.Http.HttpContext, object>), Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions options = default(Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions), Microsoft.AspNetCore.Http.RequestDelegateMetadataResult metadataResult = default(Microsoft.AspNetCore.Http.RequestDelegateMetadataResult)) => throw null;
                public static Microsoft.AspNetCore.Http.RequestDelegateMetadataResult InferMetadata(System.Reflection.MethodInfo methodInfo, Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions options = default(Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions)) => throw null;
            }
            public sealed class RequestDelegateFactoryOptions
            {
                public RequestDelegateFactoryOptions() => throw null;
                public bool DisableInferBodyFromParameters { get => throw null; set { } }
                public Microsoft.AspNetCore.Builder.EndpointBuilder EndpointBuilder { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> RouteParameterNames { get => throw null; set { } }
                public System.IServiceProvider ServiceProvider { get => throw null; set { } }
                public bool ThrowOnBadRequest { get => throw null; set { } }
            }
            public sealed class RequestDelegateMetadataResult
            {
                public RequestDelegateMetadataResult() => throw null;
                public System.Collections.Generic.IReadOnlyList<object> EndpointMetadata { get => throw null; set { } }
            }
            public static partial class ResponseExtensions
            {
                public static void Clear(this Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
                public static void Redirect(this Microsoft.AspNetCore.Http.HttpResponse response, string location, bool permanent, bool preserveMethod) => throw null;
            }
            public static partial class SendFileResponseExtensions
            {
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, Microsoft.Extensions.FileProviders.IFileInfo file, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, Microsoft.Extensions.FileProviders.IFileInfo file, long offset, long? count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string fileName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string fileName, long offset, long? count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public static partial class SessionExtensions
            {
                public static byte[] Get(this Microsoft.AspNetCore.Http.ISession session, string key) => throw null;
                public static int? GetInt32(this Microsoft.AspNetCore.Http.ISession session, string key) => throw null;
                public static string GetString(this Microsoft.AspNetCore.Http.ISession session, string key) => throw null;
                public static void SetInt32(this Microsoft.AspNetCore.Http.ISession session, string key, int value) => throw null;
                public static void SetString(this Microsoft.AspNetCore.Http.ISession session, string key, string value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4164, Inherited = false, AllowMultiple = false)]
            public sealed class TagsAttribute : System.Attribute, Microsoft.AspNetCore.Http.Metadata.ITagsMetadata
            {
                public TagsAttribute(params string[] tags) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> Tags { get => throw null; }
                public override string ToString() => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class HttpJsonServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureHttpJsonOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Http.Json.JsonOptions> configureOptions) => throw null;
            }
            public static partial class ProblemDetailsServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddProblemDetails(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddProblemDetails(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Http.ProblemDetailsOptions> configure) => throw null;
            }
        }
    }
}
