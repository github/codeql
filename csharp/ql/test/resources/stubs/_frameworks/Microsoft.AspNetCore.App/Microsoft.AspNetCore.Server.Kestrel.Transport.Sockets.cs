// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            // Generated from `Microsoft.AspNetCore.Hosting.WebHostBuilderSocketExtensions` in `Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WebHostBuilderSocketExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSockets(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketTransportOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSockets(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
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
                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketTransportFactory` in `Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public class SocketTransportFactory : Microsoft.AspNetCore.Connections.IConnectionListenerFactory
                        {
                            public System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Connections.IConnectionListener> BindAsync(System.Net.EndPoint endpoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                            public SocketTransportFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketTransportOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        }

                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.SocketTransportOptions` in `Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public class SocketTransportOptions
                        {
                            public int Backlog { get => throw null; set => throw null; }
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
