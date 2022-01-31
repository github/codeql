// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace WebSockets
        {
            // Generated from `System.Net.WebSockets.ValueWebSocketReceiveResult` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ValueWebSocketReceiveResult
            {
                public int Count { get => throw null; }
                public bool EndOfMessage { get => throw null; }
                public System.Net.WebSockets.WebSocketMessageType MessageType { get => throw null; }
                // Stub generator skipped constructor 
                public ValueWebSocketReceiveResult(int count, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage) => throw null;
            }

            // Generated from `System.Net.WebSockets.WebSocket` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class WebSocket : System.IDisposable
            {
                public abstract void Abort();
                public abstract System.Threading.Tasks.Task CloseAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken);
                public abstract System.Threading.Tasks.Task CloseOutputAsync(System.Net.WebSockets.WebSocketCloseStatus closeStatus, string statusDescription, System.Threading.CancellationToken cancellationToken);
                public abstract System.Net.WebSockets.WebSocketCloseStatus? CloseStatus { get; }
                public abstract string CloseStatusDescription { get; }
                public static System.ArraySegment<System.Byte> CreateClientBuffer(int receiveBufferSize, int sendBufferSize) => throw null;
                public static System.Net.WebSockets.WebSocket CreateClientWebSocket(System.IO.Stream innerStream, string subProtocol, int receiveBufferSize, int sendBufferSize, System.TimeSpan keepAliveInterval, bool useZeroMaskingKey, System.ArraySegment<System.Byte> internalBuffer) => throw null;
                public static System.Net.WebSockets.WebSocket CreateFromStream(System.IO.Stream stream, bool isServer, string subProtocol, System.TimeSpan keepAliveInterval) => throw null;
                public static System.ArraySegment<System.Byte> CreateServerBuffer(int receiveBufferSize) => throw null;
                public static System.TimeSpan DefaultKeepAliveInterval { get => throw null; }
                public abstract void Dispose();
                public static bool IsApplicationTargeting45() => throw null;
                protected static bool IsStateTerminal(System.Net.WebSockets.WebSocketState state) => throw null;
                public abstract System.Threading.Tasks.Task<System.Net.WebSockets.WebSocketReceiveResult> ReceiveAsync(System.ArraySegment<System.Byte> buffer, System.Threading.CancellationToken cancellationToken);
                public virtual System.Threading.Tasks.ValueTask<System.Net.WebSockets.ValueWebSocketReceiveResult> ReceiveAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public static void RegisterPrefixes() => throw null;
                public abstract System.Threading.Tasks.Task SendAsync(System.ArraySegment<System.Byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken);
                public virtual System.Threading.Tasks.ValueTask SendAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract System.Net.WebSockets.WebSocketState State { get; }
                public abstract string SubProtocol { get; }
                protected static void ThrowOnInvalidState(System.Net.WebSockets.WebSocketState state, params System.Net.WebSockets.WebSocketState[] validStates) => throw null;
                protected WebSocket() => throw null;
            }

            // Generated from `System.Net.WebSockets.WebSocketCloseStatus` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WebSocketCloseStatus
            {
                Empty,
                EndpointUnavailable,
                InternalServerError,
                InvalidMessageType,
                InvalidPayloadData,
                MandatoryExtension,
                MessageTooBig,
                NormalClosure,
                PolicyViolation,
                ProtocolError,
            }

            // Generated from `System.Net.WebSockets.WebSocketContext` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class WebSocketContext
            {
                public abstract System.Net.CookieCollection CookieCollection { get; }
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
                protected WebSocketContext() => throw null;
            }

            // Generated from `System.Net.WebSockets.WebSocketError` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WebSocketError
            {
                ConnectionClosedPrematurely,
                Faulted,
                HeaderError,
                InvalidMessageType,
                InvalidState,
                NativeError,
                NotAWebSocket,
                Success,
                UnsupportedProtocol,
                UnsupportedVersion,
            }

            // Generated from `System.Net.WebSockets.WebSocketException` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class WebSocketException : System.ComponentModel.Win32Exception
            {
                public override int ErrorCode { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Net.WebSockets.WebSocketError WebSocketErrorCode { get => throw null; }
                public WebSocketException() => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, System.Exception innerException) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError, System.Exception innerException) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError, string message) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, int nativeError, string message, System.Exception innerException) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, string message) => throw null;
                public WebSocketException(System.Net.WebSockets.WebSocketError error, string message, System.Exception innerException) => throw null;
                public WebSocketException(int nativeError) => throw null;
                public WebSocketException(int nativeError, System.Exception innerException) => throw null;
                public WebSocketException(int nativeError, string message) => throw null;
                public WebSocketException(string message) => throw null;
                public WebSocketException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Net.WebSockets.WebSocketMessageType` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WebSocketMessageType
            {
                Binary,
                Close,
                Text,
            }

            // Generated from `System.Net.WebSockets.WebSocketReceiveResult` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class WebSocketReceiveResult
            {
                public System.Net.WebSockets.WebSocketCloseStatus? CloseStatus { get => throw null; }
                public string CloseStatusDescription { get => throw null; }
                public int Count { get => throw null; }
                public bool EndOfMessage { get => throw null; }
                public System.Net.WebSockets.WebSocketMessageType MessageType { get => throw null; }
                public WebSocketReceiveResult(int count, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage) => throw null;
                public WebSocketReceiveResult(int count, System.Net.WebSockets.WebSocketMessageType messageType, bool endOfMessage, System.Net.WebSockets.WebSocketCloseStatus? closeStatus, string closeStatusDescription) => throw null;
            }

            // Generated from `System.Net.WebSockets.WebSocketState` in `System.Net.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WebSocketState
            {
                Aborted,
                CloseReceived,
                CloseSent,
                Closed,
                Connecting,
                None,
                Open,
            }

        }
    }
}
