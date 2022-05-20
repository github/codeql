// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace WebUtilities
        {
            // Generated from `Microsoft.AspNetCore.WebUtilities.Base64UrlTextEncoder` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class Base64UrlTextEncoder
            {
                public static System.Byte[] Decode(string text) => throw null;
                public static string Encode(System.Byte[] data) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.BufferedReadStream` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BufferedReadStream : System.IO.Stream
            {
                public System.ArraySegment<System.Byte> BufferedData { get => throw null; }
                public BufferedReadStream(System.IO.Stream inner, int bufferSize, System.Buffers.ArrayPool<System.Byte> bytePool) => throw null;
                public BufferedReadStream(System.IO.Stream inner, int bufferSize) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public bool EnsureBuffered(int minCount) => throw null;
                public bool EnsureBuffered() => throw null;
                public System.Threading.Tasks.Task<bool> EnsureBufferedAsync(int minCount, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<bool> EnsureBufferedAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public string ReadLine(int lengthLimit) => throw null;
                public System.Threading.Tasks.Task<string> ReadLineAsync(int lengthLimit, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.FileBufferingReadStream` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileBufferingReadStream : System.IO.Stream
            {
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, System.Int64? bufferLimit, string tempFileDirectory, System.Buffers.ArrayPool<System.Byte> bytePool) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, System.Int64? bufferLimit, string tempFileDirectory) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, System.Int64? bufferLimit, System.Func<string> tempFileDirectoryAccessor, System.Buffers.ArrayPool<System.Byte> bytePool) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold, System.Int64? bufferLimit, System.Func<string> tempFileDirectoryAccessor) => throw null;
                public FileBufferingReadStream(System.IO.Stream inner, int memoryThreshold) => throw null;
                public override void Flush() => throw null;
                public bool InMemory { get => throw null; }
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public string TempFileName { get => throw null; }
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.FileBufferingWriteStream` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileBufferingWriteStream : System.IO.Stream
            {
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.Threading.Tasks.Task DrainBufferAsync(System.IO.Stream destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task DrainBufferAsync(System.IO.Pipelines.PipeWriter destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public FileBufferingWriteStream(int memoryThreshold = default(int), System.Int64? bufferLimit = default(System.Int64?), System.Func<string> tempFileDirectoryAccessor = default(System.Func<string>)) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.FileMultipartSection` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileMultipartSection
            {
                public FileMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section, Microsoft.Net.Http.Headers.ContentDispositionHeaderValue header) => throw null;
                public FileMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public string FileName { get => throw null; }
                public System.IO.Stream FileStream { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.AspNetCore.WebUtilities.MultipartSection Section { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.FormMultipartSection` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormMultipartSection
            {
                public FormMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section, Microsoft.Net.Http.Headers.ContentDispositionHeaderValue header) => throw null;
                public FormMultipartSection(Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public System.Threading.Tasks.Task<string> GetValueAsync() => throw null;
                public string Name { get => throw null; }
                public Microsoft.AspNetCore.WebUtilities.MultipartSection Section { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.FormPipeReader` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormPipeReader
            {
                public FormPipeReader(System.IO.Pipelines.PipeReader pipeReader, System.Text.Encoding encoding) => throw null;
                public FormPipeReader(System.IO.Pipelines.PipeReader pipeReader) => throw null;
                public int KeyLengthLimit { get => throw null; set => throw null; }
                public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues>> ReadFormAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public int ValueCountLimit { get => throw null; set => throw null; }
                public int ValueLengthLimit { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.FormReader` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormReader : System.IDisposable
            {
                public const int DefaultKeyLengthLimit = default;
                public const int DefaultValueCountLimit = default;
                public const int DefaultValueLengthLimit = default;
                public void Dispose() => throw null;
                public FormReader(string data, System.Buffers.ArrayPool<System.Char> charPool) => throw null;
                public FormReader(string data) => throw null;
                public FormReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Buffers.ArrayPool<System.Char> charPool) => throw null;
                public FormReader(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                public FormReader(System.IO.Stream stream) => throw null;
                public int KeyLengthLimit { get => throw null; set => throw null; }
                public System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> ReadForm() => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues>> ReadFormAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Collections.Generic.KeyValuePair<string, string>? ReadNextPair() => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.KeyValuePair<string, string>?> ReadNextPairAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public int ValueCountLimit { get => throw null; set => throw null; }
                public int ValueLengthLimit { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.HttpRequestStreamReader` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpRequestStreamReader : System.IO.TextReader
            {
                protected override void Dispose(bool disposing) => throw null;
                public HttpRequestStreamReader(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize, System.Buffers.ArrayPool<System.Byte> bytePool, System.Buffers.ArrayPool<System.Char> charPool) => throw null;
                public HttpRequestStreamReader(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize) => throw null;
                public HttpRequestStreamReader(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                public override int Peek() => throw null;
                public override int Read(System.Span<System.Char> buffer) => throw null;
                public override int Read(System.Char[] buffer, int index, int count) => throw null;
                public override int Read() => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Char[] buffer, int index, int count) => throw null;
                public override string ReadLine() => throw null;
                public override System.Threading.Tasks.Task<string> ReadLineAsync() => throw null;
                public override System.Threading.Tasks.Task<string> ReadToEndAsync() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.HttpResponseStreamWriter` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpResponseStreamWriter : System.IO.TextWriter
            {
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override System.Text.Encoding Encoding { get => throw null; }
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync() => throw null;
                public HttpResponseStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize, System.Buffers.ArrayPool<System.Byte> bytePool, System.Buffers.ArrayPool<System.Char> charPool) => throw null;
                public HttpResponseStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize) => throw null;
                public HttpResponseStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                public override void Write(string value) => throw null;
                public override void Write(System.ReadOnlySpan<System.Char> value) => throw null;
                public override void Write(System.Char[] values, int index, int count) => throw null;
                public override void Write(System.Char value) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(string value) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.ReadOnlyMemory<System.Char> value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Char[] values, int index, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Char value) => throw null;
                public override void WriteLine(System.ReadOnlySpan<System.Char> value) => throw null;
                public override System.Threading.Tasks.Task WriteLineAsync(System.ReadOnlyMemory<System.Char> value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.KeyValueAccumulator` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct KeyValueAccumulator
            {
                public void Append(string key, string value) => throw null;
                public System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> GetResults() => throw null;
                public bool HasValues { get => throw null; }
                public int KeyCount { get => throw null; }
                // Stub generator skipped constructor 
                public int ValueCount { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.MultipartReader` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class MultipartReader
            {
                public System.Int64? BodyLengthLimit { get => throw null; set => throw null; }
                public const int DefaultHeadersCountLimit = default;
                public const int DefaultHeadersLengthLimit = default;
                public int HeadersCountLimit { get => throw null; set => throw null; }
                public int HeadersLengthLimit { get => throw null; set => throw null; }
                public MultipartReader(string boundary, System.IO.Stream stream, int bufferSize) => throw null;
                public MultipartReader(string boundary, System.IO.Stream stream) => throw null;
                public System.Threading.Tasks.Task<Microsoft.AspNetCore.WebUtilities.MultipartSection> ReadNextSectionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.MultipartSection` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class MultipartSection
            {
                public System.Int64? BaseStreamOffset { get => throw null; set => throw null; }
                public System.IO.Stream Body { get => throw null; set => throw null; }
                public string ContentDisposition { get => throw null; }
                public string ContentType { get => throw null; }
                public System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> Headers { get => throw null; set => throw null; }
                public MultipartSection() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.MultipartSectionConverterExtensions` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MultipartSectionConverterExtensions
            {
                public static Microsoft.AspNetCore.WebUtilities.FileMultipartSection AsFileSection(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public static Microsoft.AspNetCore.WebUtilities.FormMultipartSection AsFormDataSection(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
                public static Microsoft.Net.Http.Headers.ContentDispositionHeaderValue GetContentDispositionHeader(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.MultipartSectionStreamExtensions` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MultipartSectionStreamExtensions
            {
                public static System.Threading.Tasks.Task<string> ReadAsStringAsync(this Microsoft.AspNetCore.WebUtilities.MultipartSection section) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.QueryHelpers` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class QueryHelpers
            {
                public static string AddQueryString(string uri, string name, string value) => throw null;
                public static string AddQueryString(string uri, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> queryString) => throw null;
                public static string AddQueryString(string uri, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>> queryString) => throw null;
                public static string AddQueryString(string uri, System.Collections.Generic.IDictionary<string, string> queryString) => throw null;
                public static System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> ParseNullableQuery(string queryString) => throw null;
                public static System.Collections.Generic.Dictionary<string, Microsoft.Extensions.Primitives.StringValues> ParseQuery(string queryString) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.ReasonPhrases` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ReasonPhrases
            {
                public static string GetReasonPhrase(int statusCode) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.StreamHelperExtensions` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class StreamHelperExtensions
            {
                public static System.Threading.Tasks.Task DrainAsync(this System.IO.Stream stream, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task DrainAsync(this System.IO.Stream stream, System.Int64? limit, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task DrainAsync(this System.IO.Stream stream, System.Buffers.ArrayPool<System.Byte> bytePool, System.Int64? limit, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebUtilities.WebEncoders` in `Microsoft.AspNetCore.WebUtilities, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WebEncoders
            {
                public static System.Byte[] Base64UrlDecode(string input, int offset, int count) => throw null;
                public static System.Byte[] Base64UrlDecode(string input, int offset, System.Char[] buffer, int bufferOffset, int count) => throw null;
                public static System.Byte[] Base64UrlDecode(string input) => throw null;
                public static string Base64UrlEncode(System.ReadOnlySpan<System.Byte> input) => throw null;
                public static string Base64UrlEncode(System.Byte[] input, int offset, int count) => throw null;
                public static string Base64UrlEncode(System.Byte[] input) => throw null;
                public static int Base64UrlEncode(System.Byte[] input, int offset, System.Char[] output, int outputOffset, int count) => throw null;
                public static int GetArraySizeRequiredToDecode(int count) => throw null;
                public static int GetArraySizeRequiredToEncode(int count) => throw null;
            }

        }
    }
}
