// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Connections.Common, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            namespace Connections
            {
                public class AvailableTransport
                {
                    public AvailableTransport() => throw null;
                    public System.Collections.Generic.IList<string> TransferFormats { get => throw null; set => throw null; }
                    public string Transport { get => throw null; set => throw null; }
                }

                [System.Flags]
                public enum HttpTransportType : int
                {
                    LongPolling = 4,
                    None = 0,
                    ServerSentEvents = 2,
                    WebSockets = 1,
                }

                public static class HttpTransports
                {
                    public static Microsoft.AspNetCore.Http.Connections.HttpTransportType All;
                }

                public static class NegotiateProtocol
                {
                    public static Microsoft.AspNetCore.Http.Connections.NegotiationResponse ParseResponse(System.ReadOnlySpan<System.Byte> content) => throw null;
                    public static void WriteResponse(Microsoft.AspNetCore.Http.Connections.NegotiationResponse response, System.Buffers.IBufferWriter<System.Byte> output) => throw null;
                }

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
