// This file contains auto-generated code.

namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.AsymmetricAlgorithm` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AsymmetricAlgorithm : System.IDisposable
            {
                protected AsymmetricAlgorithm() => throw null;
                public void Clear() => throw null;
                public static System.Security.Cryptography.AsymmetricAlgorithm Create() => throw null;
                public static System.Security.Cryptography.AsymmetricAlgorithm Create(string algName) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public virtual System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public virtual System.Byte[] ExportPkcs8PrivateKey() => throw null;
                public virtual System.Byte[] ExportSubjectPublicKeyInfo() => throw null;
                public virtual void FromXmlString(string xmlString) => throw null;
                public virtual void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Byte> passwordBytes) => throw null;
                public virtual void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> password) => throw null;
                public virtual void ImportFromPem(System.ReadOnlySpan<System.Char> input) => throw null;
                public virtual void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual string KeyExchangeAlgorithm { get => throw null; }
                public virtual int KeySize { get => throw null; set => throw null; }
                protected int KeySizeValue;
                public virtual System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                protected System.Security.Cryptography.KeySizes[] LegalKeySizesValue;
                public virtual string SignatureAlgorithm { get => throw null; }
                public virtual string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.CipherMode` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CipherMode
            {
                CBC,
                CFB,
                CTS,
                ECB,
                OFB,
            }

            // Generated from `System.Security.Cryptography.CryptoStream` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CryptoStream : System.IO.Stream, System.IDisposable
            {
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public void Clear() => throw null;
                public CryptoStream(System.IO.Stream stream, System.Security.Cryptography.ICryptoTransform transform, System.Security.Cryptography.CryptoStreamMode mode) => throw null;
                public CryptoStream(System.IO.Stream stream, System.Security.Cryptography.ICryptoTransform transform, System.Security.Cryptography.CryptoStreamMode mode, bool leaveOpen) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public void FlushFinalBlock() => throw null;
                public System.Threading.Tasks.ValueTask FlushFinalBlockAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public bool HasFlushedFinalBlock { get => throw null; }
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override int ReadByte() => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override void WriteByte(System.Byte value) => throw null;
            }

            // Generated from `System.Security.Cryptography.CryptoStreamMode` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CryptoStreamMode
            {
                Read,
                Write,
            }

            // Generated from `System.Security.Cryptography.CryptographicOperations` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class CryptographicOperations
            {
                public static bool FixedTimeEquals(System.ReadOnlySpan<System.Byte> left, System.ReadOnlySpan<System.Byte> right) => throw null;
                public static void ZeroMemory(System.Span<System.Byte> buffer) => throw null;
            }

            // Generated from `System.Security.Cryptography.CryptographicUnexpectedOperationException` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CryptographicUnexpectedOperationException : System.Security.Cryptography.CryptographicException
            {
                public CryptographicUnexpectedOperationException() => throw null;
                protected CryptographicUnexpectedOperationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CryptographicUnexpectedOperationException(string message) => throw null;
                public CryptographicUnexpectedOperationException(string message, System.Exception inner) => throw null;
                public CryptographicUnexpectedOperationException(string format, string insert) => throw null;
            }

            // Generated from `System.Security.Cryptography.HMAC` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class HMAC : System.Security.Cryptography.KeyedHashAlgorithm
            {
                protected int BlockSizeValue { get => throw null; set => throw null; }
                public static System.Security.Cryptography.HMAC Create() => throw null;
                public static System.Security.Cryptography.HMAC Create(string algorithmName) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected HMAC() => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public string HashName { get => throw null; set => throw null; }
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.HashAlgorithm` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class HashAlgorithm : System.IDisposable, System.Security.Cryptography.ICryptoTransform
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public virtual bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public System.Byte[] ComputeHash(System.Byte[] buffer) => throw null;
                public System.Byte[] ComputeHash(System.Byte[] buffer, int offset, int count) => throw null;
                public System.Byte[] ComputeHash(System.IO.Stream inputStream) => throw null;
                public System.Threading.Tasks.Task<System.Byte[]> ComputeHashAsync(System.IO.Stream inputStream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Security.Cryptography.HashAlgorithm Create() => throw null;
                public static System.Security.Cryptography.HashAlgorithm Create(string hashName) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Byte[] Hash { get => throw null; }
                protected HashAlgorithm() => throw null;
                protected abstract void HashCore(System.Byte[] array, int ibStart, int cbSize);
                protected virtual void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected abstract System.Byte[] HashFinal();
                public virtual int HashSize { get => throw null; }
                protected int HashSizeValue;
                protected internal System.Byte[] HashValue;
                public abstract void Initialize();
                public virtual int InputBlockSize { get => throw null; }
                public virtual int OutputBlockSize { get => throw null; }
                protected int State;
                public int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset) => throw null;
                public System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
                public bool TryComputeHash(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.HashAlgorithmName` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct HashAlgorithmName : System.IEquatable<System.Security.Cryptography.HashAlgorithmName>
            {
                public static bool operator !=(System.Security.Cryptography.HashAlgorithmName left, System.Security.Cryptography.HashAlgorithmName right) => throw null;
                public static bool operator ==(System.Security.Cryptography.HashAlgorithmName left, System.Security.Cryptography.HashAlgorithmName right) => throw null;
                public bool Equals(System.Security.Cryptography.HashAlgorithmName other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Security.Cryptography.HashAlgorithmName FromOid(string oidValue) => throw null;
                public override int GetHashCode() => throw null;
                // Stub generator skipped constructor 
                public HashAlgorithmName(string name) => throw null;
                public static System.Security.Cryptography.HashAlgorithmName MD5 { get => throw null; }
                public string Name { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA1 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA256 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA384 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA512 { get => throw null; }
                public override string ToString() => throw null;
                public static bool TryFromOid(string oidValue, out System.Security.Cryptography.HashAlgorithmName value) => throw null;
            }

            // Generated from `System.Security.Cryptography.ICryptoTransform` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICryptoTransform : System.IDisposable
            {
                bool CanReuseTransform { get; }
                bool CanTransformMultipleBlocks { get; }
                int InputBlockSize { get; }
                int OutputBlockSize { get; }
                int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset);
                System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount);
            }

            // Generated from `System.Security.Cryptography.KeySizes` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class KeySizes
            {
                public KeySizes(int minSize, int maxSize, int skipSize) => throw null;
                public int MaxSize { get => throw null; }
                public int MinSize { get => throw null; }
                public int SkipSize { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.KeyedHashAlgorithm` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class KeyedHashAlgorithm : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.KeyedHashAlgorithm Create() => throw null;
                public static System.Security.Cryptography.KeyedHashAlgorithm Create(string algName) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public virtual System.Byte[] Key { get => throw null; set => throw null; }
                protected System.Byte[] KeyValue;
                protected KeyedHashAlgorithm() => throw null;
            }

            // Generated from `System.Security.Cryptography.PaddingMode` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PaddingMode
            {
                ANSIX923,
                ISO10126,
                None,
                PKCS7,
                Zeros,
            }

            // Generated from `System.Security.Cryptography.PbeEncryptionAlgorithm` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PbeEncryptionAlgorithm
            {
                Aes128Cbc,
                Aes192Cbc,
                Aes256Cbc,
                TripleDes3KeyPkcs12,
                Unknown,
            }

            // Generated from `System.Security.Cryptography.PbeParameters` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PbeParameters
            {
                public System.Security.Cryptography.PbeEncryptionAlgorithm EncryptionAlgorithm { get => throw null; }
                public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                public int IterationCount { get => throw null; }
                public PbeParameters(System.Security.Cryptography.PbeEncryptionAlgorithm encryptionAlgorithm, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int iterationCount) => throw null;
            }

            // Generated from `System.Security.Cryptography.SymmetricAlgorithm` in `System.Security.Cryptography.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SymmetricAlgorithm : System.IDisposable
            {
                public virtual int BlockSize { get => throw null; set => throw null; }
                protected int BlockSizeValue;
                public void Clear() => throw null;
                public static System.Security.Cryptography.SymmetricAlgorithm Create() => throw null;
                public static System.Security.Cryptography.SymmetricAlgorithm Create(string algName) => throw null;
                public virtual System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public abstract System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV);
                public virtual System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public abstract System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV);
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual int FeedbackSize { get => throw null; set => throw null; }
                protected int FeedbackSizeValue;
                public abstract void GenerateIV();
                public abstract void GenerateKey();
                public virtual System.Byte[] IV { get => throw null; set => throw null; }
                protected System.Byte[] IVValue;
                public virtual System.Byte[] Key { get => throw null; set => throw null; }
                public virtual int KeySize { get => throw null; set => throw null; }
                protected int KeySizeValue;
                protected System.Byte[] KeyValue;
                public virtual System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                protected System.Security.Cryptography.KeySizes[] LegalBlockSizesValue;
                public virtual System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                protected System.Security.Cryptography.KeySizes[] LegalKeySizesValue;
                public virtual System.Security.Cryptography.CipherMode Mode { get => throw null; set => throw null; }
                protected System.Security.Cryptography.CipherMode ModeValue;
                public virtual System.Security.Cryptography.PaddingMode Padding { get => throw null; set => throw null; }
                protected System.Security.Cryptography.PaddingMode PaddingValue;
                protected SymmetricAlgorithm() => throw null;
                public bool ValidKeySize(int bitLength) => throw null;
            }

        }
    }
}
