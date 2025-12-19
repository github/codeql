// This file contains auto-generated code.
// Generated from `System.Memory.Data, Version=8.0.0.1, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    public class BinaryData
    {
        public BinaryData(byte[] data) => throw null;
        public BinaryData(byte[] data, string mediaType) => throw null;
        public BinaryData(object jsonSerializable, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Type type = default(System.Type)) => throw null;
        public BinaryData(object jsonSerializable, System.Text.Json.Serialization.JsonSerializerContext context, System.Type type = default(System.Type)) => throw null;
        public BinaryData(System.ReadOnlyMemory<byte> data) => throw null;
        public BinaryData(System.ReadOnlyMemory<byte> data, string mediaType) => throw null;
        public BinaryData(string data) => throw null;
        public BinaryData(string data, string mediaType) => throw null;
        public static System.BinaryData Empty { get => throw null; }
        public override bool Equals(object obj) => throw null;
        public static System.BinaryData FromBytes(System.ReadOnlyMemory<byte> data) => throw null;
        public static System.BinaryData FromBytes(System.ReadOnlyMemory<byte> data, string mediaType) => throw null;
        public static System.BinaryData FromBytes(byte[] data) => throw null;
        public static System.BinaryData FromBytes(byte[] data, string mediaType) => throw null;
        public static System.BinaryData FromObjectAsJson<T>(T jsonSerializable, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
        public static System.BinaryData FromObjectAsJson<T>(T jsonSerializable, System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> jsonTypeInfo) => throw null;
        public static System.BinaryData FromStream(System.IO.Stream stream) => throw null;
        public static System.BinaryData FromStream(System.IO.Stream stream, string mediaType) => throw null;
        public static System.Threading.Tasks.Task<System.BinaryData> FromStreamAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.BinaryData> FromStreamAsync(System.IO.Stream stream, string mediaType, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public static System.BinaryData FromString(string data) => throw null;
        public static System.BinaryData FromString(string data, string mediaType) => throw null;
        public override int GetHashCode() => throw null;
        public bool IsEmpty { get => throw null; }
        public int Length { get => throw null; }
        public string MediaType { get => throw null; }
        public static implicit operator System.ReadOnlyMemory<byte>(System.BinaryData data) => throw null;
        public static implicit operator System.ReadOnlySpan<byte>(System.BinaryData data) => throw null;
        public byte[] ToArray() => throw null;
        public System.ReadOnlyMemory<byte> ToMemory() => throw null;
        public T ToObjectFromJson<T>(System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
        public T ToObjectFromJson<T>(System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> jsonTypeInfo) => throw null;
        public System.IO.Stream ToStream() => throw null;
        public override string ToString() => throw null;
        public System.BinaryData WithMediaType(string mediaType) => throw null;
    }
    namespace Text
    {
        namespace Json
        {
            namespace Serialization
            {
                public sealed class BinaryDataJsonConverter : System.Text.Json.Serialization.JsonConverter<System.BinaryData>
                {
                    public BinaryDataJsonConverter() => throw null;
                    public override System.BinaryData Read(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                    public override void Write(System.Text.Json.Utf8JsonWriter writer, System.BinaryData value, System.Text.Json.JsonSerializerOptions options) => throw null;
                }
            }
        }
    }
}
