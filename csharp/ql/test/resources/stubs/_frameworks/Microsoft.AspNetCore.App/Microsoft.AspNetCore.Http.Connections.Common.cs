// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            namespace Connections
            {
                // Generated from `Microsoft.AspNetCore.Http.Connections.AvailableTransport` in `Microsoft.AspNetCore.Http.Connections.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AvailableTransport
                {
                    public AvailableTransport() => throw null;
                    public System.Collections.Generic.IList<string> TransferFormats { get => throw null; set => throw null; }
                    public string Transport { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.HttpTransportType` in `Microsoft.AspNetCore.Http.Connections.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                [System.Flags]
                public enum HttpTransportType
                {
                    LongPolling,
                    None,
                    ServerSentEvents,
                    WebSockets,
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.HttpTransports` in `Microsoft.AspNetCore.Http.Connections.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HttpTransports
                {
                    public static Microsoft.AspNetCore.Http.Connections.HttpTransportType All;
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.NegotiateProtocol` in `Microsoft.AspNetCore.Http.Connections.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class NegotiateProtocol
                {
                    public static Microsoft.AspNetCore.Http.Connections.NegotiationResponse ParseResponse(System.ReadOnlySpan<System.Byte> content) => throw null;
                    public static Microsoft.AspNetCore.Http.Connections.NegotiationResponse ParseResponse(System.IO.Stream content) => throw null;
                    public static void WriteResponse(Microsoft.AspNetCore.Http.Connections.NegotiationResponse response, System.Buffers.IBufferWriter<System.Byte> output) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.NegotiationResponse` in `Microsoft.AspNetCore.Http.Connections.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NegotiationResponse
                {
                    public string AccessToken { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Http.Connections.AvailableTransport> AvailableTransports { get => throw null; set => throw null; }
                    public string ConnectionId { get => throw null; set => throw null; }
                    public string ConnectionToken { get => throw null; set => throw null; }
                    public string Error { get => throw null; set => throw null; }
                    public NegotiationResponse() => throw null;
                    public string Url { get => throw null; set => throw null; }
                    public int Version { get => throw null; set => throw null; }
                }

            }
        }
    }
}
