// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Connections.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Connections
        {
            namespace Abstractions
            {
                public interface IStatefulReconnectFeature
                {
                    void DisableReconnect();
                    void OnReconnected(System.Func<System.IO.Pipelines.PipeWriter, System.Threading.Tasks.Task> notifyOnReconnect);
                }
            }
            public class AddressInUseException : System.InvalidOperationException
            {
                public AddressInUseException(string message) => throw null;
                public AddressInUseException(string message, System.Exception inner) => throw null;
            }
            public abstract class BaseConnectionContext : System.IAsyncDisposable
            {
                public abstract void Abort();
                public abstract void Abort(Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason);
                public virtual System.Threading.CancellationToken ConnectionClosed { get => throw null; set { } }
                public abstract string ConnectionId { get; set; }
                protected BaseConnectionContext() => throw null;
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public abstract Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                public abstract System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                public virtual System.Net.EndPoint LocalEndPoint { get => throw null; set { } }
                public virtual System.Net.EndPoint RemoteEndPoint { get => throw null; set { } }
            }
            public class ConnectionAbortedException : System.OperationCanceledException
            {
                public ConnectionAbortedException() => throw null;
                public ConnectionAbortedException(string message) => throw null;
                public ConnectionAbortedException(string message, System.Exception inner) => throw null;
            }
            public class ConnectionBuilder : Microsoft.AspNetCore.Connections.IConnectionBuilder
            {
                public System.IServiceProvider ApplicationServices { get => throw null; }
                public Microsoft.AspNetCore.Connections.ConnectionDelegate Build() => throw null;
                public ConnectionBuilder(System.IServiceProvider applicationServices) => throw null;
                public Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware) => throw null;
            }
            public static partial class ConnectionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder Run(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder, System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, System.Threading.Tasks.Task> middleware) => throw null;
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder Use(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder, System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, System.Func<System.Threading.Tasks.Task>, System.Threading.Tasks.Task> middleware) => throw null;
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder Use(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder, System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, Microsoft.AspNetCore.Connections.ConnectionDelegate, System.Threading.Tasks.Task> middleware) => throw null;
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder UseConnectionHandler<TConnectionHandler>(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder) where TConnectionHandler : Microsoft.AspNetCore.Connections.ConnectionHandler => throw null;
            }
            public abstract class ConnectionContext : Microsoft.AspNetCore.Connections.BaseConnectionContext, System.IAsyncDisposable
            {
                public override void Abort(Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason) => throw null;
                public override void Abort() => throw null;
                protected ConnectionContext() => throw null;
                public abstract System.IO.Pipelines.IDuplexPipe Transport { get; set; }
            }
            public delegate System.Threading.Tasks.Task ConnectionDelegate(Microsoft.AspNetCore.Connections.ConnectionContext connection);
            public abstract class ConnectionHandler
            {
                protected ConnectionHandler() => throw null;
                public abstract System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.Connections.ConnectionContext connection);
            }
            public class ConnectionItems : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>, System.Collections.Generic.IDictionary<object, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, object>>, System.Collections.IEnumerable
            {
                void System.Collections.Generic.IDictionary<object, object>.Add(object key, object value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Add(System.Collections.Generic.KeyValuePair<object, object> item) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Contains(System.Collections.Generic.KeyValuePair<object, object> item) => throw null;
                bool System.Collections.Generic.IDictionary<object, object>.ContainsKey(object key) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.CopyTo(System.Collections.Generic.KeyValuePair<object, object>[] array, int arrayIndex) => throw null;
                int System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Count { get => throw null; }
                public ConnectionItems() => throw null;
                public ConnectionItems(System.Collections.Generic.IDictionary<object, object> items) => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<object, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, object>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.IsReadOnly { get => throw null; }
                object System.Collections.Generic.IDictionary<object, object>.this[object key] { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                System.Collections.Generic.ICollection<object> System.Collections.Generic.IDictionary<object, object>.Keys { get => throw null; }
                bool System.Collections.Generic.IDictionary<object, object>.Remove(object key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Remove(System.Collections.Generic.KeyValuePair<object, object> item) => throw null;
                bool System.Collections.Generic.IDictionary<object, object>.TryGetValue(object key, out object value) => throw null;
                System.Collections.Generic.ICollection<object> System.Collections.Generic.IDictionary<object, object>.Values { get => throw null; }
            }
            public class ConnectionResetException : System.IO.IOException
            {
                public ConnectionResetException(string message) => throw null;
                public ConnectionResetException(string message, System.Exception inner) => throw null;
            }
            public class DefaultConnectionContext : Microsoft.AspNetCore.Connections.ConnectionContext, Microsoft.AspNetCore.Connections.Features.IConnectionEndPointFeature, Microsoft.AspNetCore.Connections.Features.IConnectionIdFeature, Microsoft.AspNetCore.Connections.Features.IConnectionItemsFeature, Microsoft.AspNetCore.Connections.Features.IConnectionLifetimeFeature, Microsoft.AspNetCore.Connections.Features.IConnectionTransportFeature, Microsoft.AspNetCore.Connections.Features.IConnectionUserFeature
            {
                public override void Abort(Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason) => throw null;
                public System.IO.Pipelines.IDuplexPipe Application { get => throw null; set { } }
                public override System.Threading.CancellationToken ConnectionClosed { get => throw null; set { } }
                public override string ConnectionId { get => throw null; set { } }
                public DefaultConnectionContext() => throw null;
                public DefaultConnectionContext(string id) => throw null;
                public DefaultConnectionContext(string id, System.IO.Pipelines.IDuplexPipe transport, System.IO.Pipelines.IDuplexPipe application) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                public override System.Collections.Generic.IDictionary<object, object> Items { get => throw null; set { } }
                public override System.Net.EndPoint LocalEndPoint { get => throw null; set { } }
                public override System.Net.EndPoint RemoteEndPoint { get => throw null; set { } }
                public override System.IO.Pipelines.IDuplexPipe Transport { get => throw null; set { } }
                public System.Security.Claims.ClaimsPrincipal User { get => throw null; set { } }
            }
            namespace Features
            {
                public interface IConnectionCompleteFeature
                {
                    void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                }
                public interface IConnectionEndPointFeature
                {
                    System.Net.EndPoint LocalEndPoint { get; set; }
                    System.Net.EndPoint RemoteEndPoint { get; set; }
                }
                public interface IConnectionHeartbeatFeature
                {
                    void OnHeartbeat(System.Action<object> action, object state);
                }
                public interface IConnectionIdFeature
                {
                    string ConnectionId { get; set; }
                }
                public interface IConnectionInherentKeepAliveFeature
                {
                    bool HasInherentKeepAlive { get; }
                }
                public interface IConnectionItemsFeature
                {
                    System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                }
                public interface IConnectionLifetimeFeature
                {
                    void Abort();
                    System.Threading.CancellationToken ConnectionClosed { get; set; }
                }
                public interface IConnectionLifetimeNotificationFeature
                {
                    System.Threading.CancellationToken ConnectionClosedRequested { get; set; }
                    void RequestClose();
                }
                public interface IConnectionMetricsTagsFeature
                {
                    System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>> Tags { get; }
                }
                public interface IConnectionNamedPipeFeature
                {
                    System.IO.Pipes.NamedPipeServerStream NamedPipe { get; }
                }
                public interface IConnectionSocketFeature
                {
                    System.Net.Sockets.Socket Socket { get; }
                }
                public interface IConnectionTransportFeature
                {
                    System.IO.Pipelines.IDuplexPipe Transport { get; set; }
                }
                public interface IConnectionUserFeature
                {
                    System.Security.Claims.ClaimsPrincipal User { get; set; }
                }
                public interface IMemoryPoolFeature
                {
                    System.Buffers.MemoryPool<byte> MemoryPool { get; }
                }
                public interface IPersistentStateFeature
                {
                    System.Collections.Generic.IDictionary<object, object> State { get; }
                }
                public interface IProtocolErrorCodeFeature
                {
                    long Error { get; set; }
                }
                public interface IStreamAbortFeature
                {
                    void AbortRead(long errorCode, Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason);
                    void AbortWrite(long errorCode, Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason);
                }
                public interface IStreamClosedFeature
                {
                    void OnClosed(System.Action<object> callback, object state);
                }
                public interface IStreamDirectionFeature
                {
                    bool CanRead { get; }
                    bool CanWrite { get; }
                }
                public interface IStreamIdFeature
                {
                    long StreamId { get; }
                }
                public interface ITlsHandshakeFeature
                {
                    System.Security.Authentication.CipherAlgorithmType CipherAlgorithm { get; }
                    int CipherStrength { get; }
                    System.Security.Authentication.HashAlgorithmType HashAlgorithm { get; }
                    int HashStrength { get; }
                    virtual string HostName { get => throw null; }
                    System.Security.Authentication.ExchangeAlgorithmType KeyExchangeAlgorithm { get; }
                    int KeyExchangeStrength { get; }
                    virtual System.Net.Security.TlsCipherSuite? NegotiatedCipherSuite { get => throw null; }
                    System.Security.Authentication.SslProtocols Protocol { get; }
                }
                public interface ITransferFormatFeature
                {
                    Microsoft.AspNetCore.Connections.TransferFormat ActiveFormat { get; set; }
                    Microsoft.AspNetCore.Connections.TransferFormat SupportedFormats { get; }
                }
            }
            public class FileHandleEndPoint : System.Net.EndPoint
            {
                public FileHandleEndPoint(ulong fileHandle, Microsoft.AspNetCore.Connections.FileHandleType fileHandleType) => throw null;
                public ulong FileHandle { get => throw null; }
                public Microsoft.AspNetCore.Connections.FileHandleType FileHandleType { get => throw null; }
            }
            public enum FileHandleType
            {
                Auto = 0,
                Tcp = 1,
                Pipe = 2,
            }
            public interface IConnectionBuilder
            {
                System.IServiceProvider ApplicationServices { get; }
                Microsoft.AspNetCore.Connections.ConnectionDelegate Build();
                Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware);
            }
            public interface IConnectionFactory
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> ConnectAsync(System.Net.EndPoint endpoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IConnectionListener : System.IAsyncDisposable
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> AcceptAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Net.EndPoint EndPoint { get; }
                System.Threading.Tasks.ValueTask UnbindAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IConnectionListenerFactory
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.IConnectionListener> BindAsync(System.Net.EndPoint endpoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IConnectionListenerFactorySelector
            {
                bool CanBind(System.Net.EndPoint endpoint);
            }
            public interface IMultiplexedConnectionBuilder
            {
                System.IServiceProvider ApplicationServices { get; }
                Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate Build();
                Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate, Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate> middleware);
            }
            public interface IMultiplexedConnectionFactory
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.MultiplexedConnectionContext> ConnectAsync(System.Net.EndPoint endpoint, Microsoft.AspNetCore.Http.Features.IFeatureCollection features = default(Microsoft.AspNetCore.Http.Features.IFeatureCollection), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IMultiplexedConnectionListener : System.IAsyncDisposable
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.MultiplexedConnectionContext> AcceptAsync(Microsoft.AspNetCore.Http.Features.IFeatureCollection features = default(Microsoft.AspNetCore.Http.Features.IFeatureCollection), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Net.EndPoint EndPoint { get; }
                System.Threading.Tasks.ValueTask UnbindAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IMultiplexedConnectionListenerFactory
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.IMultiplexedConnectionListener> BindAsync(System.Net.EndPoint endpoint, Microsoft.AspNetCore.Http.Features.IFeatureCollection features = default(Microsoft.AspNetCore.Http.Features.IFeatureCollection), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public class MultiplexedConnectionBuilder : Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder
            {
                public System.IServiceProvider ApplicationServices { get => throw null; }
                public Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate Build() => throw null;
                public MultiplexedConnectionBuilder(System.IServiceProvider applicationServices) => throw null;
                public Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate, Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate> middleware) => throw null;
            }
            public abstract class MultiplexedConnectionContext : Microsoft.AspNetCore.Connections.BaseConnectionContext, System.IAsyncDisposable
            {
                public abstract System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> AcceptAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> ConnectAsync(Microsoft.AspNetCore.Http.Features.IFeatureCollection features = default(Microsoft.AspNetCore.Http.Features.IFeatureCollection), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected MultiplexedConnectionContext() => throw null;
            }
            public delegate System.Threading.Tasks.Task MultiplexedConnectionDelegate(Microsoft.AspNetCore.Connections.MultiplexedConnectionContext connection);
            public sealed class NamedPipeEndPoint : System.Net.EndPoint
            {
                public NamedPipeEndPoint(string pipeName) => throw null;
                public NamedPipeEndPoint(string pipeName, string serverName) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string PipeName { get => throw null; }
                public string ServerName { get => throw null; }
                public override string ToString() => throw null;
            }
            public class TlsConnectionCallbackContext
            {
                public System.Net.Security.SslClientHelloInfo ClientHelloInfo { get => throw null; set { } }
                public Microsoft.AspNetCore.Connections.BaseConnectionContext Connection { get => throw null; set { } }
                public TlsConnectionCallbackContext() => throw null;
                public object State { get => throw null; set { } }
            }
            public class TlsConnectionCallbackOptions
            {
                public System.Collections.Generic.List<System.Net.Security.SslApplicationProtocol> ApplicationProtocols { get => throw null; set { } }
                public TlsConnectionCallbackOptions() => throw null;
                public System.Func<Microsoft.AspNetCore.Connections.TlsConnectionCallbackContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Net.Security.SslServerAuthenticationOptions>> OnConnection { get => throw null; set { } }
                public object OnConnectionState { get => throw null; set { } }
            }
            [System.Flags]
            public enum TransferFormat
            {
                Binary = 1,
                Text = 2,
            }
            public class UriEndPoint : System.Net.EndPoint
            {
                public UriEndPoint(System.Uri uri) => throw null;
                public override string ToString() => throw null;
                public System.Uri Uri { get => throw null; }
            }
        }
    }
}
