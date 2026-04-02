// This file contains auto-generated code.
// Generated from `System.Net.ServerSentEvents, Version=10.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Net
    {
        namespace ServerSentEvents
        {
            public static class SseFormatter
            {
                public static System.Threading.Tasks.Task WriteAsync(System.Collections.Generic.IAsyncEnumerable<System.Net.ServerSentEvents.SseItem<string>> source, System.IO.Stream destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task WriteAsync<T>(System.Collections.Generic.IAsyncEnumerable<System.Net.ServerSentEvents.SseItem<T>> source, System.IO.Stream destination, System.Action<System.Net.ServerSentEvents.SseItem<T>, System.Buffers.IBufferWriter<byte>> itemFormatter, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public struct SseItem<T>
            {
                public SseItem(T data, string eventType = default(string)) => throw null;
                public T Data { get => throw null; }
                public string EventId { get => throw null; set { } }
                public string EventType { get => throw null; }
                public System.TimeSpan? ReconnectionInterval { get => throw null; set { } }
            }
            public delegate T SseItemParser<T>(string eventType, System.ReadOnlySpan<byte> data);
            public static class SseParser
            {
                public static System.Net.ServerSentEvents.SseParser<string> Create(System.IO.Stream sseStream) => throw null;
                public static System.Net.ServerSentEvents.SseParser<T> Create<T>(System.IO.Stream sseStream, System.Net.ServerSentEvents.SseItemParser<T> itemParser) => throw null;
                public const string EventTypeDefault = default;
            }
            public sealed class SseParser<T>
            {
                public System.Collections.Generic.IEnumerable<System.Net.ServerSentEvents.SseItem<T>> Enumerate() => throw null;
                public System.Collections.Generic.IAsyncEnumerable<System.Net.ServerSentEvents.SseItem<T>> EnumerateAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public string LastEventId { get => throw null; }
                public System.TimeSpan ReconnectionInterval { get => throw null; }
            }
        }
    }
}
