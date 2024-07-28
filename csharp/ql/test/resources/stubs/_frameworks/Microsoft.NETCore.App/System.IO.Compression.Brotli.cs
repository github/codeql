// This file contains auto-generated code.
// Generated from `System.IO.Compression.Brotli, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`.
namespace System
{
    namespace IO
    {
        namespace Compression
        {
            public struct BrotliDecoder : System.IDisposable
            {
                public System.Buffers.OperationStatus Decompress(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesConsumed, out int bytesWritten) => throw null;
                public void Dispose() => throw null;
                public static bool TryDecompress(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public struct BrotliEncoder : System.IDisposable
            {
                public System.Buffers.OperationStatus Compress(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesConsumed, out int bytesWritten, bool isFinalBlock) => throw null;
                public BrotliEncoder(int quality, int window) => throw null;
                public void Dispose() => throw null;
                public System.Buffers.OperationStatus Flush(System.Span<byte> destination, out int bytesWritten) => throw null;
                public static int GetMaxCompressedLength(int inputSize) => throw null;
                public static bool TryCompress(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                public static bool TryCompress(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten, int quality, int window) => throw null;
            }
            public sealed class BrotliStream : System.IO.Stream
            {
                public System.IO.Stream BaseStream { get => throw null; }
                public override System.IAsyncResult BeginRead(byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginWrite(byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel, bool leaveOpen) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode, bool leaveOpen) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override long Length { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(byte value) => throw null;
            }
        }
    }
}
