// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Connections.Common, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
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
                    public System.Collections.Generic.IList<string> TransferFormats { get => throw null; set { } }
                    public string Transport { get => throw null; set { } }
                }
                public static class HttpTransports
                {
                    public static readonly Microsoft.AspNetCore.Http.Connections.HttpTransportType All;
                }
                [System.Flags]
                public enum HttpTransportType
                {
                    None = 0,
                    WebSockets = 1,
                    ServerSentEvents = 2,
                    LongPolling = 4,
                }
                public static class NegotiateProtocol
                {
                    public static Microsoft.AspNetCore.Http.Connections.NegotiationResponse ParseResponse(System.ReadOnlySpan<byte> content) => throw null;
                    public static void WriteResponse(Microsoft.AspNetCore.Http.Connections.NegotiationResponse response, System.Buffers.IBufferWriter<byte> output) => throw null;
                }
                public class NegotiationResponse
                {
                    public string AccessToken { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Http.Connections.AvailableTransport> AvailableTransports { get => throw null; set { } }
                    public string ConnectionId { get => throw null; set { } }
                    public string ConnectionToken { get => throw null; set { } }
                    public NegotiationResponse() => throw null;
                    public string Error { get => throw null; set { } }
                    public string Url { get => throw null; set { } }
                    public bool UseStatefulReconnect { get => throw null; set { } }
                    public int Version { get => throw null; set { } }
                }
            }
        }
    }
}
