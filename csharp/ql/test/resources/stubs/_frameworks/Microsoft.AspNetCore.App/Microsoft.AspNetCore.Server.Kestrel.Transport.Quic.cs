// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.Kestrel.Transport.Quic, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static partial class WebHostBuilderQuicExtensions
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
                        public sealed class QuicTransportOptions
                        {
                            public int Backlog { get => throw null; set { } }
                            public QuicTransportOptions() => throw null;
                            public long DefaultCloseErrorCode { get => throw null; set { } }
                            public long DefaultStreamErrorCode { get => throw null; set { } }
                            public int MaxBidirectionalStreamCount { get => throw null; set { } }
                            public long? MaxReadBufferSize { get => throw null; set { } }
                            public int MaxUnidirectionalStreamCount { get => throw null; set { } }
                            public long? MaxWriteBufferSize { get => throw null; set { } }
                        }
                    }
                }
            }
        }
    }
}
