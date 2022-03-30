// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        namespace Compression
        {
            // Generated from `System.IO.Compression.BrotliDecoder` in `System.IO.Compression.Brotli, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public struct BrotliDecoder : System.IDisposable
            {
                // Stub generator skipped constructor 
                public System.Buffers.OperationStatus Decompress(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesConsumed, out int bytesWritten) => throw null;
                public void Dispose() => throw null;
                public static bool TryDecompress(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.IO.Compression.BrotliEncoder` in `System.IO.Compression.Brotli, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public struct BrotliEncoder : System.IDisposable
            {
                // Stub generator skipped constructor 
                public BrotliEncoder(int quality, int window) => throw null;
                public System.Buffers.OperationStatus Compress(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesConsumed, out int bytesWritten, bool isFinalBlock) => throw null;
                public void Dispose() => throw null;
                public System.Buffers.OperationStatus Flush(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public static int GetMaxCompressedLength(int inputSize) => throw null;
                public static bool TryCompress(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public static bool TryCompress(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten, int quality, int window) => throw null;
            }

            // Generated from `System.IO.Compression.BrotliStream` in `System.IO.Compression.Brotli, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class BrotliStream : System.IO.Stream
            {
                public System.IO.Stream BaseStream { get => throw null; }
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel, bool leaveOpen) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode) => throw null;
                public BrotliStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode, bool leaveOpen) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

        }
    }
}
