// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.Kestrel.Transport.Quic, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
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
                        public class QuicTransportOptions
                        {
                            public int Backlog { get => throw null; set => throw null; }
                            public System.Int64 DefaultCloseErrorCode { get => throw null; set => throw null; }
                            public System.Int64 DefaultStreamErrorCode { get => throw null; set => throw null; }
                            public int MaxBidirectionalStreamCount { get => throw null; set => throw null; }
                            public System.Int64? MaxReadBufferSize { get => throw null; set => throw null; }
                            public int MaxUnidirectionalStreamCount { get => throw null; set => throw null; }
                            public System.Int64? MaxWriteBufferSize { get => throw null; set => throw null; }
                            public QuicTransportOptions() => throw null;
                        }

                    }
                }
            }
        }
    }
}
