// This file contains auto-generated code.
// Generated from `System.IO.Pipelines, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace IO
    {
        namespace Pipelines
        {
            public struct FlushResult
            {
                public FlushResult(bool isCanceled, bool isCompleted) => throw null;
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
            }
            public interface IDuplexPipe
            {
                System.IO.Pipelines.PipeReader Input { get; }
                System.IO.Pipelines.PipeWriter Output { get; }
            }
            public sealed class Pipe
            {
                public Pipe() => throw null;
                public Pipe(System.IO.Pipelines.PipeOptions options) => throw null;
                public System.IO.Pipelines.PipeReader Reader { get => throw null; }
                public void Reset() => throw null;
                public System.IO.Pipelines.PipeWriter Writer { get => throw null; }
            }
            public class PipeOptions
            {
                public PipeOptions(System.Buffers.MemoryPool<byte> pool = default(System.Buffers.MemoryPool<byte>), System.IO.Pipelines.PipeScheduler readerScheduler = default(System.IO.Pipelines.PipeScheduler), System.IO.Pipelines.PipeScheduler writerScheduler = default(System.IO.Pipelines.PipeScheduler), long pauseWriterThreshold = default(long), long resumeWriterThreshold = default(long), int minimumSegmentSize = default(int), bool useSynchronizationContext = default(bool)) => throw null;
                public static System.IO.Pipelines.PipeOptions Default { get => throw null; }
                public int MinimumSegmentSize { get => throw null; }
                public long PauseWriterThreshold { get => throw null; }
                public System.Buffers.MemoryPool<byte> Pool { get => throw null; }
                public System.IO.Pipelines.PipeScheduler ReaderScheduler { get => throw null; }
                public long ResumeWriterThreshold { get => throw null; }
                public bool UseSynchronizationContext { get => throw null; }
                public System.IO.Pipelines.PipeScheduler WriterScheduler { get => throw null; }
            }
            public abstract class PipeReader
            {
                public abstract void AdvanceTo(System.SequencePosition consumed);
                public abstract void AdvanceTo(System.SequencePosition consumed, System.SequencePosition examined);
                public virtual System.IO.Stream AsStream(bool leaveOpen = default(bool)) => throw null;
                public abstract void CancelPendingRead();
                public abstract void Complete(System.Exception exception = default(System.Exception));
                public virtual System.Threading.Tasks.ValueTask CompleteAsync(System.Exception exception = default(System.Exception)) => throw null;
                public virtual System.Threading.Tasks.Task CopyToAsync(System.IO.Pipelines.PipeWriter destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.IO.Pipelines.PipeReader Create(System.Buffers.ReadOnlySequence<byte> sequence) => throw null;
                public static System.IO.Pipelines.PipeReader Create(System.IO.Stream stream, System.IO.Pipelines.StreamPipeReaderOptions readerOptions = default(System.IO.Pipelines.StreamPipeReaderOptions)) => throw null;
                protected PipeReader() => throw null;
                public virtual void OnWriterCompleted(System.Action<System.Exception, object> callback, object state) => throw null;
                public abstract System.Threading.Tasks.ValueTask<System.IO.Pipelines.ReadResult> ReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public System.Threading.Tasks.ValueTask<System.IO.Pipelines.ReadResult> ReadAtLeastAsync(int minimumSize, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected virtual System.Threading.Tasks.ValueTask<System.IO.Pipelines.ReadResult> ReadAtLeastAsyncCore(int minimumSize, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract bool TryRead(out System.IO.Pipelines.ReadResult result);
            }
            public abstract class PipeScheduler
            {
                protected PipeScheduler() => throw null;
                public static System.IO.Pipelines.PipeScheduler Inline { get => throw null; }
                public abstract void Schedule(System.Action<object> action, object state);
                public static System.IO.Pipelines.PipeScheduler ThreadPool { get => throw null; }
            }
            public abstract class PipeWriter : System.Buffers.IBufferWriter<byte>
            {
                public abstract void Advance(int bytes);
                public virtual System.IO.Stream AsStream(bool leaveOpen = default(bool)) => throw null;
                public abstract void CancelPendingFlush();
                public virtual bool CanGetUnflushedBytes { get => throw null; }
                public abstract void Complete(System.Exception exception = default(System.Exception));
                public virtual System.Threading.Tasks.ValueTask CompleteAsync(System.Exception exception = default(System.Exception)) => throw null;
                protected virtual System.Threading.Tasks.Task CopyFromAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.IO.Pipelines.PipeWriter Create(System.IO.Stream stream, System.IO.Pipelines.StreamPipeWriterOptions writerOptions = default(System.IO.Pipelines.StreamPipeWriterOptions)) => throw null;
                protected PipeWriter() => throw null;
                public abstract System.Threading.Tasks.ValueTask<System.IO.Pipelines.FlushResult> FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Memory<byte> GetMemory(int sizeHint = default(int));
                public abstract System.Span<byte> GetSpan(int sizeHint = default(int));
                public virtual void OnReaderCompleted(System.Action<System.Exception, object> callback, object state) => throw null;
                public virtual long UnflushedBytes { get => throw null; }
                public virtual System.Threading.Tasks.ValueTask<System.IO.Pipelines.FlushResult> WriteAsync(System.ReadOnlyMemory<byte> source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public struct ReadResult
            {
                public System.Buffers.ReadOnlySequence<byte> Buffer { get => throw null; }
                public ReadResult(System.Buffers.ReadOnlySequence<byte> buffer, bool isCanceled, bool isCompleted) => throw null;
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
            }
            public static partial class StreamPipeExtensions
            {
                public static System.Threading.Tasks.Task CopyToAsync(this System.IO.Stream source, System.IO.Pipelines.PipeWriter destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public class StreamPipeReaderOptions
            {
                public int BufferSize { get => throw null; }
                public StreamPipeReaderOptions(System.Buffers.MemoryPool<byte> pool, int bufferSize, int minimumReadSize, bool leaveOpen) => throw null;
                public StreamPipeReaderOptions(System.Buffers.MemoryPool<byte> pool = default(System.Buffers.MemoryPool<byte>), int bufferSize = default(int), int minimumReadSize = default(int), bool leaveOpen = default(bool), bool useZeroByteReads = default(bool)) => throw null;
                public bool LeaveOpen { get => throw null; }
                public int MinimumReadSize { get => throw null; }
                public System.Buffers.MemoryPool<byte> Pool { get => throw null; }
                public bool UseZeroByteReads { get => throw null; }
            }
            public class StreamPipeWriterOptions
            {
                public StreamPipeWriterOptions(System.Buffers.MemoryPool<byte> pool = default(System.Buffers.MemoryPool<byte>), int minimumBufferSize = default(int), bool leaveOpen = default(bool)) => throw null;
                public bool LeaveOpen { get => throw null; }
                public int MinimumBufferSize { get => throw null; }
                public System.Buffers.MemoryPool<byte> Pool { get => throw null; }
            }
        }
    }
}
