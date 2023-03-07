// This file contains auto-generated code.
// Generated from `System.Text.Json, Version=7.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.

namespace System
{
    namespace Text
    {
        namespace Json
        {
            public enum JsonCommentHandling : byte
            {
                Allow = 2,
                Disallow = 0,
                Skip = 1,
            }

            public class JsonDocument : System.IDisposable
            {
                public void Dispose() => throw null;
                public static System.Text.Json.JsonDocument Parse(System.ReadOnlyMemory<System.Byte> utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(System.ReadOnlyMemory<System.Char> json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(System.Buffers.ReadOnlySequence<System.Byte> utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(System.IO.Stream utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Text.Json.JsonDocument Parse(string json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                public static System.Threading.Tasks.Task<System.Text.Json.JsonDocument> ParseAsync(System.IO.Stream utf8Json, System.Text.Json.JsonDocumentOptions options = default(System.Text.Json.JsonDocumentOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Text.Json.JsonDocument ParseValue(ref System.Text.Json.Utf8JsonReader reader) => throw null;
                public System.Text.Json.JsonElement RootElement { get => throw null; }
                public static bool TryParseValue(ref System.Text.Json.Utf8JsonReader reader, out System.Text.Json.JsonDocument document) => throw null;
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }

            public struct JsonDocumentOptions
            {
                public bool AllowTrailingCommas { get => throw null; set => throw null; }
                public System.Text.Json.JsonCommentHandling CommentHandling { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public int MaxDepth { get => throw null; set => throw null; }
            }

            public struct JsonElement
            {
                public struct ArrayEnumerator : System.Collections.Generic.IEnumerable<System.Text.Json.JsonElement>, System.Collections.Generic.IEnumerator<System.Text.Json.JsonElement>, System.Collections.IEnumerable, System.Collections.IEnumerator, System.IDisposable
                {
                    // Stub generator skipped constructor 
                    public System.Text.Json.JsonElement Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public System.Text.Json.JsonElement.ArrayEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Text.Json.JsonElement> System.Collections.Generic.IEnumerable<System.Text.Json.JsonElement>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }


                public struct ObjectEnumerator : System.Collections.Generic.IEnumerable<System.Text.Json.JsonProperty>, System.Collections.Generic.IEnumerator<System.Text.Json.JsonProperty>, System.Collections.IEnumerable, System.Collections.IEnumerator, System.IDisposable
                {
                    public System.Text.Json.JsonProperty Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public System.Text.Json.JsonElement.ObjectEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Text.Json.JsonProperty> System.Collections.Generic.IEnumerable<System.Text.Json.JsonProperty>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool MoveNext() => throw null;
                    // Stub generator skipped constructor 
                    public void Reset() => throw null;
                }


                public System.Text.Json.JsonElement Clone() => throw null;
                public System.Text.Json.JsonElement.ArrayEnumerator EnumerateArray() => throw null;
                public System.Text.Json.JsonElement.ObjectEnumerator EnumerateObject() => throw null;
                public int GetArrayLength() => throw null;
                public bool GetBoolean() => throw null;
                public System.Byte GetByte() => throw null;
                public System.Byte[] GetBytesFromBase64() => throw null;
                public System.DateTime GetDateTime() => throw null;
                public System.DateTimeOffset GetDateTimeOffset() => throw null;
                public System.Decimal GetDecimal() => throw null;
                public double GetDouble() => throw null;
                public System.Guid GetGuid() => throw null;
                public System.Int16 GetInt16() => throw null;
                public int GetInt32() => throw null;
                public System.Int64 GetInt64() => throw null;
                public System.Text.Json.JsonElement GetProperty(System.ReadOnlySpan<System.Byte> utf8PropertyName) => throw null;
                public System.Text.Json.JsonElement GetProperty(System.ReadOnlySpan<System.Char> propertyName) => throw null;
                public System.Text.Json.JsonElement GetProperty(string propertyName) => throw null;
                public string GetRawText() => throw null;
                public System.SByte GetSByte() => throw null;
                public float GetSingle() => throw null;
                public string GetString() => throw null;
                public System.UInt16 GetUInt16() => throw null;
                public System.UInt32 GetUInt32() => throw null;
                public System.UInt64 GetUInt64() => throw null;
                public System.Text.Json.JsonElement this[int index] { get => throw null; }
                // Stub generator skipped constructor 
                public static System.Text.Json.JsonElement ParseValue(ref System.Text.Json.Utf8JsonReader reader) => throw null;
                public override string ToString() => throw null;
                public bool TryGetByte(out System.Byte value) => throw null;
                public bool TryGetBytesFromBase64(out System.Byte[] value) => throw null;
                public bool TryGetDateTime(out System.DateTime value) => throw null;
                public bool TryGetDateTimeOffset(out System.DateTimeOffset value) => throw null;
                public bool TryGetDecimal(out System.Decimal value) => throw null;
                public bool TryGetDouble(out double value) => throw null;
                public bool TryGetGuid(out System.Guid value) => throw null;
                public bool TryGetInt16(out System.Int16 value) => throw null;
                public bool TryGetInt32(out int value) => throw null;
                public bool TryGetInt64(out System.Int64 value) => throw null;
                public bool TryGetProperty(System.ReadOnlySpan<System.Byte> utf8PropertyName, out System.Text.Json.JsonElement value) => throw null;
                public bool TryGetProperty(System.ReadOnlySpan<System.Char> propertyName, out System.Text.Json.JsonElement value) => throw null;
                public bool TryGetProperty(string propertyName, out System.Text.Json.JsonElement value) => throw null;
                public bool TryGetSByte(out System.SByte value) => throw null;
                public bool TryGetSingle(out float value) => throw null;
                public bool TryGetUInt16(out System.UInt16 value) => throw null;
                public bool TryGetUInt32(out System.UInt32 value) => throw null;
                public bool TryGetUInt64(out System.UInt64 value) => throw null;
                public static bool TryParseValue(ref System.Text.Json.Utf8JsonReader reader, out System.Text.Json.JsonElement? element) => throw null;
                public bool ValueEquals(System.ReadOnlySpan<System.Byte> utf8Text) => throw null;
                public bool ValueEquals(System.ReadOnlySpan<System.Char> text) => throw null;
                public bool ValueEquals(string text) => throw null;
                public System.Text.Json.JsonValueKind ValueKind { get => throw null; }
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }

            public struct JsonEncodedText : System.IEquatable<System.Text.Json.JsonEncodedText>
            {
                public static System.Text.Json.JsonEncodedText Encode(System.ReadOnlySpan<System.Byte> utf8Value, System.Text.Encodings.Web.JavaScriptEncoder encoder = default(System.Text.Encodings.Web.JavaScriptEncoder)) => throw null;
                public static System.Text.Json.JsonEncodedText Encode(System.ReadOnlySpan<System.Char> value, System.Text.Encodings.Web.JavaScriptEncoder encoder = default(System.Text.Encodings.Web.JavaScriptEncoder)) => throw null;
                public static System.Text.Json.JsonEncodedText Encode(string value, System.Text.Encodings.Web.JavaScriptEncoder encoder = default(System.Text.Encodings.Web.JavaScriptEncoder)) => throw null;
                public System.ReadOnlySpan<System.Byte> EncodedUtf8Bytes { get => throw null; }
                public bool Equals(System.Text.Json.JsonEncodedText other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                // Stub generator skipped constructor 
                public override string ToString() => throw null;
            }

            public class JsonException : System.Exception
            {
                public System.Int64? BytePositionInLine { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public JsonException() => throw null;
                protected JsonException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public JsonException(string message) => throw null;
                public JsonException(string message, System.Exception innerException) => throw null;
                public JsonException(string message, string path, System.Int64? lineNumber, System.Int64? bytePositionInLine) => throw null;
                public JsonException(string message, string path, System.Int64? lineNumber, System.Int64? bytePositionInLine, System.Exception innerException) => throw null;
                public System.Int64? LineNumber { get => throw null; }
                public override string Message { get => throw null; }
                public string Path { get => throw null; }
            }

            public abstract class JsonNamingPolicy
            {
                public static System.Text.Json.JsonNamingPolicy CamelCase { get => throw null; }
                public abstract string ConvertName(string name);
                protected JsonNamingPolicy() => throw null;
            }

            public struct JsonProperty
            {
                // Stub generator skipped constructor 
                public string Name { get => throw null; }
                public bool NameEquals(System.ReadOnlySpan<System.Byte> utf8Text) => throw null;
                public bool NameEquals(System.ReadOnlySpan<System.Char> text) => throw null;
                public bool NameEquals(string text) => throw null;
                public override string ToString() => throw null;
                public System.Text.Json.JsonElement Value { get => throw null; }
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }

            public struct JsonReaderOptions
            {
                public bool AllowTrailingCommas { get => throw null; set => throw null; }
                public System.Text.Json.JsonCommentHandling CommentHandling { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public int MaxDepth { get => throw null; set => throw null; }
            }

            public struct JsonReaderState
            {
                // Stub generator skipped constructor 
                public JsonReaderState(System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public System.Text.Json.JsonReaderOptions Options { get => throw null; }
            }

            public static class JsonSerializer
            {
                public static object Deserialize(this System.Text.Json.JsonDocument document, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(this System.Text.Json.JsonDocument document, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(this System.Text.Json.JsonElement element, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(this System.Text.Json.JsonElement element, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(this System.Text.Json.Nodes.JsonNode node, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(this System.Text.Json.Nodes.JsonNode node, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(System.ReadOnlySpan<System.Byte> utf8Json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(System.ReadOnlySpan<System.Byte> utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(System.ReadOnlySpan<System.Char> json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(System.ReadOnlySpan<System.Char> json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(ref System.Text.Json.Utf8JsonReader reader, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(ref System.Text.Json.Utf8JsonReader reader, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(string json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static object Deserialize(string json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonDocument document, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonDocument document, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonElement element, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.JsonElement element, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.Nodes.JsonNode node, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(this System.Text.Json.Nodes.JsonNode node, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<System.Byte> utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<System.Byte> utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<System.Char> json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<System.Char> json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static TValue Deserialize<TValue>(string json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(string json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.Serialization.JsonSerializerContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> DeserializeAsync<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> DeserializeAsync<TValue>(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Collections.Generic.IAsyncEnumerable<TValue> DeserializeAsyncEnumerable<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Collections.Generic.IAsyncEnumerable<TValue> DeserializeAsyncEnumerable<TValue>(System.IO.Stream utf8Json, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static void Serialize(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static void Serialize(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize(System.Text.Json.Utf8JsonWriter writer, object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static void Serialize(System.Text.Json.Utf8JsonWriter writer, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static string Serialize(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static string Serialize(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static string Serialize<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static string Serialize<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static void Serialize<TValue>(System.Text.Json.Utf8JsonWriter writer, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize<TValue>(System.Text.Json.Utf8JsonWriter writer, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonDocument SerializeToDocument<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.JsonElement SerializeToElement<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Text.Json.Nodes.JsonNode SerializeToNode<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
                public static System.Byte[] SerializeToUtf8Bytes(object value, System.Type inputType, System.Text.Json.Serialization.JsonSerializerContext context) => throw null;
                public static System.Byte[] SerializeToUtf8Bytes(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Byte[] SerializeToUtf8Bytes<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Byte[] SerializeToUtf8Bytes<TValue>(TValue value, System.Text.Json.Serialization.Metadata.JsonTypeInfo<TValue> jsonTypeInfo) => throw null;
            }

            public enum JsonSerializerDefaults : int
            {
                General = 0,
                Web = 1,
            }

            public class JsonSerializerOptions
            {
                public void AddContext<TContext>() where TContext : System.Text.Json.Serialization.JsonSerializerContext, new() => throw null;
                public bool AllowTrailingCommas { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<System.Text.Json.Serialization.JsonConverter> Converters { get => throw null; }
                public static System.Text.Json.JsonSerializerOptions Default { get => throw null; }
                public int DefaultBufferSize { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.JsonIgnoreCondition DefaultIgnoreCondition { get => throw null; set => throw null; }
                public System.Text.Json.JsonNamingPolicy DictionaryKeyPolicy { get => throw null; set => throw null; }
                public System.Text.Encodings.Web.JavaScriptEncoder Encoder { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.JsonConverter GetConverter(System.Type typeToConvert) => throw null;
                public System.Text.Json.Serialization.Metadata.JsonTypeInfo GetTypeInfo(System.Type type) => throw null;
                public bool IgnoreNullValues { get => throw null; set => throw null; }
                public bool IgnoreReadOnlyFields { get => throw null; set => throw null; }
                public bool IgnoreReadOnlyProperties { get => throw null; set => throw null; }
                public bool IncludeFields { get => throw null; set => throw null; }
                public JsonSerializerOptions() => throw null;
                public JsonSerializerOptions(System.Text.Json.JsonSerializerDefaults defaults) => throw null;
                public JsonSerializerOptions(System.Text.Json.JsonSerializerOptions options) => throw null;
                public int MaxDepth { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set => throw null; }
                public bool PropertyNameCaseInsensitive { get => throw null; set => throw null; }
                public System.Text.Json.JsonNamingPolicy PropertyNamingPolicy { get => throw null; set => throw null; }
                public System.Text.Json.JsonCommentHandling ReadCommentHandling { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.ReferenceHandler ReferenceHandler { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver TypeInfoResolver { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.JsonUnknownTypeHandling UnknownTypeHandling { get => throw null; set => throw null; }
                public bool WriteIndented { get => throw null; set => throw null; }
            }

            public enum JsonTokenType : byte
            {
                Comment = 6,
                EndArray = 4,
                EndObject = 2,
                False = 10,
                None = 0,
                Null = 11,
                Number = 8,
                PropertyName = 5,
                StartArray = 3,
                StartObject = 1,
                String = 7,
                True = 9,
            }

            public enum JsonValueKind : byte
            {
                Array = 2,
                False = 6,
                Null = 7,
                Number = 4,
                Object = 1,
                String = 3,
                True = 5,
                Undefined = 0,
            }

            public struct JsonWriterOptions
            {
                public System.Text.Encodings.Web.JavaScriptEncoder Encoder { get => throw null; set => throw null; }
                public bool Indented { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public int MaxDepth { get => throw null; set => throw null; }
                public bool SkipValidation { get => throw null; set => throw null; }
            }

            public struct Utf8JsonReader
            {
                public System.Int64 BytesConsumed { get => throw null; }
                public int CopyString(System.Span<System.Byte> utf8Destination) => throw null;
                public int CopyString(System.Span<System.Char> destination) => throw null;
                public int CurrentDepth { get => throw null; }
                public System.Text.Json.JsonReaderState CurrentState { get => throw null; }
                public bool GetBoolean() => throw null;
                public System.Byte GetByte() => throw null;
                public System.Byte[] GetBytesFromBase64() => throw null;
                public string GetComment() => throw null;
                public System.DateTime GetDateTime() => throw null;
                public System.DateTimeOffset GetDateTimeOffset() => throw null;
                public System.Decimal GetDecimal() => throw null;
                public double GetDouble() => throw null;
                public System.Guid GetGuid() => throw null;
                public System.Int16 GetInt16() => throw null;
                public int GetInt32() => throw null;
                public System.Int64 GetInt64() => throw null;
                public System.SByte GetSByte() => throw null;
                public float GetSingle() => throw null;
                public string GetString() => throw null;
                public System.UInt16 GetUInt16() => throw null;
                public System.UInt32 GetUInt32() => throw null;
                public System.UInt64 GetUInt64() => throw null;
                public bool HasValueSequence { get => throw null; }
                public bool IsFinalBlock { get => throw null; }
                public System.SequencePosition Position { get => throw null; }
                public bool Read() => throw null;
                public void Skip() => throw null;
                public System.Int64 TokenStartIndex { get => throw null; }
                public System.Text.Json.JsonTokenType TokenType { get => throw null; }
                public bool TryGetByte(out System.Byte value) => throw null;
                public bool TryGetBytesFromBase64(out System.Byte[] value) => throw null;
                public bool TryGetDateTime(out System.DateTime value) => throw null;
                public bool TryGetDateTimeOffset(out System.DateTimeOffset value) => throw null;
                public bool TryGetDecimal(out System.Decimal value) => throw null;
                public bool TryGetDouble(out double value) => throw null;
                public bool TryGetGuid(out System.Guid value) => throw null;
                public bool TryGetInt16(out System.Int16 value) => throw null;
                public bool TryGetInt32(out int value) => throw null;
                public bool TryGetInt64(out System.Int64 value) => throw null;
                public bool TryGetSByte(out System.SByte value) => throw null;
                public bool TryGetSingle(out float value) => throw null;
                public bool TryGetUInt16(out System.UInt16 value) => throw null;
                public bool TryGetUInt32(out System.UInt32 value) => throw null;
                public bool TryGetUInt64(out System.UInt64 value) => throw null;
                public bool TrySkip() => throw null;
                // Stub generator skipped constructor 
                public Utf8JsonReader(System.Buffers.ReadOnlySequence<System.Byte> jsonData, System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public Utf8JsonReader(System.Buffers.ReadOnlySequence<System.Byte> jsonData, bool isFinalBlock, System.Text.Json.JsonReaderState state) => throw null;
                public Utf8JsonReader(System.ReadOnlySpan<System.Byte> jsonData, System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public Utf8JsonReader(System.ReadOnlySpan<System.Byte> jsonData, bool isFinalBlock, System.Text.Json.JsonReaderState state) => throw null;
                public bool ValueIsEscaped { get => throw null; }
                public System.Buffers.ReadOnlySequence<System.Byte> ValueSequence { get => throw null; }
                public System.ReadOnlySpan<System.Byte> ValueSpan { get => throw null; }
                public bool ValueTextEquals(System.ReadOnlySpan<System.Byte> utf8Text) => throw null;
                public bool ValueTextEquals(System.ReadOnlySpan<System.Char> text) => throw null;
                public bool ValueTextEquals(string text) => throw null;
            }

            public class Utf8JsonWriter : System.IAsyncDisposable, System.IDisposable
            {
                public System.Int64 BytesCommitted { get => throw null; }
                public int BytesPending { get => throw null; }
                public int CurrentDepth { get => throw null; }
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public void Flush() => throw null;
                public System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Text.Json.JsonWriterOptions Options { get => throw null; }
                public void Reset() => throw null;
                public void Reset(System.Buffers.IBufferWriter<System.Byte> bufferWriter) => throw null;
                public void Reset(System.IO.Stream utf8Json) => throw null;
                public Utf8JsonWriter(System.Buffers.IBufferWriter<System.Byte> bufferWriter, System.Text.Json.JsonWriterOptions options = default(System.Text.Json.JsonWriterOptions)) => throw null;
                public Utf8JsonWriter(System.IO.Stream utf8Json, System.Text.Json.JsonWriterOptions options = default(System.Text.Json.JsonWriterOptions)) => throw null;
                public void WriteBase64String(System.Text.Json.JsonEncodedText propertyName, System.ReadOnlySpan<System.Byte> bytes) => throw null;
                public void WriteBase64String(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.ReadOnlySpan<System.Byte> bytes) => throw null;
                public void WriteBase64String(System.ReadOnlySpan<System.Char> propertyName, System.ReadOnlySpan<System.Byte> bytes) => throw null;
                public void WriteBase64String(string propertyName, System.ReadOnlySpan<System.Byte> bytes) => throw null;
                public void WriteBase64StringValue(System.ReadOnlySpan<System.Byte> bytes) => throw null;
                public void WriteBoolean(System.Text.Json.JsonEncodedText propertyName, bool value) => throw null;
                public void WriteBoolean(System.ReadOnlySpan<System.Byte> utf8PropertyName, bool value) => throw null;
                public void WriteBoolean(System.ReadOnlySpan<System.Char> propertyName, bool value) => throw null;
                public void WriteBoolean(string propertyName, bool value) => throw null;
                public void WriteBooleanValue(bool value) => throw null;
                public void WriteCommentValue(System.ReadOnlySpan<System.Byte> utf8Value) => throw null;
                public void WriteCommentValue(System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteCommentValue(string value) => throw null;
                public void WriteEndArray() => throw null;
                public void WriteEndObject() => throw null;
                public void WriteNull(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteNull(System.ReadOnlySpan<System.Byte> utf8PropertyName) => throw null;
                public void WriteNull(System.ReadOnlySpan<System.Char> propertyName) => throw null;
                public void WriteNull(string propertyName) => throw null;
                public void WriteNullValue() => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, System.Decimal value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, double value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, float value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, int value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, System.Int64 value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, System.UInt32 value) => throw null;
                public void WriteNumber(System.Text.Json.JsonEncodedText propertyName, System.UInt64 value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.Decimal value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, double value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, float value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, int value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.Int64 value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.UInt32 value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.UInt64 value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, System.Decimal value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, double value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, float value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, int value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, System.Int64 value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, System.UInt32 value) => throw null;
                public void WriteNumber(System.ReadOnlySpan<System.Char> propertyName, System.UInt64 value) => throw null;
                public void WriteNumber(string propertyName, System.Decimal value) => throw null;
                public void WriteNumber(string propertyName, double value) => throw null;
                public void WriteNumber(string propertyName, float value) => throw null;
                public void WriteNumber(string propertyName, int value) => throw null;
                public void WriteNumber(string propertyName, System.Int64 value) => throw null;
                public void WriteNumber(string propertyName, System.UInt32 value) => throw null;
                public void WriteNumber(string propertyName, System.UInt64 value) => throw null;
                public void WriteNumberValue(System.Decimal value) => throw null;
                public void WriteNumberValue(double value) => throw null;
                public void WriteNumberValue(float value) => throw null;
                public void WriteNumberValue(int value) => throw null;
                public void WriteNumberValue(System.Int64 value) => throw null;
                public void WriteNumberValue(System.UInt32 value) => throw null;
                public void WriteNumberValue(System.UInt64 value) => throw null;
                public void WritePropertyName(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WritePropertyName(System.ReadOnlySpan<System.Byte> utf8PropertyName) => throw null;
                public void WritePropertyName(System.ReadOnlySpan<System.Char> propertyName) => throw null;
                public void WritePropertyName(string propertyName) => throw null;
                public void WriteRawValue(System.ReadOnlySpan<System.Byte> utf8Json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteRawValue(System.ReadOnlySpan<System.Char> json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteRawValue(string json, bool skipInputValidation = default(bool)) => throw null;
                public void WriteStartArray() => throw null;
                public void WriteStartArray(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteStartArray(System.ReadOnlySpan<System.Byte> utf8PropertyName) => throw null;
                public void WriteStartArray(System.ReadOnlySpan<System.Char> propertyName) => throw null;
                public void WriteStartArray(string propertyName) => throw null;
                public void WriteStartObject() => throw null;
                public void WriteStartObject(System.Text.Json.JsonEncodedText propertyName) => throw null;
                public void WriteStartObject(System.ReadOnlySpan<System.Byte> utf8PropertyName) => throw null;
                public void WriteStartObject(System.ReadOnlySpan<System.Char> propertyName) => throw null;
                public void WriteStartObject(string propertyName) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.DateTime value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.Guid value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.ReadOnlySpan<System.Byte> utf8Value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteString(System.Text.Json.JsonEncodedText propertyName, string value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.DateTime value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.Guid value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.ReadOnlySpan<System.Byte> utf8Value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Byte> utf8PropertyName, string value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, System.DateTime value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, System.Guid value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, System.ReadOnlySpan<System.Byte> utf8Value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteString(System.ReadOnlySpan<System.Char> propertyName, string value) => throw null;
                public void WriteString(string propertyName, System.DateTime value) => throw null;
                public void WriteString(string propertyName, System.DateTimeOffset value) => throw null;
                public void WriteString(string propertyName, System.Guid value) => throw null;
                public void WriteString(string propertyName, System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteString(string propertyName, System.ReadOnlySpan<System.Byte> utf8Value) => throw null;
                public void WriteString(string propertyName, System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteString(string propertyName, string value) => throw null;
                public void WriteStringValue(System.DateTime value) => throw null;
                public void WriteStringValue(System.DateTimeOffset value) => throw null;
                public void WriteStringValue(System.Guid value) => throw null;
                public void WriteStringValue(System.Text.Json.JsonEncodedText value) => throw null;
                public void WriteStringValue(System.ReadOnlySpan<System.Byte> utf8Value) => throw null;
                public void WriteStringValue(System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteStringValue(string value) => throw null;
            }

            namespace Nodes
            {
                public class JsonArray : System.Text.Json.Nodes.JsonNode, System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode>, System.Collections.Generic.IEnumerable<System.Text.Json.Nodes.JsonNode>, System.Collections.Generic.IList<System.Text.Json.Nodes.JsonNode>, System.Collections.IEnumerable
                {
                    public void Add(System.Text.Json.Nodes.JsonNode item) => throw null;
                    public void Add<T>(T value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(System.Text.Json.Nodes.JsonNode item) => throw null;
                    void System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode>.CopyTo(System.Text.Json.Nodes.JsonNode[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public static System.Text.Json.Nodes.JsonArray Create(System.Text.Json.JsonElement element, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Text.Json.Nodes.JsonNode> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public int IndexOf(System.Text.Json.Nodes.JsonNode item) => throw null;
                    public void Insert(int index, System.Text.Json.Nodes.JsonNode item) => throw null;
                    bool System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode>.IsReadOnly { get => throw null; }
                    public JsonArray(System.Text.Json.Nodes.JsonNodeOptions options, params System.Text.Json.Nodes.JsonNode[] items) => throw null;
                    public JsonArray(System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public JsonArray(params System.Text.Json.Nodes.JsonNode[] items) => throw null;
                    public bool Remove(System.Text.Json.Nodes.JsonNode item) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public override void WriteTo(System.Text.Json.Utf8JsonWriter writer, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                }

                public abstract class JsonNode
                {
                    public System.Text.Json.Nodes.JsonArray AsArray() => throw null;
                    public System.Text.Json.Nodes.JsonObject AsObject() => throw null;
                    public System.Text.Json.Nodes.JsonValue AsValue() => throw null;
                    public string GetPath() => throw null;
                    public virtual T GetValue<T>() => throw null;
                    public System.Text.Json.Nodes.JsonNode this[int index] { get => throw null; set => throw null; }
                    public System.Text.Json.Nodes.JsonNode this[string propertyName] { get => throw null; set => throw null; }
                    internal JsonNode() => throw null;
                    public System.Text.Json.Nodes.JsonNodeOptions? Options { get => throw null; }
                    public System.Text.Json.Nodes.JsonNode Parent { get => throw null; }
                    public static System.Text.Json.Nodes.JsonNode Parse(System.ReadOnlySpan<System.Byte> utf8Json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                    public static System.Text.Json.Nodes.JsonNode Parse(System.IO.Stream utf8Json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                    public static System.Text.Json.Nodes.JsonNode Parse(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonNode Parse(string json, System.Text.Json.Nodes.JsonNodeOptions? nodeOptions = default(System.Text.Json.Nodes.JsonNodeOptions?), System.Text.Json.JsonDocumentOptions documentOptions = default(System.Text.Json.JsonDocumentOptions)) => throw null;
                    public System.Text.Json.Nodes.JsonNode Root { get => throw null; }
                    public string ToJsonString(System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                    public override string ToString() => throw null;
                    public abstract void WriteTo(System.Text.Json.Utf8JsonWriter writer, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions));
                    public static explicit operator System.Byte(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Byte?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Char(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Char?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTime(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTime?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTimeOffset(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.DateTimeOffset?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Decimal(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Decimal?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Guid(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Guid?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Int16(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Int16?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Int64(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.Int64?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.SByte(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.SByte?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.UInt16(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.UInt16?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.UInt32(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.UInt32?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.UInt64(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator System.UInt64?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator bool(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator bool?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator double(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator double?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator float(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator float?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator int(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator int?(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static explicit operator string(System.Text.Json.Nodes.JsonNode value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTime value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTime? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTimeOffset value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.DateTimeOffset? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Guid value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Guid? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(bool value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(bool? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Byte value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Byte? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Char value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Char? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Decimal value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Decimal? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(double value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(double? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(float value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(float? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(int value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(int? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Int64 value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Int64? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.SByte value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.SByte? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Int16 value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.Int16? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(string value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.UInt32 value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.UInt32? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.UInt64 value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.UInt64? value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.UInt16 value) => throw null;
                    public static implicit operator System.Text.Json.Nodes.JsonNode(System.UInt16? value) => throw null;
                }

                public struct JsonNodeOptions
                {
                    // Stub generator skipped constructor 
                    public bool PropertyNameCaseInsensitive { get => throw null; set => throw null; }
                }

                public class JsonObject : System.Text.Json.Nodes.JsonNode, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>, System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>, System.Collections.IEnumerable
                {
                    public void Add(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode> property) => throw null;
                    public void Add(string propertyName, System.Text.Json.Nodes.JsonNode value) => throw null;
                    public void Clear() => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.Contains(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode> item) => throw null;
                    public bool ContainsKey(string propertyName) => throw null;
                    void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.CopyTo(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public static System.Text.Json.Nodes.JsonObject Create(System.Text.Json.JsonElement element, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.IsReadOnly { get => throw null; }
                    public JsonObject(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>> properties, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public JsonObject(System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    System.Collections.Generic.ICollection<string> System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>.Keys { get => throw null; }
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>>.Remove(System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode> item) => throw null;
                    public bool Remove(string propertyName) => throw null;
                    public bool TryGetPropertyValue(string propertyName, out System.Text.Json.Nodes.JsonNode jsonNode) => throw null;
                    bool System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>.TryGetValue(string propertyName, out System.Text.Json.Nodes.JsonNode jsonNode) => throw null;
                    System.Collections.Generic.ICollection<System.Text.Json.Nodes.JsonNode> System.Collections.Generic.IDictionary<string, System.Text.Json.Nodes.JsonNode>.Values { get => throw null; }
                    public override void WriteTo(System.Text.Json.Utf8JsonWriter writer, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                }

                public abstract class JsonValue : System.Text.Json.Nodes.JsonNode
                {
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTime value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTime? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTimeOffset value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.DateTimeOffset? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Guid value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Guid? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Text.Json.JsonElement value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Text.Json.JsonElement? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(bool value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(bool? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Byte value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Byte? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Char value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Char? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Decimal value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Decimal? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(double value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(double? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(float value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(float? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(int value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(int? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Int64 value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Int64? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.SByte value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.SByte? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Int16 value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.Int16? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(string value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.UInt32 value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.UInt32? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.UInt64 value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.UInt64? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.UInt16 value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
                    public static System.Text.Json.Nodes.JsonValue Create(System.UInt16? value, System.Text.Json.Nodes.JsonNodeOptions? options = default(System.Text.Json.Nodes.JsonNodeOptions?)) => throw null;
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

                public class JsonConstructorAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonConstructorAttribute() => throw null;
                }

                public abstract class JsonConverter
                {
                    public abstract bool CanConvert(System.Type typeToConvert);
                    internal JsonConverter() => throw null;
                }

                public abstract class JsonConverter<T> : System.Text.Json.Serialization.JsonConverter
                {
                    public override bool CanConvert(System.Type typeToConvert) => throw null;
                    public virtual bool HandleNull { get => throw null; }
                    protected internal JsonConverter() => throw null;
                    public abstract T Read(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options);
                    public virtual T ReadAsPropertyName(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public abstract void Write(System.Text.Json.Utf8JsonWriter writer, T value, System.Text.Json.JsonSerializerOptions options);
                    public virtual void WriteAsPropertyName(System.Text.Json.Utf8JsonWriter writer, T value, System.Text.Json.JsonSerializerOptions options) => throw null;
                }

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
                }

                public class JsonDerivedTypeAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Type DerivedType { get => throw null; }
                    public JsonDerivedTypeAttribute(System.Type derivedType) => throw null;
                    public JsonDerivedTypeAttribute(System.Type derivedType, int typeDiscriminator) => throw null;
                    public JsonDerivedTypeAttribute(System.Type derivedType, string typeDiscriminator) => throw null;
                    public object TypeDiscriminator { get => throw null; }
                }

                public class JsonExtensionDataAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonExtensionDataAttribute() => throw null;
                }

                public class JsonIgnoreAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonIgnoreCondition Condition { get => throw null; set => throw null; }
                    public JsonIgnoreAttribute() => throw null;
                }

                public enum JsonIgnoreCondition : int
                {
                    Always = 1,
                    Never = 0,
                    WhenWritingDefault = 2,
                    WhenWritingNull = 3,
                }

                public class JsonIncludeAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonIncludeAttribute() => throw null;
                }

                public enum JsonKnownNamingPolicy : int
                {
                    CamelCase = 1,
                    Unspecified = 0,
                }

                [System.Flags]
                public enum JsonNumberHandling : int
                {
                    AllowNamedFloatingPointLiterals = 4,
                    AllowReadingFromString = 1,
                    Strict = 0,
                    WriteAsString = 2,
                }

                public class JsonNumberHandlingAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonNumberHandling Handling { get => throw null; }
                    public JsonNumberHandlingAttribute(System.Text.Json.Serialization.JsonNumberHandling handling) => throw null;
                }

                public class JsonPolymorphicAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public bool IgnoreUnrecognizedTypeDiscriminators { get => throw null; set => throw null; }
                    public JsonPolymorphicAttribute() => throw null;
                    public string TypeDiscriminatorPropertyName { get => throw null; set => throw null; }
                    public System.Text.Json.Serialization.JsonUnknownDerivedTypeHandling UnknownDerivedTypeHandling { get => throw null; set => throw null; }
                }

                public class JsonPropertyNameAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonPropertyNameAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                }

                public class JsonPropertyOrderAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonPropertyOrderAttribute(int order) => throw null;
                    public int Order { get => throw null; }
                }

                public class JsonRequiredAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonRequiredAttribute() => throw null;
                }

                public class JsonSerializableAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonSourceGenerationMode GenerationMode { get => throw null; set => throw null; }
                    public JsonSerializableAttribute(System.Type type) => throw null;
                    public string TypeInfoPropertyName { get => throw null; set => throw null; }
                }

                public abstract class JsonSerializerContext : System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver
                {
                    protected abstract System.Text.Json.JsonSerializerOptions GeneratedSerializerOptions { get; }
                    public abstract System.Text.Json.Serialization.Metadata.JsonTypeInfo GetTypeInfo(System.Type type);
                    System.Text.Json.Serialization.Metadata.JsonTypeInfo System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver.GetTypeInfo(System.Type type, System.Text.Json.JsonSerializerOptions options) => throw null;
                    protected JsonSerializerContext(System.Text.Json.JsonSerializerOptions options) => throw null;
                    public System.Text.Json.JsonSerializerOptions Options { get => throw null; }
                }

                [System.Flags]
                public enum JsonSourceGenerationMode : int
                {
                    Default = 0,
                    Metadata = 1,
                    Serialization = 2,
                }

                public class JsonSourceGenerationOptionsAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonIgnoreCondition DefaultIgnoreCondition { get => throw null; set => throw null; }
                    public System.Text.Json.Serialization.JsonSourceGenerationMode GenerationMode { get => throw null; set => throw null; }
                    public bool IgnoreReadOnlyFields { get => throw null; set => throw null; }
                    public bool IgnoreReadOnlyProperties { get => throw null; set => throw null; }
                    public bool IncludeFields { get => throw null; set => throw null; }
                    public JsonSourceGenerationOptionsAttribute() => throw null;
                    public System.Text.Json.Serialization.JsonKnownNamingPolicy PropertyNamingPolicy { get => throw null; set => throw null; }
                    public bool WriteIndented { get => throw null; set => throw null; }
                }

                public class JsonStringEnumConverter : System.Text.Json.Serialization.JsonConverterFactory
                {
                    public override bool CanConvert(System.Type typeToConvert) => throw null;
                    public override System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public JsonStringEnumConverter() => throw null;
                    public JsonStringEnumConverter(System.Text.Json.JsonNamingPolicy namingPolicy = default(System.Text.Json.JsonNamingPolicy), bool allowIntegerValues = default(bool)) => throw null;
                }

                public enum JsonUnknownDerivedTypeHandling : int
                {
                    FailSerialization = 0,
                    FallBackToBaseType = 1,
                    FallBackToNearestAncestor = 2,
                }

                public enum JsonUnknownTypeHandling : int
                {
                    JsonElement = 0,
                    JsonNode = 1,
                }

                public abstract class ReferenceHandler
                {
                    public abstract System.Text.Json.Serialization.ReferenceResolver CreateResolver();
                    public static System.Text.Json.Serialization.ReferenceHandler IgnoreCycles { get => throw null; }
                    public static System.Text.Json.Serialization.ReferenceHandler Preserve { get => throw null; }
                    protected ReferenceHandler() => throw null;
                }

                public class ReferenceHandler<T> : System.Text.Json.Serialization.ReferenceHandler where T : System.Text.Json.Serialization.ReferenceResolver, new()
                {
                    public override System.Text.Json.Serialization.ReferenceResolver CreateResolver() => throw null;
                    public ReferenceHandler() => throw null;
                }

                public abstract class ReferenceResolver
                {
                    public abstract void AddReference(string referenceId, object value);
                    public abstract string GetReference(object value, out bool alreadyExists);
                    protected ReferenceResolver() => throw null;
                    public abstract object ResolveReference(string referenceId);
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

                    public class JsonCollectionInfoValues<TCollection>
                    {
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfo ElementInfo { get => throw null; set => throw null; }
                        public JsonCollectionInfoValues() => throw null;
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfo KeyInfo { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set => throw null; }
                        public System.Func<TCollection> ObjectCreator { get => throw null; set => throw null; }
                        public System.Action<System.Text.Json.Utf8JsonWriter, TCollection> SerializeHandler { get => throw null; set => throw null; }
                    }

                    public struct JsonDerivedType
                    {
                        public System.Type DerivedType { get => throw null; }
                        // Stub generator skipped constructor 
                        public JsonDerivedType(System.Type derivedType) => throw null;
                        public JsonDerivedType(System.Type derivedType, int typeDiscriminator) => throw null;
                        public JsonDerivedType(System.Type derivedType, string typeDiscriminator) => throw null;
                        public object TypeDiscriminator { get => throw null; }
                    }

                    public static class JsonMetadataServices
                    {
                        public static System.Text.Json.Serialization.JsonConverter<bool> BooleanConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Byte[]> ByteArrayConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Byte> ByteConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Char> CharConverter { get => throw null; }
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TElement[]> CreateArrayInfo<TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TElement[]> collectionInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateConcurrentQueueInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Concurrent.ConcurrentQueue<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateConcurrentStackInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Concurrent.ConcurrentStack<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.Dictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIAsyncEnumerableInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IAsyncEnumerable<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateICollectionInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.ICollection<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IDictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIDictionaryInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.IDictionary => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIEnumerableInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IEnumerable<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIEnumerableInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.IEnumerable => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIListInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IList<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIListInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.IList => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateIReadOnlyDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.IReadOnlyDictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateISetInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.ISet<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateImmutableDictionaryInfo<TCollection, TKey, TValue>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Func<System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, TCollection> createRangeFunc) where TCollection : System.Collections.Generic.IReadOnlyDictionary<TKey, TValue> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateImmutableEnumerableInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Func<System.Collections.Generic.IEnumerable<TElement>, TCollection> createRangeFunc) where TCollection : System.Collections.Generic.IEnumerable<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateListInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.List<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> CreateObjectInfo<T>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonObjectInfoValues<T> objectInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonPropertyInfo CreatePropertyInfo<T>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonPropertyInfoValues<T> propertyInfo) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateQueueInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.Queue<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateQueueInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Action<TCollection, object> addFunc) where TCollection : System.Collections.IEnumerable => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateStackInfo<TCollection, TElement>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo) where TCollection : System.Collections.Generic.Stack<TElement> => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<TCollection> CreateStackInfo<TCollection>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.Metadata.JsonCollectionInfoValues<TCollection> collectionInfo, System.Action<TCollection, object> addFunc) where TCollection : System.Collections.IEnumerable => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> CreateValueInfo<T>(System.Text.Json.JsonSerializerOptions options, System.Text.Json.Serialization.JsonConverter converter) => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<System.DateOnly> DateOnlyConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.DateTime> DateTimeConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.DateTimeOffset> DateTimeOffsetConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Decimal> DecimalConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<double> DoubleConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<T> GetEnumConverter<T>(System.Text.Json.JsonSerializerOptions options) where T : struct => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<T?> GetNullableConverter<T>(System.Text.Json.JsonSerializerOptions options) where T : struct => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<T?> GetNullableConverter<T>(System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> underlyingTypeInfo) where T : struct => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<T> GetUnsupportedTypeConverter<T>() => throw null;
                        public static System.Text.Json.Serialization.JsonConverter<System.Guid> GuidConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Int16> Int16Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<int> Int32Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Int64> Int64Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonArray> JsonArrayConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.JsonDocument> JsonDocumentConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.JsonElement> JsonElementConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonNode> JsonNodeConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonObject> JsonObjectConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Text.Json.Nodes.JsonValue> JsonValueConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<object> ObjectConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.SByte> SByteConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<float> SingleConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<string> StringConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.TimeOnly> TimeOnlyConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.TimeSpan> TimeSpanConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.UInt16> UInt16Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.UInt32> UInt32Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.UInt64> UInt64Converter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Uri> UriConverter { get => throw null; }
                        public static System.Text.Json.Serialization.JsonConverter<System.Version> VersionConverter { get => throw null; }
                    }

                    public class JsonObjectInfoValues<T>
                    {
                        public System.Func<System.Text.Json.Serialization.Metadata.JsonParameterInfoValues[]> ConstructorParameterMetadataInitializer { get => throw null; set => throw null; }
                        public JsonObjectInfoValues() => throw null;
                        public System.Text.Json.Serialization.JsonNumberHandling NumberHandling { get => throw null; set => throw null; }
                        public System.Func<T> ObjectCreator { get => throw null; set => throw null; }
                        public System.Func<object[], T> ObjectWithParameterizedConstructorCreator { get => throw null; set => throw null; }
                        public System.Func<System.Text.Json.Serialization.JsonSerializerContext, System.Text.Json.Serialization.Metadata.JsonPropertyInfo[]> PropertyMetadataInitializer { get => throw null; set => throw null; }
                        public System.Action<System.Text.Json.Utf8JsonWriter, T> SerializeHandler { get => throw null; set => throw null; }
                    }

                    public class JsonParameterInfoValues
                    {
                        public object DefaultValue { get => throw null; set => throw null; }
                        public bool HasDefaultValue { get => throw null; set => throw null; }
                        public JsonParameterInfoValues() => throw null;
                        public string Name { get => throw null; set => throw null; }
                        public System.Type ParameterType { get => throw null; set => throw null; }
                        public int Position { get => throw null; set => throw null; }
                    }

                    public class JsonPolymorphismOptions
                    {
                        public System.Collections.Generic.IList<System.Text.Json.Serialization.Metadata.JsonDerivedType> DerivedTypes { get => throw null; }
                        public bool IgnoreUnrecognizedTypeDiscriminators { get => throw null; set => throw null; }
                        public JsonPolymorphismOptions() => throw null;
                        public string TypeDiscriminatorPropertyName { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.JsonUnknownDerivedTypeHandling UnknownDerivedTypeHandling { get => throw null; set => throw null; }
                    }

                    public abstract class JsonPropertyInfo
                    {
                        public System.Reflection.ICustomAttributeProvider AttributeProvider { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.JsonConverter CustomConverter { get => throw null; set => throw null; }
                        public System.Func<object, object> Get { get => throw null; set => throw null; }
                        public bool IsExtensionData { get => throw null; set => throw null; }
                        public bool IsRequired { get => throw null; set => throw null; }
                        public string Name { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.JsonNumberHandling? NumberHandling { get => throw null; set => throw null; }
                        public System.Text.Json.JsonSerializerOptions Options { get => throw null; }
                        public int Order { get => throw null; set => throw null; }
                        public System.Type PropertyType { get => throw null; }
                        public System.Action<object, object> Set { get => throw null; set => throw null; }
                        public System.Func<object, object, bool> ShouldSerialize { get => throw null; set => throw null; }
                    }

                    public class JsonPropertyInfoValues<T>
                    {
                        public System.Text.Json.Serialization.JsonConverter<T> Converter { get => throw null; set => throw null; }
                        public System.Type DeclaringType { get => throw null; set => throw null; }
                        public System.Func<object, T> Getter { get => throw null; set => throw null; }
                        public bool HasJsonInclude { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.JsonIgnoreCondition? IgnoreCondition { get => throw null; set => throw null; }
                        public bool IsExtensionData { get => throw null; set => throw null; }
                        public bool IsProperty { get => throw null; set => throw null; }
                        public bool IsPublic { get => throw null; set => throw null; }
                        public bool IsVirtual { get => throw null; set => throw null; }
                        public JsonPropertyInfoValues() => throw null;
                        public string JsonPropertyName { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.JsonNumberHandling? NumberHandling { get => throw null; set => throw null; }
                        public string PropertyName { get => throw null; set => throw null; }
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfo PropertyTypeInfo { get => throw null; set => throw null; }
                        public System.Action<object, T> Setter { get => throw null; set => throw null; }
                    }

                    public abstract class JsonTypeInfo
                    {
                        public System.Text.Json.Serialization.JsonConverter Converter { get => throw null; }
                        public System.Text.Json.Serialization.Metadata.JsonPropertyInfo CreateJsonPropertyInfo(System.Type propertyType, string name) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo CreateJsonTypeInfo(System.Type type, System.Text.Json.JsonSerializerOptions options) => throw null;
                        public static System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> CreateJsonTypeInfo<T>(System.Text.Json.JsonSerializerOptions options) => throw null;
                        public System.Func<object> CreateObject { get => throw null; set => throw null; }
                        public bool IsReadOnly { get => throw null; }
                        internal JsonTypeInfo() => throw null;
                        public System.Text.Json.Serialization.Metadata.JsonTypeInfoKind Kind { get => throw null; }
                        public void MakeReadOnly() => throw null;
                        public System.Text.Json.Serialization.JsonNumberHandling? NumberHandling { get => throw null; set => throw null; }
                        public System.Action<object> OnDeserialized { get => throw null; set => throw null; }
                        public System.Action<object> OnDeserializing { get => throw null; set => throw null; }
                        public System.Action<object> OnSerialized { get => throw null; set => throw null; }
                        public System.Action<object> OnSerializing { get => throw null; set => throw null; }
                        public System.Text.Json.JsonSerializerOptions Options { get => throw null; }
                        public System.Text.Json.Serialization.Metadata.JsonPolymorphismOptions PolymorphismOptions { get => throw null; set => throw null; }
                        public System.Collections.Generic.IList<System.Text.Json.Serialization.Metadata.JsonPropertyInfo> Properties { get => throw null; }
                        public System.Type Type { get => throw null; }
                    }

                    public abstract class JsonTypeInfo<T> : System.Text.Json.Serialization.Metadata.JsonTypeInfo
                    {
                        public System.Func<T> CreateObject { get => throw null; set => throw null; }
                        public System.Action<System.Text.Json.Utf8JsonWriter, T> SerializeHandler { get => throw null; }
                    }

                    public enum JsonTypeInfoKind : int
                    {
                        Dictionary = 3,
                        Enumerable = 2,
                        None = 0,
                        Object = 1,
                    }

                    public static class JsonTypeInfoResolver
                    {
                        public static System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver Combine(params System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver[] resolvers) => throw null;
                    }

                }
            }
        }
    }
}
