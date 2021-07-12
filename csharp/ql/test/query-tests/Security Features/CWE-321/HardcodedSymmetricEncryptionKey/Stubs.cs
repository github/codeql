namespace Windows.Security.Cryptography
{
    public static class CryptographicBuffer
    {
        public static Windows.Storage.Streams.IBuffer CreateFromByteArray(byte[] value) => throw null;
    }
}

namespace Windows.Storage.Streams
{
    public interface IBuffer { }
}

namespace Windows.Security.Cryptography.Core
{
    public sealed class CryptographicKey { }

    public sealed class SymmetricKeyAlgorithmProvider
    {
        public CryptographicKey CreateSymmetricKey(Windows.Storage.Streams.IBuffer keyMaterial) => throw null;
    }
}
