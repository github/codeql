// This file contains auto-generated code.
// Generated from `System.Net.WebSockets, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Net
    {
        namespace WebSockets
        {
            public struct ValueWebSocketReceiveResult
            {
                public int Count { get => throw null; }
                public ValueWebSocketReceiveResult(int count, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage) => throw null;
                public bool EndOfMessage { get => throw null; }
                public System.Net.WebSockets.WebSocketMessageType MessageType { get => throw null; }
            }
            public abstract class WebSocket : System.IDisposable
            {
                public abstract void Abort();
                public abstract System.Threading.Tasks.Task CloseAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken);
                public abstract System.Threading.Tasks.Task CloseOutputAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken);
                public abstract System.Net.WebSockets.WebSocketCloseStatus? CloseStatus { get; }
                public abstract string CloseStatusDescription { get; }
                public static System.ArraySegment<byte> CreateClientBuffer(int receiveBufferSize, int sendBufferSize) => throw null;
                public static System.Net.WebSockets.WebSocket CreateClientWebSocket(System.IO.Stream innerStream, string subProtocol, int receiveBufferSize, int sendBufferSize, System.TimeSpan keepAliveInterval, bool useZeroMaskingKey, System.ArraySegment<byte> internalBuffer) => throw null;
                public static System.Net.WebSockets.WebSocket CreateFromStream(System.IO.Stream stream, bool isServer, string subProtocol, System.TimeSpan keepAliveInterval) => throw null;
                public static System.Net.WebSockets.WebSocket CreateFromStream(System.IO.Stream stream, System.Net.WebSockets.WebSocketCreationOptions options) => throw null;
                public static System.ArraySegment<byte> CreateServerBuffer(int receiveBufferSize) => throw null;
                protected WebSocket() => throw null;
                public static System.TimeSpan DefaultKeepAliveInterval { get => throw null; }
                public abstract void Dispose();
                public static bool IsApplicationTargeting45() => throw null;
                protected static bool IsStateTerminal(System.Net.WebSockets.WebSocketState state) => throw null;
                public abstract System.Threading.Tasks.Task<System.Net.WebSockets.WebSocketReceiveResult> ReceiveAsync(System.ArraySegment<byte> buffer, System.Threading.CancellationToken cancellationToken);
                public virtual System.Threading.Tasks.ValueTask<System.Net.WebSockets.ValueWebSocketReceiveResult> ReceiveAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public static void RegisterPrefixes() => throw null;
                public abstract System.Threading.Tasks.Task SendAsync(System.ArraySegment<byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken);
                public virtual System.Threading.Tasks.ValueTask SendAsync(System.ReadOnlyMemory<byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.ValueTask SendAsync(System.ReadOnlyMemory<byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, System.Net.WebSockets.WebSocketMessageFlags messageFlags, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract System.Net.WebSockets.WebSocketState State { get; }
                public abstract string SubProtocol { get; }
                protected static void ThrowOnInvalidState(System.Net.WebSockets.WebSocketState state, params System.Net.WebSockets.WebSocketState[] validStates) => throw null;
            }
            public enum WebSocketCloseStatus
            {
                NormalClosure = 1000,
                EndpointUnavailable = 1001,
                ProtocolError = 1002,
                InvalidMessageType = 1003,
                Empty = 1005,
                InvalidPayloadData = 1007,
                PolicyViolation = 1008,
                MessageTooBig = 1009,
                MandatoryExtension = 1010,
                InternalServerError = 1011,
            }
            public abstract class WebSocketContext
            {
                public abstract System.Net.CookieCollection CookieCollection { get; }
                protected WebSocketContext() => throw null;
                public abstract System.Collections.Specialized.NameValueCollection Headers { get; }
                public abstract bool IsAuthenticated { get; }
                public abstract bool IsLocal { get; }
                public abstract bool IsSecureConnection { get; }
                public abstract string Origin { get; }
                public abstract System.Uri RequestUri { get; }
                public abstract string SecWebSocketKey { get; }
                public abstract System.Collections.Generic.IEnumerable<string> SecWebSocketProtocols { get; }
                public abstract string SecWebSocketVersion { get; }
                public abstract System.Security.Principal.IPrincipal User { get; }
                public abstract System.Net.WebSockets.WebSocket WebSocket { get; }
            }
            public sealed class WebSocketCreationOptions
            {
                public WebSocketCreationOptions() => throw null;
                public System.Net.WebSockets.WebSocketDeflateOptions DangerousDeflateOptions { get => throw null; set { } }
                public bool IsServer { get => throw null; set { } }
                public System.TimeSpan KeepAliveInterval { get => throw null; set { } }
                public string SubProtocol { get => throw null; set { } }
            }
            public sealed class WebSocketDeflateOptions
            {
                public bool ClientContextTakeover { get => throw null; set { } }
                public int ClientMaxWindowBits { get => throw null; set { } }
                public WebSocketDeflateOptions() => throw null;
                public bool ServerContextTakeover { get => throw null; set { } }
                public int ServerMaxWindowBits { get => throw null; set { } }
            }
            public enum WebSocketError
            {
                Success = 0,
                InvalidMessageType = 1,
                Faulted = 2,
                NativeError = 3,
                NotAWebSocket = 4,
                UnsupportedVersion = 5,
                UnsupportedProtocol = 6,
                HeaderError = 7,
                ConnectionClosedPrematurely = 8,
                InvalidState = 9,
            }
            public sealed class WebSocketException : System.ComponentModel.Win32Exception
            {
                public WebSocketException() => throw null;
                public WebSocketException(int nativeError) => throw null;
                public WebSocketException(int nativeError, System.Exception innerException) => throw null;
                public WebSocketException(int nativeError, string message) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, System.Exception innerException) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError, System.Exception innerException) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError, string message) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError, string message, System.Exception innerException) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, string message) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, string message, System.Exception innerException) => throw null;
                public WebSocketException(string message) => throw null;
                public WebSocketException(string message, System.Exception innerException) => throw null;
                public override int ErrorCode { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Net.WebSockets.WebSocketError WebSocketErrorCode { get => throw null; }
            }
            [System.Flags]
            public enum WebSocketMessageFlags
            {
                None = 0,
                EndOfMessage = 1,
                DisableCompression = 2,
            }
            public enum WebSocketMessageType
            {
                Text = 0,
                Binary = 1,
                Close = 2,
            }
            public class WebSocketReceiveResult
            {
                public System.Net.WebSockets.WebSocketCloseStatus? CloseStatus { get => throw null; }
                public string CloseStatusDescription { get => throw null; }
                public int Count { get => throw null; }
                public WebSocketReceiveResult(int count, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage) => throw null;
                public WebSocketReceiveResult(int count, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Net.WebSockets.WebSocketCloseStatus? closeStatus, string closeStatusDescription) => throw null;
                public bool EndOfMessage { get => throw null; }
                public System.Net.WebSockets.WebSocketMessageType MessageType { get => throw null; }
            }
            public enum WebSocketState
            {
                None = 0,
                Connecting = 1,
                Open = 2,
                CloseSent = 3,
                CloseReceived = 4,
                Closed = 5,
                Aborted = 6,
            }
        }
    }
}
