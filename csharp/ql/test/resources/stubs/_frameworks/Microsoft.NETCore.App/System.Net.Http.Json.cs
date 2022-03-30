// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace Http
        {
            namespace Json
            {
                // Generated from `System.Net.Http.Json.HttpClientJsonExtensions` in `System.Net.Http.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public static class HttpClientJsonExtensions
                {
                    public static System.Threading.Tasks.Task<object> GetFromJsonAsync(this System.Net.Http.HttpClient client, System.Uri requestUri, System.Type type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<object> GetFromJsonAsync(this System.Net.Http.HttpClient client, System.Uri requestUri, System.Type type, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<object> GetFromJsonAsync(this System.Net.Http.HttpClient client, string requestUri, System.Type type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<object> GetFromJsonAsync(this System.Net.Http.HttpClient client, string requestUri, System.Type type, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<TValue> GetFromJsonAsync<TValue>(this System.Net.Http.HttpClient client, System.Uri requestUri, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<TValue> GetFromJsonAsync<TValue>(this System.Net.Http.HttpClient client, System.Uri requestUri, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<TValue> GetFromJsonAsync<TValue>(this System.Net.Http.HttpClient client, string requestUri, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<TValue> GetFromJsonAsync<TValue>(this System.Net.Http.HttpClient client, string requestUri, System.Text.Json.JsonSerializerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, System.Uri requestUri, TValue value, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, System.Uri requestUri, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, string requestUri, TValue value, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, string requestUri, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, System.Uri requestUri, TValue value, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, System.Uri requestUri, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, string requestUri, TValue value, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsJsonAsync<TValue>(this System.Net.Http.HttpClient client, string requestUri, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                }

                // Generated from `System.Net.Http.Json.HttpContentJsonExtensions` in `System.Net.Http.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public static class HttpContentJsonExtensions
                {
                    public static System.Threading.Tasks.Task<object> ReadFromJsonAsync(this System.Net.Http.HttpContent content, System.Type type, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task<T> ReadFromJsonAsync<T>(this System.Net.Http.HttpContent content, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                }

                // Generated from `System.Net.Http.Json.JsonContent` in `System.Net.Http.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonContent : System.Net.Http.HttpContent
                {
                    public static System.Net.Http.Json.JsonContent Create(object inputValue, System.Type inputType, System.Net.Http.Headers.MediaTypeHeaderValue mediaType = default(System.Net.Http.Headers.MediaTypeHeaderValue), System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                    public static System.Net.Http.Json.JsonContent Create<T>(T inputValue, System.Net.Http.Headers.MediaTypeHeaderValue mediaType = default(System.Net.Http.Headers.MediaTypeHeaderValue), System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                    public System.Type ObjectType { get => throw null; }
                    protected override void SerializeToStream(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                    protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context) => throw null;
                    protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                    protected internal override bool TryComputeLength(out System.Int64 length) => throw null;
                    public object Value { get => throw null; }
                }

            }
        }
    }
}
