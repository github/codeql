// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace WebSockets
        {
            // Generated from `System.Net.WebSockets.ClientWebSocket` in `System.Net.WebSockets.Client, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ClientWebSocket : System.Net.WebSockets.WebSocket
            {
                public override void Abort() => throw null;
                public ClientWebSocket() => throw null;
                public override System.Threading.Tasks.Task CloseAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task CloseOutputAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Net.WebSockets.WebSocketCloseStatus? CloseStatus { get => throw null; }
                public override string CloseStatusDescription { get => throw null; }
                public System.Threading.Tasks.Task ConnectAsync(System.Uri uri, System.Threading.CancellationToken cancellationToken) => throw null;
                public override void Dispose() => throw null;
                public System.Net.WebSockets.ClientWebSocketOptions Options { get => throw null; }
                public override System.Threading.Tasks.Task<System.Net.WebSockets.WebSocketReceiveResult> ReceiveAsync(System.ArraySegment<System.Byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<System.Net.WebSockets.ValueWebSocketReceiveResult> ReceiveAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task SendAsync(System.ArraySegment<System.Byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask SendAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Net.WebSockets.WebSocketState State { get => throw null; }
                public override string SubProtocol { get => throw null; }
            }

            // Generated from `System.Net.WebSockets.ClientWebSocketOptions` in `System.Net.WebSockets.Client, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ClientWebSocketOptions
            {
                public void AddSubProtocol(string subProtocol) => throw null;
                public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; set => throw null; }
                public System.Net.CookieContainer Cookies { get => throw null; set => throw null; }
                public System.Net.ICredentials Credentials { get => throw null; set => throw null; }
                public System.TimeSpan KeepAliveInterval { get => throw null; set => throw null; }
                public System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
                public System.Net.Security.RemoteCertificateValidationCallback RemoteCertificateValidationCallback { get => throw null; set => throw null; }
                public void SetBuffer(int receiveBufferSize, int sendBufferSize) => throw null;
                public void SetBuffer(int receiveBufferSize, int sendBufferSize, System.ArraySegment<System.Byte> buffer) => throw null;
                public void SetRequestHeader(string headerName, string headerValue) => throw null;
                public bool UseDefaultCredentials { get => throw null; set => throw null; }
            }

        }
    }
}
