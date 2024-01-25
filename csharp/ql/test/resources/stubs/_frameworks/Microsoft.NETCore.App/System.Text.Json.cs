// This file contains auto-generated code.
// Generated from `System.Text.Json, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Text
    {
        namespace Json
        {
            public enum JsonCommentHandling : byte
            {
                Disallow = 0,
                Skip = 1,
                Allow = 2,
            }
            public sealed class JsonDocument : System.IDisposable
            {
                public void Dispose() => throw null;
                public static System.Text.Json.JsonDocument Parse(System.Buffers.ReadOnlySequence<byte> utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(System.IO.Stream utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(System.ReadOnlyMemory<byte> utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(System.ReadOnlyMemory<char> json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(string json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Threading.Tasks.Task<System.Text.Json.JsonDocument> ParseAsync(System.IO.Stream utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Text.Json.JsonDocument ParseValue(ref System.Text.Json.Utf8JsonReader reader) => throw null;
                public System.Text.Json.JsonElement RootElement { get => throw null; }
                public static bool TryParseValue(ref System.Text.Json.Utf8JsonReader reader, out System.Text.Json.JsonDocument document) => throw null;
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }
            public struct JsonDocumentOptions
            {
                public bool AllowTrailingCommas { get => throw null; set { } }
                public System.Text.Json.JsonCommentHandling CommentHandling { get => throw null; set { } }
                public int MaxDepth { get => throw null; set { } }
            }
            public struct JsonElement
            {
                public struct ArrayEnumerator : System.IDisposable, System.Collections.Generic.IEnumerable<System.Text.Json.JsonElement>, System.Collections.IEnumerable, System.Collections.Generic.IEnumerator<System.Text.Json.JsonElement>, System.Collections.IEnumerator
                {
                    public System.Text.Json.JsonElement Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public System.Text.Json.JsonElement.ArrayEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Text.Json.JsonElement> System.Collections.Generic.IEnumerable<System.Text.Json.JsonElement>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public System.Text.Json.JsonElement Clone() => throw null;
                public System.Text.Json.JsonElement.ArrayEnumerator EnumerateArray() => throw null;
                public System.Text.Json.JsonElement.ObjectEnumerator EnumerateObject() => throw null;
                public int GetArrayLength() => throw null;
                public bool GetBoolean() => throw null;
                public byte GetByte() => throw null;
                public byte[] GetBytesFromBase64() => throw null;
                public System.DateTime GetDateTime() => throw null;
                public System.DateTimeOffset GetDateTimeOffset() => throw null;
                public decimal GetDecimal() => throw null;
                public double GetDouble() => throw null;
                public System.Guid GetGuid() => throw null;
                public short GetInt16() => throw null;
                public int GetInt32() => throw null;
                public long GetInt64() => throw null;
                public System.Text.Json.JsonElement GetProperty(System.ReadOnlySpan<byte> utf8PropertyName) => throw null;
                public System.Text.Json.JsonElement GetProperty(System.ReadOnlySpan<char> propertyName) => throw null;
                public System.Text.Json.JsonElement GetProperty(string propertyName) => throw null;
                public string GetRawText() => throw null;
                public sbyte GetSByte() => throw null;
                public float GetSingle() => throw null;
                public string GetString() => throw null;
                public ushort GetUInt16() => throw null;
                public uint GetUInt32() => throw null;
                public ulong GetUInt64() => throw null;
                public struct ObjectEnumerator : System.IDisposable, System.Collections.Generic.IEnumerable<System.Text.Json.JsonProperty>, System.Collections.IEnumerable, System.Collections.Generic.IEnumerator<System.Text.Json.JsonProperty>, System.Collections.IEnumerator
                {
                    public System.Text.Json.JsonProperty Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public System.Text.Json.JsonElement.ObjectEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Text.Json.JsonProperty> System.Collections.Generic.IEnumerable<System.Text.Json.JsonProperty>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public static System.Text.Json.JsonElement ParseValue(ref System.Text.Json.Utf8JsonReader reader) => throw null;
                public System.Text.Json.JsonElement this[int index] { get => throw null; }
                public override string ToString() => throw null;
                public bool TryGetByte(out byte value) => throw null;
                public bool TryGetBytesFromBase64(out byte[] value) => throw null;
                public bool TryGetDateTime(out System.DateTime value) => throw null;
                public bool TryGetDateTimeOffset(out System.DateTimeOffset value) => throw null;
                public bool TryGetDecimal(out decimal value) => throw null;
                public bool TryGetDouble(out double value) => throw null;
                public bool TryGetGuid(out System.Guid value) => throw null;
                public bool TryGetInt16(out short value) => throw null;
                public bool TryGetInt32(out int value) => throw null;
                public bool TryGetInt64(out long value) => throw null;
                public bool TryGetProperty(System.ReadOnlySpan<byte> utf8PropertyName, out System.Text.Json.JsonElement value) => throw null;
                public bool TryGetProperty(System.ReadOnlySpan<char> propertyName, out System.Text.Json.JsonElement value) => throw null;
                public bool TryGetProperty(string propertyName, out System.Text.Json.JsonElement value) => throw null;
                public bool TryGetSByte(out sbyte value) => throw null;
                public bool TryGetSingle(out float value) => throw null;
                public bool TryGetUInt16(out ushort value) => throw null;
                public bool TryGetUInt32(out uint value) => throw null;
                public bool TryGetUInt64(out ulong value) => throw null;
                public static bool TryParseValue(ref System.Text.Json.Utf8JsonReader reader, out System.Text.Json.JsonElement? element) => throw null;
                public bool ValueEquals(System.ReadOnlySpan<byte> utf8Text) => throw null;
                public bool ValueEquals(System.ReadOnlySpan<char> text) => throw null;
                public bool ValueEquals(string text) => throw null;
                public System.Text.Json.JsonValueKind ValueKind { get => throw null; }
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }
            public struct JsonEncodedText : System.IEquatable<System.Text.Json.JsonEncodedText>
            {
                public static System.Text.Json.JsonEncodedText Encode(System.ReadOnlySpan<byte> utf8Value, System.Text.Encodings.Web.JavaScriptEncoder encoder = default(System.Text.Encodings.Web.JavaScriptEncoder)) => throw null;
                public static System.Text.Json.JsonEncodedText Encode(System.ReadOnlySpan<char> value, System.Text.Encodings.Web.JavaScriptEncoder encoder = default(System.Text.Encodings.Web.JavaScriptEncoder)) => throw null;
                public static System.Text.Json.JsonEncodedText Encode(string value, System.Text.Encodings.Web.JavaScriptEncoder encoder = default(System.Text.Encodings.Web.JavaScriptEncoder)) => throw null;
                public System.ReadOnlySpan<byte> EncodedUtf8Bytes { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Text.Json.JsonEncodedText other) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public string Value { get => throw null; }
            }
            public class JsonException : System.Exception
            {
                public long? BytePositionInLine { get => throw null; }
                public JsonException() => throw null;
                protected JsonException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public JsonException(string message) => throw null;
                public JsonException(string message, System.Exception innerException) => throw null;
                public JsonException(string message, string path, long? lineNumber, long? bytePositionInLine) => throw null;
                public JsonException(string message, string path, long? lineNumber, long? bytePositionInLine, System.Exception innerException) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public long? LineNumber { get => throw null; }
                public override string Message { get => throw null; }
                public string Path { get => throw null; }
            }
            public abstract class JsonNamingPolicy
            {
                public static System.Text.Json.JsonNamingPolicy CamelCase { get => throw null; }
                public abstract string ConvertName(string name);
                protected JsonNamingPolicy() => throw null;
                public static System.Text.Json.JsonNamingPolicy KebabCaseLower { get => throw null; }
                public static System.Text.Json.JsonNamingPolicy KebabCaseUpper { get => throw null; }
                public static System.Text.Json.JsonNamingPolicy SnakeCaseLower { get => throw null; }
                public static System.Text.Json.JsonNamingPolicy SnakeCaseUpper { get => throw null; }
            }
            public struct JsonProperty
            {
                public string Name { get => throw null; }
                public bool NameEquals(System.ReadOnlySpan<byte> utf8Text) => throw null;
                public bool NameEquals(System.ReadOnlySpan<char> text) => throw null;
                public bool NameEquals(string text) => throw null;
                public override string ToString() => throw null;
                public System.Text.Json.JsonElement Value { get => throw null; }
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }
            public struct JsonReaderOptions
            {
                public bool AllowTrailingCommas { get => throw null; set { } }
                public System.Text.Json.JsonCommentHandling CommentHandling { get => throw null; set { } }
                public int MaxDepth { get => throw null; set { } }
            }
            public struct JsonReaderState
            {
                public JsonReaderState(System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public System.Text.Json.JsonReaderOptions Options { get => throw null; }
            }
            public static class JsonSerializer
            {
                public static object Deserialize(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(System.ReadOnlySpan<byte> utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(System.ReadOnlySpan<byte> utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(System.ReadOnlySpan<byte> utf8Json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(System.ReadOnlySpan<char> json, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(System.ReadOnlySpan<char> json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(System.ReadOnlySpan<char> json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(string json, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(string json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(string json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(this System.Text.Json.JsonDocument document, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(this System.Text.Json.JsonDocument document, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(this System.Text.Json.JsonDocument document, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(this System.Text.Json.JsonElement element, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(this System.Text.Json.JsonElement element, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(this System.Text.Json.JsonElement element, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(this System.Text.Json.Nodes.JsonNode node, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(this System.Text.Json.Nodes.JsonNode node, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(this System.Text.Json.Nodes.JsonNode node, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static object Deserialize(ref System.Text.Json.Utf8JsonReader reader, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(ref System.Text.Json.Utf8JsonReader reader, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static TValue Deserialize<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<byte> utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<byte> utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<char> json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<char> json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(string json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(string json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonDocument document, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonDocument document, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonElement element, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonElement element, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.Nodes.JsonNode node, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.Nodes.JsonNode node, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> DeserializeAsync<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> DeserializeAsync<TValue>(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Collections.Generic.IAsyncEnumerable<TValue> DeserializeAsyncEnumerable<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Collections.Generic.IAsyncEnumerable<TValue> DeserializeAsyncEnumerable<TValue>(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static bool IsReflectionEnabledByDefault { get => throw null; }
                public static void Serialize(System.IO.Stream utf8Json, object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static void Serialize(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static string Serialize(object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static string Serialize(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static string Serialize(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static void Serialize(System.Text.Json.Utf8JsonWriter writer, object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static void Serialize(System.Text.Json.Utf8JsonWriter writer, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize(System.Text.Json.Utf8JsonWriter writer, object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static void Serialize<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static void Serialize<TValue>(System.Text.Json.Utf8JsonWriter writer, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize<TValue>(System.Text.Json.Utf8JsonWriter writer, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static string Serialize<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static string Serialize<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync(System.IO.Stream utf8Json, object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument(object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement(object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode(object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static byte[] SerializeToUtf8Bytes(object value, System.Text.Json.Serialization.Metadata.JsonTypeInfo jsonTypeInfo) => throw null;
                public static byte[] SerializeToUtf8Bytes(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static byte[] SerializeToUtf8Bytes(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static byte[] SerializeToUtf8Bytes<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static byte[] SerializeToUtf8Bytes<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
            }
            public enum JsonSerializerDefaults
            {
                General = 0,
                Web = 1,
            }
            public sealed class JsonSerializerOptions
            {
                public void AddContext<TContext>() where TContext : System.Text.Json.Serialization.JsonSerializerContext, new() => throw null;
                public bool AllowTrailingCommas { get => throw null; set { } }
                public System.Collections.Generic.IList<System.Text.Json.Serialization.JsonConverter> Converters { get => throw null; }
                public JsonSerializerOptions() => throw null;
                public JsonSerializerOptions(System.Text.Json.JsonSerializerDefaults defaults) => throw null;
                public JsonSerializerOptions(System.Text.Json.JsonSerializerOptions options) => throw null;
                public static System.Text.Json.JsonSerializerOptions Default { get => throw null; }
                public int DefaultBufferSize { get => throw null; set { } }
                public System.Text.Json.Serialization.JsonIgnoreCondition DefaultIgnoreCondition { get => throw null; set { } }
                public System.Text.Json.JsonNamingPolicy DictionaryKeyPolicy { get => throw null; set { } }
                public System.Text.Encodings.Web.JavaScriptEncoder Encoder { get => throw null; set { } }
                public System.Text.Json.Serialization.JsonConverter GetConverter(System.Type typeToConvert) => throw null;
                public System.Text.Json.Serialization.Metadata.JsonTypeInfo GetTypeInfo(System.Type type) => throw null;
                public bool IgnoreNullValues { get => throw null; set { } }
                public bool IgnoreReadOnlyFields { get => throw null; set { } }
                public bool IgnoreReadOnlyProperties { get => throw null; set { } }
                public bool IncludeFields { get => throw null; set { } }
                public bool IsReadOnly { get => throw null; }
                public void MakeReadOnly() => throw null;
                public void MakeReadOnly(bool populateMissingResolver) => throw null;
                public int MaxDepth { get => throw null; set { } }
                public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set { } }
                public System.Text.Json.Serialization.JsonObjectCreationHandling PreferredObjectCreationHandling { get => throw null; set { } }
                public bool PropertyNameCaseInsensitive { get => throw null; set { } }
                public System.Text.Json.JsonNamingPolicy PropertyNamingPolicy { get => throw null; set { } }
                public System.Text.Json.JsonCommentHandling ReadCommentHandling { get => throw null; set { } }
                public System.Text.Json.Serialization.ReferenceHandler ReferenceHandler { get => throw null; set { } }
                public bool TryGetTypeInfo(System.Type type, out System.Text.Json.Serialization.Metadata.JsonTypeInfo typeInfo) => throw null;
                public System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver TypeInfoResolver { get => throw null; set { } }
                public System.Collections.Generic.IList<System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver> TypeInfoResolverChain { get => throw null; }
                public System.Text.Json.Serialization.JsonUnknownTypeHandling UnknownTypeHandling { get => throw null; set { } }
                public System.Text.Json.Serialization.JsonUnmappedMemberHandling UnmappedMemberHandling { get => throw null; set { } }
                public bool WriteIndented { get => throw null; set { } }
            }
            public enum JsonTokenType : byte
            {
                None = 0,
                StartObject = 1,
                EndObject = 2,
                StartArray = 3,
                EndArray = 4,
                PropertyName = 5,
                Comment = 6,
                String = 7,
                Number = 8,
                True = 9,
                False = 10,
                Null = 11,
            }
            public enum JsonValueKind : byte
            {
                Undefined = 0,
                Object = 1,
                Array = 2,
                String = 3,
                Number = 4,
                True = 5,
                False = 6,
                Null = 7,
            }
            public struct JsonWriterOptions
            {
                public System.Text.Encodings.Web.JavaScriptEncoder Encoder { get => throw null; set { } }
                public bool Indented { get => throw null; set { } }
                public int MaxDepth { get => throw null; set { } }
                public bool SkipValidation { get => throw null; set { } }
            }
            namespace Nodes
            {
                public sealed class JsonArray : System.Text.Json.Nodes.JsonNode, System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode>, System.Collections.Generic.IEnumerable<System.Text.Json.Nodes.JsonNode>, System.Collections.IEnumerable, System.Collections.Generic.IList<System.Text.Json.Nodes.JsonNode>
                {
                    public void Add(System.Text.Json.Nodes.JsonNode item) => throw null;
                    public void Add<T>(T value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(System.Text.Json.Nodes.JsonNode item) => throw null;
                    void System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode>.CopyTo(System.Text.Json.Nodes.JsonNode[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public static System.Text.Json.Nodes.JsonArray Create(System.Text.Json.JsonElement element, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public JsonArray(System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public JsonArray(System.Text.Json.Nodes.JsonNodeOptions options, params System.Text.Json.Nodes.JsonNode[] items) => throw null;
                    public JsonArray(params System.Text.Json.Nodes.JsonNode[] items) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Text.Json.Nodes.JsonNode> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerable<T> GetValues<T>() => throw null;
                    public int IndexOf(System.Text.Json.Nodes.JsonNode item) => throw null;
                    public void Insert(int index, System.Text.Json.Nodes.JsonNode item) => throw null;
                    bool System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode>.IsReadOnly { get => throw null; }
                    public bool Remove(System.Text.Json.Nodes.JsonNode item) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public override void WriteTo(System.Text.Json.Utf8JsonWriter writer, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                }
                public abstract class JsonNode
                {
                    public System.Text.Json.Nodes.JsonArray AsArray() => throw null;
                    public System.Text.Json.Nodes.JsonObject AsObject() => throw null;
                    public System.Text.Json.Nodes.JsonValue AsValue() => throw null;
                    public System.Text.Json.Nodes.JsonNode DeepClone() => throw null;
                    public static bool DeepEquals(System.Text.Json.Nodes.JsonNode node1, System.Text.Json.Nodes.JsonNode node2) => throw null;
                    public int GetElementIndex() => throw null;
                    public string GetPath() => throw null;
                    public string GetPropertyName() => throw null;
                    public virtual T GetValue<T>() => throw null;
                    public System.Text.Json.JsonValueKind GetValueKind() => throw null;
                    public static explicit operator bool(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator byte(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator char(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTime(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTimeOffset(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator decimal(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator double(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Guid(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator short(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator int(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator long(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator bool?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator byte?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator char?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTimeOffset?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTime?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator decimal?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator double?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Guid?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator short?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator int?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator long?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator sbyte?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator float?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator ushort?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator uint?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator ulong?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator sbyte(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator float(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator string(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator ushort(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator uint(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator ulong(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(bool value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(byte value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(char value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTime value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTimeOffset value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(decimal value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(double value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Guid value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(short value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(int value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(long value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(bool? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(byte? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(char? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTimeOffset? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTime? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(decimal? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(double? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Guid? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(short? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(int? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(long? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(sbyte? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(float? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(ushort? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(uint? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(ulong? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(sbyte value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(float value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(string value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(ushort value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(uint value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(ulong value) => throw null;
                    public System.Text.Json.Nodes.JsonNodeOptions? Options { get => throw null; }
                    public System.Text.Json.Nodes.JsonNode Parent { get => throw null; }
                    public static System.Text.Json.Nodes.JsonNode Parse(System.IO.Stream utf8Json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                    public static System.Text.Json.Nodes.JsonNode Parse(System.ReadOnlySpan<byte> utf8Json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                    public static System.Text.Json.Nodes.JsonNode Parse(string json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                    public static System.Text.Json.Nodes.JsonNode Parse(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Threading.Tasks.Task<System.Text.Json.Nodes.JsonNode> ParseAsync(System.IO.Stream utf8Json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public void ReplaceWith<T>(T value) => throw null;
                    public System.Text.Json.Nodes.JsonNode Root { get => throw null; }
                    public System.Text.Json.Nodes.JsonNode this[int index] { get => throw null; set { } }
                    public System.Text.Json.Nodes.JsonNode this[string propertyName] { get => throw null; set { } }
                    public string ToJsonString(System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                    public override string ToString() => throw null;
                    public abstract void WriteTo(System.Text.Json.Utf8JsonWriter writer, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions));
                }
                public struct JsonNodeOptions
                {
                    public bool PropertyNameCaseInsensitive { get => throw null; set { } }
                }
                public sealed class JsonObject : System.Text.Json.Nodes.JsonNode, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>, System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>, System.Collections.IEnumerable
                {
                    public void Add(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode> property) => throw null;
                    public void Add(string propertyName, System.Text.Json.Nodes.JsonNode value) => throw null;
                    public void Clear() => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.Contains(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode> item) => throw null;
                    public bool ContainsKey(string propertyName) => throw null;
                    void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.CopyTo(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public static System.Text.Json.Nodes.JsonObject Create(System.Text.Json.JsonElement element, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public JsonObject(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>> properties, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public JsonObject(System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.IsReadOnly { get => throw null; }
                    System.Collections.Generic.ICollection<string> System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>.Keys { get => throw null; }
                    public bool Remove(string propertyName) => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.Remove(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode> item) => throw null;
                    public bool TryGetPropertyValue(string propertyName, out System.Text.Json.Nodes.JsonNode jsonNode) => throw null;
                    bool System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>.TryGetValue(string propertyName, out System.Text.Json.Nodes.JsonNode jsonNode) => throw null;
                    System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode> System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>.Values { get => throw null; }
                    public override void WriteTo(System.Text.Json.Utf8JsonWriter writer, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                }
                public abstract class JsonValue : System.Text.Json.Nodes.JsonNode
                {
                    public static System.Text.Json.Nodes.JsonValue Create(bool value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(byte value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(char value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTime value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTimeOffset value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(decimal value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(double value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Guid value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(short value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(int value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(long value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(bool? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(byte? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(char? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTimeOffset? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTime? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(decimal? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(double? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Guid? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(short? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(int? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(long? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(sbyte? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(float? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Text.Json.JsonElement? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(ushort? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(uint? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(ulong? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(sbyte value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(float value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(string value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Text.Json.JsonElement value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(ushort value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(uint value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(ulong value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create<T>(T value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create<T>(T value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> jsonTypeInfo, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public abstract bool TryGetValue<T>(out T value);
                }
            }
            namespace Serialization
            {
                public interface IJsonOnDeserialized
                {
                    void OnDeserialized();
                }
                public interface IJsonOnDeserializing
                {
                    void OnDeserializing();
                }
                public interface IJsonOnSerialized
                {
                    void OnSerialized();
                }
                public interface IJsonOnSerializing
                {
                    void OnSerializing();
                }
                public abstract class JsonAttribute : System.Attribute
                {
                    protected JsonAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)32, AllowMultiple = false)]
                public sealed class JsonConstructorAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonConstructorAttribute() => throw null;
                }
                public abstract class JsonConverter
                {
                    public abstract bool CanConvert(System.Type typeToConvert);
                    public abstract System.Type Type { get; }
                }
                public abstract class JsonConverter<T> : System.Text.Json.Serialization.JsonConverter
                {
                    public override bool CanConvert(System.Type typeToConvert) => throw null;
                    protected JsonConverter() => throw null;
                    public virtual bool HandleNull { get => throw null; }
                    public abstract T Read(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options);
                    public virtual T ReadAsPropertyName(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public override sealed System.Type Type { get => throw null; }
                    public abstract void Write(System.Text.Json.Utf8JsonWriter writer, T value, System.Text.Json.JsonSerializerOptions options);
                    public virtual void WriteAsPropertyName(System.Text.Json.Utf8JsonWriter writer, T value, System.Text.Json.JsonSerializerOptions options) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)1436, AllowMultiple = false)]
                public class JsonConverterAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Type ConverterType { get => throw null; }
                    public virtual System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert) => throw null;
                    protected JsonConverterAttribute() => throw null;
                    public JsonConverterAttribute(System.Type converterType) => throw null;
                }
                public abstract class JsonConverterFactory : System.Text.Json.Serialization.JsonConverter
                {
                    public abstract System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options);
                    protected JsonConverterFactory() => throw null;
                    public override sealed System.Type Type { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)1028, AllowMultiple = true, Inherited = false)]
                public class JsonDerivedTypeAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonDerivedTypeAttribute(System.Type derivedType) => throw null;
                    public JsonDerivedTypeAttribute(System.Type derivedType, int typeDiscriminator) => throw null;
                    public JsonDerivedTypeAttribute(System.Type derivedType, string typeDiscriminator) => throw null;
                    public System.Type DerivedType { get => throw null; }
                    public object TypeDiscriminator { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public sealed class JsonExtensionDataAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonExtensionDataAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public sealed class JsonIgnoreAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonIgnoreCondition Condition { get => throw null; set { } }
                    public JsonIgnoreAttribute() => throw null;
                }
                public enum JsonIgnoreCondition
                {
                    Never = 0,
                    Always = 1,
                    WhenWritingDefault = 2,
                    WhenWritingNull = 3,
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public sealed class JsonIncludeAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonIncludeAttribute() => throw null;
                }
                public enum JsonKnownNamingPolicy
                {
                    Unspecified = 0,
                    CamelCase = 1,
                    SnakeCaseLower = 2,
                    SnakeCaseUpper = 3,
                    KebabCaseLower = 4,
                    KebabCaseUpper = 5,
                }
                public sealed class JsonNumberEnumConverter<TEnum> : System.Text.Json.Serialization.JsonConverterFactory where TEnum : struct
                {
                    public override bool CanConvert(System.Type typeToConvert) => throw null;
                    public override System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public JsonNumberEnumConverter() => throw null;
                }
                [System.Flags]
                public enum JsonNumberHandling
                {
                    Strict = 0,
                    AllowReadingFromString = 1,
                    WriteAsString = 2,
                    AllowNamedFloatingPointLiterals = 4,
                }
                [System.AttributeUsage((System.AttributeTargets)396, AllowMultiple = false)]
                public sealed class JsonNumberHandlingAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonNumberHandlingAttribute(System.Text.Json.Serialization.JsonNumberHandling handling) => throw null;
                    public System.Text.Json.Serialization.JsonNumberHandling Handling { get => throw null; }
                }
                public enum JsonObjectCreationHandling
                {
                    Replace = 0,
                    Populate = 1,
                }
                [System.AttributeUsage((System.AttributeTargets)1420, AllowMultiple = false)]
                public sealed class JsonObjectCreationHandlingAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonObjectCreationHandlingAttribute(System.Text.Json.Serialization.JsonObjectCreationHandling handling) => throw null;
                    public System.Text.Json.Serialization.JsonObjectCreationHandling Handling { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)1028, AllowMultiple = false, Inherited = false)]
                public sealed class JsonPolymorphicAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonPolymorphicAttribute() => throw null;
                    public bool IgnoreUnrecognizedTypeDiscriminators { get => throw null; set { } }
                    public string TypeDiscriminatorPropertyName { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonUnknownDerivedTypeHandling UnknownDerivedTypeHandling { get => throw null; set { } }
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public sealed class JsonPropertyNameAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonPropertyNameAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public sealed class JsonPropertyOrderAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonPropertyOrderAttribute(int order) => throw null;
                    public int Order { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public sealed class JsonRequiredAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonRequiredAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
                public sealed class JsonSerializableAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonSerializableAttribute(System.Type type) => throw null;
                    public System.Text.Json.Serialization.JsonSourceGenerationMode GenerationMode { get => throw null; set { } }
                    public string TypeInfoPropertyName { get => throw null; set { } }
                }
                public abstract class JsonSerializerContext : System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver
                {
                    protected JsonSerializerContext(System.Text.Json.JsonSerializerOptions options) => throw null;
                    protected abstract System.Text.Json.JsonSerializerOptions GeneratedSerializerOptions { get; }
                    public abstract System.Text.Json.Serialization.Metadata.JsonTypeInfo GetTypeInfo(System.Type type);
                    System.Text.Json.Serialization.Metadata.JsonTypeInfo System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver.GetTypeInfo(System.Type type, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public System.Text.Json.JsonSerializerOptions Options { get => throw null; }
                }
                [System.Flags]
                public enum JsonSourceGenerationMode
                {
                    Default = 0,
                    Metadata = 1,
                    Serialization = 2,
                }
                [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
                public sealed class JsonSourceGenerationOptionsAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public bool AllowTrailingCommas { get => throw null; set { } }
                    public System.Type[] Converters { get => throw null; set { } }
                    public JsonSourceGenerationOptionsAttribute() => throw null;
                    public JsonSourceGenerationOptionsAttribute(System.Text.Json.JsonSerializerDefaults defaults) => throw null;
                    public int DefaultBufferSize { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonIgnoreCondition DefaultIgnoreCondition { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonKnownNamingPolicy DictionaryKeyPolicy { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonSourceGenerationMode GenerationMode { get => throw null; set { } }
                    public bool IgnoreReadOnlyFields { get => throw null; set { } }
                    public bool IgnoreReadOnlyProperties { get => throw null; set { } }
                    public bool IncludeFields { get => throw null; set { } }
                    public int MaxDepth { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonObjectCreationHandling PreferredObjectCreationHandling { get => throw null; set { } }
                    public bool PropertyNameCaseInsensitive { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonKnownNamingPolicy PropertyNamingPolicy { get => throw null; set { } }
                    public System.Text.Json.JsonCommentHandling ReadCommentHandling { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonUnknownTypeHandling UnknownTypeHandling { get => throw null; set { } }
                    public System.Text.Json.Serialization.JsonUnmappedMemberHandling UnmappedMemberHandling { get => throw null; set { } }
                    public bool UseStringEnumConverter { get => throw null; set { } }
                    public bool WriteIndented { get => throw null; set { } }
                }
                public class JsonStringEnumConverter : System.Text.Json.Serialization.JsonConverterFactory
                {
                    public override sealed bool CanConvert(System.Type typeToConvert) => throw null;
                    public override sealed System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public JsonStringEnumConverter() => throw null;
                    public JsonStringEnumConverter(System.Text.Json.JsonNamingPolicy namingPolicy = default(System.Text.Json.JsonNamingPolicy), bool allowIntegerValues = default(bool)) => throw null;
                }
                public class JsonStringEnumConverter<TEnum> : System.Text.Json.Serialization.JsonConverterFactory where TEnum : System.Enum
                {
                    public override sealed bool CanConvert(System.Type typeToConvert) => throw null;
                    public override sealed System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public JsonStringEnumConverter() => throw null;
                    public JsonStringEnumConverter(System.Text.Json.JsonNamingPolicy namingPolicy = default(System.Text.Json.JsonNamingPolicy), bool allowIntegerValues = default(bool)) => throw null;
                }
                public enum JsonUnknownDerivedTypeHandling
                {
                    FailSerialization = 0,
                    FallBackToBaseType = 1,
                    FallBackToNearestAncestor = 2,
                }
                public enum JsonUnknownTypeHandling
                {
                    JsonElement = 0,
                    JsonNode = 1,
                }
                public enum JsonUnmappedMemberHandling
                {
                    Skip = 0,
                    Disallow = 1,
                }
                [System.AttributeUsage((System.AttributeTargets)1036, AllowMultiple = false, Inherited = false)]
                public class JsonUnmappedMemberHandlingAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonUnmappedMemberHandlingAttribute(System.Text.Json.Serialization.JsonUnmappedMemberHandling unmappedMemberHandling) => throw null;
                    public System.Text.Json.Serialization.JsonUnmappedMemberHandling UnmappedMemberHandling { get => throw null; }
                }
                namespace Metadata
                {
                    public class DefaultJsonTypeInfoResolver : System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver
                    {
                        public DefaultJsonTypeInfoResolver() => throw null;
                        public virtual System.Text.Json.Serialization.Metadata.JsonTypeInfo GetTypeInfo(System.Type type, System.Text.Json.JsonSerializerOptions options) => throw null;
                        public System.Collections.Generic.IList<System.Action<System.Text.Json.Serialization.Metadata.JsonTypeInfo>> Modifiers { get => throw null; }
                    }
                    public interface IJsonTypeInfoResolver
                    {
                        System.Text.Json.Serialization.Metadata.JsonTypeInfo GetTypeInfo(System.Type type, System.Text.Json.JsonSerializerOptions options);
                    }
                    public sealed class JsonCollectionInfoValues<TCollection>
                    {
                        public JsonCollectionInfoValues() => throw null;
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfo ElementInfo { get => throw null; set { } }
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfo KeyInfo { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set { } }
                        public System.Func<TCollection> ObjectCreator { get => throw null; set { } }
                        public System.Action<System.Text.Json.Utf8JsonWriter, TCollection> SerializeHandler { get => throw null; set { } }
                    }
                    public struct JsonDerivedType
                    {
                        public JsonDerivedType(System.Type derivedType) => throw null;
                        public JsonDerivedType(System.Type derivedType, int typeDiscriminator) => throw null;
                        public JsonDerivedType(System.Type derivedType, string typeDiscriminator) => throw null;
                        public System.Type DerivedType { get => throw null; }
                        public object TypeDiscriminator { get => throw null; }
                    }
                    public static class JsonMetadataServices
                    {
                        public static System.Text.Json.Serialization.JsonConverter<bool> BooleanConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<byte[]> ByteArrayConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<byte> ByteConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<char> CharConverter { get => throw null; }
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TElement[]> CreateArrayInfo<TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TElement[]> collectionInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateConcurrentQueueInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Concurrent.ConcurrentQueue<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateConcurrentStackInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Concurrent.ConcurrentStack<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.Dictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIAsyncEnumerableInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IAsyncEnumerable<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateICollectionInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.ICollection<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIDictionaryInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.IDictionary => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IDictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIEnumerableInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.IEnumerable => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIEnumerableInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IEnumerable<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIListInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.IList => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIListInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IList<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateImmutableDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Func<System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, TCollection> createRangeFunc) where TCollection : System.Collections.Generic.IReadOnlyDictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateImmutableEnumerableInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Func<System.Collections.Generic.IEnumerable<TElement>, TCollection> createRangeFunc) where TCollection : System.Collections.Generic.IEnumerable<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIReadOnlyDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IReadOnlyDictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateISetInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.ISet<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateListInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.List<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<System.Memory<TElement>> CreateMemoryInfo<TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<System.Memory<TElement>> collectionInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> CreateObjectInfo<T>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonObjectInfoValues<T> objectInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonPropertyInfo CreatePropertyInfo<T>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonPropertyInfoValues<T> propertyInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateQueueInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Action<TCollection, object> addFunc) where TCollection : System.Collections.IEnumerable => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateQueueInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.Queue<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<System.ReadOnlyMemory<TElement>> CreateReadOnlyMemoryInfo<TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<System.ReadOnlyMemory<TElement>> collectionInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateStackInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Action<TCollection, object> addFunc) where TCollection : System.Collections.IEnumerable => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateStackInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.Stack<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> CreateValueInfo<T>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.JsonConverter converter) => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<System.DateOnly> DateOnlyConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.DateTime> DateTimeConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.DateTimeOffset> DateTimeOffsetConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<decimal> DecimalConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<double> DoubleConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<T> GetEnumConverter<T>(System.Text.Json.JsonSerializerOptions options) where T : System.Enum => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<T?> GetNullableConverter<T>(System.Text.Json.JsonSerializerOptions options) where T : struct => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<T?> GetNullableConverter<T>(System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> underlyingTypeInfo) where T : struct => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<T> GetUnsupportedTypeConverter<T>() => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<System.Guid> GuidConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Half> HalfConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Int128> Int128Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<short> Int16Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<int> Int32Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<long> Int64Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonArray> JsonArrayConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.JsonDocument> JsonDocumentConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.JsonElement> JsonElementConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonNode> JsonNodeConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonObject> JsonObjectConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonValue> JsonValueConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Memory<byte>> MemoryByteConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<object> ObjectConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.ReadOnlyMemory<byte>> ReadOnlyMemoryByteConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<sbyte> SByteConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<float> SingleConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<string> StringConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.TimeOnly> TimeOnlyConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.TimeSpan> TimeSpanConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.UInt128> UInt128Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<ushort> UInt16Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<uint> UInt32Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<ulong> UInt64Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Uri> UriConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Version> VersionConverter { get => throw null; }
                    }
                    public sealed class JsonObjectInfoValues<T>
                    {
                        public System.Func<System.Text.Json.Serialization.Metadata.JsonParameterInfoValues[]> ConstructorParameterMetadataInitializer { get => throw null; set { } }
                        public JsonObjectInfoValues() => throw null;
                        public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set { } }
                        public System.Func<T> ObjectCreator { get => throw null; set { } }
                        public System.Func<object[], T> ObjectWithParameterizedConstructorCreator { get => throw null; set { } }
                        public System.Func<System.Text.Json.Serialization.JsonSerializerContext, System.Text.Json.Serialization.Metadata.JsonPropertyInfo[]> PropertyMetadataInitializer { get => throw null; set { } }
                        public System.Action<System.Text.Json.Utf8JsonWriter, T> SerializeHandler { get => throw null; set { } }
                    }
                    public sealed class JsonParameterInfoValues
                    {
                        public JsonParameterInfoValues() => throw null;
                        public object DefaultValue { get => throw null; set { } }
                        public bool HasDefaultValue { get => throw null; set { } }
                        public string Name { get => throw null; set { } }
                        public System.Type ParameterType { get => throw null; set { } }
                        public int Position { get => throw null; set { } }
                    }
                    public class JsonPolymorphismOptions
                    {
                        public JsonPolymorphismOptions() => throw null;
                        public System.Collections.Generic.IList<System.Text.Json.Serialization.Metadata.JsonDerivedType> DerivedTypes { get => throw null; }
                        public bool IgnoreUnrecognizedTypeDiscriminators { get => throw null; set { } }
                        public string TypeDiscriminatorPropertyName { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonUnknownDerivedTypeHandling UnknownDerivedTypeHandling { get => throw null; set { } }
                    }
                    public abstract class JsonPropertyInfo
                    {
                        public System.Reflection.ICustomAttributeProvider AttributeProvider { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonConverter CustomConverter { get => throw null; set { } }
                        public System.Func<object, object> Get { get => throw null; set { } }
                        public bool IsExtensionData { get => throw null; set { } }
                        public bool IsRequired { get => throw null; set { } }
                        public string Name { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonNumberHandling? NumberHandling { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonObjectCreationHandling? ObjectCreationHandling { get => throw null; set { } }
                        public System.Text.Json.JsonSerializerOptions Options { get => throw null; }
                        public int Order { get => throw null; set { } }
                        public System.Type PropertyType { get => throw null; }
                        public System.Action<object, object> Set { get => throw null; set { } }
                        public System.Func<object, object, bool> ShouldSerialize { get => throw null; set { } }
                    }
                    public sealed class JsonPropertyInfoValues<T>
                    {
                        public System.Text.Json.Serialization.JsonConverter<T> Converter { get => throw null; set { } }
                        public JsonPropertyInfoValues() => throw null;
                        public System.Type DeclaringType { get => throw null; set { } }
                        public System.Func<object, T> Getter { get => throw null; set { } }
                        public bool HasJsonInclude { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonIgnoreCondition? IgnoreCondition { get => throw null; set { } }
                        public bool IsExtensionData { get => throw null; set { } }
                        public bool IsProperty { get => throw null; set { } }
                        public bool IsPublic { get => throw null; set { } }
                        public bool IsVirtual { get => throw null; set { } }
                        public string JsonPropertyName { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonNumberHandling? NumberHandling { get => throw null; set { } }
                        public string PropertyName { get => throw null; set { } }
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfo PropertyTypeInfo { get => throw null; set { } }
                        public System.Action<object, T> Setter { get => throw null; set { } }
                    }
                    public abstract class JsonTypeInfo
                    {
                        public System.Text.Json.Serialization.JsonConverter Converter { get => throw null; }
                        public System.Text.Json.Serialization.Metadata.JsonPropertyInfo CreateJsonPropertyInfo(System.Type propertyType, string name) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo CreateJsonTypeInfo(System.Type type, System.Text.Json.JsonSerializerOptions options) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> CreateJsonTypeInfo<T>(System.Text.Json.JsonSerializerOptions options) => throw null;
                        public System.Func<object> CreateObject { get => throw null; set { } }
                        public bool IsReadOnly { get => throw null; }
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfoKind Kind { get => throw null; }
                        public void MakeReadOnly() => throw null;
                        public System.Text.Json.Serialization.JsonNumberHandling? NumberHandling { get => throw null; set { } }
                        public System.Action<object> OnDeserialized { get => throw null; set { } }
                        public System.Action<object> OnDeserializing { get => throw null; set { } }
                        public System.Action<object> OnSerialized { get => throw null; set { } }
                        public System.Action<object> OnSerializing { get => throw null; set { } }
                        public System.Text.Json.JsonSerializerOptions Options { get => throw null; }
                        public System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver OriginatingResolver { get => throw null; set { } }
                        public System.Text.Json.Serialization.Metadata.JsonPolymorphismOptions PolymorphismOptions { get => throw null; set { } }
                        public System.Text.Json.Serialization.JsonObjectCreationHandling? PreferredPropertyObjectCreationHandling { get => throw null; set { } }
                        public System.Collections.Generic.IList<System.Text.Json.Serialization.Metadata.JsonPropertyInfo> Properties { get => throw null; }
                        public System.Type Type { get => throw null; }
                        public System.Text.Json.Serialization.JsonUnmappedMemberHandling? UnmappedMemberHandling { get => throw null; set { } }
                    }
                    public sealed class JsonTypeInfo<T> : System.Text.Json.Serialization.Metadata.JsonTypeInfo
                    {
                        public System.Func<T> CreateObject { get => throw null; set { } }
                        public System.Action<System.Text.Json.Utf8JsonWriter, T> SerializeHandler { get => throw null; }
                    }
                    public enum JsonTypeInfoKind
                    {
                        None = 0,
                        Object = 1,
                        Enumerable = 2,
                        Dictionary = 3,
                    }
                    public static class JsonTypeInfoResolver
                    {
                        public static System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver Combine(params System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver[] resolvers) => throw null;
                        public static System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver WithAddedModifier(this System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver resolver, System.Action<System.Text.Json.Serialization.Metadata.JsonTypeInfo> modifier) => throw null;
                    }
                }
                public abstract class ReferenceHandler
                {
                    public abstract System.Text.Json.Serialization.ReferenceResolver CreateResolver();
                    protected ReferenceHandler() => throw null;
                    public static System.Text.Json.Serialization.ReferenceHandler IgnoreCycles { get => throw null; }
                    public static System.Text.Json.Serialization.ReferenceHandler Preserve { get => throw null; }
                }
                public sealed class ReferenceHandler<T> : System.Text.Json.Serialization.ReferenceHandler where T : System.Text.Json.Serialization.ReferenceResolver, new()
                {
                    public override System.Text.Json.Serialization.ReferenceResolver CreateResolver() => throw null;
                    public ReferenceHandler() => throw null;
                }
                public abstract class ReferenceResolver
                {
                    public abstract void AddReference(string referenceId, object value);
                    protected ReferenceResolver() => throw null;
                    public abstract string GetReference(object value, out bool alreadyExists);
                    public abstract object ResolveReference(string referenceId);
                }
            }
            public struct Utf8JsonReader
            {
                public long BytesConsumed { get => throw null; }
                public int CopyString(System.Span<byte> utf8Destination) => throw null;
                public int CopyString(System.Span<char> destination) => throw null;
                public Utf8JsonReader(System.Buffers.ReadOnlySequence<byte> jsonData, bool isFinalBlock, System.Text.Json.JsonReaderState state) => throw null;
                public Utf8JsonReader(System.Buffers.ReadOnlySequence<byte> jsonData, System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public Utf8JsonReader(System.ReadOnlySpan<byte> jsonData, bool isFinalBlock, System.Text.Json.JsonReaderState state) => throw null;
                public Utf8JsonReader(System.ReadOnlySpan<byte> jsonData, System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public int CurrentDepth { get => throw null; }
                public System.Text.Json.JsonReaderState CurrentState { get => throw null; }
                public bool GetBoolean() => throw null;
                public byte GetByte() => throw null;
                public byte[] GetBytesFromBase64() => throw null;
                public string GetComment() => throw null;
                public System.DateTime GetDateTime() => throw null;
                public System.DateTimeOffset GetDateTimeOffset() => throw null;
                public decimal GetDecimal() => throw null;
                public double GetDouble() => throw null;
                public System.Guid GetGuid() => throw null;
                public short GetInt16() => throw null;
                public int GetInt32() => throw null;
                public long GetInt64() => throw null;
                public sbyte GetSByte() => throw null;
                public float GetSingle() => throw null;
                public string GetString() => throw null;
                public ushort GetUInt16() => throw null;
                public uint GetUInt32() => throw null;
                public ulong GetUInt64() => throw null;
                public bool HasValueSequence { get => throw null; }
                public bool IsFinalBlock { get => throw null; }
                public System.SequencePosition Position { get => throw null; }
                public bool Read() => throw null;
                public void Skip() => throw null;
                public long TokenStartIndex { get => throw null; }
                public System.Text.Json.JsonTokenType TokenType { get => throw null; }
                public bool TryGetByte(out byte value) => throw null;
                public bool TryGetBytesFromBase64(out byte[] value) => throw null;
                public bool TryGetDateTime(out System.DateTime value) => throw null;
                public bool TryGetDateTimeOffset(out System.DateTimeOffset value) => throw null;
                public bool TryGetDecimal(out decimal value) => throw null;
                public bool TryGetDouble(out double value) => throw null;
                public bool TryGetGuid(out System.Guid value) => throw null;
                public bool TryGetInt16(out short value) => throw null;
                public bool TryGetInt32(out int value) => throw null;
                public bool TryGetInt64(out long value) => throw null;
                public bool TryGetSByte(out sbyte value) => throw null;
                public bool TryGetSingle(out float value) => throw null;
                public bool TryGetUInt16(out ushort value) => throw null;
                public bool TryGetUInt32(out uint value) => throw null;
                public bool TryGetUInt64(out ulong value) => throw null;
                public bool TrySkip() => throw null;
                public bool ValueIsEscaped { get => throw null; }
                public System.Buffers.ReadOnlySequence<byte> ValueSequence { get => throw null; }
                public System.ReadOnlySpan<byte> ValueSpan { get => throw null; }
                public bool ValueTextEquals(System.ReadOnlySpan<byte> utf8Text) => throw null;
                public bool ValueTextEquals(System.ReadOnlySpan<char> text) => throw null;
                public bool ValueTextEquals(string text) => throw null;
            }
            public sealed class Utf8JsonWriter : System.IAsyncDisposable, System.IDisposable
            {
                public long BytesCommitted { get => throw null; }
                public int BytesPending { get => throw null; }
                public Utf8JsonWriter(System.Buffers.IBufferWriter<byte> bufferWriter, System.Text.Json.JsonWriterOptions options = default(System.Text.Json.JsonWriterOptions)) => throw null;
                public Utf8JsonWriter(System.IO.Stream utf8Json, System.Text.Json.JsonWriterOptions options = default(System.Text.Json.JsonWriterOptions)) => throw null;
                public int CurrentDepth { get => throw null; }
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public void Flush() => throw null;
                public System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Text.Json.JsonWriterOptions Options { get => throw null; }
                public void Reset() => throw null;
                public void Reset(System.Buffers.IBufferWriter<byte> bufferWriter) => throw null;
                public void Reset(System.IO.Stream utf8Json) => throw null;
                public void WriteBase64String(System.ReadOnlySpan<byte> utf8PropertyName, System.ReadOnlySpan<byte> bytes) => throw null;
                public void WriteBase64String(System.ReadOnlySpan<char> propertyName, System.ReadOnlySpan<byte> bytes) => throw null;
                public void WriteBase64String(string propertyName, System.ReadOnlySpan<byte> bytes) => throw null;
                public void WriteBase64String(System.Text.Json.JsonEncodedText propertyName, System.ReadOnlySpan<byte> bytes) => throw null;
                public void WriteBase64StringValue(System.ReadOnlySpan<byte> bytes) => throw null;
                public void WriteBoolean(System.ReadOnlySpan<byte> utf8PropertyName, bool value) => throw null;
                public void WriteBoolean(System.ReadOnlySpan<char> propertyName, bool value) => throw null;
                public void WriteBoolean(string propertyName, bool value) => throw null;
                public void WriteBoolean(System.Text.Json.JsonEncodedText propertyName, bool value) => throw null;
                public void WriteBooleanValue(bool value) => throw null;
                public void WriteCommentValue(System.ReadOnlySpan<byte> utf8Value) => throw null;
                public void WriteCommentValue(System.ReadOnlySpan<char> value) => throw null;
                public void WriteCommentValue(string value) => throw null;
                public void WriteEndArray() => throw null;
                public void WriteEndObject() => throw null;
                public void WriteNull(System.ReadOnlySpan<byte> utf8PropertyName) => throw null;
                public void WriteNull(System.ReadOnlySpan<char> propertyName) => throw null;
                public void WriteNull(string propertyName) => throw null;
                public void WriteNull(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteNullValue() => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, decimal value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, double value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, int value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, long value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, float value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, uint value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<byte> utf8PropertyName, ulong value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, decimal value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, double value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, int value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, long value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, float value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, uint value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<char> propertyName, ulong value) => throw null;
                public void WriteNumber(string propertyName, decimal value) => throw null;
                public void WriteNumber(string propertyName, double value) => throw null;
                public void WriteNumber(string propertyName, int value) => throw null;
                public void WriteNumber(string propertyName, long value) => throw null;
                public void WriteNumber(string propertyName, float value) => throw null;
                public void WriteNumber(string propertyName, uint value) => throw null;
                public void WriteNumber(string propertyName, ulong value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, decimal value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, double value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, int value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, long value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, float value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, uint value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, ulong value) => throw null;
                public void WriteNumberValue(decimal value) => throw null;
                public void WriteNumberValue(double value) => throw null;
                public void WriteNumberValue(int value) => throw null;
                public void WriteNumberValue(long value) => throw null;
                public void WriteNumberValue(float value) => throw null;
                public void WriteNumberValue(uint value) => throw null;
                public void WriteNumberValue(ulong value) => throw null;
                public void WritePropertyName(System.ReadOnlySpan<byte> utf8PropertyName) => throw null;
                public void WritePropertyName(System.ReadOnlySpan<char> propertyName) => throw null;
                public void WritePropertyName(string propertyName) => throw null;
                public void WritePropertyName(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteRawValue(System.Buffers.ReadOnlySequence<byte> utf8Json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteRawValue(System.ReadOnlySpan<byte> utf8Json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteRawValue(System.ReadOnlySpan<char> json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteRawValue(string json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteStartArray() => throw null;
                public void WriteStartArray(System.ReadOnlySpan<byte> utf8PropertyName) => throw null;
                public void WriteStartArray(System.ReadOnlySpan<char> propertyName) => throw null;
                public void WriteStartArray(string propertyName) => throw null;
                public void WriteStartArray(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteStartObject() => throw null;
                public void WriteStartObject(System.ReadOnlySpan<byte> utf8PropertyName) => throw null;
                public void WriteStartObject(System.ReadOnlySpan<char> propertyName) => throw null;
                public void WriteStartObject(string propertyName) => throw null;
                public void WriteStartObject(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, System.DateTime value) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, System.Guid value) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, System.ReadOnlySpan<byte> utf8Value) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, System.ReadOnlySpan<char> value) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, string value) => throw null;
                public void WriteString(System.ReadOnlySpan<byte> utf8PropertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, System.DateTime value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, System.Guid value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, System.ReadOnlySpan<byte> utf8Value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, System.ReadOnlySpan<char> value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, string value) => throw null;
                public void WriteString(System.ReadOnlySpan<char> propertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(string propertyName, System.DateTime value) => throw null;
                public void WriteString(string propertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(string propertyName, System.Guid value) => throw null;
                public void WriteString(string propertyName, System.ReadOnlySpan<byte> utf8Value) => throw null;
                public void WriteString(string propertyName, System.ReadOnlySpan<char> value) => throw null;
                public void WriteString(string propertyName, string value) => throw null;
                public void WriteString(string propertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.DateTime value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.Guid value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.ReadOnlySpan<byte> utf8Value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.ReadOnlySpan<char> value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, string value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteStringValue(System.DateTime value) => throw null;
                public void WriteStringValue(System.DateTimeOffset value) => throw null;
                public void WriteStringValue(System.Guid value) => throw null;
                public void WriteStringValue(System.ReadOnlySpan<byte> utf8Value) => throw null;
                public void WriteStringValue(System.ReadOnlySpan<char> value) => throw null;
                public void WriteStringValue(string value) => throw null;
                public void WriteStringValue(System.Text.Json.JsonEncodedText value) => throw null;
            }
        }
    }
}
