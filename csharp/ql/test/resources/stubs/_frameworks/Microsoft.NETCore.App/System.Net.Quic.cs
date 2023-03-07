// This file contains auto-generated code.
// Generated from `System.Net.Quic, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Net
    {
        namespace Quic
        {
            [System.Flags]
            public enum QuicAbortDirection : int
            {
                Both = 3,
                Read = 1,
                Write = 2,
            }

            public class QuicClientConnectionOptions : System.Net.Quic.QuicConnectionOptions
            {
                public System.Net.Security.SslClientAuthenticationOptions ClientAuthenticationOptions { get => throw null; set => throw null; }
                public System.Net.IPEndPoint LocalEndPoint { get => throw null; set => throw null; }
                public QuicClientConnectionOptions() => throw null;
                public System.Net.EndPoint RemoteEndPoint { get => throw null; set => throw null; }
            }

            public class QuicConnection : System.IAsyncDisposable
            {
                public System.Threading.Tasks.ValueTask<System.Net.Quic.QuicStream> AcceptInboundStreamAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask CloseAsync(System.Int64 errorCode, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Net.Quic.QuicConnection> ConnectAsync(System.Net.Quic.QuicClientConnectionOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public static bool IsSupported { get => throw null; }
                public System.Net.IPEndPoint LocalEndPoint { get => throw null; }
                public System.Net.Security.SslApplicationProtocol NegotiatedApplicationProtocol { get => throw null; }
                public System.Threading.Tasks.ValueTask<System.Net.Quic.QuicStream> OpenOutboundStreamAsync(System.Net.Quic.QuicStreamType type, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Security.Cryptography.X509Certificates.X509Certificate RemoteCertificate { get => throw null; }
                public System.Net.IPEndPoint RemoteEndPoint { get => throw null; }
                public override string ToString() => throw null;
            }

            public abstract class QuicConnectionOptions
            {
                public System.Int64 DefaultCloseErrorCode { get => throw null; set => throw null; }
                public System.Int64 DefaultStreamErrorCode { get => throw null; set => throw null; }
                public System.TimeSpan IdleTimeout { get => throw null; set => throw null; }
                public int MaxInboundBidirectionalStreams { get => throw null; set => throw null; }
                public int MaxInboundUnidirectionalStreams { get => throw null; set => throw null; }
                internal QuicConnectionOptions() => throw null;
            }

            public enum QuicError : int
            {
                AddressInUse = 4,
                ConnectionAborted = 2,
                ConnectionIdle = 10,
                ConnectionRefused = 8,
                ConnectionTimeout = 6,
                HostUnreachable = 7,
                InternalError = 1,
                InvalidAddress = 5,
                OperationAborted = 12,
                ProtocolError = 11,
                StreamAborted = 3,
                Success = 0,
                VersionNegotiationError = 9,
            }

            public class QuicException : System.IO.IOException
            {
                public System.Int64? ApplicationErrorCode { get => throw null; }
                public System.Net.Quic.QuicError QuicError { get => throw null; }
                public QuicException(System.Net.Quic.QuicError error, System.Int64? applicationErrorCode, string message) => throw null;
            }

            public class QuicListener : System.IAsyncDisposable
            {
                public System.Threading.Tasks.ValueTask<System.Net.Quic.QuicConnection> AcceptConnectionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public static bool IsSupported { get => throw null; }
                public static System.Threading.Tasks.ValueTask<System.Net.Quic.QuicListener> ListenAsync(System.Net.Quic.QuicListenerOptions options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Net.IPEndPoint LocalEndPoint { get => throw null; }
                public override string ToString() => throw null;
            }

            public class QuicListenerOptions
            {
                public System.Collections.Generic.List<System.Net.Security.SslApplicationProtocol> ApplicationProtocols { get => throw null; set => throw null; }
                public System.Func<System.Net.Quic.QuicConnection, System.Net.Security.SslClientHelloInfo, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Net.Quic.QuicServerConnectionOptions>> ConnectionOptionsCallback { get => throw null; set => throw null; }
                public int ListenBacklog { get => throw null; set => throw null; }
                public System.Net.IPEndPoint ListenEndPoint { get => throw null; set => throw null; }
                public QuicListenerOptions() => throw null;
            }

            public class QuicServerConnectionOptions : System.Net.Quic.QuicConnectionOptions
            {
                public QuicServerConnectionOptions() => throw null;
                public System.Net.Security.SslServerAuthenticationOptions ServerAuthenticationOptions { get => throw null; set => throw null; }
            }

            public class QuicStream : System.IO.Stream
            {
                public void Abort(System.Net.Quic.QuicAbortDirection abortDirection, System.Int64 errorCode) => throw null;
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public void CompleteWrites() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Int64 Id { get => throw null; }
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override int ReadTimeout { get => throw null; set => throw null; }
                public System.Threading.Tasks.Task ReadsClosed { get => throw null; }
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public System.Net.Quic.QuicStreamType Type { get => throw null; }
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, bool completeWrites, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(System.Byte value) => throw null;
                public override int WriteTimeout { get => throw null; set => throw null; }
                public System.Threading.Tasks.Task WritesClosed { get => throw null; }
            }

            public enum QuicStreamType : int
            {
                Bidirectional = 1,
                Unidirectional = 0,
            }

        }
    }
}
