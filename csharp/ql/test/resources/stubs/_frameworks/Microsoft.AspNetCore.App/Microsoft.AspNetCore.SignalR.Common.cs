// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.SignalR.Common, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace SignalR
        {
            public class HubException : System.Exception
            {
                public HubException() => throw null;
                public HubException(string message) => throw null;
                public HubException(string message, System.Exception innerException) => throw null;
                public HubException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public interface IInvocationBinder
            {
                System.Collections.Generic.IReadOnlyList<System.Type> GetParameterTypes(string methodName);
                System.Type GetReturnType(string invocationId);
                System.Type GetStreamItemType(string streamId);
                virtual string GetTarget(System.ReadOnlySpan<byte> utf8Bytes) => throw null;
            }
            public interface ISignalRBuilder
            {
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
            namespace Protocol
            {
                public sealed class AckMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public AckMessage(long sequenceId) => throw null;
                    public long SequenceId { get => throw null; set { } }
                }
                public class CancelInvocationMessage : Microsoft.AspNetCore.SignalR.Protocol.HubInvocationMessage
                {
                    public CancelInvocationMessage(string invocationId) : base(default(string)) => throw null;
                }
                public class CloseMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public bool AllowReconnect { get => throw null; }
                    public CloseMessage(string error) => throw null;
                    public CloseMessage(string error, bool allowReconnect) => throw null;
                    public static readonly Microsoft.AspNetCore.SignalR.Protocol.CloseMessage Empty;
                    public string Error { get => throw null; }
                }
                public class CompletionMessage : Microsoft.AspNetCore.SignalR.Protocol.HubInvocationMessage
                {
                    public CompletionMessage(string invocationId, string error, object result, bool hasResult) : base(default(string)) => throw null;
                    public static Microsoft.AspNetCore.SignalR.Protocol.CompletionMessage Empty(string invocationId) => throw null;
                    public string Error { get => throw null; }
                    public bool HasResult { get => throw null; }
                    public object Result { get => throw null; }
                    public override string ToString() => throw null;
                    public static Microsoft.AspNetCore.SignalR.Protocol.CompletionMessage WithError(string invocationId, string error) => throw null;
                    public static Microsoft.AspNetCore.SignalR.Protocol.CompletionMessage WithResult(string invocationId, object payload) => throw null;
                }
                public static class HandshakeProtocol
                {
                    public static System.ReadOnlySpan<byte> GetSuccessfulHandshake(Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol protocol) => throw null;
                    public static bool TryParseRequestMessage(ref System.Buffers.ReadOnlySequence<byte> buffer, out Microsoft.AspNetCore.SignalR.Protocol.HandshakeRequestMessage requestMessage) => throw null;
                    public static bool TryParseResponseMessage(ref System.Buffers.ReadOnlySequence<byte> buffer, out Microsoft.AspNetCore.SignalR.Protocol.HandshakeResponseMessage responseMessage) => throw null;
                    public static void WriteRequestMessage(Microsoft.AspNetCore.SignalR.Protocol.HandshakeRequestMessage requestMessage, System.Buffers.IBufferWriter<byte> output) => throw null;
                    public static void WriteResponseMessage(Microsoft.AspNetCore.SignalR.Protocol.HandshakeResponseMessage responseMessage, System.Buffers.IBufferWriter<byte> output) => throw null;
                }
                public class HandshakeRequestMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public HandshakeRequestMessage(string protocol, int version) => throw null;
                    public string Protocol { get => throw null; }
                    public int Version { get => throw null; }
                }
                public class HandshakeResponseMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public HandshakeResponseMessage(string error) => throw null;
                    public static readonly Microsoft.AspNetCore.SignalR.Protocol.HandshakeResponseMessage Empty;
                    public string Error { get => throw null; }
                }
                public abstract class HubInvocationMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    protected HubInvocationMessage(string invocationId) => throw null;
                    public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; set { } }
                    public string InvocationId { get => throw null; }
                }
                public abstract class HubMessage
                {
                    protected HubMessage() => throw null;
                }
                public abstract class HubMethodInvocationMessage : Microsoft.AspNetCore.SignalR.Protocol.HubInvocationMessage
                {
                    public object[] Arguments { get => throw null; }
                    protected HubMethodInvocationMessage(string invocationId, string target, object[] arguments, string[] streamIds) : base(default(string)) => throw null;
                    protected HubMethodInvocationMessage(string invocationId, string target, object[] arguments) : base(default(string)) => throw null;
                    public string[] StreamIds { get => throw null; }
                    public string Target { get => throw null; }
                }
                public static class HubProtocolConstants
                {
                    public const int AckMessageType = 8;
                    public const int CancelInvocationMessageType = 5;
                    public const int CloseMessageType = 7;
                    public const int CompletionMessageType = 3;
                    public const int InvocationMessageType = 1;
                    public const int PingMessageType = 6;
                    public const int SequenceMessageType = 9;
                    public const int StreamInvocationMessageType = 4;
                    public const int StreamItemMessageType = 2;
                }
                public static partial class HubProtocolExtensions
                {
                    public static byte[] GetMessageBytes(this Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol hubProtocol, Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
                }
                public interface IHubProtocol
                {
                    System.ReadOnlyMemory<byte> GetMessageBytes(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message);
                    bool IsVersionSupported(int version);
                    string Name { get; }
                    Microsoft.AspNetCore.Connections.TransferFormat TransferFormat { get; }
                    bool TryParseMessage(ref System.Buffers.ReadOnlySequence<byte> input, Microsoft.AspNetCore.SignalR.IInvocationBinder binder, out Microsoft.AspNetCore.SignalR.Protocol.HubMessage message);
                    int Version { get; }
                    void WriteMessage(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message, System.Buffers.IBufferWriter<byte> output);
                }
                public class InvocationBindingFailureMessage : Microsoft.AspNetCore.SignalR.Protocol.HubInvocationMessage
                {
                    public System.Runtime.ExceptionServices.ExceptionDispatchInfo BindingFailure { get => throw null; }
                    public InvocationBindingFailureMessage(string invocationId, string target, System.Runtime.ExceptionServices.ExceptionDispatchInfo bindingFailure) : base(default(string)) => throw null;
                    public string Target { get => throw null; }
                }
                public class InvocationMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMethodInvocationMessage
                {
                    public InvocationMessage(string target, object[] arguments) : base(default(string), default(string), default(object[])) => throw null;
                    public InvocationMessage(string invocationId, string target, object[] arguments) : base(default(string), default(string), default(object[])) => throw null;
                    public InvocationMessage(string invocationId, string target, object[] arguments, string[] streamIds) : base(default(string), default(string), default(object[])) => throw null;
                    public override string ToString() => throw null;
                }
                public class PingMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public static readonly Microsoft.AspNetCore.SignalR.Protocol.PingMessage Instance;
                }
                public sealed class RawResult
                {
                    public RawResult(System.Buffers.ReadOnlySequence<byte> rawBytes) => throw null;
                    public System.Buffers.ReadOnlySequence<byte> RawSerializedData { get => throw null; }
                }
                public sealed class SequenceMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public SequenceMessage(long sequenceId) => throw null;
                    public long SequenceId { get => throw null; set { } }
                }
                public class StreamBindingFailureMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMessage
                {
                    public System.Runtime.ExceptionServices.ExceptionDispatchInfo BindingFailure { get => throw null; }
                    public StreamBindingFailureMessage(string id, System.Runtime.ExceptionServices.ExceptionDispatchInfo bindingFailure) => throw null;
                    public string Id { get => throw null; }
                }
                public class StreamInvocationMessage : Microsoft.AspNetCore.SignalR.Protocol.HubMethodInvocationMessage
                {
                    public StreamInvocationMessage(string invocationId, string target, object[] arguments) : base(default(string), default(string), default(object[])) => throw null;
                    public StreamInvocationMessage(string invocationId, string target, object[] arguments, string[] streamIds) : base(default(string), default(string), default(object[])) => throw null;
                    public override string ToString() => throw null;
                }
                public class StreamItemMessage : Microsoft.AspNetCore.SignalR.Protocol.HubInvocationMessage
                {
                    public StreamItemMessage(string invocationId, object item) : base(default(string)) => throw null;
                    public object Item { get => throw null; set { } }
                    public override string ToString() => throw null;
                }
            }
        }
    }
}
