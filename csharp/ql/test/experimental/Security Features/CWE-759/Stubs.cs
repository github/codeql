namespace Windows.Security.Cryptography
{
    public enum BinaryStringEncoding
    {
        Utf8,
        Utf16LE,
        Utf16BE
    }

    public static class CryptographicBuffer
    {
        public static Windows.Storage.Streams.IBuffer ConvertStringToBinary(string value, BinaryStringEncoding encoding) => throw null;

        public static string EncodeToBase64String(Windows.Storage.Streams.IBuffer buffer) => throw null;
    }
}

namespace Windows.Storage.Streams
{
    public interface IBuffer {
        public uint Capacity { get; }

        public uint Length { get; set; }
     }
}

namespace Windows.Security.Cryptography.Core
{
    public sealed class CryptographicKey { }

    public sealed class SymmetricKeyAlgorithmProvider
    {
        public CryptographicKey CreateSymmetricKey(Windows.Storage.Streams.IBuffer keyMaterial) => throw null;
    }

    public sealed class HashAlgorithmProvider {
        public string AlgorithmName { get; }

        public uint HashLength { get; }

        public static HashAlgorithmProvider OpenAlgorithm(string algorithm) => throw null;

        public Windows.Storage.Streams.IBuffer HashData(Windows.Storage.Streams.IBuffer data) => throw null;
    }
}
