// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Connections
        {
            // Generated from `Microsoft.AspNetCore.Connections.AddressInUseException` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AddressInUseException : System.InvalidOperationException
            {
                public AddressInUseException(string message, System.Exception inner) => throw null;
                public AddressInUseException(string message) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Connections.BaseConnectionContext` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class BaseConnectionContext : System.IAsyncDisposable
            {
                public abstract void Abort(Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason);
                public abstract void Abort();
                protected BaseConnectionContext() => throw null;
                public virtual System.Threading.CancellationToken ConnectionClosed { get => throw null; set => throw null; }
                public abstract string ConnectionId { get; set; }
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public abstract Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                public abstract System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                public virtual System.Net.EndPoint LocalEndPoint { get => throw null; set => throw null; }
                public virtual System.Net.EndPoint RemoteEndPoint { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionAbortedException` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConnectionAbortedException : System.OperationCanceledException
            {
                public ConnectionAbortedException(string message, System.Exception inner) => throw null;
                public ConnectionAbortedException(string message) => throw null;
                public ConnectionAbortedException() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionBuilder` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConnectionBuilder : Microsoft.AspNetCore.Connections.IConnectionBuilder
            {
                public System.IServiceProvider ApplicationServices { get => throw null; }
                public Microsoft.AspNetCore.Connections.ConnectionDelegate Build() => throw null;
                public ConnectionBuilder(System.IServiceProvider applicationServices) => throw null;
                public Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionBuilderExtensions` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConnectionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder Run(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder, System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, System.Threading.Tasks.Task> middleware) => throw null;
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder Use(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder, System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, System.Func<System.Threading.Tasks.Task>, System.Threading.Tasks.Task> middleware) => throw null;
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder UseConnectionHandler<TConnectionHandler>(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder) where TConnectionHandler : Microsoft.AspNetCore.Connections.ConnectionHandler => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionContext` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ConnectionContext : Microsoft.AspNetCore.Connections.BaseConnectionContext, System.IAsyncDisposable
            {
                public override void Abort(Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason) => throw null;
                public override void Abort() => throw null;
                protected ConnectionContext() => throw null;
                public abstract System.IO.Pipelines.IDuplexPipe Transport { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionDelegate` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public delegate System.Threading.Tasks.Task ConnectionDelegate(Microsoft.AspNetCore.Connections.ConnectionContext connection);

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionHandler` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ConnectionHandler
            {
                protected ConnectionHandler() => throw null;
                public abstract System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.Connections.ConnectionContext connection);
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionItems` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConnectionItems : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, object>>, System.Collections.Generic.IDictionary<object, object>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>
            {
                void System.Collections.Generic.IDictionary<object, object>.Add(object key, object value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Add(System.Collections.Generic.KeyValuePair<object, object> item) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Clear() => throw null;
                public ConnectionItems(System.Collections.Generic.IDictionary<object, object> items) => throw null;
                public ConnectionItems() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Contains(System.Collections.Generic.KeyValuePair<object, object> item) => throw null;
                bool System.Collections.Generic.IDictionary<object, object>.ContainsKey(object key) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.CopyTo(System.Collections.Generic.KeyValuePair<object, object>[] array, int arrayIndex) => throw null;
                int System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Count { get => throw null; }
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<object, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, object>>.GetEnumerator() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.IsReadOnly { get => throw null; }
                object System.Collections.Generic.IDictionary<object, object>.this[object key] { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                System.Collections.Generic.ICollection<object> System.Collections.Generic.IDictionary<object, object>.Keys { get => throw null; }
                bool System.Collections.Generic.IDictionary<object, object>.Remove(object key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, object>>.Remove(System.Collections.Generic.KeyValuePair<object, object> item) => throw null;
                bool System.Collections.Generic.IDictionary<object, object>.TryGetValue(object key, out object value) => throw null;
                System.Collections.Generic.ICollection<object> System.Collections.Generic.IDictionary<object, object>.Values { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Connections.ConnectionResetException` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConnectionResetException : System.IO.IOException
            {
                public ConnectionResetException(string message, System.Exception inner) => throw null;
                public ConnectionResetException(string message) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Connections.DefaultConnectionContext` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultConnectionContext : Microsoft.AspNetCore.Connections.ConnectionContext, Microsoft.AspNetCore.Connections.Features.IConnectionUserFeature, Microsoft.AspNetCore.Connections.Features.IConnectionTransportFeature, Microsoft.AspNetCore.Connections.Features.IConnectionLifetimeFeature, Microsoft.AspNetCore.Connections.Features.IConnectionItemsFeature, Microsoft.AspNetCore.Connections.Features.IConnectionIdFeature, Microsoft.AspNetCore.Connections.Features.IConnectionEndPointFeature
            {
                public override void Abort(Microsoft.AspNetCore.Connections.ConnectionAbortedException abortReason) => throw null;
                public System.IO.Pipelines.IDuplexPipe Application { get => throw null; set => throw null; }
                public override System.Threading.CancellationToken ConnectionClosed { get => throw null; set => throw null; }
                public override string ConnectionId { get => throw null; set => throw null; }
                public DefaultConnectionContext(string id, System.IO.Pipelines.IDuplexPipe transport, System.IO.Pipelines.IDuplexPipe application) => throw null;
                public DefaultConnectionContext(string id) => throw null;
                public DefaultConnectionContext() => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                public override System.Collections.Generic.IDictionary<object, object> Items { get => throw null; set => throw null; }
                public override System.Net.EndPoint LocalEndPoint { get => throw null; set => throw null; }
                public override System.Net.EndPoint RemoteEndPoint { get => throw null; set => throw null; }
                public override System.IO.Pipelines.IDuplexPipe Transport { get => throw null; set => throw null; }
                public System.Security.Claims.ClaimsPrincipal User { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Connections.FileHandleEndPoint` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileHandleEndPoint : System.Net.EndPoint
            {
                public System.UInt64 FileHandle { get => throw null; }
                public FileHandleEndPoint(System.UInt64 fileHandle, Microsoft.AspNetCore.Connections.FileHandleType fileHandleType) => throw null;
                public Microsoft.AspNetCore.Connections.FileHandleType FileHandleType { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Connections.FileHandleType` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum FileHandleType
            {
                Auto,
                Pipe,
                Tcp,
            }

            // Generated from `Microsoft.AspNetCore.Connections.IConnectionBuilder` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConnectionBuilder
            {
                System.IServiceProvider ApplicationServices { get; }
                Microsoft.AspNetCore.Connections.ConnectionDelegate Build();
                Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware);
            }

            // Generated from `Microsoft.AspNetCore.Connections.IConnectionFactory` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConnectionFactory
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> ConnectAsync(System.Net.EndPoint endpoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.AspNetCore.Connections.IConnectionListener` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConnectionListener : System.IAsyncDisposable
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.ConnectionContext> AcceptAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Net.EndPoint EndPoint { get; }
                System.Threading.Tasks.ValueTask UnbindAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.AspNetCore.Connections.IConnectionListenerFactory` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConnectionListenerFactory
            {
                System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.IConnectionListener> BindAsync(System.Net.EndPoint endpoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.AspNetCore.Connections.TransferFormat` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            [System.Flags]
            public enum TransferFormat
            {
                Binary,
                Text,
            }

            // Generated from `Microsoft.AspNetCore.Connections.UriEndPoint` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class UriEndPoint : System.Net.EndPoint
            {
                public override string ToString() => throw null;
                public System.Uri Uri { get => throw null; }
                public UriEndPoint(System.Uri uri) => throw null;
            }

            namespace Experimental
            {
                // Generated from `Microsoft.AspNetCore.Connections.Experimental.IMultiplexedConnectionBuilder` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IMultiplexedConnectionBuilder
                {
                    System.IServiceProvider ApplicationServices { get; }
                }

            }
            namespace Features
            {
                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionCompleteFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionCompleteFeature
                {
                    void OnCompleted(System.Func<object, System.Threading.Tasks.Task> callback, object state);
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionEndPointFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionEndPointFeature
                {
                    System.Net.EndPoint LocalEndPoint { get; set; }
                    System.Net.EndPoint RemoteEndPoint { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionHeartbeatFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionHeartbeatFeature
                {
                    void OnHeartbeat(System.Action<object> action, object state);
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionIdFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionIdFeature
                {
                    string ConnectionId { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionInherentKeepAliveFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionInherentKeepAliveFeature
                {
                    bool HasInherentKeepAlive { get; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionItemsFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionItemsFeature
                {
                    System.Collections.Generic.IDictionary<object, object> Items { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionLifetimeFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionLifetimeFeature
                {
                    void Abort();
                    System.Threading.CancellationToken ConnectionClosed { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionLifetimeNotificationFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionLifetimeNotificationFeature
                {
                    System.Threading.CancellationToken ConnectionClosedRequested { get; set; }
                    void RequestClose();
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionTransportFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionTransportFeature
                {
                    System.IO.Pipelines.IDuplexPipe Transport { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IConnectionUserFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConnectionUserFeature
                {
                    System.Security.Claims.ClaimsPrincipal User { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IMemoryPoolFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IMemoryPoolFeature
                {
                    System.Buffers.MemoryPool<System.Byte> MemoryPool { get; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IProtocolErrorCodeFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IProtocolErrorCodeFeature
                {
                    System.Int64 Error { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IStreamDirectionFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IStreamDirectionFeature
                {
                    bool CanRead { get; }
                    bool CanWrite { get; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.IStreamIdFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IStreamIdFeature
                {
                    System.Int64 StreamId { get; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.ITlsHandshakeFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITlsHandshakeFeature
                {
                    System.Security.Authentication.CipherAlgorithmType CipherAlgorithm { get; }
                    int CipherStrength { get; }
                    System.Security.Authentication.HashAlgorithmType HashAlgorithm { get; }
                    int HashStrength { get; }
                    System.Security.Authentication.ExchangeAlgorithmType KeyExchangeAlgorithm { get; }
                    int KeyExchangeStrength { get; }
                    System.Security.Authentication.SslProtocols Protocol { get; }
                }

                // Generated from `Microsoft.AspNetCore.Connections.Features.ITransferFormatFeature` in `Microsoft.AspNetCore.Connections.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITransferFormatFeature
                {
                    Microsoft.AspNetCore.Connections.TransferFormat ActiveFormat { get; set; }
                    Microsoft.AspNetCore.Connections.TransferFormat SupportedFormats { get; }
                }

            }
        }
    }
}
