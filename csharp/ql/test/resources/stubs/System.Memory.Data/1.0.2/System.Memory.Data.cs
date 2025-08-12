// This file contains auto-generated code.
// Generated from `System.Memory.Data, Version=1.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    public class BinaryData
    {
        public BinaryData(byte[] data) => throw null;
        public BinaryData(object jsonSerializable, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), System.Type type = default(System.Type)) => throw null;
        public BinaryData(System.ReadOnlyMemory<byte> data) => throw null;
        public BinaryData(string data) => throw null;
        public override bool Equals(object obj) => throw null;
        public static System.BinaryData FromBytes(System.ReadOnlyMemory<byte> data) => throw null;
        public static System.BinaryData FromBytes(byte[] data) => throw null;
        public static System.BinaryData FromObjectAsJson<T>(T jsonSerializable, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
        public static System.BinaryData FromStream(System.IO.Stream stream) => throw null;
        public static System.Threading.Tasks.Task<System.BinaryData> FromStreamAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public static System.BinaryData FromString(string data) => throw null;
        public override int GetHashCode() => throw null;
        public static implicit operator System.ReadOnlyMemory<byte>(System.BinaryData data) => throw null;
        public static implicit operator System.ReadOnlySpan<byte>(System.BinaryData data) => throw null;
        public byte[] ToArray() => throw null;
        public System.ReadOnlyMemory<byte> ToMemory() => throw null;
        public T ToObjectFromJson<T>(System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
        public System.IO.Stream ToStream() => throw null;
        public override string ToString() => throw null;
    }
}
