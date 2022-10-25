// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            // Generated from `Microsoft.AspNetCore.Hosting.WebHostBuilderQuicExtensions` in `Microsoft.AspNetCore.Server.Kestrel.Transport.Quic, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WebHostBuilderQuicExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseQuic(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseQuic(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Server.Kestrel.Transport.Quic.QuicTransportOptions> configureOptions) => throw null;
            }

        }
        namespace Server
        {
            namespace Kestrel
            {
                namespace Transport
                {
                    namespace Quic
                    {
                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Transport.Quic.QuicTransportOptions` in `Microsoft.AspNetCore.Server.Kestrel.Transport.Quic, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public class QuicTransportOptions
                        {
                            public int Backlog { get => throw null; set => throw null; }
                            public System.TimeSpan IdleTimeout { get => throw null; set => throw null; }
                            public System.UInt16 MaxBidirectionalStreamCount { get => throw null; set => throw null; }
                            public System.Int64? MaxReadBufferSize { get => throw null; set => throw null; }
                            public System.UInt16 MaxUnidirectionalStreamCount { get => throw null; set => throw null; }
                            public System.Int64? MaxWriteBufferSize { get => throw null; set => throw null; }
                            public QuicTransportOptions() => throw null;
                        }

                    }
                }
            }
        }
    }
}
