// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        namespace Compression
        {
            // Generated from `System.IO.Compression.CompressionLevel` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public enum CompressionLevel
            {
                Fastest,
                NoCompression,
                Optimal,
            }

            // Generated from `System.IO.Compression.CompressionMode` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public enum CompressionMode
            {
                Compress,
                Decompress,
            }

            // Generated from `System.IO.Compression.DeflateStream` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class DeflateStream : System.IO.Stream
            {
                public System.IO.Stream BaseStream { get => throw null; }
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] array, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public override void CopyTo(System.IO.Stream destination, int bufferSize) => throw null;
                public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
                public DeflateStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public DeflateStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel, bool leaveOpen) => throw null;
                public DeflateStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode) => throw null;
                public DeflateStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode, bool leaveOpen) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] array, int offset, int count) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] array, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] array, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] array, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `System.IO.Compression.GZipStream` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class GZipStream : System.IO.Stream
            {
                public System.IO.Stream BaseStream { get => throw null; }
                public override System.IAsyncResult BeginRead(System.Byte[] array, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] array, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public override void CopyTo(System.IO.Stream destination, int bufferSize) => throw null;
                public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public GZipStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public GZipStream(System.IO.Stream stream, System.IO.Compression.CompressionLevel compressionLevel, bool leaveOpen) => throw null;
                public GZipStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode) => throw null;
                public GZipStream(System.IO.Stream stream, System.IO.Compression.CompressionMode mode, bool leaveOpen) => throw null;
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] array, int offset, int count) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] array, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] array, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] array, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `System.IO.Compression.ZipArchive` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class ZipArchive : System.IDisposable
            {
                public System.IO.Compression.ZipArchiveEntry CreateEntry(string entryName) => throw null;
                public System.IO.Compression.ZipArchiveEntry CreateEntry(string entryName, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Collections.ObjectModel.ReadOnlyCollection<System.IO.Compression.ZipArchiveEntry> Entries { get => throw null; }
                public System.IO.Compression.ZipArchiveEntry GetEntry(string entryName) => throw null;
                public System.IO.Compression.ZipArchiveMode Mode { get => throw null; }
                public ZipArchive(System.IO.Stream stream) => throw null;
                public ZipArchive(System.IO.Stream stream, System.IO.Compression.ZipArchiveMode mode) => throw null;
                public ZipArchive(System.IO.Stream stream, System.IO.Compression.ZipArchiveMode mode, bool leaveOpen) => throw null;
                public ZipArchive(System.IO.Stream stream, System.IO.Compression.ZipArchiveMode mode, bool leaveOpen, System.Text.Encoding entryNameEncoding) => throw null;
            }

            // Generated from `System.IO.Compression.ZipArchiveEntry` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class ZipArchiveEntry
            {
                public System.IO.Compression.ZipArchive Archive { get => throw null; }
                public System.Int64 CompressedLength { get => throw null; }
                public System.UInt32 Crc32 { get => throw null; }
                public void Delete() => throw null;
                public int ExternalAttributes { get => throw null; set => throw null; }
                public string FullName { get => throw null; }
                public System.DateTimeOffset LastWriteTime { get => throw null; set => throw null; }
                public System.Int64 Length { get => throw null; }
                public string Name { get => throw null; }
                public System.IO.Stream Open() => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.IO.Compression.ZipArchiveMode` in `System.IO.Compression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public enum ZipArchiveMode
            {
                Create,
                Read,
                Update,
            }

        }
    }
}
