// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static class WebHostBuilderSocketExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSockets(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSockets(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketTransportOptions> configureOptions) => throw null;
            }

        }
        namespace Server
        {
            namespace Kestrel
            {
                namespace Transport
                {
                    namespace Sockets
                    {
                        public class SocketConnectionContextFactory : System.IDisposable
                        {
                            public Microsoft.AspNetCore.Connections.ConnectionContext Create(System.Net.Sockets.Socket socket) => throw null;
                            public void Dispose() => throw null;
                            public SocketConnectionContextFactory(Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketConnectionFactoryOptions options, Microsoft.Extensions.Logging.ILogger logger) => throw null;
                        }

                        public class SocketConnectionFactoryOptions
                        {
                            public int IOQueueCount { get => throw null; set => throw null; }
                            public System.Int64? MaxReadBufferSize { get => throw null; set => throw null; }
                            public System.Int64? MaxWriteBufferSize { get => throw null; set => throw null; }
                            public SocketConnectionFactoryOptions() => throw null;
                            public bool UnsafePreferInlineScheduling { get => throw null; set => throw null; }
                            public bool WaitForDataBeforeAllocatingBuffer { get => throw null; set => throw null; }
                        }

                        public class SocketTransportFactory : Microsoft.AspNetCore.Connections.IConnectionListenerFactory
                        {
                            public System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.IConnectionListener> BindAsync(System.Net.EndPoint endpoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                            public SocketTransportFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketTransportOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        }

                        public class SocketTransportOptions
                        {
                            public int Backlog { get => throw null; set => throw null; }
                            public System.Func<System.Net.EndPoint, System.Net.Sockets.Socket> CreateBoundListenSocket { get => throw null; set => throw null; }
                            public static System.Net.Sockets.Socket CreateDefaultBoundListenSocket(System.Net.EndPoint endpoint) => throw null;
                            public int IOQueueCount { get => throw null; set => throw null; }
                            public System.Int64? MaxReadBufferSize { get => throw null; set => throw null; }
                            public System.Int64? MaxWriteBufferSize { get => throw null; set => throw null; }
                            public bool NoDelay { get => throw null; set => throw null; }
                            public SocketTransportOptions() => throw null;
                            public bool UnsafePreferInlineScheduling { get => throw null; set => throw null; }
                            public bool WaitForDataBeforeAllocatingBuffer { get => throw null; set => throw null; }
                        }

                    }
                }
            }
        }
    }
}
