// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.SignalR.Protocols.Json, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace SignalR
        {
            public class JsonHubProtocolOptions
            {
                public JsonHubProtocolOptions() => throw null;
                public System.Text.Json.JsonSerializerOptions PayloadSerializerOptions { get => throw null; set { } }
            }
            namespace Protocol
            {
                public sealed class JsonHubProtocol : Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol
                {
                    public JsonHubProtocol() => throw null;
                    public JsonHubProtocol(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.JsonHubProtocolOptions> options) => throw null;
                    public System.ReadOnlyMemory<byte> GetMessageBytes(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
                    public bool IsVersionSupported(int version) => throw null;
                    public string Name { get => throw null; }
                    public Microsoft.AspNetCore.Connections.TransferFormat TransferFormat { get => throw null; }
                    public bool TryParseMessage(ref System.Buffers.ReadOnlySequence<byte> input, Microsoft.AspNetCore.SignalR.IInvocationBinder binder, out Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
                    public int Version { get => throw null; }
                    public void WriteMessage(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message, System.Buffers.IBufferWriter<byte> output) => throw null;
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class JsonProtocolDependencyInjectionExtensions
            {
                public static TBuilder AddJsonProtocol<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.SignalR.ISignalRBuilder => throw null;
                public static TBuilder AddJsonProtocol<TBuilder>(this TBuilder builder, System.Action<Microsoft.AspNetCore.SignalR.JsonHubProtocolOptions> configure) where TBuilder : Microsoft.AspNetCore.SignalR.ISignalRBuilder => throw null;
            }
        }
    }
}
