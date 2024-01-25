// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.WebUtilities, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace WebUtilities
        {
            public static class Base64UrlTextEncoder
            {
                public static byte[] Decode(string text) => throw null;
                public static string Encode(byte[] data) => throw null;
            }
            public class BufferedReadStream : System.IO.Stream
            {
                public System.ArraySegment<byte> BufferedData { get => throw null; }
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public BufferedReadStream(System.IO.Stream inner, int bufferSize) => throw null;
                public BufferedReadStream(System.IO.Stream inner, int bufferSize, System.Buffers.ArrayPool<byte> bytePool) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public bool EnsureBuffered() => throw null;
                public bool EnsureBuffered(int minCount) => throw null;
                public System.Threading.Tasks.Task<bool> EnsureBufferedAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<bool> EnsureBufferedAsync(int minCount, System.Threading.CancellationToken cancellationToken) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override long Length { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public string ReadLine(int lengthLimit) => throw null;
                public System.Threading.Tasks.Task<string> ReadLineAsync(int lengthLimit, System.Threading.CancellationToken cancellationToken) => throw null;
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public class FileBufferingReadStream : System.IO.Stream
            {
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, long? bufferLimit, System.Func<string> tempFileDirectoryAccessor) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, long? bufferLimit, System.Func<string> tempFileDirectoryAccessor, System.Buffers.ArrayPool<byte> bytePool) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, long? bufferLimit, string tempFileDirectory) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, long? bufferLimit, string tempFileDirectory, System.Buffers.ArrayPool<byte> bytePool) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override void Flush() => throw null;
                public bool InMemory { get => throw null; }
                public override long Length { get => throw null; }
                public int MemoryThreshold { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(System.Span<byte> buffer) => throw null;
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public string TempFileName { get => throw null; }
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public sealed class FileBufferingWriteStream : System.IO.Stream
            {
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public FileBufferingWriteStream(int memoryThreshold = default(int), long? bufferLimit = default(long?), System.Func<string> tempFileDirectoryAccessor = default(System.Func<string>)) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.Threading.Tasks.Task DrainBufferAsync(System.IO.Stream destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task DrainBufferAsync(System.IO.Pipelines.PipeWriter destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override long Length { get => throw null; }
                public int MemoryThreshold { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public class FileMultipartSection
            {
                public FileMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public FileMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section, Microsoft.Net.Http.Headers.ContentDispositionHeaderValue header) => throw null;
                public string FileName { get => throw null; }
                public System.IO.Stream FileStream { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.AspNetCore.WebUtilities.MultipartSection Section { get => throw null; }
            }
            public class FormMultipartSection
            {
                public FormMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public FormMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section, Microsoft.Net.Http.Headers.ContentDispositionHeaderValue header) => throw null;
                public System.Threading.Tasks.Task<string> GetValueAsync() => throw null;
                public System.Threading.Tasks.ValueTask<string> GetValueAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public string Name { get => throw null; }
                public Microsoft.AspNetCore.WebUtilities.MultipartSection Section { get => throw null; }
            }
            public class FormPipeReader
            {
                public FormPipeReader(System.IO.Pipelines.PipeReader pipeReader) => throw null;
                public FormPipeReader(System.IO.Pipelines.PipeReader pipeReader, System.Text.Encoding encoding) => throw null;
                public int KeyLengthLimit { get => throw null; set { } }
                public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues>> ReadFormAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public int ValueCountLimit { get => throw null; set { } }
                public int ValueLengthLimit { get => throw null; set { } }
            }
            public class FormReader : System.IDisposable
            {
                public FormReader(string data) => throw null;
                public FormReader(string data, System.Buffers.ArrayPool<char> charPool) => throw null;
                public FormReader(System.IO.Stream stream) => throw null;
                public FormReader(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                public FormReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Buffers.ArrayPool<char> charPool) => throw null;
                public const int DefaultKeyLengthLimit = 2048;
                public const int DefaultValueCountLimit = 1024;
                public const int DefaultValueLengthLimit = 4194304;
                public void Dispose() => throw null;
                public int KeyLengthLimit { get => throw null; set { } }
                public System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> ReadForm() => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues>> ReadFormAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Collections.Generic.KeyValuePair<string, string>? ReadNextPair() => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.KeyValuePair<string, string>?> ReadNextPairAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public int ValueCountLimit { get => throw null; set { } }
                public int ValueLengthLimit { get => throw null; set { } }
            }
            public class HttpRequestStreamReader : System.IO.TextReader
            {
                public HttpRequestStreamReader(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                public HttpRequestStreamReader(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize) => throw null;
                public HttpRequestStreamReader(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize, System.Buffers.ArrayPool<byte> bytePool, System.Buffers.ArrayPool<char> charPool) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int Peek() => throw null;
                public override int Read() => throw null;
                public override int Read(char[] buffer, int index, int count) => throw null;
                public override int Read(System.Span<char> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(char[] buffer, int index, int count) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override string ReadLine() => throw null;
                public override System.Threading.Tasks.Task<string> ReadLineAsync() => throw null;
                public override System.Threading.Tasks.Task<string> ReadToEndAsync() => throw null;
            }
            public class HttpResponseStreamWriter : System.IO.TextWriter
            {
                public HttpResponseStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                public HttpResponseStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize) => throw null;
                public HttpResponseStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize, System.Buffers.ArrayPool<byte> bytePool, System.Buffers.ArrayPool<char> charPool) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override System.Text.Encoding Encoding { get => throw null; }
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync() => throw null;
                public override void Write(char value) => throw null;
                public override void Write(char[] values, int index, int count) => throw null;
                public override void Write(System.ReadOnlySpan<char> value) => throw null;
                public override void Write(string value) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(char value) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(char[] values, int index, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(string value) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.ReadOnlyMemory<char> value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteLine(System.ReadOnlySpan<char> value) => throw null;
                public override System.Threading.Tasks.Task WriteLineAsync(System.ReadOnlyMemory<char> value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task WriteLineAsync(char[] values, int index, int count) => throw null;
                public override System.Threading.Tasks.Task WriteLineAsync(char value) => throw null;
                public override System.Threading.Tasks.Task WriteLineAsync(string value) => throw null;
            }
            public struct KeyValueAccumulator
            {
                public void Append(string key, string value) => throw null;
                public System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> GetResults() => throw null;
                public bool HasValues { get => throw null; }
                public int KeyCount { get => throw null; }
                public int ValueCount { get => throw null; }
            }
            public class MultipartReader
            {
                public long? BodyLengthLimit { get => throw null; set { } }
                public MultipartReader(string boundary, System.IO.Stream stream) => throw null;
                public MultipartReader(string boundary, System.IO.Stream stream, int bufferSize) => throw null;
                public const int DefaultHeadersCountLimit = 16;
                public const int DefaultHeadersLengthLimit = 16384;
                public int HeadersCountLimit { get => throw null; set { } }
                public int HeadersLengthLimit { get => throw null; set { } }
                public System.Threading.Tasks.Task<Microsoft.AspNetCore.WebUtilities.MultipartSection> ReadNextSectionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public class MultipartSection
            {
                public long? BaseStreamOffset { get => throw null; set { } }
                public System.IO.Stream Body { get => throw null; set { } }
                public string ContentDisposition { get => throw null; }
                public string ContentType { get => throw null; }
                public MultipartSection() => throw null;
                public System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> Headers { get => throw null; set { } }
            }
            public static partial class MultipartSectionConverterExtensions
            {
                public static Microsoft.AspNetCore.WebUtilities.FileMultipartSection AsFileSection(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public static Microsoft.AspNetCore.WebUtilities.FormMultipartSection AsFormDataSection(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public static Microsoft.Net.Http.Headers.ContentDispositionHeaderValue GetContentDispositionHeader(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
            }
            public static partial class MultipartSectionStreamExtensions
            {
                public static System.Threading.Tasks.Task<string> ReadAsStringAsync(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public static System.Threading.Tasks.ValueTask<string> ReadAsStringAsync(this Microsoft.AspNetCore.WebUtilities.MultipartSection section, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public static class QueryHelpers
            {
                public static string AddQueryString(string uri, string name, string value) => throw null;
                public static string AddQueryString(string uri, System.Collections.Generic.IDictionary<string, string> queryString) => throw null;
                public static string AddQueryString(string uri, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> queryString) => throw null;
                public static string AddQueryString(string uri, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> queryString) => throw null;
                public static System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> ParseNullableQuery(string queryString) => throw null;
                public static System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> ParseQuery(string queryString) => throw null;
            }
            public struct QueryStringEnumerable
            {
                public QueryStringEnumerable(string queryString) => throw null;
                public QueryStringEnumerable(System.ReadOnlyMemory<char> queryString) => throw null;
                public struct EncodedNameValuePair
                {
                    public System.ReadOnlyMemory<char> DecodeName() => throw null;
                    public System.ReadOnlyMemory<char> DecodeValue() => throw null;
                    public System.ReadOnlyMemory<char> EncodedName { get => throw null; }
                    public System.ReadOnlyMemory<char> EncodedValue { get => throw null; }
                }
                public struct Enumerator
                {
                    public Microsoft.AspNetCore.WebUtilities.QueryStringEnumerable.EncodedNameValuePair Current { get => throw null; }
                    public bool MoveNext() => throw null;
                }
                public Microsoft.AspNetCore.WebUtilities.QueryStringEnumerable.Enumerator GetEnumerator() => throw null;
            }
            public static class ReasonPhrases
            {
                public static string GetReasonPhrase(int statusCode) => throw null;
            }
            public static partial class StreamHelperExtensions
            {
                public static System.Threading.Tasks.Task DrainAsync(this System.IO.Stream stream, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task DrainAsync(this System.IO.Stream stream, long? limit, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task DrainAsync(this System.IO.Stream stream, System.Buffers.ArrayPool<byte> bytePool, long? limit, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public static class WebEncoders
            {
                public static byte[] Base64UrlDecode(string input) => throw null;
                public static byte[] Base64UrlDecode(string input, int offset, int count) => throw null;
                public static byte[] Base64UrlDecode(string input, int offset, char[] buffer, int bufferOffset, int count) => throw null;
                public static string Base64UrlEncode(byte[] input) => throw null;
                public static string Base64UrlEncode(byte[] input, int offset, int count) => throw null;
                public static int Base64UrlEncode(byte[] input, int offset, char[] output, int outputOffset, int count) => throw null;
                public static string Base64UrlEncode(System.ReadOnlySpan<byte> input) => throw null;
                public static int GetArraySizeRequiredToDecode(int count) => throw null;
                public static int GetArraySizeRequiredToEncode(int count) => throw null;
            }
        }
    }
}
