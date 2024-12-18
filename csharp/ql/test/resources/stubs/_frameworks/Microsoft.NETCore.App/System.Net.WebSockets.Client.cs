// This file contains auto-generated code.
// Generated from `System.Net.WebSockets.Client, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Net
    {
        namespace WebSockets
        {
            public sealed class ClientWebSocket : System.Net.WebSockets.WebSocket
            {
                public override void Abort() => throw null;
                public override System.Threading.Tasks.Task CloseAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task CloseOutputAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Net.WebSockets.WebSocketCloseStatus? CloseStatus { get => throw null; }
                public override string CloseStatusDescription { get => throw null; }
                public System.Threading.Tasks.Task ConnectAsync(System.Uri uri, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Uri uri, System.Net.Http.HttpMessageInvoker invoker, System.Threading.CancellationToken cancellationToken) => throw null;
                public ClientWebSocket() => throw null;
                public override void Dispose() => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, System.Collections.Generic.IEnumerable<string>> HttpResponseHeaders { get => throw null; set { } }
                public System.Net.HttpStatusCode HttpStatusCode { get => throw null; }
                public System.Net.WebSockets.ClientWebSocketOptions Options { get => throw null; }
                public override System.Threading.Tasks.Task<System.Net.WebSockets.WebSocketReceiveResult> ReceiveAsync(System.ArraySegment<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<System.Net.WebSockets.ValueWebSocketReceiveResult> ReceiveAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task SendAsync(System.ArraySegment<byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask SendAsync(System.ReadOnlyMemory<byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask SendAsync(System.ReadOnlyMemory<byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, System.Net.WebSockets.WebSocketMessageFlags messageFlags, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Net.WebSockets.WebSocketState State { get => throw null; }
                public override string SubProtocol { get => throw null; }
            }
            public sealed class ClientWebSocketOptions
            {
                public void AddSubProtocol(string subProtocol) => throw null;
                public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; set { } }
                public bool CollectHttpResponseDetails { get => throw null; set { } }
                public System.Net.CookieContainer Cookies { get => throw null; set { } }
                public System.Net.ICredentials Credentials { get => throw null; set { } }
                public System.Net.WebSockets.WebSocketDeflateOptions DangerousDeflateOptions { get => throw null; set { } }
                public System.Version HttpVersion { get => throw null; set { } }
                public System.Net.Http.HttpVersionPolicy HttpVersionPolicy { get => throw null; set { } }
                public System.TimeSpan KeepAliveInterval { get => throw null; set { } }
                public System.Net.IWebProxy Proxy { get => throw null; set { } }
                public System.Net.Security.RemoteCertificateValidationCallback RemoteCertificateValidationCallback { get => throw null; set { } }
                public void SetBuffer(int receiveBufferSize, int sendBufferSize) => throw null;
                public void SetBuffer(int receiveBufferSize, int sendBufferSize, System.ArraySegment<byte> buffer) => throw null;
                public void SetRequestHeader(string headerName, string headerValue) => throw null;
                public bool UseDefaultCredentials { get => throw null; set { } }
            }
        }
    }
}
