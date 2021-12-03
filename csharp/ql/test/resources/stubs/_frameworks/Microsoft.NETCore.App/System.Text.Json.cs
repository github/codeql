// This file contains auto-generated code.

namespace System
{
    namespace Text
    {
        namespace Json
        {
            // Generated from `System.Text.Json.JsonCommentHandling` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum JsonCommentHandling
            {
                Allow,
                Disallow,
                Skip,
            }

            // Generated from `System.Text.Json.JsonDocument` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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

            // Generated from `System.Text.Json.JsonDocumentOptions` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct JsonDocumentOptions
            {
                public bool AllowTrailingCommas { get => throw null; set => throw null; }
                public System.Text.Json.JsonCommentHandling CommentHandling { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public int MaxDepth { get => throw null; set => throw null; }
            }

            // Generated from `System.Text.Json.JsonElement` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct JsonElement
            {
                // Generated from `System.Text.Json.JsonElement+ArrayEnumerator` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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


                // Generated from `System.Text.Json.JsonElement+ObjectEnumerator` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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
                public bool ValueEquals(System.ReadOnlySpan<System.Byte> utf8Text) => throw null;
                public bool ValueEquals(System.ReadOnlySpan<System.Char> text) => throw null;
                public bool ValueEquals(string text) => throw null;
                public System.Text.Json.JsonValueKind ValueKind { get => throw null; }
                public void WriteTo(System.Text.Json.Utf8JsonWriter writer) => throw null;
            }

            // Generated from `System.Text.Json.JsonEncodedText` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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

            // Generated from `System.Text.Json.JsonException` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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

            // Generated from `System.Text.Json.JsonNamingPolicy` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class JsonNamingPolicy
            {
                public static System.Text.Json.JsonNamingPolicy CamelCase { get => throw null; }
                public abstract string ConvertName(string name);
                protected JsonNamingPolicy() => throw null;
            }

            // Generated from `System.Text.Json.JsonProperty` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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

            // Generated from `System.Text.Json.JsonReaderOptions` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct JsonReaderOptions
            {
                public bool AllowTrailingCommas { get => throw null; set => throw null; }
                public System.Text.Json.JsonCommentHandling CommentHandling { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public int MaxDepth { get => throw null; set => throw null; }
            }

            // Generated from `System.Text.Json.JsonReaderState` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct JsonReaderState
            {
                // Stub generator skipped constructor 
                public JsonReaderState(System.Text.Json.JsonReaderOptions options = default(System.Text.Json.JsonReaderOptions)) => throw null;
                public System.Text.Json.JsonReaderOptions Options { get => throw null; }
            }

            // Generated from `System.Text.Json.JsonSerializer` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class JsonSerializer
            {
                public static object Deserialize(System.ReadOnlySpan<System.Byte> utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(ref System.Text.Json.Utf8JsonReader reader, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static object Deserialize(string json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(System.ReadOnlySpan<System.Byte> utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(ref System.Text.Json.Utf8JsonReader reader, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static TValue Deserialize<TValue>(string json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream utf8Json, System.Type returnType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<TValue> DeserializeAsync<TValue>(System.IO.Stream utf8Json, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static void Serialize(System.Text.Json.Utf8JsonWriter writer, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static string Serialize(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static string Serialize<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static void Serialize<TValue>(System.Text.Json.Utf8JsonWriter writer, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync(System.IO.Stream utf8Json, object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SerializeAsync<TValue>(System.IO.Stream utf8Json, TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Byte[] SerializeToUtf8Bytes(object value, System.Type inputType, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
                public static System.Byte[] SerializeToUtf8Bytes<TValue>(TValue value, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
            }

            // Generated from `System.Text.Json.JsonSerializerDefaults` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum JsonSerializerDefaults
            {
                General,
                Web,
            }

            // Generated from `System.Text.Json.JsonSerializerOptions` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class JsonSerializerOptions
            {
                public bool AllowTrailingCommas { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<System.Text.Json.Serialization.JsonConverter> Converters { get => throw null; }
                public int DefaultBufferSize { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.JsonIgnoreCondition DefaultIgnoreCondition { get => throw null; set => throw null; }
                public System.Text.Json.JsonNamingPolicy DictionaryKeyPolicy { get => throw null; set => throw null; }
                public System.Text.Encodings.Web.JavaScriptEncoder Encoder { get => throw null; set => throw null; }
                public System.Text.Json.Serialization.JsonConverter GetConverter(System.Type typeToConvert) => throw null;
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
                public bool WriteIndented { get => throw null; set => throw null; }
            }

            // Generated from `System.Text.Json.JsonTokenType` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum JsonTokenType
            {
                Comment,
                EndArray,
                EndObject,
                False,
                None,
                Null,
                Number,
                PropertyName,
                StartArray,
                StartObject,
                String,
                True,
            }

            // Generated from `System.Text.Json.JsonValueKind` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum JsonValueKind
            {
                Array,
                False,
                Null,
                Number,
                Object,
                String,
                True,
                Undefined,
            }

            // Generated from `System.Text.Json.JsonWriterOptions` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct JsonWriterOptions
            {
                public System.Text.Encodings.Web.JavaScriptEncoder Encoder { get => throw null; set => throw null; }
                public bool Indented { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public bool SkipValidation { get => throw null; set => throw null; }
            }

            // Generated from `System.Text.Json.Utf8JsonReader` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct Utf8JsonReader
            {
                public System.Int64 BytesConsumed { get => throw null; }
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
                public System.Buffers.ReadOnlySequence<System.Byte> ValueSequence { get => throw null; }
                public System.ReadOnlySpan<System.Byte> ValueSpan { get => throw null; }
                public bool ValueTextEquals(System.ReadOnlySpan<System.Byte> utf8Text) => throw null;
                public bool ValueTextEquals(System.ReadOnlySpan<System.Char> text) => throw null;
                public bool ValueTextEquals(string text) => throw null;
            }

            // Generated from `System.Text.Json.Utf8JsonWriter` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
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

            namespace Serialization
            {
                // Generated from `System.Text.Json.Serialization.JsonAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class JsonAttribute : System.Attribute
                {
                    protected JsonAttribute() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonConstructorAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonConstructorAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonConstructorAttribute() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonConverter` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class JsonConverter
                {
                    public abstract bool CanConvert(System.Type typeToConvert);
                    internal JsonConverter() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonConverter<>` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class JsonConverter<T> : System.Text.Json.Serialization.JsonConverter
                {
                    public override bool CanConvert(System.Type typeToConvert) => throw null;
                    public virtual bool HandleNull { get => throw null; }
                    protected internal JsonConverter() => throw null;
                    public abstract T Read(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options);
                    public abstract void Write(System.Text.Json.Utf8JsonWriter writer, T value, System.Text.Json.JsonSerializerOptions options);
                }

                // Generated from `System.Text.Json.Serialization.JsonConverterAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonConverterAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Type ConverterType { get => throw null; }
                    public virtual System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert) => throw null;
                    protected JsonConverterAttribute() => throw null;
                    public JsonConverterAttribute(System.Type converterType) => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonConverterFactory` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class JsonConverterFactory : System.Text.Json.Serialization.JsonConverter
                {
                    public abstract System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options);
                    protected JsonConverterFactory() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonExtensionDataAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonExtensionDataAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonExtensionDataAttribute() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonIgnoreAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonIgnoreAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonIgnoreCondition Condition { get => throw null; set => throw null; }
                    public JsonIgnoreAttribute() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonIgnoreCondition` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum JsonIgnoreCondition
                {
                    Always,
                    Never,
                    WhenWritingDefault,
                    WhenWritingNull,
                }

                // Generated from `System.Text.Json.Serialization.JsonIncludeAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonIncludeAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonIncludeAttribute() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonNumberHandling` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                [System.Flags]
                public enum JsonNumberHandling
                {
                    AllowNamedFloatingPointLiterals,
                    AllowReadingFromString,
                    Strict,
                    WriteAsString,
                }

                // Generated from `System.Text.Json.Serialization.JsonNumberHandlingAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonNumberHandlingAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public System.Text.Json.Serialization.JsonNumberHandling Handling { get => throw null; }
                    public JsonNumberHandlingAttribute(System.Text.Json.Serialization.JsonNumberHandling handling) => throw null;
                }

                // Generated from `System.Text.Json.Serialization.JsonPropertyNameAttribute` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonPropertyNameAttribute : System.Text.Json.Serialization.JsonAttribute
                {
                    public JsonPropertyNameAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                }

                // Generated from `System.Text.Json.Serialization.JsonStringEnumConverter` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class JsonStringEnumConverter : System.Text.Json.Serialization.JsonConverterFactory
                {
                    public override bool CanConvert(System.Type typeToConvert) => throw null;
                    public override System.Text.Json.Serialization.JsonConverter CreateConverter(System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public JsonStringEnumConverter() => throw null;
                    public JsonStringEnumConverter(System.Text.Json.JsonNamingPolicy namingPolicy = default(System.Text.Json.JsonNamingPolicy), bool allowIntegerValues = default(bool)) => throw null;
                }

                // Generated from `System.Text.Json.Serialization.ReferenceHandler` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class ReferenceHandler
                {
                    public abstract System.Text.Json.Serialization.ReferenceResolver CreateResolver();
                    public static System.Text.Json.Serialization.ReferenceHandler Preserve { get => throw null; }
                    protected ReferenceHandler() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.ReferenceHandler<>` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class ReferenceHandler<T> : System.Text.Json.Serialization.ReferenceHandler where T : System.Text.Json.Serialization.ReferenceResolver, new()
                {
                    public override System.Text.Json.Serialization.ReferenceResolver CreateResolver() => throw null;
                    public ReferenceHandler() => throw null;
                }

                // Generated from `System.Text.Json.Serialization.ReferenceResolver` in `System.Text.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class ReferenceResolver
                {
                    public abstract void AddReference(string referenceId, object value);
                    public abstract string GetReference(object value, out bool alreadyExists);
                    protected ReferenceResolver() => throw null;
                    public abstract object ResolveReference(string referenceId);
                }

            }
        }
    }
}
