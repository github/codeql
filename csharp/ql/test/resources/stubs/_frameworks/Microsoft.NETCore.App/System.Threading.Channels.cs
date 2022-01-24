// This file contains auto-generated code.

namespace System
{
    namespace Threading
    {
        namespace Channels
        {
            // Generated from `System.Threading.Channels.BoundedChannelFullMode` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum BoundedChannelFullMode
            {
                DropNewest,
                DropOldest,
                DropWrite,
                Wait,
            }

            // Generated from `System.Threading.Channels.BoundedChannelOptions` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class BoundedChannelOptions : System.Threading.Channels.ChannelOptions
            {
                public BoundedChannelOptions(int capacity) => throw null;
                public int Capacity { get => throw null; set => throw null; }
                public System.Threading.Channels.BoundedChannelFullMode FullMode { get => throw null; set => throw null; }
            }

            // Generated from `System.Threading.Channels.Channel` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class Channel
            {
                public static System.Threading.Channels.Channel<T> CreateBounded<T>(System.Threading.Channels.BoundedChannelOptions options) => throw null;
                public static System.Threading.Channels.Channel<T> CreateBounded<T>(int capacity) => throw null;
                public static System.Threading.Channels.Channel<T> CreateUnbounded<T>() => throw null;
                public static System.Threading.Channels.Channel<T> CreateUnbounded<T>(System.Threading.Channels.UnboundedChannelOptions options) => throw null;
            }

            // Generated from `System.Threading.Channels.Channel<,>` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class Channel<TWrite, TRead>
            {
                protected Channel() => throw null;
                public System.Threading.Channels.ChannelReader<TRead> Reader { get => throw null; set => throw null; }
                public System.Threading.Channels.ChannelWriter<TWrite> Writer { get => throw null; set => throw null; }
                public static implicit operator System.Threading.Channels.ChannelReader<TRead>(System.Threading.Channels.Channel<TWrite, TRead> channel) => throw null;
                public static implicit operator System.Threading.Channels.ChannelWriter<TWrite>(System.Threading.Channels.Channel<TWrite, TRead> channel) => throw null;
            }

            // Generated from `System.Threading.Channels.Channel<>` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class Channel<T> : System.Threading.Channels.Channel<T, T>
            {
                protected Channel() => throw null;
            }

            // Generated from `System.Threading.Channels.ChannelClosedException` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ChannelClosedException : System.InvalidOperationException
            {
                public ChannelClosedException() => throw null;
                public ChannelClosedException(System.Exception innerException) => throw null;
                protected ChannelClosedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public ChannelClosedException(string message) => throw null;
                public ChannelClosedException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Threading.Channels.ChannelOptions` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class ChannelOptions
            {
                public bool AllowSynchronousContinuations { get => throw null; set => throw null; }
                protected ChannelOptions() => throw null;
                public bool SingleReader { get => throw null; set => throw null; }
                public bool SingleWriter { get => throw null; set => throw null; }
            }

            // Generated from `System.Threading.Channels.ChannelReader<>` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class ChannelReader<T>
            {
                public virtual bool CanCount { get => throw null; }
                protected ChannelReader() => throw null;
                public virtual System.Threading.Tasks.Task Completion { get => throw null; }
                public virtual int Count { get => throw null; }
                public virtual System.Collections.Generic.IAsyncEnumerable<T> ReadAllAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.ValueTask<T> ReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract bool TryRead(out T item);
                public abstract System.Threading.Tasks.ValueTask<bool> WaitToReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `System.Threading.Channels.ChannelWriter<>` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class ChannelWriter<T>
            {
                protected ChannelWriter() => throw null;
                public void Complete(System.Exception error = default(System.Exception)) => throw null;
                public virtual bool TryComplete(System.Exception error = default(System.Exception)) => throw null;
                public abstract bool TryWrite(T item);
                public abstract System.Threading.Tasks.ValueTask<bool> WaitToWriteAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.ValueTask WriteAsync(T item, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `System.Threading.Channels.UnboundedChannelOptions` in `System.Threading.Channels, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UnboundedChannelOptions : System.Threading.Channels.ChannelOptions
            {
                public UnboundedChannelOptions() => throw null;
            }

        }
    }
}
