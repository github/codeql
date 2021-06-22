// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'AllowNullAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'DisallowNullAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'DoesNotReturnAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'DoesNotReturnIfAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MaybeNullAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MaybeNullWhenAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MemberNotNullAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MemberNotNullWhenAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'NotNullAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'NotNullIfNotNullAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'NotNullWhenAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
    namespace IO
    {
        namespace Pipelines
        {
            // Generated from `System.IO.Pipelines.FlushResult` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct FlushResult
            {
                public FlushResult(bool isCanceled, bool isCompleted) => throw null;
                // Stub generator skipped constructor 
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
            }

            // Generated from `System.IO.Pipelines.IDuplexPipe` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IDuplexPipe
            {
                System.IO.Pipelines.PipeReader Input { get; }
                System.IO.Pipelines.PipeWriter Output { get; }
            }

            // Generated from `System.IO.Pipelines.Pipe` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Pipe
            {
                public Pipe(System.IO.Pipelines.PipeOptions options) => throw null;
                public Pipe() => throw null;
                public System.IO.Pipelines.PipeReader Reader { get => throw null; }
                public void Reset() => throw null;
                public System.IO.Pipelines.PipeWriter Writer { get => throw null; }
            }

            // Generated from `System.IO.Pipelines.PipeOptions` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PipeOptions
            {
                public static System.IO.Pipelines.PipeOptions Default { get => throw null; }
                public int MinimumSegmentSize { get => throw null; }
                public System.Int64 PauseWriterThreshold { get => throw null; }
                public PipeOptions(System.Buffers.MemoryPool<System.Byte> pool = default(System.Buffers.MemoryPool<System.Byte>), System.IO.Pipelines.PipeScheduler readerScheduler = default(System.IO.Pipelines.PipeScheduler), System.IO.Pipelines.PipeScheduler writerScheduler = default(System.IO.Pipelines.PipeScheduler), System.Int64 pauseWriterThreshold = default(System.Int64), System.Int64 resumeWriterThreshold = default(System.Int64), int minimumSegmentSize = default(int), bool useSynchronizationContext = default(bool)) => throw null;
                public System.Buffers.MemoryPool<System.Byte> Pool { get => throw null; }
                public System.IO.Pipelines.PipeScheduler ReaderScheduler { get => throw null; }
                public System.Int64 ResumeWriterThreshold { get => throw null; }
                public bool UseSynchronizationContext { get => throw null; }
                public System.IO.Pipelines.PipeScheduler WriterScheduler { get => throw null; }
            }

            // Generated from `System.IO.Pipelines.PipeReader` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class PipeReader
            {
                public abstract void AdvanceTo(System.SequencePosition consumed, System.SequencePosition examined);
                public abstract void AdvanceTo(System.SequencePosition consumed);
                public virtual System.IO.Stream AsStream(bool leaveOpen = default(bool)) => throw null;
                public abstract void CancelPendingRead();
                public abstract void Complete(System.Exception exception = default(System.Exception));
                public virtual System.Threading.Tasks.ValueTask CompleteAsync(System.Exception exception = default(System.Exception)) => throw null;
                public virtual System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task CopyToAsync(System.IO.Pipelines.PipeWriter destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.IO.Pipelines.PipeReader Create(System.IO.Stream stream, System.IO.Pipelines.StreamPipeReaderOptions readerOptions = default(System.IO.Pipelines.StreamPipeReaderOptions)) => throw null;
                public virtual void OnWriterCompleted(System.Action<System.Exception, object> callback, object state) => throw null;
                protected PipeReader() => throw null;
                public abstract System.Threading.Tasks.ValueTask<System.IO.Pipelines.ReadResult> ReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract bool TryRead(out System.IO.Pipelines.ReadResult result);
            }

            // Generated from `System.IO.Pipelines.PipeScheduler` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class PipeScheduler
            {
                public static System.IO.Pipelines.PipeScheduler Inline { get => throw null; }
                protected PipeScheduler() => throw null;
                public abstract void Schedule(System.Action<object> action, object state);
                public static System.IO.Pipelines.PipeScheduler ThreadPool { get => throw null; }
            }

            // Generated from `System.IO.Pipelines.PipeWriter` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class PipeWriter : System.Buffers.IBufferWriter<System.Byte>
            {
                public abstract void Advance(int bytes);
                public virtual System.IO.Stream AsStream(bool leaveOpen = default(bool)) => throw null;
                public abstract void CancelPendingFlush();
                public abstract void Complete(System.Exception exception = default(System.Exception));
                public virtual System.Threading.Tasks.ValueTask CompleteAsync(System.Exception exception = default(System.Exception)) => throw null;
                protected internal virtual System.Threading.Tasks.Task CopyFromAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.IO.Pipelines.PipeWriter Create(System.IO.Stream stream, System.IO.Pipelines.StreamPipeWriterOptions writerOptions = default(System.IO.Pipelines.StreamPipeWriterOptions)) => throw null;
                public abstract System.Threading.Tasks.ValueTask<System.IO.Pipelines.FlushResult> FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Memory<System.Byte> GetMemory(int sizeHint = default(int));
                public abstract System.Span<System.Byte> GetSpan(int sizeHint = default(int));
                public virtual void OnReaderCompleted(System.Action<System.Exception, object> callback, object state) => throw null;
                protected PipeWriter() => throw null;
                public virtual System.Threading.Tasks.ValueTask<System.IO.Pipelines.FlushResult> WriteAsync(System.ReadOnlyMemory<System.Byte> source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `System.IO.Pipelines.ReadResult` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct ReadResult
            {
                public System.Buffers.ReadOnlySequence<System.Byte> Buffer { get => throw null; }
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
                public ReadResult(System.Buffers.ReadOnlySequence<System.Byte> buffer, bool isCanceled, bool isCompleted) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `System.IO.Pipelines.StreamPipeExtensions` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class StreamPipeExtensions
            {
                public static System.Threading.Tasks.Task CopyToAsync(this System.IO.Stream source, System.IO.Pipelines.PipeWriter destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `System.IO.Pipelines.StreamPipeReaderOptions` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StreamPipeReaderOptions
            {
                public int BufferSize { get => throw null; }
                public bool LeaveOpen { get => throw null; }
                public int MinimumReadSize { get => throw null; }
                public System.Buffers.MemoryPool<System.Byte> Pool { get => throw null; }
                public StreamPipeReaderOptions(System.Buffers.MemoryPool<System.Byte> pool = default(System.Buffers.MemoryPool<System.Byte>), int bufferSize = default(int), int minimumReadSize = default(int), bool leaveOpen = default(bool)) => throw null;
            }

            // Generated from `System.IO.Pipelines.StreamPipeWriterOptions` in `System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StreamPipeWriterOptions
            {
                public bool LeaveOpen { get => throw null; }
                public int MinimumBufferSize { get => throw null; }
                public System.Buffers.MemoryPool<System.Byte> Pool { get => throw null; }
                public StreamPipeWriterOptions(System.Buffers.MemoryPool<System.Byte> pool = default(System.Buffers.MemoryPool<System.Byte>), int minimumBufferSize = default(int), bool leaveOpen = default(bool)) => throw null;
            }

        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'System.IO.Pipelines, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
}
