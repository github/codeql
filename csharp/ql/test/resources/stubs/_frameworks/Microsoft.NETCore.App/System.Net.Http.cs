// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace Http
        {
            // Generated from `System.Net.Http.ByteArrayContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ByteArrayContent : System.Net.Http.HttpContent
            {
                public ByteArrayContent(System.Byte[] content) => throw null;
                public ByteArrayContent(System.Byte[] content, int offset, int count) => throw null;
                protected override System.IO.Stream CreateContentReadStream(System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync() => throw null;
                protected override void SerializeToStream(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override bool TryComputeLength(out System.Int64 length) => throw null;
            }

            // Generated from `System.Net.Http.ClientCertificateOption` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ClientCertificateOption
            {
                Automatic,
                Manual,
            }

            // Generated from `System.Net.Http.DelegatingHandler` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DelegatingHandler : System.Net.Http.HttpMessageHandler
            {
                protected DelegatingHandler() => throw null;
                protected DelegatingHandler(System.Net.Http.HttpMessageHandler innerHandler) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Net.Http.HttpMessageHandler InnerHandler { get => throw null; set => throw null; }
                protected internal override System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Net.Http.FormUrlEncodedContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FormUrlEncodedContent : System.Net.Http.ByteArrayContent
            {
                public FormUrlEncodedContent(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> nameValueCollection) : base(default(System.Byte[])) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Net.Http.HeaderEncodingSelector<>` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Text.Encoding HeaderEncodingSelector<TContext>(string headerName, TContext context);

            // Generated from `System.Net.Http.HttpClient` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpClient : System.Net.Http.HttpMessageInvoker
            {
                public System.Uri BaseAddress { get => throw null; set => throw null; }
                public void CancelPendingRequests() => throw null;
                public static System.Net.IWebProxy DefaultProxy { get => throw null; set => throw null; }
                public System.Net.Http.Headers.HttpRequestHeaders DefaultRequestHeaders { get => throw null; }
                public System.Version DefaultRequestVersion { get => throw null; set => throw null; }
                public System.Net.Http.HttpVersionPolicy DefaultVersionPolicy { get => throw null; set => throw null; }
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> DeleteAsync(System.Uri requestUri) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> DeleteAsync(System.Uri requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> DeleteAsync(string requestUri) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> DeleteAsync(string requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(System.Uri requestUri) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(System.Uri requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(System.Uri requestUri, System.Net.Http.HttpCompletionOption completionOption) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(System.Uri requestUri, System.Net.Http.HttpCompletionOption completionOption, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(string requestUri) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(string requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(string requestUri, System.Net.Http.HttpCompletionOption completionOption) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetAsync(string requestUri, System.Net.Http.HttpCompletionOption completionOption, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> GetByteArrayAsync(System.Uri requestUri) => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> GetByteArrayAsync(System.Uri requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> GetByteArrayAsync(string requestUri) => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> GetByteArrayAsync(string requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.IO.Stream> GetStreamAsync(System.Uri requestUri) => throw null;
                public System.Threading.Tasks.Task<System.IO.Stream> GetStreamAsync(System.Uri requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.IO.Stream> GetStreamAsync(string requestUri) => throw null;
                public System.Threading.Tasks.Task<System.IO.Stream> GetStreamAsync(string requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<string> GetStringAsync(System.Uri requestUri) => throw null;
                public System.Threading.Tasks.Task<string> GetStringAsync(System.Uri requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<string> GetStringAsync(string requestUri) => throw null;
                public System.Threading.Tasks.Task<string> GetStringAsync(string requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                public HttpClient() : base(default(System.Net.Http.HttpMessageHandler)) => throw null;
                public HttpClient(System.Net.Http.HttpMessageHandler handler) : base(default(System.Net.Http.HttpMessageHandler)) => throw null;
                public HttpClient(System.Net.Http.HttpMessageHandler handler, bool disposeHandler) : base(default(System.Net.Http.HttpMessageHandler)) => throw null;
                public System.Int64 MaxResponseContentBufferSize { get => throw null; set => throw null; }
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PatchAsync(System.Uri requestUri, System.Net.Http.HttpContent content) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PatchAsync(System.Uri requestUri, System.Net.Http.HttpContent content, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PatchAsync(string requestUri, System.Net.Http.HttpContent content) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PatchAsync(string requestUri, System.Net.Http.HttpContent content, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsync(System.Uri requestUri, System.Net.Http.HttpContent content) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsync(System.Uri requestUri, System.Net.Http.HttpContent content, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsync(string requestUri, System.Net.Http.HttpContent content) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostAsync(string requestUri, System.Net.Http.HttpContent content, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsync(System.Uri requestUri, System.Net.Http.HttpContent content) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsync(System.Uri requestUri, System.Net.Http.HttpContent content, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsync(string requestUri, System.Net.Http.HttpContent content) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutAsync(string requestUri, System.Net.Http.HttpContent content, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request) => throw null;
                public override System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpCompletionOption completionOption) => throw null;
                public System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpCompletionOption completionOption, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request) => throw null;
                public override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpCompletionOption completionOption) => throw null;
                public System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpCompletionOption completionOption, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.TimeSpan Timeout { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Http.HttpClientHandler` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpClientHandler : System.Net.Http.HttpMessageHandler
            {
                public bool AllowAutoRedirect { get => throw null; set => throw null; }
                public System.Net.DecompressionMethods AutomaticDecompression { get => throw null; set => throw null; }
                public bool CheckCertificateRevocationList { get => throw null; set => throw null; }
                public System.Net.Http.ClientCertificateOption ClientCertificateOptions { get => throw null; set => throw null; }
                public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; }
                public System.Net.CookieContainer CookieContainer { get => throw null; set => throw null; }
                public System.Net.ICredentials Credentials { get => throw null; set => throw null; }
                public static System.Func<System.Net.Http.HttpRequestMessage, System.Security.Cryptography.X509Certificates.X509Certificate2, System.Security.Cryptography.X509Certificates.X509Chain, System.Net.Security.SslPolicyErrors, bool> DangerousAcceptAnyServerCertificateValidator { get => throw null; }
                public System.Net.ICredentials DefaultProxyCredentials { get => throw null; set => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public HttpClientHandler() => throw null;
                public int MaxAutomaticRedirections { get => throw null; set => throw null; }
                public int MaxConnectionsPerServer { get => throw null; set => throw null; }
                public System.Int64 MaxRequestContentBufferSize { get => throw null; set => throw null; }
                public int MaxResponseHeadersLength { get => throw null; set => throw null; }
                public bool PreAuthenticate { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
                protected internal override System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Func<System.Net.Http.HttpRequestMessage, System.Security.Cryptography.X509Certificates.X509Certificate2, System.Security.Cryptography.X509Certificates.X509Chain, System.Net.Security.SslPolicyErrors, bool> ServerCertificateCustomValidationCallback { get => throw null; set => throw null; }
                public System.Security.Authentication.SslProtocols SslProtocols { get => throw null; set => throw null; }
                public virtual bool SupportsAutomaticDecompression { get => throw null; }
                public virtual bool SupportsProxy { get => throw null; }
                public virtual bool SupportsRedirectConfiguration { get => throw null; }
                public bool UseCookies { get => throw null; set => throw null; }
                public bool UseDefaultCredentials { get => throw null; set => throw null; }
                public bool UseProxy { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Http.HttpCompletionOption` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HttpCompletionOption
            {
                ResponseContentRead,
                ResponseHeadersRead,
            }

            // Generated from `System.Net.Http.HttpContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class HttpContent : System.IDisposable
            {
                public void CopyTo(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream stream) => throw null;
                public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream stream, System.Net.TransportContext context) => throw null;
                public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected virtual System.IO.Stream CreateContentReadStream(System.Threading.CancellationToken cancellationToken) => throw null;
                protected virtual System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync() => throw null;
                protected virtual System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Http.Headers.HttpContentHeaders Headers { get => throw null; }
                protected HttpContent() => throw null;
                public System.Threading.Tasks.Task LoadIntoBufferAsync() => throw null;
                public System.Threading.Tasks.Task LoadIntoBufferAsync(System.Int64 maxBufferSize) => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> ReadAsByteArrayAsync() => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> ReadAsByteArrayAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.IO.Stream ReadAsStream() => throw null;
                public System.IO.Stream ReadAsStream(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.IO.Stream> ReadAsStreamAsync() => throw null;
                public System.Threading.Tasks.Task<System.IO.Stream> ReadAsStreamAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<string> ReadAsStringAsync() => throw null;
                public System.Threading.Tasks.Task<string> ReadAsStringAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                protected virtual void SerializeToStream(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected abstract System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context);
                protected virtual System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal abstract bool TryComputeLength(out System.Int64 length);
            }

            // Generated from `System.Net.Http.HttpKeepAlivePingPolicy` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HttpKeepAlivePingPolicy
            {
                Always,
                WithActiveRequests,
            }

            // Generated from `System.Net.Http.HttpMessageHandler` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class HttpMessageHandler : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                protected HttpMessageHandler() => throw null;
                protected internal virtual System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal abstract System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken);
            }

            // Generated from `System.Net.Http.HttpMessageInvoker` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpMessageInvoker : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public HttpMessageInvoker(System.Net.Http.HttpMessageHandler handler) => throw null;
                public HttpMessageInvoker(System.Net.Http.HttpMessageHandler handler, bool disposeHandler) => throw null;
                public virtual System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Net.Http.HttpMethod` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpMethod : System.IEquatable<System.Net.Http.HttpMethod>
            {
                public static bool operator !=(System.Net.Http.HttpMethod left, System.Net.Http.HttpMethod right) => throw null;
                public static bool operator ==(System.Net.Http.HttpMethod left, System.Net.Http.HttpMethod right) => throw null;
                public static System.Net.Http.HttpMethod Delete { get => throw null; }
                public bool Equals(System.Net.Http.HttpMethod other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Net.Http.HttpMethod Get { get => throw null; }
                public override int GetHashCode() => throw null;
                public static System.Net.Http.HttpMethod Head { get => throw null; }
                public HttpMethod(string method) => throw null;
                public string Method { get => throw null; }
                public static System.Net.Http.HttpMethod Options { get => throw null; }
                public static System.Net.Http.HttpMethod Patch { get => throw null; }
                public static System.Net.Http.HttpMethod Post { get => throw null; }
                public static System.Net.Http.HttpMethod Put { get => throw null; }
                public override string ToString() => throw null;
                public static System.Net.Http.HttpMethod Trace { get => throw null; }
            }

            // Generated from `System.Net.Http.HttpRequestException` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpRequestException : System.Exception
            {
                public HttpRequestException() => throw null;
                public HttpRequestException(string message) => throw null;
                public HttpRequestException(string message, System.Exception inner) => throw null;
                public HttpRequestException(string message, System.Exception inner, System.Net.HttpStatusCode? statusCode) => throw null;
                public System.Net.HttpStatusCode? StatusCode { get => throw null; }
            }

            // Generated from `System.Net.Http.HttpRequestMessage` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpRequestMessage : System.IDisposable
            {
                public System.Net.Http.HttpContent Content { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Http.Headers.HttpRequestHeaders Headers { get => throw null; }
                public HttpRequestMessage() => throw null;
                public HttpRequestMessage(System.Net.Http.HttpMethod method, System.Uri requestUri) => throw null;
                public HttpRequestMessage(System.Net.Http.HttpMethod method, string requestUri) => throw null;
                public System.Net.Http.HttpMethod Method { get => throw null; set => throw null; }
                public System.Net.Http.HttpRequestOptions Options { get => throw null; }
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public System.Uri RequestUri { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public System.Version Version { get => throw null; set => throw null; }
                public System.Net.Http.HttpVersionPolicy VersionPolicy { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Http.HttpRequestOptions` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpRequestOptions : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
            {
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Add(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                void System.Collections.Generic.IDictionary<string, object>.Add(string key, object value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                bool System.Collections.Generic.IDictionary<string, object>.ContainsKey(string key) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
                int System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Count { get => throw null; }
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public HttpRequestOptions() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.IsReadOnly { get => throw null; }
                object System.Collections.Generic.IDictionary<string, object>.this[string key] { get => throw null; set => throw null; }
                System.Collections.Generic.ICollection<string> System.Collections.Generic.IDictionary<string, object>.Keys { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                bool System.Collections.Generic.IDictionary<string, object>.Remove(string key) => throw null;
                public void Set<TValue>(System.Net.Http.HttpRequestOptionsKey<TValue> key, TValue value) => throw null;
                bool System.Collections.Generic.IDictionary<string, object>.TryGetValue(string key, out object value) => throw null;
                public bool TryGetValue<TValue>(System.Net.Http.HttpRequestOptionsKey<TValue> key, out TValue value) => throw null;
                System.Collections.Generic.ICollection<object> System.Collections.Generic.IDictionary<string, object>.Values { get => throw null; }
            }

            // Generated from `System.Net.Http.HttpRequestOptionsKey<>` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct HttpRequestOptionsKey<TValue>
            {
                // Stub generator skipped constructor 
                public HttpRequestOptionsKey(string key) => throw null;
                public string Key { get => throw null; }
            }

            // Generated from `System.Net.Http.HttpResponseMessage` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HttpResponseMessage : System.IDisposable
            {
                public System.Net.Http.HttpContent Content { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Http.HttpResponseMessage EnsureSuccessStatusCode() => throw null;
                public System.Net.Http.Headers.HttpResponseHeaders Headers { get => throw null; }
                public HttpResponseMessage() => throw null;
                public HttpResponseMessage(System.Net.HttpStatusCode statusCode) => throw null;
                public bool IsSuccessStatusCode { get => throw null; }
                public string ReasonPhrase { get => throw null; set => throw null; }
                public System.Net.Http.HttpRequestMessage RequestMessage { get => throw null; set => throw null; }
                public System.Net.HttpStatusCode StatusCode { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public System.Net.Http.Headers.HttpResponseHeaders TrailingHeaders { get => throw null; }
                public System.Version Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Http.HttpVersionPolicy` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HttpVersionPolicy
            {
                RequestVersionExact,
                RequestVersionOrHigher,
                RequestVersionOrLower,
            }

            // Generated from `System.Net.Http.MessageProcessingHandler` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class MessageProcessingHandler : System.Net.Http.DelegatingHandler
            {
                protected MessageProcessingHandler() => throw null;
                protected MessageProcessingHandler(System.Net.Http.HttpMessageHandler innerHandler) => throw null;
                protected abstract System.Net.Http.HttpRequestMessage ProcessRequest(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken);
                protected abstract System.Net.Http.HttpResponseMessage ProcessResponse(System.Net.Http.HttpResponseMessage response, System.Threading.CancellationToken cancellationToken);
                protected internal override System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Net.Http.MultipartContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MultipartContent : System.Net.Http.HttpContent, System.Collections.Generic.IEnumerable<System.Net.Http.HttpContent>, System.Collections.IEnumerable
            {
                public virtual void Add(System.Net.Http.HttpContent content) => throw null;
                protected override System.IO.Stream CreateContentReadStream(System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync() => throw null;
                protected override System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Collections.Generic.IEnumerator<System.Net.Http.HttpContent> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Net.Http.HeaderEncodingSelector<System.Net.Http.HttpContent> HeaderEncodingSelector { get => throw null; set => throw null; }
                public MultipartContent() => throw null;
                public MultipartContent(string subtype) => throw null;
                public MultipartContent(string subtype, string boundary) => throw null;
                protected override void SerializeToStream(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override bool TryComputeLength(out System.Int64 length) => throw null;
            }

            // Generated from `System.Net.Http.MultipartFormDataContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MultipartFormDataContent : System.Net.Http.MultipartContent
            {
                public override void Add(System.Net.Http.HttpContent content) => throw null;
                public void Add(System.Net.Http.HttpContent content, string name) => throw null;
                public void Add(System.Net.Http.HttpContent content, string name, string fileName) => throw null;
                public MultipartFormDataContent() => throw null;
                public MultipartFormDataContent(string boundary) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Net.Http.ReadOnlyMemoryContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ReadOnlyMemoryContent : System.Net.Http.HttpContent
            {
                protected override System.IO.Stream CreateContentReadStream(System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync() => throw null;
                public ReadOnlyMemoryContent(System.ReadOnlyMemory<System.Byte> content) => throw null;
                protected override void SerializeToStream(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override bool TryComputeLength(out System.Int64 length) => throw null;
            }

            // Generated from `System.Net.Http.SocketsHttpConnectionContext` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SocketsHttpConnectionContext
            {
                public System.Net.DnsEndPoint DnsEndPoint { get => throw null; }
                public System.Net.Http.HttpRequestMessage InitialRequestMessage { get => throw null; }
            }

            // Generated from `System.Net.Http.SocketsHttpHandler` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SocketsHttpHandler : System.Net.Http.HttpMessageHandler
            {
                public bool AllowAutoRedirect { get => throw null; set => throw null; }
                public System.Net.DecompressionMethods AutomaticDecompression { get => throw null; set => throw null; }
                public System.Func<System.Net.Http.SocketsHttpConnectionContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.IO.Stream>> ConnectCallback { get => throw null; set => throw null; }
                public System.TimeSpan ConnectTimeout { get => throw null; set => throw null; }
                public System.Net.CookieContainer CookieContainer { get => throw null; set => throw null; }
                public System.Net.ICredentials Credentials { get => throw null; set => throw null; }
                public System.Net.ICredentials DefaultProxyCredentials { get => throw null; set => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public bool EnableMultipleHttp2Connections { get => throw null; set => throw null; }
                public System.TimeSpan Expect100ContinueTimeout { get => throw null; set => throw null; }
                public static bool IsSupported { get => throw null; }
                public System.TimeSpan KeepAlivePingDelay { get => throw null; set => throw null; }
                public System.Net.Http.HttpKeepAlivePingPolicy KeepAlivePingPolicy { get => throw null; set => throw null; }
                public System.TimeSpan KeepAlivePingTimeout { get => throw null; set => throw null; }
                public int MaxAutomaticRedirections { get => throw null; set => throw null; }
                public int MaxConnectionsPerServer { get => throw null; set => throw null; }
                public int MaxResponseDrainSize { get => throw null; set => throw null; }
                public int MaxResponseHeadersLength { get => throw null; set => throw null; }
                public System.Func<System.Net.Http.SocketsHttpPlaintextStreamFilterContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.IO.Stream>> PlaintextStreamFilter { get => throw null; set => throw null; }
                public System.TimeSpan PooledConnectionIdleTimeout { get => throw null; set => throw null; }
                public System.TimeSpan PooledConnectionLifetime { get => throw null; set => throw null; }
                public bool PreAuthenticate { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
                public System.Net.Http.HeaderEncodingSelector<System.Net.Http.HttpRequestMessage> RequestHeaderEncodingSelector { get => throw null; set => throw null; }
                public System.TimeSpan ResponseDrainTimeout { get => throw null; set => throw null; }
                public System.Net.Http.HeaderEncodingSelector<System.Net.Http.HttpRequestMessage> ResponseHeaderEncodingSelector { get => throw null; set => throw null; }
                protected internal override System.Net.Http.HttpResponseMessage Send(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                protected internal override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                public SocketsHttpHandler() => throw null;
                public System.Net.Security.SslClientAuthenticationOptions SslOptions { get => throw null; set => throw null; }
                public bool UseCookies { get => throw null; set => throw null; }
                public bool UseProxy { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Http.SocketsHttpPlaintextStreamFilterContext` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SocketsHttpPlaintextStreamFilterContext
            {
                public System.Net.Http.HttpRequestMessage InitialRequestMessage { get => throw null; }
                public System.Version NegotiatedHttpVersion { get => throw null; }
                public System.IO.Stream PlaintextStream { get => throw null; }
            }

            // Generated from `System.Net.Http.StreamContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StreamContent : System.Net.Http.HttpContent
            {
                protected override System.IO.Stream CreateContentReadStream(System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task<System.IO.Stream> CreateContentReadStreamAsync() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void SerializeToStream(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context) => throw null;
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                public StreamContent(System.IO.Stream content) => throw null;
                public StreamContent(System.IO.Stream content, int bufferSize) => throw null;
                protected internal override bool TryComputeLength(out System.Int64 length) => throw null;
            }

            // Generated from `System.Net.Http.StringContent` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StringContent : System.Net.Http.ByteArrayContent
            {
                protected override System.Threading.Tasks.Task SerializeToStreamAsync(System.IO.Stream stream, System.Net.TransportContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                public StringContent(string content) : base(default(System.Byte[])) => throw null;
                public StringContent(string content, System.Text.Encoding encoding) : base(default(System.Byte[])) => throw null;
                public StringContent(string content, System.Text.Encoding encoding, string mediaType) : base(default(System.Byte[])) => throw null;
            }

            namespace Headers
            {
                // Generated from `System.Net.Http.Headers.AuthenticationHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class AuthenticationHeaderValue : System.ICloneable
                {
                    public AuthenticationHeaderValue(string scheme) => throw null;
                    public AuthenticationHeaderValue(string scheme, string parameter) => throw null;
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public string Parameter { get => throw null; }
                    public static System.Net.Http.Headers.AuthenticationHeaderValue Parse(string input) => throw null;
                    public string Scheme { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.AuthenticationHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.CacheControlHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class CacheControlHeaderValue : System.ICloneable
                {
                    public CacheControlHeaderValue() => throw null;
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Collections.Generic.ICollection<System.Net.Http.Headers.NameValueHeaderValue> Extensions { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public System.TimeSpan? MaxAge { get => throw null; set => throw null; }
                    public bool MaxStale { get => throw null; set => throw null; }
                    public System.TimeSpan? MaxStaleLimit { get => throw null; set => throw null; }
                    public System.TimeSpan? MinFresh { get => throw null; set => throw null; }
                    public bool MustRevalidate { get => throw null; set => throw null; }
                    public bool NoCache { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<string> NoCacheHeaders { get => throw null; }
                    public bool NoStore { get => throw null; set => throw null; }
                    public bool NoTransform { get => throw null; set => throw null; }
                    public bool OnlyIfCached { get => throw null; set => throw null; }
                    public static System.Net.Http.Headers.CacheControlHeaderValue Parse(string input) => throw null;
                    public bool Private { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<string> PrivateHeaders { get => throw null; }
                    public bool ProxyRevalidate { get => throw null; set => throw null; }
                    public bool Public { get => throw null; set => throw null; }
                    public System.TimeSpan? SharedMaxAge { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.CacheControlHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.ContentDispositionHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ContentDispositionHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    protected ContentDispositionHeaderValue(System.Net.Http.Headers.ContentDispositionHeaderValue source) => throw null;
                    public ContentDispositionHeaderValue(string dispositionType) => throw null;
                    public System.DateTimeOffset? CreationDate { get => throw null; set => throw null; }
                    public string DispositionType { get => throw null; set => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public string FileName { get => throw null; set => throw null; }
                    public string FileNameStar { get => throw null; set => throw null; }
                    public override int GetHashCode() => throw null;
                    public System.DateTimeOffset? ModificationDate { get => throw null; set => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<System.Net.Http.Headers.NameValueHeaderValue> Parameters { get => throw null; }
                    public static System.Net.Http.Headers.ContentDispositionHeaderValue Parse(string input) => throw null;
                    public System.DateTimeOffset? ReadDate { get => throw null; set => throw null; }
                    public System.Int64? Size { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.ContentDispositionHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.ContentRangeHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ContentRangeHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public ContentRangeHeaderValue(System.Int64 length) => throw null;
                    public ContentRangeHeaderValue(System.Int64 from, System.Int64 to) => throw null;
                    public ContentRangeHeaderValue(System.Int64 from, System.Int64 to, System.Int64 length) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Int64? From { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public bool HasLength { get => throw null; }
                    public bool HasRange { get => throw null; }
                    public System.Int64? Length { get => throw null; }
                    public static System.Net.Http.Headers.ContentRangeHeaderValue Parse(string input) => throw null;
                    public System.Int64? To { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.ContentRangeHeaderValue parsedValue) => throw null;
                    public string Unit { get => throw null; set => throw null; }
                }

                // Generated from `System.Net.Http.Headers.EntityTagHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class EntityTagHeaderValue : System.ICloneable
                {
                    public static System.Net.Http.Headers.EntityTagHeaderValue Any { get => throw null; }
                    object System.ICloneable.Clone() => throw null;
                    public EntityTagHeaderValue(string tag) => throw null;
                    public EntityTagHeaderValue(string tag, bool isWeak) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsWeak { get => throw null; }
                    public static System.Net.Http.Headers.EntityTagHeaderValue Parse(string input) => throw null;
                    public string Tag { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.EntityTagHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.HttpContentHeaders` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class HttpContentHeaders : System.Net.Http.Headers.HttpHeaders
                {
                    public System.Collections.Generic.ICollection<string> Allow { get => throw null; }
                    public System.Net.Http.Headers.ContentDispositionHeaderValue ContentDisposition { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<string> ContentEncoding { get => throw null; }
                    public System.Collections.Generic.ICollection<string> ContentLanguage { get => throw null; }
                    public System.Int64? ContentLength { get => throw null; set => throw null; }
                    public System.Uri ContentLocation { get => throw null; set => throw null; }
                    public System.Byte[] ContentMD5 { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.ContentRangeHeaderValue ContentRange { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.MediaTypeHeaderValue ContentType { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Expires { get => throw null; set => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                }

                // Generated from `System.Net.Http.Headers.HttpHeaderValueCollection<>` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class HttpHeaderValueCollection<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable where T : class
                {
                    public void Add(T item) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(T item) => throw null;
                    public void CopyTo(T[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public void ParseAdd(string input) => throw null;
                    public bool Remove(T item) => throw null;
                    public override string ToString() => throw null;
                    public bool TryParseAdd(string input) => throw null;
                }

                // Generated from `System.Net.Http.Headers.HttpHeaders` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public abstract class HttpHeaders : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Collections.Generic.IEnumerable<string>>>, System.Collections.IEnumerable
                {
                    public void Add(string name, System.Collections.Generic.IEnumerable<string> values) => throw null;
                    public void Add(string name, string value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(string name) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, System.Collections.Generic.IEnumerable<string>>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetValues(string name) => throw null;
                    protected HttpHeaders() => throw null;
                    public bool Remove(string name) => throw null;
                    public override string ToString() => throw null;
                    public bool TryAddWithoutValidation(string name, System.Collections.Generic.IEnumerable<string> values) => throw null;
                    public bool TryAddWithoutValidation(string name, string value) => throw null;
                    public bool TryGetValues(string name, out System.Collections.Generic.IEnumerable<string> values) => throw null;
                }

                // Generated from `System.Net.Http.Headers.HttpRequestHeaders` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class HttpRequestHeaders : System.Net.Http.Headers.HttpHeaders
                {
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.MediaTypeWithQualityHeaderValue> Accept { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.StringWithQualityHeaderValue> AcceptCharset { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.StringWithQualityHeaderValue> AcceptEncoding { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.StringWithQualityHeaderValue> AcceptLanguage { get => throw null; }
                    public System.Net.Http.Headers.AuthenticationHeaderValue Authorization { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.CacheControlHeaderValue CacheControl { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<string> Connection { get => throw null; }
                    public bool? ConnectionClose { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Date { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.NameValueWithParametersHeaderValue> Expect { get => throw null; }
                    public bool? ExpectContinue { get => throw null; set => throw null; }
                    public string From { get => throw null; set => throw null; }
                    public string Host { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.EntityTagHeaderValue> IfMatch { get => throw null; }
                    public System.DateTimeOffset? IfModifiedSince { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.EntityTagHeaderValue> IfNoneMatch { get => throw null; }
                    public System.Net.Http.Headers.RangeConditionHeaderValue IfRange { get => throw null; set => throw null; }
                    public System.DateTimeOffset? IfUnmodifiedSince { get => throw null; set => throw null; }
                    public int? MaxForwards { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.NameValueHeaderValue> Pragma { get => throw null; }
                    public System.Net.Http.Headers.AuthenticationHeaderValue ProxyAuthorization { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.RangeHeaderValue Range { get => throw null; set => throw null; }
                    public System.Uri Referrer { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.TransferCodingWithQualityHeaderValue> TE { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<string> Trailer { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.TransferCodingHeaderValue> TransferEncoding { get => throw null; }
                    public bool? TransferEncodingChunked { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.ProductHeaderValue> Upgrade { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.ProductInfoHeaderValue> UserAgent { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.ViaHeaderValue> Via { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.WarningHeaderValue> Warning { get => throw null; }
                }

                // Generated from `System.Net.Http.Headers.HttpResponseHeaders` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class HttpResponseHeaders : System.Net.Http.Headers.HttpHeaders
                {
                    public System.Net.Http.Headers.HttpHeaderValueCollection<string> AcceptRanges { get => throw null; }
                    public System.TimeSpan? Age { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.CacheControlHeaderValue CacheControl { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<string> Connection { get => throw null; }
                    public bool? ConnectionClose { get => throw null; set => throw null; }
                    public System.DateTimeOffset? Date { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.EntityTagHeaderValue ETag { get => throw null; set => throw null; }
                    public System.Uri Location { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.NameValueHeaderValue> Pragma { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.AuthenticationHeaderValue> ProxyAuthenticate { get => throw null; }
                    public System.Net.Http.Headers.RetryConditionHeaderValue RetryAfter { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.ProductInfoHeaderValue> Server { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<string> Trailer { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.TransferCodingHeaderValue> TransferEncoding { get => throw null; }
                    public bool? TransferEncodingChunked { get => throw null; set => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.ProductHeaderValue> Upgrade { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<string> Vary { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.ViaHeaderValue> Via { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.WarningHeaderValue> Warning { get => throw null; }
                    public System.Net.Http.Headers.HttpHeaderValueCollection<System.Net.Http.Headers.AuthenticationHeaderValue> WwwAuthenticate { get => throw null; }
                }

                // Generated from `System.Net.Http.Headers.MediaTypeHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class MediaTypeHeaderValue : System.ICloneable
                {
                    public string CharSet { get => throw null; set => throw null; }
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public string MediaType { get => throw null; set => throw null; }
                    protected MediaTypeHeaderValue(System.Net.Http.Headers.MediaTypeHeaderValue source) => throw null;
                    public MediaTypeHeaderValue(string mediaType) => throw null;
                    public System.Collections.Generic.ICollection<System.Net.Http.Headers.NameValueHeaderValue> Parameters { get => throw null; }
                    public static System.Net.Http.Headers.MediaTypeHeaderValue Parse(string input) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.MediaTypeHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.MediaTypeWithQualityHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class MediaTypeWithQualityHeaderValue : System.Net.Http.Headers.MediaTypeHeaderValue, System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public MediaTypeWithQualityHeaderValue(string mediaType) : base(default(System.Net.Http.Headers.MediaTypeHeaderValue)) => throw null;
                    public MediaTypeWithQualityHeaderValue(string mediaType, double quality) : base(default(System.Net.Http.Headers.MediaTypeHeaderValue)) => throw null;
                    public static System.Net.Http.Headers.MediaTypeWithQualityHeaderValue Parse(string input) => throw null;
                    public double? Quality { get => throw null; set => throw null; }
                    public static bool TryParse(string input, out System.Net.Http.Headers.MediaTypeWithQualityHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.NameValueHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class NameValueHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public string Name { get => throw null; }
                    protected NameValueHeaderValue(System.Net.Http.Headers.NameValueHeaderValue source) => throw null;
                    public NameValueHeaderValue(string name) => throw null;
                    public NameValueHeaderValue(string name, string value) => throw null;
                    public static System.Net.Http.Headers.NameValueHeaderValue Parse(string input) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.NameValueHeaderValue parsedValue) => throw null;
                    public string Value { get => throw null; set => throw null; }
                }

                // Generated from `System.Net.Http.Headers.NameValueWithParametersHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class NameValueWithParametersHeaderValue : System.Net.Http.Headers.NameValueHeaderValue, System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    protected NameValueWithParametersHeaderValue(System.Net.Http.Headers.NameValueWithParametersHeaderValue source) : base(default(System.Net.Http.Headers.NameValueHeaderValue)) => throw null;
                    public NameValueWithParametersHeaderValue(string name) : base(default(System.Net.Http.Headers.NameValueHeaderValue)) => throw null;
                    public NameValueWithParametersHeaderValue(string name, string value) : base(default(System.Net.Http.Headers.NameValueHeaderValue)) => throw null;
                    public System.Collections.Generic.ICollection<System.Net.Http.Headers.NameValueHeaderValue> Parameters { get => throw null; }
                    public static System.Net.Http.Headers.NameValueWithParametersHeaderValue Parse(string input) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.NameValueWithParametersHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.ProductHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ProductHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public string Name { get => throw null; }
                    public static System.Net.Http.Headers.ProductHeaderValue Parse(string input) => throw null;
                    public ProductHeaderValue(string name) => throw null;
                    public ProductHeaderValue(string name, string version) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.ProductHeaderValue parsedValue) => throw null;
                    public string Version { get => throw null; }
                }

                // Generated from `System.Net.Http.Headers.ProductInfoHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ProductInfoHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public string Comment { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.ProductInfoHeaderValue Parse(string input) => throw null;
                    public System.Net.Http.Headers.ProductHeaderValue Product { get => throw null; }
                    public ProductInfoHeaderValue(System.Net.Http.Headers.ProductHeaderValue product) => throw null;
                    public ProductInfoHeaderValue(string comment) => throw null;
                    public ProductInfoHeaderValue(string productName, string productVersion) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.ProductInfoHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.RangeConditionHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class RangeConditionHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public System.DateTimeOffset? Date { get => throw null; }
                    public System.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.RangeConditionHeaderValue Parse(string input) => throw null;
                    public RangeConditionHeaderValue(System.DateTimeOffset date) => throw null;
                    public RangeConditionHeaderValue(System.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                    public RangeConditionHeaderValue(string entityTag) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.RangeConditionHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.RangeHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class RangeHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.RangeHeaderValue Parse(string input) => throw null;
                    public RangeHeaderValue() => throw null;
                    public RangeHeaderValue(System.Int64? from, System.Int64? to) => throw null;
                    public System.Collections.Generic.ICollection<System.Net.Http.Headers.RangeItemHeaderValue> Ranges { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.RangeHeaderValue parsedValue) => throw null;
                    public string Unit { get => throw null; set => throw null; }
                }

                // Generated from `System.Net.Http.Headers.RangeItemHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class RangeItemHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Int64? From { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public RangeItemHeaderValue(System.Int64? from, System.Int64? to) => throw null;
                    public System.Int64? To { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `System.Net.Http.Headers.RetryConditionHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class RetryConditionHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public System.DateTimeOffset? Date { get => throw null; }
                    public System.TimeSpan? Delta { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.RetryConditionHeaderValue Parse(string input) => throw null;
                    public RetryConditionHeaderValue(System.DateTimeOffset date) => throw null;
                    public RetryConditionHeaderValue(System.TimeSpan delta) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.RetryConditionHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.StringWithQualityHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class StringWithQualityHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.StringWithQualityHeaderValue Parse(string input) => throw null;
                    public double? Quality { get => throw null; }
                    public StringWithQualityHeaderValue(string value) => throw null;
                    public StringWithQualityHeaderValue(string value, double quality) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.StringWithQualityHeaderValue parsedValue) => throw null;
                    public string Value { get => throw null; }
                }

                // Generated from `System.Net.Http.Headers.TransferCodingHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class TransferCodingHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Collections.Generic.ICollection<System.Net.Http.Headers.NameValueHeaderValue> Parameters { get => throw null; }
                    public static System.Net.Http.Headers.TransferCodingHeaderValue Parse(string input) => throw null;
                    public override string ToString() => throw null;
                    protected TransferCodingHeaderValue(System.Net.Http.Headers.TransferCodingHeaderValue source) => throw null;
                    public TransferCodingHeaderValue(string value) => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.TransferCodingHeaderValue parsedValue) => throw null;
                    public string Value { get => throw null; }
                }

                // Generated from `System.Net.Http.Headers.TransferCodingWithQualityHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class TransferCodingWithQualityHeaderValue : System.Net.Http.Headers.TransferCodingHeaderValue, System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public static System.Net.Http.Headers.TransferCodingWithQualityHeaderValue Parse(string input) => throw null;
                    public double? Quality { get => throw null; set => throw null; }
                    public TransferCodingWithQualityHeaderValue(string value) : base(default(System.Net.Http.Headers.TransferCodingHeaderValue)) => throw null;
                    public TransferCodingWithQualityHeaderValue(string value, double quality) : base(default(System.Net.Http.Headers.TransferCodingHeaderValue)) => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.TransferCodingWithQualityHeaderValue parsedValue) => throw null;
                }

                // Generated from `System.Net.Http.Headers.ViaHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ViaHeaderValue : System.ICloneable
                {
                    object System.ICloneable.Clone() => throw null;
                    public string Comment { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.ViaHeaderValue Parse(string input) => throw null;
                    public string ProtocolName { get => throw null; }
                    public string ProtocolVersion { get => throw null; }
                    public string ReceivedBy { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.ViaHeaderValue parsedValue) => throw null;
                    public ViaHeaderValue(string protocolVersion, string receivedBy) => throw null;
                    public ViaHeaderValue(string protocolVersion, string receivedBy, string protocolName) => throw null;
                    public ViaHeaderValue(string protocolVersion, string receivedBy, string protocolName, string comment) => throw null;
                }

                // Generated from `System.Net.Http.Headers.WarningHeaderValue` in `System.Net.Http, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class WarningHeaderValue : System.ICloneable
                {
                    public string Agent { get => throw null; }
                    object System.ICloneable.Clone() => throw null;
                    public int Code { get => throw null; }
                    public System.DateTimeOffset? Date { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static System.Net.Http.Headers.WarningHeaderValue Parse(string input) => throw null;
                    public string Text { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(string input, out System.Net.Http.Headers.WarningHeaderValue parsedValue) => throw null;
                    public WarningHeaderValue(int code, string agent, string text) => throw null;
                    public WarningHeaderValue(int code, string agent, string text, System.DateTimeOffset date) => throw null;
                }

            }
        }
    }
}
