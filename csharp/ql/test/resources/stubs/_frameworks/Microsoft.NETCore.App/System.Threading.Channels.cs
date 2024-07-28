// This file contains auto-generated code.
// Generated from `System.Threading.Channels, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Threading
    {
        namespace Channels
        {
            public enum BoundedChannelFullMode
            {
                Wait = 0,
                DropNewest = 1,
                DropOldest = 2,
                DropWrite = 3,
            }
            public sealed class BoundedChannelOptions : System.Threading.Channels.ChannelOptions
            {
                public int Capacity { get => throw null; set { } }
                public BoundedChannelOptions(int capacity) => throw null;
                public System.Threading.Channels.BoundedChannelFullMode FullMode { get => throw null; set { } }
            }
            public static class Channel
            {
                public static System.Threading.Channels.Channel<T> CreateBounded<T>(int capacity) => throw null;
                public static System.Threading.Channels.Channel<T> CreateBounded<T>(System.Threading.Channels.BoundedChannelOptions options) => throw null;
                public static System.Threading.Channels.Channel<T> CreateBounded<T>(System.Threading.Channels.BoundedChannelOptions options, System.Action<T> itemDropped) => throw null;
                public static System.Threading.Channels.Channel<T> CreateUnbounded<T>() => throw null;
                public static System.Threading.Channels.Channel<T> CreateUnbounded<T>(System.Threading.Channels.UnboundedChannelOptions options) => throw null;
            }
            public abstract class Channel<T> : System.Threading.Channels.Channel<T, T>
            {
                protected Channel() => throw null;
            }
            public abstract class Channel<TWrite, TRead>
            {
                protected Channel() => throw null;
                public static implicit operator System.Threading.Channels.ChannelReader<TRead>(System.Threading.Channels.Channel<TWrite, TRead> channel) => throw null;
                public static implicit operator System.Threading.Channels.ChannelWriter<TWrite>(System.Threading.Channels.Channel<TWrite, TRead> channel) => throw null;
                public System.Threading.Channels.ChannelReader<TRead> Reader { get => throw null; set { } }
                public System.Threading.Channels.ChannelWriter<TWrite> Writer { get => throw null; set { } }
            }
            public class ChannelClosedException : System.InvalidOperationException
            {
                public ChannelClosedException() => throw null;
                public ChannelClosedException(System.Exception innerException) => throw null;
                public ChannelClosedException(string message) => throw null;
                public ChannelClosedException(string message, System.Exception innerException) => throw null;
                protected ChannelClosedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public abstract class ChannelOptions
            {
                public bool AllowSynchronousContinuations { get => throw null; set { } }
                protected ChannelOptions() => throw null;
                public bool SingleReader { get => throw null; set { } }
                public bool SingleWriter { get => throw null; set { } }
            }
            public abstract class ChannelReader<T>
            {
                public virtual bool CanCount { get => throw null; }
                public virtual bool CanPeek { get => throw null; }
                public virtual System.Threading.Tasks.Task Completion { get => throw null; }
                public virtual int Count { get => throw null; }
                protected ChannelReader() => throw null;
                public virtual System.Collections.Generic.IAsyncEnumerable<T> ReadAllAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.ValueTask<T> ReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual bool TryPeek(out T item) => throw null;
                public abstract bool TryRead(out T item);
                public abstract System.Threading.Tasks.ValueTask<bool> WaitToReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public abstract class ChannelWriter<T>
            {
                public void Complete(System.Exception error = default(System.Exception)) => throw null;
                protected ChannelWriter() => throw null;
                public virtual bool TryComplete(System.Exception error = default(System.Exception)) => throw null;
                public abstract bool TryWrite(T item);
                public abstract System.Threading.Tasks.ValueTask<bool> WaitToWriteAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.ValueTask WriteAsync(T item, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public sealed class UnboundedChannelOptions : System.Threading.Channels.ChannelOptions
            {
                public UnboundedChannelOptions() => throw null;
            }
        }
    }
}
