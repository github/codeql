// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            // Generated from `Microsoft.AspNetCore.Http.HeaderDictionaryTypeExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HeaderDictionaryTypeExtensions
            {
                public static void AppendList<T>(this Microsoft.AspNetCore.Http.IHeaderDictionary Headers, string name, System.Collections.Generic.IList<T> values) => throw null;
                public static Microsoft.AspNetCore.Http.Headers.ResponseHeaders GetTypedHeaders(this Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
                public static Microsoft.AspNetCore.Http.Headers.RequestHeaders GetTypedHeaders(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpContextServerVariableExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpContextServerVariableExtensions
            {
                public static string GetServerVariable(this Microsoft.AspNetCore.Http.HttpContext context, string variableName) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpRequestJsonExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpRequestJsonExtensions
            {
                public static bool HasJsonContentType(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                public static System.Threading.Tasks.ValueTask<object> ReadFromJsonAsync(this Microsoft.AspNetCore.Http.HttpRequest request, System.Type type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> ReadFromJsonAsync(this Microsoft.AspNetCore.Http.HttpRequest request, System.Type type, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> ReadFromJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpRequest request, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> ReadFromJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpRequest request, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.HttpResponseJsonExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpResponseJsonExtensions
            {
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Text.Json.JsonSerializerOptions options, string contentType, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync<TValue>(this Microsoft.AspNetCore.Http.HttpResponse response, TValue value, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Text.Json.JsonSerializerOptions options, string contentType, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsJsonAsync(this Microsoft.AspNetCore.Http.HttpResponse response, object value, System.Type type, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.ResponseExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ResponseExtensions
            {
                public static void Clear(this Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
                public static void Redirect(this Microsoft.AspNetCore.Http.HttpResponse response, string location, bool permanent, bool preserveMethod) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.SendFileResponseExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class SendFileResponseExtensions
            {
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string fileName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, string fileName, System.Int64 offset, System.Int64? count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, Microsoft.Extensions.FileProviders.IFileInfo file, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendFileAsync(this Microsoft.AspNetCore.Http.HttpResponse response, Microsoft.Extensions.FileProviders.IFileInfo file, System.Int64 offset, System.Int64? count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Http.SessionExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class SessionExtensions
            {
                public static System.Byte[] Get(this Microsoft.AspNetCore.Http.ISession session, string key) => throw null;
                public static int? GetInt32(this Microsoft.AspNetCore.Http.ISession session, string key) => throw null;
                public static string GetString(this Microsoft.AspNetCore.Http.ISession session, string key) => throw null;
                public static void SetInt32(this Microsoft.AspNetCore.Http.ISession session, string key, int value) => throw null;
                public static void SetString(this Microsoft.AspNetCore.Http.ISession session, string key, string value) => throw null;
            }

            namespace Extensions
            {
                // Generated from `Microsoft.AspNetCore.Http.Extensions.HttpRequestMultipartExtensions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HttpRequestMultipartExtensions
                {
                    public static string GetMultipartBoundary(this Microsoft.AspNetCore.Http.HttpRequest request) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Extensions.QueryBuilder` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class QueryBuilder : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>
                {
                    public void Add(string key, string value) => throw null;
                    public void Add(string key, System.Collections.Generic.IEnumerable<string> values) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    public QueryBuilder(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> parameters) => throw null;
                    public QueryBuilder(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> parameters) => throw null;
                    public QueryBuilder() => throw null;
                    public Microsoft.AspNetCore.Http.QueryString ToQueryString() => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Extensions.StreamCopyOperation` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class StreamCopyOperation
                {
                    public static System.Threading.Tasks.Task CopyToAsync(System.IO.Stream source, System.IO.Stream destination, System.Int64? count, int bufferSize, System.Threading.CancellationToken cancel) => throw null;
                    public static System.Threading.Tasks.Task CopyToAsync(System.IO.Stream source, System.IO.Stream destination, System.Int64? count, System.Threading.CancellationToken cancel) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Extensions.UriHelper` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
            namespace Headers
            {
                // Generated from `Microsoft.AspNetCore.Http.Headers.RequestHeaders` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RequestHeaders
                {
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.MediaTypeHeaderValue> Accept { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> AcceptCharset { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> AcceptEncoding { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> AcceptLanguage { get => throw null; set => throw null; }
                    public void Append(string name, object value) => throw null;
                    public void AppendList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                    public Microsoft.Net.Http.Headers.CacheControlHeaderValue CacheControl { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.ContentDispositionHeaderValue ContentDisposition { get => throw null; set => throw null; }
                    public System.Int64? ContentLength { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.ContentRangeHeaderValue ContentRange { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.MediaTypeHeaderValue ContentType { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.CookieHeaderValue> Cookie { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Date { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Expires { get => throw null; set => throw null; }
                    public T Get<T>(string name) => throw null;
                    public System.Collections.Generic.IList<T> GetList<T>(string name) => throw null;
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; }
                    public Microsoft.AspNetCore.Http.HostString Host { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> IfMatch { get => throw null; set => throw null; }
                    public System.DateTimeOffset? IfModifiedSince { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> IfNoneMatch { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.RangeConditionHeaderValue IfRange { get => throw null; set => throw null; }
                    public System.DateTimeOffset? IfUnmodifiedSince { get => throw null; set => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.RangeHeaderValue Range { get => throw null; set => throw null; }
                    public System.Uri Referer { get => throw null; set => throw null; }
                    public RequestHeaders(Microsoft.AspNetCore.Http.IHeaderDictionary headers) => throw null;
                    public void Set(string name, object value) => throw null;
                    public void SetList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Headers.ResponseHeaders` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ResponseHeaders
                {
                    public void Append(string name, object value) => throw null;
                    public void AppendList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                    public Microsoft.Net.Http.Headers.CacheControlHeaderValue CacheControl { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.ContentDispositionHeaderValue ContentDisposition { get => throw null; set => throw null; }
                    public System.Int64? ContentLength { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.ContentRangeHeaderValue ContentRange { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.MediaTypeHeaderValue ContentType { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Date { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue ETag { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Expires { get => throw null; set => throw null; }
                    public T Get<T>(string name) => throw null;
                    public System.Collections.Generic.IList<T> GetList<T>(string name) => throw null;
                    public Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                    public System.Uri Location { get => throw null; set => throw null; }
                    public ResponseHeaders(Microsoft.AspNetCore.Http.IHeaderDictionary headers) => throw null;
                    public void Set(string name, object value) => throw null;
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.SetCookieHeaderValue> SetCookie { get => throw null; set => throw null; }
                    public void SetList<T>(string name, System.Collections.Generic.IList<T> values) => throw null;
                }

            }
            namespace Json
            {
                // Generated from `Microsoft.AspNetCore.Http.Json.JsonOptions` in `Microsoft.AspNetCore.Http.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JsonOptions
                {
                    public JsonOptions() => throw null;
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                }

            }
        }
    }
}
