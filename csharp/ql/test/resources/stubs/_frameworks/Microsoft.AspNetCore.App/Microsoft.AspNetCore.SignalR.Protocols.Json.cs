// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace SignalR
        {
            // Generated from `Microsoft.AspNetCore.SignalR.JsonHubProtocolOptions` in `Microsoft.AspNetCore.SignalR.Protocols.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class JsonHubProtocolOptions
            {
                public JsonHubProtocolOptions() => throw null;
                public System.Text.Json.JsonSerializerOptions PayloadSerializerOptions { get => throw null; set => throw null; }
            }

            namespace Protocol
            {
                // Generated from `Microsoft.AspNetCore.SignalR.Protocol.JsonHubProtocol` in `Microsoft.AspNetCore.SignalR.Protocols.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JsonHubProtocol : Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol
                {
                    public System.ReadOnlyMemory<System.Byte> GetMessageBytes(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
                    public bool IsVersionSupported(int version) => throw null;
                    public JsonHubProtocol(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.JsonHubProtocolOptions> options) => throw null;
                    public JsonHubProtocol() => throw null;
                    public string Name { get => throw null; }
                    public Microsoft.AspNetCore.Connections.TransferFormat TransferFormat { get => throw null; }
                    public bool TryParseMessage(ref System.Buffers.ReadOnlySequence<System.Byte> input, Microsoft.AspNetCore.SignalR.IInvocationBinder binder, out Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
                    public int Version { get => throw null; }
                    public void WriteMessage(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message, System.Buffers.IBufferWriter<System.Byte> output) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.JsonProtocolDependencyInjectionExtensions` in `Microsoft.AspNetCore.SignalR.Protocols.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class JsonProtocolDependencyInjectionExtensions
            {
                public static TBuilder AddJsonProtocol<TBuilder>(this TBuilder builder, System.Action<Microsoft.AspNetCore.SignalR.JsonHubProtocolOptions> configure) where TBuilder : Microsoft.AspNetCore.SignalR.ISignalRBuilder => throw null;
                public static TBuilder AddJsonProtocol<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.SignalR.ISignalRBuilder => throw null;
            }

        }
    }
}
