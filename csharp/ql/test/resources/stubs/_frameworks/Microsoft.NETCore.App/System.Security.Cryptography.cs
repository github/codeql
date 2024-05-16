// This file contains auto-generated code.
// Generated from `System.Security.Cryptography, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public abstract class SafeNCryptHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                protected SafeNCryptHandle() : base(default(bool)) => throw null;
                protected SafeNCryptHandle(nint handle, System.Runtime.InteropServices.SafeHandle parentHandle) : base(default(bool)) => throw null;
                protected override bool ReleaseHandle() => throw null;
                protected abstract bool ReleaseNativeHandle();
            }
            public sealed class SafeNCryptKeyHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                public SafeNCryptKeyHandle() => throw null;
                public SafeNCryptKeyHandle(nint handle, System.Runtime.InteropServices.SafeHandle parentHandle) => throw null;
                protected override bool ReleaseNativeHandle() => throw null;
            }
            public sealed class SafeNCryptProviderHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                public SafeNCryptProviderHandle() => throw null;
                protected override bool ReleaseNativeHandle() => throw null;
            }
            public sealed class SafeNCryptSecretHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                public SafeNCryptSecretHandle() => throw null;
                protected override bool ReleaseNativeHandle() => throw null;
            }
            public sealed class SafeX509ChainHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public SafeX509ChainHandle() : base(default(bool)) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override bool ReleaseHandle() => throw null;
            }
        }
    }
}
namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            public abstract class Aes : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.Aes Create() => throw null;
                public static System.Security.Cryptography.Aes Create(string algorithmName) => throw null;
                protected Aes() => throw null;
            }
            public sealed class AesCcm : System.IDisposable
            {
                public AesCcm(byte[] key) => throw null;
                public AesCcm(System.ReadOnlySpan<byte> key) => throw null;
                public void Decrypt(byte[] nonce, byte[] ciphertext, byte[] tag, byte[] plaintext, byte[] associatedData = default(byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<byte> nonce, System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> tag, System.Span<byte> plaintext, System.ReadOnlySpan<byte> associatedData = default(System.ReadOnlySpan<byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(byte[] nonce, byte[] plaintext, byte[] ciphertext, byte[] tag, byte[] associatedData = default(byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<byte> nonce, System.ReadOnlySpan<byte> plaintext, System.Span<byte> ciphertext, System.Span<byte> tag, System.ReadOnlySpan<byte> associatedData = default(System.ReadOnlySpan<byte>)) => throw null;
                public static bool IsSupported { get => throw null; }
                public static System.Security.Cryptography.KeySizes NonceByteSizes { get => throw null; }
                public static System.Security.Cryptography.KeySizes TagByteSizes { get => throw null; }
            }
            public sealed class AesCng : System.Security.Cryptography.Aes
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public AesCng() => throw null;
                public AesCng(string keyName) => throw null;
                public AesCng(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public AesCng(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                protected override bool TryDecryptCbcCore(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryDecryptCfbCore(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryDecryptEcbCore(System.ReadOnlySpan<byte> ciphertext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCbcCore(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCfbCore(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryEncryptEcbCore(System.ReadOnlySpan<byte> plaintext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
            }
            public sealed class AesCryptoServiceProvider : System.Security.Cryptography.Aes
            {
                public override int BlockSize { get => throw null; set { } }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public AesCryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set { } }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override byte[] IV { get => throw null; set { } }
                public override byte[] Key { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                public override System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set { } }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set { } }
            }
            public sealed class AesGcm : System.IDisposable
            {
                public AesGcm(byte[] key) => throw null;
                public AesGcm(byte[] key, int tagSizeInBytes) => throw null;
                public AesGcm(System.ReadOnlySpan<byte> key) => throw null;
                public AesGcm(System.ReadOnlySpan<byte> key, int tagSizeInBytes) => throw null;
                public void Decrypt(byte[] nonce, byte[] ciphertext, byte[] tag, byte[] plaintext, byte[] associatedData = default(byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<byte> nonce, System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> tag, System.Span<byte> plaintext, System.ReadOnlySpan<byte> associatedData = default(System.ReadOnlySpan<byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(byte[] nonce, byte[] plaintext, byte[] ciphertext, byte[] tag, byte[] associatedData = default(byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<byte> nonce, System.ReadOnlySpan<byte> plaintext, System.Span<byte> ciphertext, System.Span<byte> tag, System.ReadOnlySpan<byte> associatedData = default(System.ReadOnlySpan<byte>)) => throw null;
                public static bool IsSupported { get => throw null; }
                public static System.Security.Cryptography.KeySizes NonceByteSizes { get => throw null; }
                public static System.Security.Cryptography.KeySizes TagByteSizes { get => throw null; }
                public int? TagSizeInBytes { get => throw null; }
            }
            public sealed class AesManaged : System.Security.Cryptography.Aes
            {
                public override int BlockSize { get => throw null; set { } }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public AesManaged() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set { } }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override byte[] IV { get => throw null; set { } }
                public override byte[] Key { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                public override System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set { } }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set { } }
            }
            public class AsnEncodedData
            {
                public virtual void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                protected AsnEncodedData() => throw null;
                public AsnEncodedData(byte[] rawData) => throw null;
                public AsnEncodedData(System.ReadOnlySpan<byte> rawData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.Oid oid, byte[] rawData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.Oid oid, System.ReadOnlySpan<byte> rawData) => throw null;
                public AsnEncodedData(string oid, byte[] rawData) => throw null;
                public AsnEncodedData(string oid, System.ReadOnlySpan<byte> rawData) => throw null;
                public virtual string Format(bool multiLine) => throw null;
                public System.Security.Cryptography.Oid Oid { get => throw null; set { } }
                public byte[] RawData { get => throw null; set { } }
            }
            public sealed class AsnEncodedDataCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public void CopyTo(System.Security.Cryptography.AsnEncodedData[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public AsnEncodedDataCollection() => throw null;
                public AsnEncodedDataCollection(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public System.Security.Cryptography.AsnEncodedDataEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public void Remove(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public object SyncRoot { get => throw null; }
                public System.Security.Cryptography.AsnEncodedData this[int index] { get => throw null; }
            }
            public sealed class AsnEncodedDataEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.AsnEncodedData Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            public abstract class AsymmetricAlgorithm : System.IDisposable
            {
                public void Clear() => throw null;
                public static System.Security.Cryptography.AsymmetricAlgorithm Create() => throw null;
                public static System.Security.Cryptography.AsymmetricAlgorithm Create(string algName) => throw null;
                protected AsymmetricAlgorithm() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public virtual byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public string ExportEncryptedPkcs8PrivateKeyPem(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public string ExportEncryptedPkcs8PrivateKeyPem(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public virtual byte[] ExportPkcs8PrivateKey() => throw null;
                public string ExportPkcs8PrivateKeyPem() => throw null;
                public virtual byte[] ExportSubjectPublicKeyInfo() => throw null;
                public string ExportSubjectPublicKeyInfoPem() => throw null;
                public virtual void FromXmlString(string xmlString) => throw null;
                public virtual void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<byte> passwordBytes) => throw null;
                public virtual void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<char> password) => throw null;
                public virtual void ImportFromPem(System.ReadOnlySpan<char> input) => throw null;
                public virtual void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual string KeyExchangeAlgorithm { get => throw null; }
                public virtual int KeySize { get => throw null; set { } }
                protected int KeySizeValue;
                public virtual System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                protected System.Security.Cryptography.KeySizes[] LegalKeySizesValue;
                public virtual string SignatureAlgorithm { get => throw null; }
                public virtual string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryExportEncryptedPkcs8PrivateKeyPem(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<char> destination, out int charsWritten) => throw null;
                public bool TryExportEncryptedPkcs8PrivateKeyPem(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<char> destination, out int charsWritten) => throw null;
                public virtual bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryExportPkcs8PrivateKeyPem(System.Span<char> destination, out int charsWritten) => throw null;
                public virtual bool TryExportSubjectPublicKeyInfo(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryExportSubjectPublicKeyInfoPem(System.Span<char> destination, out int charsWritten) => throw null;
            }
            public abstract class AsymmetricKeyExchangeDeformatter
            {
                protected AsymmetricKeyExchangeDeformatter() => throw null;
                public abstract byte[] DecryptKeyExchange(byte[] rgb);
                public abstract string Parameters { get; set; }
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }
            public abstract class AsymmetricKeyExchangeFormatter
            {
                public abstract byte[] CreateKeyExchange(byte[] data);
                public abstract byte[] CreateKeyExchange(byte[] data, System.Type symAlgType);
                protected AsymmetricKeyExchangeFormatter() => throw null;
                public abstract string Parameters { get; }
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }
            public abstract class AsymmetricSignatureDeformatter
            {
                protected AsymmetricSignatureDeformatter() => throw null;
                public abstract void SetHashAlgorithm(string strName);
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
                public abstract bool VerifySignature(byte[] rgbHash, byte[] rgbSignature);
                public virtual bool VerifySignature(System.Security.Cryptography.HashAlgorithm hash, byte[] rgbSignature) => throw null;
            }
            public abstract class AsymmetricSignatureFormatter
            {
                public abstract byte[] CreateSignature(byte[] rgbHash);
                public virtual byte[] CreateSignature(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                protected AsymmetricSignatureFormatter() => throw null;
                public abstract void SetHashAlgorithm(string strName);
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }
            public sealed class AuthenticationTagMismatchException : System.Security.Cryptography.CryptographicException
            {
                public AuthenticationTagMismatchException() => throw null;
                public AuthenticationTagMismatchException(string message) => throw null;
                public AuthenticationTagMismatchException(string message, System.Exception inner) => throw null;
            }
            public sealed class ChaCha20Poly1305 : System.IDisposable
            {
                public ChaCha20Poly1305(byte[] key) => throw null;
                public ChaCha20Poly1305(System.ReadOnlySpan<byte> key) => throw null;
                public void Decrypt(byte[] nonce, byte[] ciphertext, byte[] tag, byte[] plaintext, byte[] associatedData = default(byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<byte> nonce, System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> tag, System.Span<byte> plaintext, System.ReadOnlySpan<byte> associatedData = default(System.ReadOnlySpan<byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(byte[] nonce, byte[] plaintext, byte[] ciphertext, byte[] tag, byte[] associatedData = default(byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<byte> nonce, System.ReadOnlySpan<byte> plaintext, System.Span<byte> ciphertext, System.Span<byte> tag, System.ReadOnlySpan<byte> associatedData = default(System.ReadOnlySpan<byte>)) => throw null;
                public static bool IsSupported { get => throw null; }
            }
            public enum CipherMode
            {
                CBC = 1,
                ECB = 2,
                OFB = 3,
                CFB = 4,
                CTS = 5,
            }
            public sealed class CngAlgorithm : System.IEquatable<System.Security.Cryptography.CngAlgorithm>
            {
                public string Algorithm { get => throw null; }
                public CngAlgorithm(string algorithm) => throw null;
                public static System.Security.Cryptography.CngAlgorithm ECDiffieHellman { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDiffieHellmanP256 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDiffieHellmanP384 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDiffieHellmanP521 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDsa { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDsaP256 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDsaP384 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm ECDsaP521 { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngAlgorithm other) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngAlgorithm MD5 { get => throw null; }
                public static bool operator ==(System.Security.Cryptography.CngAlgorithm left, System.Security.Cryptography.CngAlgorithm right) => throw null;
                public static bool operator !=(System.Security.Cryptography.CngAlgorithm left, System.Security.Cryptography.CngAlgorithm right) => throw null;
                public static System.Security.Cryptography.CngAlgorithm Rsa { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha1 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha256 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha384 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha512 { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class CngAlgorithmGroup : System.IEquatable<System.Security.Cryptography.CngAlgorithmGroup>
            {
                public string AlgorithmGroup { get => throw null; }
                public CngAlgorithmGroup(string algorithmGroup) => throw null;
                public static System.Security.Cryptography.CngAlgorithmGroup DiffieHellman { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithmGroup Dsa { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithmGroup ECDiffieHellman { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithmGroup ECDsa { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngAlgorithmGroup other) => throw null;
                public override int GetHashCode() => throw null;
                public static bool operator ==(System.Security.Cryptography.CngAlgorithmGroup left, System.Security.Cryptography.CngAlgorithmGroup right) => throw null;
                public static bool operator !=(System.Security.Cryptography.CngAlgorithmGroup left, System.Security.Cryptography.CngAlgorithmGroup right) => throw null;
                public static System.Security.Cryptography.CngAlgorithmGroup Rsa { get => throw null; }
                public override string ToString() => throw null;
            }
            [System.Flags]
            public enum CngExportPolicies
            {
                None = 0,
                AllowExport = 1,
                AllowPlaintextExport = 2,
                AllowArchiving = 4,
                AllowPlaintextArchiving = 8,
            }
            public sealed class CngKey : System.IDisposable
            {
                public System.Security.Cryptography.CngAlgorithm Algorithm { get => throw null; }
                public System.Security.Cryptography.CngAlgorithmGroup AlgorithmGroup { get => throw null; }
                public static System.Security.Cryptography.CngKey Create(System.Security.Cryptography.CngAlgorithm algorithm) => throw null;
                public static System.Security.Cryptography.CngKey Create(System.Security.Cryptography.CngAlgorithm algorithm, string keyName) => throw null;
                public static System.Security.Cryptography.CngKey Create(System.Security.Cryptography.CngAlgorithm algorithm, string keyName, System.Security.Cryptography.CngKeyCreationParameters creationParameters) => throw null;
                public void Delete() => throw null;
                public void Dispose() => throw null;
                public static bool Exists(string keyName) => throw null;
                public static bool Exists(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public static bool Exists(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions options) => throw null;
                public byte[] Export(System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public System.Security.Cryptography.CngExportPolicies ExportPolicy { get => throw null; }
                public System.Security.Cryptography.CngProperty GetProperty(string name, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle Handle { get => throw null; }
                public bool HasProperty(string name, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public static System.Security.Cryptography.CngKey Import(byte[] keyBlob, System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public static System.Security.Cryptography.CngKey Import(byte[] keyBlob, System.Security.Cryptography.CngKeyBlobFormat format, System.Security.Cryptography.CngProvider provider) => throw null;
                public bool IsEphemeral { get => throw null; }
                public bool IsMachineKey { get => throw null; }
                public string KeyName { get => throw null; }
                public int KeySize { get => throw null; }
                public System.Security.Cryptography.CngKeyUsages KeyUsage { get => throw null; }
                public static System.Security.Cryptography.CngKey Open(Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle keyHandle, System.Security.Cryptography.CngKeyHandleOpenOptions keyHandleOpenOptions) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                public nint ParentWindowHandle { get => throw null; set { } }
                public System.Security.Cryptography.CngProvider Provider { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeNCryptProviderHandle ProviderHandle { get => throw null; }
                public void SetProperty(System.Security.Cryptography.CngProperty property) => throw null;
                public System.Security.Cryptography.CngUIPolicy UIPolicy { get => throw null; }
                public string UniqueName { get => throw null; }
            }
            public sealed class CngKeyBlobFormat : System.IEquatable<System.Security.Cryptography.CngKeyBlobFormat>
            {
                public CngKeyBlobFormat(string format) => throw null;
                public static System.Security.Cryptography.CngKeyBlobFormat EccFullPrivateBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat EccFullPublicBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat EccPrivateBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat EccPublicBlob { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngKeyBlobFormat other) => throw null;
                public string Format { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat GenericPrivateBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat GenericPublicBlob { get => throw null; }
                public override int GetHashCode() => throw null;
                public static bool operator ==(System.Security.Cryptography.CngKeyBlobFormat left, System.Security.Cryptography.CngKeyBlobFormat right) => throw null;
                public static bool operator !=(System.Security.Cryptography.CngKeyBlobFormat left, System.Security.Cryptography.CngKeyBlobFormat right) => throw null;
                public static System.Security.Cryptography.CngKeyBlobFormat OpaqueTransportBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat Pkcs8PrivateBlob { get => throw null; }
                public override string ToString() => throw null;
            }
            [System.Flags]
            public enum CngKeyCreationOptions
            {
                None = 0,
                MachineKey = 32,
                OverwriteExistingKey = 128,
            }
            public sealed class CngKeyCreationParameters
            {
                public CngKeyCreationParameters() => throw null;
                public System.Security.Cryptography.CngExportPolicies? ExportPolicy { get => throw null; set { } }
                public System.Security.Cryptography.CngKeyCreationOptions KeyCreationOptions { get => throw null; set { } }
                public System.Security.Cryptography.CngKeyUsages? KeyUsage { get => throw null; set { } }
                public System.Security.Cryptography.CngPropertyCollection Parameters { get => throw null; }
                public nint ParentWindowHandle { get => throw null; set { } }
                public System.Security.Cryptography.CngProvider Provider { get => throw null; set { } }
                public System.Security.Cryptography.CngUIPolicy UIPolicy { get => throw null; set { } }
            }
            [System.Flags]
            public enum CngKeyHandleOpenOptions
            {
                None = 0,
                EphemeralKey = 1,
            }
            [System.Flags]
            public enum CngKeyOpenOptions
            {
                None = 0,
                UserKey = 0,
                MachineKey = 32,
                Silent = 64,
            }
            [System.Flags]
            public enum CngKeyUsages
            {
                None = 0,
                Decryption = 1,
                Signing = 2,
                KeyAgreement = 4,
                AllUsages = 16777215,
            }
            public struct CngProperty : System.IEquatable<System.Security.Cryptography.CngProperty>
            {
                public CngProperty(string name, byte[] value, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngProperty other) => throw null;
                public override int GetHashCode() => throw null;
                public byte[] GetValue() => throw null;
                public string Name { get => throw null; }
                public static bool operator ==(System.Security.Cryptography.CngProperty left, System.Security.Cryptography.CngProperty right) => throw null;
                public static bool operator !=(System.Security.Cryptography.CngProperty left, System.Security.Cryptography.CngProperty right) => throw null;
                public System.Security.Cryptography.CngPropertyOptions Options { get => throw null; }
            }
            public sealed class CngPropertyCollection : System.Collections.ObjectModel.Collection<System.Security.Cryptography.CngProperty>
            {
                public CngPropertyCollection() => throw null;
            }
            [System.Flags]
            public enum CngPropertyOptions
            {
                Persist = -2147483648,
                None = 0,
                CustomProperty = 1073741824,
            }
            public sealed class CngProvider : System.IEquatable<System.Security.Cryptography.CngProvider>
            {
                public CngProvider(string provider) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngProvider other) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngProvider MicrosoftPlatformCryptoProvider { get => throw null; }
                public static System.Security.Cryptography.CngProvider MicrosoftSmartCardKeyStorageProvider { get => throw null; }
                public static System.Security.Cryptography.CngProvider MicrosoftSoftwareKeyStorageProvider { get => throw null; }
                public static bool operator ==(System.Security.Cryptography.CngProvider left, System.Security.Cryptography.CngProvider right) => throw null;
                public static bool operator !=(System.Security.Cryptography.CngProvider left, System.Security.Cryptography.CngProvider right) => throw null;
                public string Provider { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class CngUIPolicy
            {
                public string CreationTitle { get => throw null; }
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description, string useContext) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description, string useContext, string creationTitle) => throw null;
                public string Description { get => throw null; }
                public string FriendlyName { get => throw null; }
                public System.Security.Cryptography.CngUIProtectionLevels ProtectionLevel { get => throw null; }
                public string UseContext { get => throw null; }
            }
            [System.Flags]
            public enum CngUIProtectionLevels
            {
                None = 0,
                ProtectKey = 1,
                ForceHighProtection = 2,
            }
            public class CryptoConfig
            {
                public static void AddAlgorithm(System.Type algorithm, params string[] names) => throw null;
                public static void AddOID(string oid, params string[] names) => throw null;
                public static bool AllowOnlyFipsAlgorithms { get => throw null; }
                public static object CreateFromName(string name) => throw null;
                public static object CreateFromName(string name, params object[] args) => throw null;
                public CryptoConfig() => throw null;
                public static byte[] EncodeOID(string str) => throw null;
                public static string MapNameToOID(string name) => throw null;
            }
            public static class CryptographicOperations
            {
                public static bool FixedTimeEquals(System.ReadOnlySpan<byte> left, System.ReadOnlySpan<byte> right) => throw null;
                public static void ZeroMemory(System.Span<byte> buffer) => throw null;
            }
            public class CryptographicUnexpectedOperationException : System.Security.Cryptography.CryptographicException
            {
                public CryptographicUnexpectedOperationException() => throw null;
                protected CryptographicUnexpectedOperationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CryptographicUnexpectedOperationException(string message) => throw null;
                public CryptographicUnexpectedOperationException(string message, System.Exception inner) => throw null;
                public CryptographicUnexpectedOperationException(string format, string insert) => throw null;
            }
            public class CryptoStream : System.IO.Stream, System.IDisposable
            {
                public override System.IAsyncResult BeginRead(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public void Clear() => throw null;
                public override void CopyTo(System.IO.Stream destination, int bufferSize) => throw null;
                public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
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
                public override long Length { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(byte value) => throw null;
            }
            public enum CryptoStreamMode
            {
                Read = 0,
                Write = 1,
            }
            public sealed class CspKeyContainerInfo
            {
                public bool Accessible { get => throw null; }
                public CspKeyContainerInfo(System.Security.Cryptography.CspParameters parameters) => throw null;
                public bool Exportable { get => throw null; }
                public bool HardwareDevice { get => throw null; }
                public string KeyContainerName { get => throw null; }
                public System.Security.Cryptography.KeyNumber KeyNumber { get => throw null; }
                public bool MachineKeyStore { get => throw null; }
                public bool Protected { get => throw null; }
                public string ProviderName { get => throw null; }
                public int ProviderType { get => throw null; }
                public bool RandomlyGenerated { get => throw null; }
                public bool Removable { get => throw null; }
                public string UniqueKeyContainerName { get => throw null; }
            }
            public sealed class CspParameters
            {
                public CspParameters() => throw null;
                public CspParameters(int dwTypeIn) => throw null;
                public CspParameters(int dwTypeIn, string strProviderNameIn) => throw null;
                public CspParameters(int dwTypeIn, string strProviderNameIn, string strContainerNameIn) => throw null;
                public System.Security.Cryptography.CspProviderFlags Flags { get => throw null; set { } }
                public string KeyContainerName;
                public int KeyNumber;
                public System.Security.SecureString KeyPassword { get => throw null; set { } }
                public nint ParentWindowHandle { get => throw null; set { } }
                public string ProviderName;
                public int ProviderType;
            }
            [System.Flags]
            public enum CspProviderFlags
            {
                NoFlags = 0,
                UseMachineKeyStore = 1,
                UseDefaultKeyContainer = 2,
                UseNonExportableKey = 4,
                UseExistingKey = 8,
                UseArchivableKey = 16,
                UseUserProtectedKey = 32,
                NoPrompt = 64,
                CreateEphemeralKey = 128,
            }
            public abstract class DeriveBytes : System.IDisposable
            {
                protected DeriveBytes() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public abstract byte[] GetBytes(int cb);
                public abstract void Reset();
            }
            public abstract class DES : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.DES Create() => throw null;
                public static System.Security.Cryptography.DES Create(string algName) => throw null;
                protected DES() => throw null;
                public static bool IsSemiWeakKey(byte[] rgbKey) => throw null;
                public static bool IsWeakKey(byte[] rgbKey) => throw null;
                public override byte[] Key { get => throw null; set { } }
            }
            public sealed class DESCryptoServiceProvider : System.Security.Cryptography.DES
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public DESCryptoServiceProvider() => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
            }
            public abstract class DSA : System.Security.Cryptography.AsymmetricAlgorithm
            {
                public static System.Security.Cryptography.DSA Create() => throw null;
                public static System.Security.Cryptography.DSA Create(int keySizeInBits) => throw null;
                public static System.Security.Cryptography.DSA Create(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public static System.Security.Cryptography.DSA Create(string algName) => throw null;
                public abstract byte[] CreateSignature(byte[] rgbHash);
                public byte[] CreateSignature(byte[] rgbHash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] CreateSignatureCore(System.ReadOnlySpan<byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected DSA() => throw null;
                public abstract System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters);
                public override void FromXmlString(string xmlString) => throw null;
                public int GetMaxSignatureSize(System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] HashData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<char> input) => throw null;
                public abstract void ImportParameters(System.Security.Cryptography.DSAParameters parameters);
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual byte[] SignData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public byte[] SignData(byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] SignDataCore(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] SignDataCore(System.ReadOnlySpan<byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryCreateSignature(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryCreateSignature(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                protected virtual bool TryCreateSignatureCore(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryHashData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public virtual bool TrySignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public bool TrySignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                protected virtual bool TrySignDataCore(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool VerifyData(byte[] data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(byte[] data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(byte[] data, int offset, int count, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(byte[] data, int offset, int count, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.IO.Stream data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.IO.Stream data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.IO.Stream data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract bool VerifySignature(byte[] rgbHash, byte[] rgbSignature);
                public bool VerifySignature(byte[] rgbHash, byte[] rgbSignature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifySignature(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature) => throw null;
                public bool VerifySignature(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifySignatureCore(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }
            public sealed class DSACng : System.Security.Cryptography.DSA
            {
                public override byte[] CreateSignature(byte[] rgbHash) => throw null;
                public DSACng() => throw null;
                public DSACng(int keySize) => throw null;
                public DSACng(System.Security.Cryptography.CngKey key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                protected override bool TryCreateSignatureCore(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool VerifySignature(byte[] rgbHash, byte[] rgbSignature) => throw null;
                protected override bool VerifySignatureCore(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }
            public sealed class DSACryptoServiceProvider : System.Security.Cryptography.DSA, System.Security.Cryptography.ICspAsymmetricAlgorithm
            {
                public override byte[] CreateSignature(byte[] rgbHash) => throw null;
                public System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get => throw null; }
                public DSACryptoServiceProvider() => throw null;
                public DSACryptoServiceProvider(int dwKeySize) => throw null;
                public DSACryptoServiceProvider(int dwKeySize, System.Security.Cryptography.CspParameters parameters) => throw null;
                public DSACryptoServiceProvider(System.Security.Cryptography.CspParameters parameters) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public byte[] ExportCspBlob(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                protected override byte[] HashData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public void ImportCspBlob(byte[] keyBlob) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override int KeySize { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public bool PersistKeyInCsp { get => throw null; set { } }
                public bool PublicOnly { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                public byte[] SignData(byte[] buffer) => throw null;
                public byte[] SignData(byte[] buffer, int offset, int count) => throw null;
                public byte[] SignData(System.IO.Stream inputStream) => throw null;
                public byte[] SignHash(byte[] rgbHash, string str) => throw null;
                public static bool UseMachineKeyStore { get => throw null; set { } }
                public bool VerifyData(byte[] rgbData, byte[] rgbSignature) => throw null;
                public bool VerifyHash(byte[] rgbHash, string str, byte[] rgbSignature) => throw null;
                public override bool VerifySignature(byte[] rgbHash, byte[] rgbSignature) => throw null;
            }
            public sealed class DSAOpenSsl : System.Security.Cryptography.DSA
            {
                public override byte[] CreateSignature(byte[] rgbHash) => throw null;
                public DSAOpenSsl() => throw null;
                public DSAOpenSsl(int keySize) => throw null;
                public DSAOpenSsl(nint handle) => throw null;
                public DSAOpenSsl(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public DSAOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public override bool VerifySignature(byte[] rgbHash, byte[] rgbSignature) => throw null;
            }
            public struct DSAParameters
            {
                public int Counter;
                public byte[] G;
                public byte[] J;
                public byte[] P;
                public byte[] Q;
                public byte[] Seed;
                public byte[] X;
                public byte[] Y;
            }
            public class DSASignatureDeformatter : System.Security.Cryptography.AsymmetricSignatureDeformatter
            {
                public DSASignatureDeformatter() => throw null;
                public DSASignatureDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override bool VerifySignature(byte[] rgbHash, byte[] rgbSignature) => throw null;
            }
            public enum DSASignatureFormat
            {
                IeeeP1363FixedFieldConcatenation = 0,
                Rfc3279DerSequence = 1,
            }
            public class DSASignatureFormatter : System.Security.Cryptography.AsymmetricSignatureFormatter
            {
                public override byte[] CreateSignature(byte[] rgbHash) => throw null;
                public DSASignatureFormatter() => throw null;
                public DSASignatureFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }
            public abstract class ECAlgorithm : System.Security.Cryptography.AsymmetricAlgorithm
            {
                protected ECAlgorithm() => throw null;
                public virtual byte[] ExportECPrivateKey() => throw null;
                public string ExportECPrivateKeyPem() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public virtual void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public virtual void ImportECPrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<char> input) => throw null;
                public virtual void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual bool TryExportECPrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryExportECPrivateKeyPem(System.Span<char> destination, out int charsWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public struct ECCurve
            {
                public byte[] A;
                public byte[] B;
                public byte[] Cofactor;
                public static System.Security.Cryptography.ECCurve CreateFromFriendlyName(string oidFriendlyName) => throw null;
                public static System.Security.Cryptography.ECCurve CreateFromOid(System.Security.Cryptography.Oid curveOid) => throw null;
                public static System.Security.Cryptography.ECCurve CreateFromValue(string oidValue) => throw null;
                public System.Security.Cryptography.ECCurve.ECCurveType CurveType;
                public enum ECCurveType
                {
                    Implicit = 0,
                    PrimeShortWeierstrass = 1,
                    PrimeTwistedEdwards = 2,
                    PrimeMontgomery = 3,
                    Characteristic2 = 4,
                    Named = 5,
                }
                public System.Security.Cryptography.ECPoint G;
                public System.Security.Cryptography.HashAlgorithmName? Hash;
                public bool IsCharacteristic2 { get => throw null; }
                public bool IsExplicit { get => throw null; }
                public bool IsNamed { get => throw null; }
                public bool IsPrime { get => throw null; }
                public static class NamedCurves
                {
                    public static System.Security.Cryptography.ECCurve brainpoolP160r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP160t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP192r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP192t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP224r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP224t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP256r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP256t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP320r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP320t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP384r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP384t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP512r1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve brainpoolP512t1 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve nistP256 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve nistP384 { get => throw null; }
                    public static System.Security.Cryptography.ECCurve nistP521 { get => throw null; }
                }
                public System.Security.Cryptography.Oid Oid { get => throw null; }
                public byte[] Order;
                public byte[] Polynomial;
                public byte[] Prime;
                public byte[] Seed;
                public void Validate() => throw null;
            }
            public abstract class ECDiffieHellman : System.Security.Cryptography.ECAlgorithm
            {
                public static System.Security.Cryptography.ECDiffieHellman Create() => throw null;
                public static System.Security.Cryptography.ECDiffieHellman Create(System.Security.Cryptography.ECCurve curve) => throw null;
                public static System.Security.Cryptography.ECDiffieHellman Create(System.Security.Cryptography.ECParameters parameters) => throw null;
                public static System.Security.Cryptography.ECDiffieHellman Create(string algorithm) => throw null;
                protected ECDiffieHellman() => throw null;
                public byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public virtual byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] secretPrepend, byte[] secretAppend) => throw null;
                public byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] hmacKey) => throw null;
                public virtual byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] hmacKey, byte[] secretPrepend, byte[] secretAppend) => throw null;
                public virtual byte[] DeriveKeyMaterial(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public virtual byte[] DeriveKeyTls(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, byte[] prfLabel, byte[] prfSeed) => throw null;
                public virtual byte[] DeriveRawSecretAgreement(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public override void FromXmlString(string xmlString) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public abstract System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get; }
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
            }
            public sealed class ECDiffieHellmanCng : System.Security.Cryptography.ECDiffieHellman
            {
                public ECDiffieHellmanCng() => throw null;
                public ECDiffieHellmanCng(int keySize) => throw null;
                public ECDiffieHellmanCng(System.Security.Cryptography.CngKey key) => throw null;
                public ECDiffieHellmanCng(System.Security.Cryptography.ECCurve curve) => throw null;
                public override byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] secretPrepend, byte[] secretAppend) => throw null;
                public override byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] hmacKey, byte[] secretPrepend, byte[] secretAppend) => throw null;
                public byte[] DeriveKeyMaterial(System.Security.Cryptography.CngKey otherPartyPublicKey) => throw null;
                public override byte[] DeriveKeyMaterial(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public override byte[] DeriveKeyTls(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, byte[] prfLabel, byte[] prfSeed) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle DeriveSecretAgreementHandle(System.Security.Cryptography.CngKey otherPartyPublicKey) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle DeriveSecretAgreementHandle(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void FromXmlString(string xml, System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public System.Security.Cryptography.CngAlgorithm HashAlgorithm { get => throw null; set { } }
                public byte[] HmacKey { get => throw null; set { } }
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public System.Security.Cryptography.ECDiffieHellmanKeyDerivationFunction KeyDerivationFunction { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                public byte[] Label { get => throw null; set { } }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get => throw null; }
                public byte[] SecretAppend { get => throw null; set { } }
                public byte[] SecretPrepend { get => throw null; set { } }
                public byte[] Seed { get => throw null; set { } }
                public string ToXmlString(System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool UseSecretAgreementAsHmacKey { get => throw null; }
            }
            public sealed class ECDiffieHellmanCngPublicKey : System.Security.Cryptography.ECDiffieHellmanPublicKey
            {
                public System.Security.Cryptography.CngKeyBlobFormat BlobFormat { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters() => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters() => throw null;
                public static System.Security.Cryptography.ECDiffieHellmanPublicKey FromByteArray(byte[] publicKeyBlob, System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public static System.Security.Cryptography.ECDiffieHellmanCngPublicKey FromXmlString(string xml) => throw null;
                public System.Security.Cryptography.CngKey Import() => throw null;
                public override string ToXmlString() => throw null;
            }
            public enum ECDiffieHellmanKeyDerivationFunction
            {
                Hash = 0,
                Hmac = 1,
                Tls = 2,
            }
            public sealed class ECDiffieHellmanOpenSsl : System.Security.Cryptography.ECDiffieHellman
            {
                public ECDiffieHellmanOpenSsl() => throw null;
                public ECDiffieHellmanOpenSsl(int keySize) => throw null;
                public ECDiffieHellmanOpenSsl(nint handle) => throw null;
                public ECDiffieHellmanOpenSsl(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDiffieHellmanOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get => throw null; }
            }
            public abstract class ECDiffieHellmanPublicKey : System.IDisposable
            {
                protected ECDiffieHellmanPublicKey() => throw null;
                protected ECDiffieHellmanPublicKey(byte[] keyBlob) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters() => throw null;
                public virtual byte[] ExportSubjectPublicKeyInfo() => throw null;
                public virtual byte[] ToByteArray() => throw null;
                public virtual string ToXmlString() => throw null;
                public virtual bool TryExportSubjectPublicKeyInfo(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class ECDsa : System.Security.Cryptography.ECAlgorithm
            {
                public static System.Security.Cryptography.ECDsa Create() => throw null;
                public static System.Security.Cryptography.ECDsa Create(System.Security.Cryptography.ECCurve curve) => throw null;
                public static System.Security.Cryptography.ECDsa Create(System.Security.Cryptography.ECParameters parameters) => throw null;
                public static System.Security.Cryptography.ECDsa Create(string algorithm) => throw null;
                protected ECDsa() => throw null;
                public override void FromXmlString(string xmlString) => throw null;
                public int GetMaxSignatureSize(System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] HashData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                public virtual byte[] SignData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual byte[] SignData(byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public byte[] SignData(System.ReadOnlySpan<byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public byte[] SignData(System.ReadOnlySpan<byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public int SignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public int SignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] SignDataCore(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] SignDataCore(System.ReadOnlySpan<byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract byte[] SignHash(byte[] hash);
                public byte[] SignHash(byte[] hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public byte[] SignHash(System.ReadOnlySpan<byte> hash) => throw null;
                public byte[] SignHash(System.ReadOnlySpan<byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public int SignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination) => throw null;
                public int SignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual byte[] SignHashCore(System.ReadOnlySpan<byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                protected virtual bool TryHashData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public virtual bool TrySignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public bool TrySignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                protected virtual bool TrySignDataCore(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public virtual bool TrySignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TrySignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                protected virtual bool TrySignHashCore(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool VerifyData(byte[] data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(byte[] data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(byte[] data, int offset, int count, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(byte[] data, int offset, int count, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public bool VerifyData(System.IO.Stream data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.IO.Stream data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.IO.Stream data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract bool VerifyHash(byte[] hash, byte[] signature);
                public bool VerifyHash(byte[] hash, byte[] signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyHash(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature) => throw null;
                public bool VerifyHash(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyHashCore(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }
            public sealed class ECDsaCng : System.Security.Cryptography.ECDsa
            {
                public ECDsaCng() => throw null;
                public ECDsaCng(int keySize) => throw null;
                public ECDsaCng(System.Security.Cryptography.CngKey key) => throw null;
                public ECDsaCng(System.Security.Cryptography.ECCurve curve) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void FromXmlString(string xml, System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public System.Security.Cryptography.CngAlgorithm HashAlgorithm { get => throw null; set { } }
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override int KeySize { get => throw null; set { } }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public byte[] SignData(byte[] data) => throw null;
                public byte[] SignData(byte[] data, int offset, int count) => throw null;
                public byte[] SignData(System.IO.Stream data) => throw null;
                public override byte[] SignHash(byte[] hash) => throw null;
                public string ToXmlString(System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TrySignHash(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TrySignHashCore(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool VerifyData(byte[] data, byte[] signature) => throw null;
                public bool VerifyData(byte[] data, int offset, int count, byte[] signature) => throw null;
                public bool VerifyData(System.IO.Stream data, byte[] signature) => throw null;
                public override bool VerifyHash(byte[] hash, byte[] signature) => throw null;
                public override bool VerifyHash(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature) => throw null;
                protected override bool VerifyHashCore(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }
            public sealed class ECDsaOpenSsl : System.Security.Cryptography.ECDsa
            {
                public ECDsaOpenSsl() => throw null;
                public ECDsaOpenSsl(int keySize) => throw null;
                public ECDsaOpenSsl(nint handle) => throw null;
                public ECDsaOpenSsl(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDsaOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override byte[] SignHash(byte[] hash) => throw null;
                public override bool VerifyHash(byte[] hash, byte[] signature) => throw null;
            }
            public enum ECKeyXmlFormat
            {
                Rfc4050 = 0,
            }
            public struct ECParameters
            {
                public System.Security.Cryptography.ECCurve Curve;
                public byte[] D;
                public System.Security.Cryptography.ECPoint Q;
                public void Validate() => throw null;
            }
            public struct ECPoint
            {
                public byte[] X;
                public byte[] Y;
            }
            public class FromBase64Transform : System.Security.Cryptography.ICryptoTransform, System.IDisposable
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public FromBase64Transform() => throw null;
                public FromBase64Transform(System.Security.Cryptography.FromBase64TransformMode whitespaces) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public int InputBlockSize { get => throw null; }
                public int OutputBlockSize { get => throw null; }
                public int TransformBlock(byte[] inputBuffer, int inputOffset, int inputCount, byte[] outputBuffer, int outputOffset) => throw null;
                public byte[] TransformFinalBlock(byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
            }
            public enum FromBase64TransformMode
            {
                IgnoreWhiteSpaces = 0,
                DoNotIgnoreWhiteSpaces = 1,
            }
            public abstract class HashAlgorithm : System.Security.Cryptography.ICryptoTransform, System.IDisposable
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public virtual bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public byte[] ComputeHash(byte[] buffer) => throw null;
                public byte[] ComputeHash(byte[] buffer, int offset, int count) => throw null;
                public byte[] ComputeHash(System.IO.Stream inputStream) => throw null;
                public System.Threading.Tasks.Task<byte[]> ComputeHashAsync(System.IO.Stream inputStream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Security.Cryptography.HashAlgorithm Create() => throw null;
                public static System.Security.Cryptography.HashAlgorithm Create(string hashName) => throw null;
                protected HashAlgorithm() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual byte[] Hash { get => throw null; }
                protected abstract void HashCore(byte[] array, int ibStart, int cbSize);
                protected virtual void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected abstract byte[] HashFinal();
                public virtual int HashSize { get => throw null; }
                protected int HashSizeValue;
                protected byte[] HashValue;
                public abstract void Initialize();
                public virtual int InputBlockSize { get => throw null; }
                public virtual int OutputBlockSize { get => throw null; }
                protected int State;
                public int TransformBlock(byte[] inputBuffer, int inputOffset, int inputCount, byte[] outputBuffer, int outputOffset) => throw null;
                public byte[] TransformFinalBlock(byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
                public bool TryComputeHash(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public struct HashAlgorithmName : System.IEquatable<System.Security.Cryptography.HashAlgorithmName>
            {
                public HashAlgorithmName(string name) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.HashAlgorithmName other) => throw null;
                public static System.Security.Cryptography.HashAlgorithmName FromOid(string oidValue) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.HashAlgorithmName MD5 { get => throw null; }
                public string Name { get => throw null; }
                public static bool operator ==(System.Security.Cryptography.HashAlgorithmName left, System.Security.Cryptography.HashAlgorithmName right) => throw null;
                public static bool operator !=(System.Security.Cryptography.HashAlgorithmName left, System.Security.Cryptography.HashAlgorithmName right) => throw null;
                public static System.Security.Cryptography.HashAlgorithmName SHA1 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA256 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA3_256 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA3_384 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA3_512 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA384 { get => throw null; }
                public static System.Security.Cryptography.HashAlgorithmName SHA512 { get => throw null; }
                public override string ToString() => throw null;
                public static bool TryFromOid(string oidValue, out System.Security.Cryptography.HashAlgorithmName value) => throw null;
            }
            public static class HKDF
            {
                public static byte[] DeriveKey(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, byte[] ikm, int outputLength, byte[] salt = default(byte[]), byte[] info = default(byte[])) => throw null;
                public static void DeriveKey(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<byte> ikm, System.Span<byte> output, System.ReadOnlySpan<byte> salt, System.ReadOnlySpan<byte> info) => throw null;
                public static byte[] Expand(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, byte[] prk, int outputLength, byte[] info = default(byte[])) => throw null;
                public static void Expand(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<byte> prk, System.Span<byte> output, System.ReadOnlySpan<byte> info) => throw null;
                public static byte[] Extract(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, byte[] ikm, byte[] salt = default(byte[])) => throw null;
                public static int Extract(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<byte> ikm, System.ReadOnlySpan<byte> salt, System.Span<byte> prk) => throw null;
            }
            public abstract class HMAC : System.Security.Cryptography.KeyedHashAlgorithm
            {
                protected int BlockSizeValue { get => throw null; set { } }
                public static System.Security.Cryptography.HMAC Create() => throw null;
                public static System.Security.Cryptography.HMAC Create(string algorithmName) => throw null;
                protected HMAC() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override byte[] HashFinal() => throw null;
                public string HashName { get => throw null; set { } }
                public override void Initialize() => throw null;
                public override byte[] Key { get => throw null; set { } }
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACMD5 : System.Security.Cryptography.HMAC
            {
                public HMACMD5() => throw null;
                public HMACMD5(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 128;
                public const int HashSizeInBytes = 16;
                public override void Initialize() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA1 : System.Security.Cryptography.HMAC
            {
                public HMACSHA1() => throw null;
                public HMACSHA1(byte[] key) => throw null;
                public HMACSHA1(byte[] key, bool useManagedSha1) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 160;
                public const int HashSizeInBytes = 20;
                public override void Initialize() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA256 : System.Security.Cryptography.HMAC
            {
                public HMACSHA256() => throw null;
                public HMACSHA256(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 256;
                public const int HashSizeInBytes = 32;
                public override void Initialize() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA3_256 : System.Security.Cryptography.HMAC
            {
                public HMACSHA3_256() => throw null;
                public HMACSHA3_256(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 256;
                public const int HashSizeInBytes = 32;
                public override void Initialize() => throw null;
                public static bool IsSupported { get => throw null; }
                public override byte[] Key { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA3_384 : System.Security.Cryptography.HMAC
            {
                public HMACSHA3_384() => throw null;
                public HMACSHA3_384(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 384;
                public const int HashSizeInBytes = 48;
                public override void Initialize() => throw null;
                public static bool IsSupported { get => throw null; }
                public override byte[] Key { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA3_512 : System.Security.Cryptography.HMAC
            {
                public HMACSHA3_512() => throw null;
                public HMACSHA3_512(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 512;
                public const int HashSizeInBytes = 64;
                public override void Initialize() => throw null;
                public static bool IsSupported { get => throw null; }
                public override byte[] Key { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA384 : System.Security.Cryptography.HMAC
            {
                public HMACSHA384() => throw null;
                public HMACSHA384(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 384;
                public const int HashSizeInBytes = 48;
                public override void Initialize() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public bool ProduceLegacyHmacValues { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public class HMACSHA512 : System.Security.Cryptography.HMAC
            {
                public HMACSHA512() => throw null;
                public HMACSHA512(byte[] key) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                public static byte[] HashData(byte[] key, byte[] source) => throw null;
                public static byte[] HashData(byte[] key, System.IO.Stream source) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.ReadOnlyMemory<byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override byte[] HashFinal() => throw null;
                public const int HashSizeInBits = 512;
                public const int HashSizeInBytes = 64;
                public override void Initialize() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public bool ProduceLegacyHmacValues { get => throw null; set { } }
                public static bool TryHashData(System.ReadOnlySpan<byte> key, System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public interface ICryptoTransform : System.IDisposable
            {
                bool CanReuseTransform { get; }
                bool CanTransformMultipleBlocks { get; }
                int InputBlockSize { get; }
                int OutputBlockSize { get; }
                int TransformBlock(byte[] inputBuffer, int inputOffset, int inputCount, byte[] outputBuffer, int outputOffset);
                byte[] TransformFinalBlock(byte[] inputBuffer, int inputOffset, int inputCount);
            }
            public interface ICspAsymmetricAlgorithm
            {
                System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get; }
                byte[] ExportCspBlob(bool includePrivateParameters);
                void ImportCspBlob(byte[] rawData);
            }
            public sealed class IncrementalHash : System.IDisposable
            {
                public System.Security.Cryptography.HashAlgorithmName AlgorithmName { get => throw null; }
                public void AppendData(byte[] data) => throw null;
                public void AppendData(byte[] data, int offset, int count) => throw null;
                public void AppendData(System.ReadOnlySpan<byte> data) => throw null;
                public static System.Security.Cryptography.IncrementalHash CreateHash(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public static System.Security.Cryptography.IncrementalHash CreateHMAC(System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] key) => throw null;
                public static System.Security.Cryptography.IncrementalHash CreateHMAC(System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.ReadOnlySpan<byte> key) => throw null;
                public void Dispose() => throw null;
                public byte[] GetCurrentHash() => throw null;
                public int GetCurrentHash(System.Span<byte> destination) => throw null;
                public byte[] GetHashAndReset() => throw null;
                public int GetHashAndReset(System.Span<byte> destination) => throw null;
                public int HashLengthInBytes { get => throw null; }
                public bool TryGetCurrentHash(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryGetHashAndReset(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class KeyedHashAlgorithm : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.KeyedHashAlgorithm Create() => throw null;
                public static System.Security.Cryptography.KeyedHashAlgorithm Create(string algName) => throw null;
                protected KeyedHashAlgorithm() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public virtual byte[] Key { get => throw null; set { } }
                protected byte[] KeyValue;
            }
            public enum KeyNumber
            {
                Exchange = 1,
                Signature = 2,
            }
            public sealed class KeySizes
            {
                public KeySizes(int minSize, int maxSize, int skipSize) => throw null;
                public int MaxSize { get => throw null; }
                public int MinSize { get => throw null; }
                public int SkipSize { get => throw null; }
            }
            public abstract class MaskGenerationMethod
            {
                protected MaskGenerationMethod() => throw null;
                public abstract byte[] GenerateMask(byte[] rgbSeed, int cbReturn);
            }
            public abstract class MD5 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.MD5 Create() => throw null;
                public static System.Security.Cryptography.MD5 Create(string algName) => throw null;
                protected MD5() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 128;
                public const int HashSizeInBytes = 16;
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class MD5CryptoServiceProvider : System.Security.Cryptography.MD5
            {
                public MD5CryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class Oid
            {
                public Oid() => throw null;
                public Oid(System.Security.Cryptography.Oid oid) => throw null;
                public Oid(string oid) => throw null;
                public Oid(string value, string friendlyName) => throw null;
                public string FriendlyName { get => throw null; set { } }
                public static System.Security.Cryptography.Oid FromFriendlyName(string friendlyName, System.Security.Cryptography.OidGroup group) => throw null;
                public static System.Security.Cryptography.Oid FromOidValue(string oidValue, System.Security.Cryptography.OidGroup group) => throw null;
                public string Value { get => throw null; set { } }
            }
            public sealed class OidCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.Oid oid) => throw null;
                public void CopyTo(System.Security.Cryptography.Oid[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public OidCollection() => throw null;
                public System.Security.Cryptography.OidEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public object SyncRoot { get => throw null; }
                public System.Security.Cryptography.Oid this[int index] { get => throw null; }
                public System.Security.Cryptography.Oid this[string oid] { get => throw null; }
            }
            public sealed class OidEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.Oid Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            public enum OidGroup
            {
                All = 0,
                HashAlgorithm = 1,
                EncryptionAlgorithm = 2,
                PublicKeyAlgorithm = 3,
                SignatureAlgorithm = 4,
                Attribute = 5,
                ExtensionOrAttribute = 6,
                EnhancedKeyUsage = 7,
                Policy = 8,
                Template = 9,
                KeyDerivationFunction = 10,
            }
            public enum PaddingMode
            {
                None = 1,
                PKCS7 = 2,
                Zeros = 3,
                ANSIX923 = 4,
                ISO10126 = 5,
            }
            public class PasswordDeriveBytes : System.Security.Cryptography.DeriveBytes
            {
                public byte[] CryptDeriveKey(string algname, string alghashname, int keySize, byte[] rgbIV) => throw null;
                public PasswordDeriveBytes(byte[] password, byte[] salt) => throw null;
                public PasswordDeriveBytes(byte[] password, byte[] salt, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public PasswordDeriveBytes(byte[] password, byte[] salt, string hashName, int iterations) => throw null;
                public PasswordDeriveBytes(byte[] password, byte[] salt, string hashName, int iterations, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public PasswordDeriveBytes(string strPassword, byte[] rgbSalt) => throw null;
                public PasswordDeriveBytes(string strPassword, byte[] rgbSalt, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public PasswordDeriveBytes(string strPassword, byte[] rgbSalt, string strHashName, int iterations) => throw null;
                public PasswordDeriveBytes(string strPassword, byte[] rgbSalt, string strHashName, int iterations, System.Security.Cryptography.CspParameters cspParams) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override byte[] GetBytes(int cb) => throw null;
                public string HashName { get => throw null; set { } }
                public int IterationCount { get => throw null; set { } }
                public override void Reset() => throw null;
                public byte[] Salt { get => throw null; set { } }
            }
            public enum PbeEncryptionAlgorithm
            {
                Unknown = 0,
                Aes128Cbc = 1,
                Aes192Cbc = 2,
                Aes256Cbc = 3,
                TripleDes3KeyPkcs12 = 4,
            }
            public sealed class PbeParameters
            {
                public PbeParameters(System.Security.Cryptography.PbeEncryptionAlgorithm encryptionAlgorithm, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int iterationCount) => throw null;
                public System.Security.Cryptography.PbeEncryptionAlgorithm EncryptionAlgorithm { get => throw null; }
                public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                public int IterationCount { get => throw null; }
            }
            public static class PemEncoding
            {
                public static System.Security.Cryptography.PemFields Find(System.ReadOnlySpan<char> pemData) => throw null;
                public static int GetEncodedSize(int labelLength, int dataLength) => throw null;
                public static bool TryFind(System.ReadOnlySpan<char> pemData, out System.Security.Cryptography.PemFields fields) => throw null;
                public static bool TryWrite(System.ReadOnlySpan<char> label, System.ReadOnlySpan<byte> data, System.Span<char> destination, out int charsWritten) => throw null;
                public static char[] Write(System.ReadOnlySpan<char> label, System.ReadOnlySpan<byte> data) => throw null;
                public static string WriteString(System.ReadOnlySpan<char> label, System.ReadOnlySpan<byte> data) => throw null;
            }
            public struct PemFields
            {
                public System.Range Base64Data { get => throw null; }
                public int DecodedDataLength { get => throw null; }
                public System.Range Label { get => throw null; }
                public System.Range Location { get => throw null; }
            }
            public class PKCS1MaskGenerationMethod : System.Security.Cryptography.MaskGenerationMethod
            {
                public PKCS1MaskGenerationMethod() => throw null;
                public override byte[] GenerateMask(byte[] rgbSeed, int cbReturn) => throw null;
                public string HashName { get => throw null; set { } }
            }
            public abstract class RandomNumberGenerator : System.IDisposable
            {
                public static System.Security.Cryptography.RandomNumberGenerator Create() => throw null;
                public static System.Security.Cryptography.RandomNumberGenerator Create(string rngName) => throw null;
                protected RandomNumberGenerator() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public static void Fill(System.Span<byte> data) => throw null;
                public abstract void GetBytes(byte[] data);
                public virtual void GetBytes(byte[] data, int offset, int count) => throw null;
                public static byte[] GetBytes(int count) => throw null;
                public virtual void GetBytes(System.Span<byte> data) => throw null;
                public static string GetHexString(int stringLength, bool lowercase = default(bool)) => throw null;
                public static void GetHexString(System.Span<char> destination, bool lowercase = default(bool)) => throw null;
                public static int GetInt32(int toExclusive) => throw null;
                public static int GetInt32(int fromInclusive, int toExclusive) => throw null;
                public static T[] GetItems<T>(System.ReadOnlySpan<T> choices, int length) => throw null;
                public static void GetItems<T>(System.ReadOnlySpan<T> choices, System.Span<T> destination) => throw null;
                public virtual void GetNonZeroBytes(byte[] data) => throw null;
                public virtual void GetNonZeroBytes(System.Span<byte> data) => throw null;
                public static string GetString(System.ReadOnlySpan<char> choices, int length) => throw null;
                public static void Shuffle<T>(System.Span<T> values) => throw null;
            }
            public abstract class RC2 : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.RC2 Create() => throw null;
                public static System.Security.Cryptography.RC2 Create(string AlgName) => throw null;
                protected RC2() => throw null;
                public virtual int EffectiveKeySize { get => throw null; set { } }
                protected int EffectiveKeySizeValue;
                public override int KeySize { get => throw null; set { } }
            }
            public sealed class RC2CryptoServiceProvider : System.Security.Cryptography.RC2
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public RC2CryptoServiceProvider() => throw null;
                public override int EffectiveKeySize { get => throw null; set { } }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public bool UseSalt { get => throw null; set { } }
            }
            public class Rfc2898DeriveBytes : System.Security.Cryptography.DeriveBytes
            {
                public byte[] CryptDeriveKey(string algname, string alghashname, int keySize, byte[] rgbIV) => throw null;
                public Rfc2898DeriveBytes(byte[] password, byte[] salt, int iterations) => throw null;
                public Rfc2898DeriveBytes(byte[] password, byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public Rfc2898DeriveBytes(string password, byte[] salt) => throw null;
                public Rfc2898DeriveBytes(string password, byte[] salt, int iterations) => throw null;
                public Rfc2898DeriveBytes(string password, byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public Rfc2898DeriveBytes(string password, int saltSize) => throw null;
                public Rfc2898DeriveBytes(string password, int saltSize, int iterations) => throw null;
                public Rfc2898DeriveBytes(string password, int saltSize, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override byte[] GetBytes(int cb) => throw null;
                public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                public int IterationCount { get => throw null; set { } }
                public static byte[] Pbkdf2(byte[] password, byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public static byte[] Pbkdf2(System.ReadOnlySpan<byte> password, System.ReadOnlySpan<byte> salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public static void Pbkdf2(System.ReadOnlySpan<byte> password, System.ReadOnlySpan<byte> salt, System.Span<byte> destination, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public static byte[] Pbkdf2(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public static void Pbkdf2(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> salt, System.Span<byte> destination, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public static byte[] Pbkdf2(string password, byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public override void Reset() => throw null;
                public byte[] Salt { get => throw null; set { } }
            }
            public abstract class Rijndael : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.Rijndael Create() => throw null;
                public static System.Security.Cryptography.Rijndael Create(string algName) => throw null;
                protected Rijndael() => throw null;
            }
            public sealed class RijndaelManaged : System.Security.Cryptography.Rijndael
            {
                public override int BlockSize { get => throw null; set { } }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public RijndaelManaged() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set { } }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override byte[] IV { get => throw null; set { } }
                public override byte[] Key { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set { } }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set { } }
            }
            public sealed class RNGCryptoServiceProvider : System.Security.Cryptography.RandomNumberGenerator
            {
                public RNGCryptoServiceProvider() => throw null;
                public RNGCryptoServiceProvider(byte[] rgb) => throw null;
                public RNGCryptoServiceProvider(System.Security.Cryptography.CspParameters cspParams) => throw null;
                public RNGCryptoServiceProvider(string str) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GetBytes(byte[] data) => throw null;
                public override void GetBytes(byte[] data, int offset, int count) => throw null;
                public override void GetBytes(System.Span<byte> data) => throw null;
                public override void GetNonZeroBytes(byte[] data) => throw null;
                public override void GetNonZeroBytes(System.Span<byte> data) => throw null;
            }
            public abstract class RSA : System.Security.Cryptography.AsymmetricAlgorithm
            {
                public static System.Security.Cryptography.RSA Create() => throw null;
                public static System.Security.Cryptography.RSA Create(int keySizeInBits) => throw null;
                public static System.Security.Cryptography.RSA Create(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public static System.Security.Cryptography.RSA Create(string algName) => throw null;
                protected RSA() => throw null;
                public virtual byte[] Decrypt(byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public byte[] Decrypt(System.ReadOnlySpan<byte> data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public int Decrypt(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public virtual byte[] DecryptValue(byte[] rgb) => throw null;
                public virtual byte[] Encrypt(byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public byte[] Encrypt(System.ReadOnlySpan<byte> data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public int Encrypt(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public virtual byte[] EncryptValue(byte[] rgb) => throw null;
                public abstract System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters);
                public virtual byte[] ExportRSAPrivateKey() => throw null;
                public string ExportRSAPrivateKeyPem() => throw null;
                public virtual byte[] ExportRSAPublicKey() => throw null;
                public string ExportRSAPublicKeyPem() => throw null;
                public override void FromXmlString(string xmlString) => throw null;
                public int GetMaxOutputSize() => throw null;
                protected virtual byte[] HashData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<char> input, System.ReadOnlySpan<char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<char> input) => throw null;
                public abstract void ImportParameters(System.Security.Cryptography.RSAParameters parameters);
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual void ImportRSAPrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public virtual void ImportRSAPublicKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                public virtual byte[] SignData(byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public byte[] SignData(byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public byte[] SignData(System.ReadOnlySpan<byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public int SignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual byte[] SignHash(byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public byte[] SignHash(System.ReadOnlySpan<byte> hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public int SignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryDecrypt(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public virtual bool TryEncrypt(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportRSAPrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryExportRSAPrivateKeyPem(System.Span<char> destination, out int charsWritten) => throw null;
                public virtual bool TryExportRSAPublicKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryExportRSAPublicKeyPem(System.Span<char> destination, out int charsWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryHashData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public virtual bool TrySignData(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding, out int bytesWritten) => throw null;
                public virtual bool TrySignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding, out int bytesWritten) => throw null;
                public bool VerifyData(byte[] data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyData(byte[] data, int offset, int count, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public bool VerifyData(System.IO.Stream data, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyData(System.ReadOnlySpan<byte> data, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyHash(byte[] hash, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyHash(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
            }
            public sealed class RSACng : System.Security.Cryptography.RSA
            {
                public RSACng() => throw null;
                public RSACng(int keySize) => throw null;
                public RSACng(System.Security.Cryptography.CngKey key) => throw null;
                public override byte[] Decrypt(byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override byte[] Encrypt(byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override byte[] SignHash(byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override bool TryDecrypt(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryEncrypt(System.ReadOnlySpan<byte> data, System.Span<byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<byte> destination, out int bytesWritten) => throw null;
                public override bool TrySignHash(System.ReadOnlySpan<byte> hash, System.Span<byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding, out int bytesWritten) => throw null;
                public override bool VerifyHash(byte[] hash, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override bool VerifyHash(System.ReadOnlySpan<byte> hash, System.ReadOnlySpan<byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
            }
            public sealed class RSACryptoServiceProvider : System.Security.Cryptography.RSA, System.Security.Cryptography.ICspAsymmetricAlgorithm
            {
                public System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get => throw null; }
                public RSACryptoServiceProvider() => throw null;
                public RSACryptoServiceProvider(int dwKeySize) => throw null;
                public RSACryptoServiceProvider(int dwKeySize, System.Security.Cryptography.CspParameters parameters) => throw null;
                public RSACryptoServiceProvider(System.Security.Cryptography.CspParameters parameters) => throw null;
                public byte[] Decrypt(byte[] rgb, bool fOAEP) => throw null;
                public override byte[] Decrypt(byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public override byte[] DecryptValue(byte[] rgb) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public byte[] Encrypt(byte[] rgb, bool fOAEP) => throw null;
                public override byte[] Encrypt(byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public override byte[] EncryptValue(byte[] rgb) => throw null;
                public byte[] ExportCspBlob(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void ImportCspBlob(byte[] keyBlob) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<char> password, System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override int KeySize { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public bool PersistKeyInCsp { get => throw null; set { } }
                public bool PublicOnly { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                public byte[] SignData(byte[] buffer, int offset, int count, object halg) => throw null;
                public byte[] SignData(byte[] buffer, object halg) => throw null;
                public byte[] SignData(System.IO.Stream inputStream, object halg) => throw null;
                public override byte[] SignHash(byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public byte[] SignHash(byte[] rgbHash, string str) => throw null;
                public static bool UseMachineKeyStore { get => throw null; set { } }
                public bool VerifyData(byte[] buffer, object halg, byte[] signature) => throw null;
                public override bool VerifyHash(byte[] hash, byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public bool VerifyHash(byte[] rgbHash, string str, byte[] rgbSignature) => throw null;
            }
            public sealed class RSAEncryptionPadding : System.IEquatable<System.Security.Cryptography.RSAEncryptionPadding>
            {
                public static System.Security.Cryptography.RSAEncryptionPadding CreateOaep(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.RSAEncryptionPadding other) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.Cryptography.RSAEncryptionPaddingMode Mode { get => throw null; }
                public System.Security.Cryptography.HashAlgorithmName OaepHashAlgorithm { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA1 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA256 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA3_256 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA3_384 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA3_512 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA384 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA512 { get => throw null; }
                public static bool operator ==(System.Security.Cryptography.RSAEncryptionPadding left, System.Security.Cryptography.RSAEncryptionPadding right) => throw null;
                public static bool operator !=(System.Security.Cryptography.RSAEncryptionPadding left, System.Security.Cryptography.RSAEncryptionPadding right) => throw null;
                public static System.Security.Cryptography.RSAEncryptionPadding Pkcs1 { get => throw null; }
                public override string ToString() => throw null;
            }
            public enum RSAEncryptionPaddingMode
            {
                Pkcs1 = 0,
                Oaep = 1,
            }
            public class RSAOAEPKeyExchangeDeformatter : System.Security.Cryptography.AsymmetricKeyExchangeDeformatter
            {
                public RSAOAEPKeyExchangeDeformatter() => throw null;
                public RSAOAEPKeyExchangeDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override byte[] DecryptKeyExchange(byte[] rgbData) => throw null;
                public override string Parameters { get => throw null; set { } }
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }
            public class RSAOAEPKeyExchangeFormatter : System.Security.Cryptography.AsymmetricKeyExchangeFormatter
            {
                public override byte[] CreateKeyExchange(byte[] rgbData) => throw null;
                public override byte[] CreateKeyExchange(byte[] rgbData, System.Type symAlgType) => throw null;
                public RSAOAEPKeyExchangeFormatter() => throw null;
                public RSAOAEPKeyExchangeFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public byte[] Parameter { get => throw null; set { } }
                public override string Parameters { get => throw null; }
                public System.Security.Cryptography.RandomNumberGenerator Rng { get => throw null; set { } }
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }
            public sealed class RSAOpenSsl : System.Security.Cryptography.RSA
            {
                public RSAOpenSsl() => throw null;
                public RSAOpenSsl(int keySize) => throw null;
                public RSAOpenSsl(nint handle) => throw null;
                public RSAOpenSsl(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public RSAOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
            }
            public struct RSAParameters
            {
                public byte[] D;
                public byte[] DP;
                public byte[] DQ;
                public byte[] Exponent;
                public byte[] InverseQ;
                public byte[] Modulus;
                public byte[] P;
                public byte[] Q;
            }
            public class RSAPKCS1KeyExchangeDeformatter : System.Security.Cryptography.AsymmetricKeyExchangeDeformatter
            {
                public RSAPKCS1KeyExchangeDeformatter() => throw null;
                public RSAPKCS1KeyExchangeDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override byte[] DecryptKeyExchange(byte[] rgbIn) => throw null;
                public override string Parameters { get => throw null; set { } }
                public System.Security.Cryptography.RandomNumberGenerator RNG { get => throw null; set { } }
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }
            public class RSAPKCS1KeyExchangeFormatter : System.Security.Cryptography.AsymmetricKeyExchangeFormatter
            {
                public override byte[] CreateKeyExchange(byte[] rgbData) => throw null;
                public override byte[] CreateKeyExchange(byte[] rgbData, System.Type symAlgType) => throw null;
                public RSAPKCS1KeyExchangeFormatter() => throw null;
                public RSAPKCS1KeyExchangeFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override string Parameters { get => throw null; }
                public System.Security.Cryptography.RandomNumberGenerator Rng { get => throw null; set { } }
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }
            public class RSAPKCS1SignatureDeformatter : System.Security.Cryptography.AsymmetricSignatureDeformatter
            {
                public RSAPKCS1SignatureDeformatter() => throw null;
                public RSAPKCS1SignatureDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override bool VerifySignature(byte[] rgbHash, byte[] rgbSignature) => throw null;
            }
            public class RSAPKCS1SignatureFormatter : System.Security.Cryptography.AsymmetricSignatureFormatter
            {
                public override byte[] CreateSignature(byte[] rgbHash) => throw null;
                public RSAPKCS1SignatureFormatter() => throw null;
                public RSAPKCS1SignatureFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }
            public sealed class RSASignaturePadding : System.IEquatable<System.Security.Cryptography.RSASignaturePadding>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.RSASignaturePadding other) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.Cryptography.RSASignaturePaddingMode Mode { get => throw null; }
                public static bool operator ==(System.Security.Cryptography.RSASignaturePadding left, System.Security.Cryptography.RSASignaturePadding right) => throw null;
                public static bool operator !=(System.Security.Cryptography.RSASignaturePadding left, System.Security.Cryptography.RSASignaturePadding right) => throw null;
                public static System.Security.Cryptography.RSASignaturePadding Pkcs1 { get => throw null; }
                public static System.Security.Cryptography.RSASignaturePadding Pss { get => throw null; }
                public override string ToString() => throw null;
            }
            public enum RSASignaturePaddingMode
            {
                Pkcs1 = 0,
                Pss = 1,
            }
            public sealed class SafeEvpPKeyHandle : System.Runtime.InteropServices.SafeHandle
            {
                public SafeEvpPKeyHandle() : base(default(nint), default(bool)) => throw null;
                public SafeEvpPKeyHandle(nint handle, bool ownsHandle) : base(default(nint), default(bool)) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateHandle() => throw null;
                public override bool IsInvalid { get => throw null; }
                public static System.Security.Cryptography.SafeEvpPKeyHandle OpenPrivateKeyFromEngine(string engineName, string keyId) => throw null;
                public static System.Security.Cryptography.SafeEvpPKeyHandle OpenPublicKeyFromEngine(string engineName, string keyId) => throw null;
                public static long OpenSslVersion { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
            }
            public abstract class SHA1 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA1 Create() => throw null;
                public static System.Security.Cryptography.SHA1 Create(string hashName) => throw null;
                protected SHA1() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 160;
                public const int HashSizeInBytes = 20;
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA1CryptoServiceProvider : System.Security.Cryptography.SHA1
            {
                public SHA1CryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA1Managed : System.Security.Cryptography.SHA1
            {
                public SHA1Managed() => throw null;
                protected override sealed void Dispose(bool disposing) => throw null;
                protected override sealed void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override sealed void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override sealed byte[] HashFinal() => throw null;
                public override sealed void Initialize() => throw null;
                protected override sealed bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class SHA256 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA256 Create() => throw null;
                public static System.Security.Cryptography.SHA256 Create(string hashName) => throw null;
                protected SHA256() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 256;
                public const int HashSizeInBytes = 32;
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA256CryptoServiceProvider : System.Security.Cryptography.SHA256
            {
                public SHA256CryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA256Managed : System.Security.Cryptography.SHA256
            {
                public SHA256Managed() => throw null;
                protected override sealed void Dispose(bool disposing) => throw null;
                protected override sealed void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override sealed void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override sealed byte[] HashFinal() => throw null;
                public override sealed void Initialize() => throw null;
                protected override sealed bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class SHA3_256 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA3_256 Create() => throw null;
                protected SHA3_256() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 256;
                public const int HashSizeInBytes = 32;
                public static bool IsSupported { get => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class SHA3_384 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA3_384 Create() => throw null;
                protected SHA3_384() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 384;
                public const int HashSizeInBytes = 48;
                public static bool IsSupported { get => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class SHA3_512 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA3_512 Create() => throw null;
                protected SHA3_512() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 512;
                public const int HashSizeInBytes = 64;
                public static bool IsSupported { get => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class SHA384 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA384 Create() => throw null;
                public static System.Security.Cryptography.SHA384 Create(string hashName) => throw null;
                protected SHA384() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 384;
                public const int HashSizeInBytes = 48;
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA384CryptoServiceProvider : System.Security.Cryptography.SHA384
            {
                public SHA384CryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA384Managed : System.Security.Cryptography.SHA384
            {
                public SHA384Managed() => throw null;
                protected override sealed void Dispose(bool disposing) => throw null;
                protected override sealed void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override sealed void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override sealed byte[] HashFinal() => throw null;
                public override sealed void Initialize() => throw null;
                protected override sealed bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public abstract class SHA512 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA512 Create() => throw null;
                public static System.Security.Cryptography.SHA512 Create(string hashName) => throw null;
                protected SHA512() => throw null;
                public static byte[] HashData(byte[] source) => throw null;
                public static byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = 512;
                public const int HashSizeInBytes = 64;
                public static bool TryHashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA512CryptoServiceProvider : System.Security.Cryptography.SHA512
            {
                public SHA512CryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                protected override bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class SHA512Managed : System.Security.Cryptography.SHA512
            {
                public SHA512Managed() => throw null;
                protected override sealed void Dispose(bool disposing) => throw null;
                protected override sealed void HashCore(byte[] array, int ibStart, int cbSize) => throw null;
                protected override sealed void HashCore(System.ReadOnlySpan<byte> source) => throw null;
                protected override sealed byte[] HashFinal() => throw null;
                public override sealed void Initialize() => throw null;
                protected override sealed bool TryHashFinal(System.Span<byte> destination, out int bytesWritten) => throw null;
            }
            public sealed class Shake128 : System.IDisposable
            {
                public void AppendData(byte[] data) => throw null;
                public void AppendData(System.ReadOnlySpan<byte> data) => throw null;
                public Shake128() => throw null;
                public void Dispose() => throw null;
                public byte[] GetCurrentHash(int outputLength) => throw null;
                public void GetCurrentHash(System.Span<byte> destination) => throw null;
                public byte[] GetHashAndReset(int outputLength) => throw null;
                public void GetHashAndReset(System.Span<byte> destination) => throw null;
                public static byte[] HashData(byte[] source, int outputLength) => throw null;
                public static byte[] HashData(System.IO.Stream source, int outputLength) => throw null;
                public static void HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source, int outputLength) => throw null;
                public static void HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, int outputLength, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static bool IsSupported { get => throw null; }
            }
            public sealed class Shake256 : System.IDisposable
            {
                public void AppendData(byte[] data) => throw null;
                public void AppendData(System.ReadOnlySpan<byte> data) => throw null;
                public Shake256() => throw null;
                public void Dispose() => throw null;
                public byte[] GetCurrentHash(int outputLength) => throw null;
                public void GetCurrentHash(System.Span<byte> destination) => throw null;
                public byte[] GetHashAndReset(int outputLength) => throw null;
                public void GetHashAndReset(System.Span<byte> destination) => throw null;
                public static byte[] HashData(byte[] source, int outputLength) => throw null;
                public static byte[] HashData(System.IO.Stream source, int outputLength) => throw null;
                public static void HashData(System.IO.Stream source, System.Span<byte> destination) => throw null;
                public static byte[] HashData(System.ReadOnlySpan<byte> source, int outputLength) => throw null;
                public static void HashData(System.ReadOnlySpan<byte> source, System.Span<byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<byte[]> HashDataAsync(System.IO.Stream source, int outputLength, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask HashDataAsync(System.IO.Stream source, System.Memory<byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static bool IsSupported { get => throw null; }
            }
            public class SignatureDescription
            {
                public virtual System.Security.Cryptography.AsymmetricSignatureDeformatter CreateDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public virtual System.Security.Cryptography.HashAlgorithm CreateDigest() => throw null;
                public virtual System.Security.Cryptography.AsymmetricSignatureFormatter CreateFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public SignatureDescription() => throw null;
                public SignatureDescription(System.Security.SecurityElement el) => throw null;
                public string DeformatterAlgorithm { get => throw null; set { } }
                public string DigestAlgorithm { get => throw null; set { } }
                public string FormatterAlgorithm { get => throw null; set { } }
                public string KeyAlgorithm { get => throw null; set { } }
            }
            public sealed class SP800108HmacCounterKdf : System.IDisposable
            {
                public SP800108HmacCounterKdf(byte[] key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public SP800108HmacCounterKdf(System.ReadOnlySpan<byte> key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public static byte[] DeriveBytes(byte[] key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, byte[] label, byte[] context, int derivedKeyLengthInBytes) => throw null;
                public static byte[] DeriveBytes(byte[] key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, string label, string context, int derivedKeyLengthInBytes) => throw null;
                public static byte[] DeriveBytes(System.ReadOnlySpan<byte> key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.ReadOnlySpan<byte> label, System.ReadOnlySpan<byte> context, int derivedKeyLengthInBytes) => throw null;
                public static void DeriveBytes(System.ReadOnlySpan<byte> key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.ReadOnlySpan<byte> label, System.ReadOnlySpan<byte> context, System.Span<byte> destination) => throw null;
                public static byte[] DeriveBytes(System.ReadOnlySpan<byte> key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.ReadOnlySpan<char> label, System.ReadOnlySpan<char> context, int derivedKeyLengthInBytes) => throw null;
                public static void DeriveBytes(System.ReadOnlySpan<byte> key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.ReadOnlySpan<char> label, System.ReadOnlySpan<char> context, System.Span<byte> destination) => throw null;
                public byte[] DeriveKey(byte[] label, byte[] context, int derivedKeyLengthInBytes) => throw null;
                public byte[] DeriveKey(System.ReadOnlySpan<byte> label, System.ReadOnlySpan<byte> context, int derivedKeyLengthInBytes) => throw null;
                public void DeriveKey(System.ReadOnlySpan<byte> label, System.ReadOnlySpan<byte> context, System.Span<byte> destination) => throw null;
                public byte[] DeriveKey(System.ReadOnlySpan<char> label, System.ReadOnlySpan<char> context, int derivedKeyLengthInBytes) => throw null;
                public void DeriveKey(System.ReadOnlySpan<char> label, System.ReadOnlySpan<char> context, System.Span<byte> destination) => throw null;
                public byte[] DeriveKey(string label, string context, int derivedKeyLengthInBytes) => throw null;
                public void Dispose() => throw null;
            }
            public abstract class SymmetricAlgorithm : System.IDisposable
            {
                public virtual int BlockSize { get => throw null; set { } }
                protected int BlockSizeValue;
                public void Clear() => throw null;
                public static System.Security.Cryptography.SymmetricAlgorithm Create() => throw null;
                public static System.Security.Cryptography.SymmetricAlgorithm Create(string algName) => throw null;
                public virtual System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public abstract System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV);
                public virtual System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public abstract System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV);
                protected SymmetricAlgorithm() => throw null;
                public byte[] DecryptCbc(byte[] ciphertext, byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public byte[] DecryptCbc(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public int DecryptCbc(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public byte[] DecryptCfb(byte[] ciphertext, byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public byte[] DecryptCfb(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public int DecryptCfb(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public byte[] DecryptEcb(byte[] ciphertext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public byte[] DecryptEcb(System.ReadOnlySpan<byte> ciphertext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public int DecryptEcb(System.ReadOnlySpan<byte> ciphertext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public byte[] EncryptCbc(byte[] plaintext, byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public byte[] EncryptCbc(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public int EncryptCbc(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public byte[] EncryptCfb(byte[] plaintext, byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public byte[] EncryptCfb(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public int EncryptCfb(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public byte[] EncryptEcb(byte[] plaintext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public byte[] EncryptEcb(System.ReadOnlySpan<byte> plaintext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public int EncryptEcb(System.ReadOnlySpan<byte> plaintext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public virtual int FeedbackSize { get => throw null; set { } }
                protected int FeedbackSizeValue;
                public abstract void GenerateIV();
                public abstract void GenerateKey();
                public int GetCiphertextLengthCbc(int plaintextLength, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public int GetCiphertextLengthCfb(int plaintextLength, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public int GetCiphertextLengthEcb(int plaintextLength, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public virtual byte[] IV { get => throw null; set { } }
                protected byte[] IVValue;
                public virtual byte[] Key { get => throw null; set { } }
                public virtual int KeySize { get => throw null; set { } }
                protected int KeySizeValue;
                protected byte[] KeyValue;
                public virtual System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                protected System.Security.Cryptography.KeySizes[] LegalBlockSizesValue;
                public virtual System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                protected System.Security.Cryptography.KeySizes[] LegalKeySizesValue;
                public virtual System.Security.Cryptography.CipherMode Mode { get => throw null; set { } }
                protected System.Security.Cryptography.CipherMode ModeValue;
                public virtual System.Security.Cryptography.PaddingMode Padding { get => throw null; set { } }
                protected System.Security.Cryptography.PaddingMode PaddingValue;
                public bool TryDecryptCbc(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                protected virtual bool TryDecryptCbcCore(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool TryDecryptCfb(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                protected virtual bool TryDecryptCfbCore(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                public bool TryDecryptEcb(System.ReadOnlySpan<byte> ciphertext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected virtual bool TryDecryptEcbCore(System.ReadOnlySpan<byte> ciphertext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool TryEncryptCbc(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                protected virtual bool TryEncryptCbcCore(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool TryEncryptCfb(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                protected virtual bool TryEncryptCfbCore(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                public bool TryEncryptEcb(System.ReadOnlySpan<byte> plaintext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected virtual bool TryEncryptEcbCore(System.ReadOnlySpan<byte> plaintext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool ValidKeySize(int bitLength) => throw null;
            }
            public class ToBase64Transform : System.Security.Cryptography.ICryptoTransform, System.IDisposable
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public ToBase64Transform() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public int InputBlockSize { get => throw null; }
                public int OutputBlockSize { get => throw null; }
                public int TransformBlock(byte[] inputBuffer, int inputOffset, int inputCount, byte[] outputBuffer, int outputOffset) => throw null;
                public byte[] TransformFinalBlock(byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
            }
            public abstract class TripleDES : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.TripleDES Create() => throw null;
                public static System.Security.Cryptography.TripleDES Create(string str) => throw null;
                protected TripleDES() => throw null;
                public static bool IsWeakKey(byte[] rgbKey) => throw null;
                public override byte[] Key { get => throw null; set { } }
            }
            public sealed class TripleDESCng : System.Security.Cryptography.TripleDES
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public TripleDESCng() => throw null;
                public TripleDESCng(string keyName) => throw null;
                public TripleDESCng(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public TripleDESCng(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override byte[] Key { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                protected override bool TryDecryptCbcCore(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryDecryptCfbCore(System.ReadOnlySpan<byte> ciphertext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryDecryptEcbCore(System.ReadOnlySpan<byte> ciphertext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCbcCore(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCfbCore(System.ReadOnlySpan<byte> plaintext, System.ReadOnlySpan<byte> iv, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryEncryptEcbCore(System.ReadOnlySpan<byte> plaintext, System.Span<byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
            }
            public sealed class TripleDESCryptoServiceProvider : System.Security.Cryptography.TripleDES
            {
                public override int BlockSize { get => throw null; set { } }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(byte[] rgbKey, byte[] rgbIV) => throw null;
                public TripleDESCryptoServiceProvider() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set { } }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override byte[] IV { get => throw null; set { } }
                public override byte[] Key { get => throw null; set { } }
                public override int KeySize { get => throw null; set { } }
                public override System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set { } }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set { } }
            }
            namespace X509Certificates
            {
                public sealed class CertificateRequest
                {
                    public System.Collections.ObjectModel.Collection<System.Security.Cryptography.X509Certificates.X509Extension> CertificateExtensions { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Security.Cryptography.X509Certificates.X509SignatureGenerator generator, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, byte[] serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Security.Cryptography.X509Certificates.X509SignatureGenerator generator, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, System.ReadOnlySpan<byte> serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X509Certificate2 issuerCertificate, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, byte[] serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X509Certificate2 issuerCertificate, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, System.ReadOnlySpan<byte> serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 CreateSelfSigned(System.DateTimeOffset notBefore, System.DateTimeOffset notAfter) => throw null;
                    public byte[] CreateSigningRequest() => throw null;
                    public byte[] CreateSigningRequest(System.Security.Cryptography.X509Certificates.X509SignatureGenerator signatureGenerator) => throw null;
                    public string CreateSigningRequestPem() => throw null;
                    public string CreateSigningRequestPem(System.Security.Cryptography.X509Certificates.X509SignatureGenerator signatureGenerator) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.ECDsa key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.RSA key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.X509Certificates.PublicKey publicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.X509Certificates.PublicKey publicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding rsaSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public CertificateRequest(string subjectName, System.Security.Cryptography.ECDsa key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(string subjectName, System.Security.Cryptography.RSA key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                    public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequest(byte[] pkcs10, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequest(System.ReadOnlySpan<byte> pkcs10, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, out int bytesConsumed, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequestPem(System.ReadOnlySpan<char> pkcs10Pem, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequestPem(string pkcs10Pem, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public System.Collections.ObjectModel.Collection<System.Security.Cryptography.AsnEncodedData> OtherRequestAttributes { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName SubjectName { get => throw null; }
                }
                [System.Flags]
                public enum CertificateRequestLoadOptions
                {
                    Default = 0,
                    SkipSignatureValidation = 1,
                    UnsafeLoadCertificateExtensions = 2,
                }
                public sealed class CertificateRevocationListBuilder
                {
                    public void AddEntry(byte[] serialNumber, System.DateTimeOffset? revocationTime = default(System.DateTimeOffset?), System.Security.Cryptography.X509Certificates.X509RevocationReason? reason = default(System.Security.Cryptography.X509Certificates.X509RevocationReason?)) => throw null;
                    public void AddEntry(System.ReadOnlySpan<byte> serialNumber, System.DateTimeOffset? revocationTime = default(System.DateTimeOffset?), System.Security.Cryptography.X509Certificates.X509RevocationReason? reason = default(System.Security.Cryptography.X509Certificates.X509RevocationReason?)) => throw null;
                    public void AddEntry(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.DateTimeOffset? revocationTime = default(System.DateTimeOffset?), System.Security.Cryptography.X509Certificates.X509RevocationReason? reason = default(System.Security.Cryptography.X509Certificates.X509RevocationReason?)) => throw null;
                    public byte[] Build(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Security.Cryptography.X509Certificates.X509SignatureGenerator generator, System.Numerics.BigInteger crlNumber, System.DateTimeOffset nextUpdate, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension authorityKeyIdentifier, System.DateTimeOffset? thisUpdate = default(System.DateTimeOffset?)) => throw null;
                    public byte[] Build(System.Security.Cryptography.X509Certificates.X509Certificate2 issuerCertificate, System.Numerics.BigInteger crlNumber, System.DateTimeOffset nextUpdate, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding rsaSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding), System.DateTimeOffset? thisUpdate = default(System.DateTimeOffset?)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Extension BuildCrlDistributionPointExtension(System.Collections.Generic.IEnumerable<string> uris, bool critical = default(bool)) => throw null;
                    public CertificateRevocationListBuilder() => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder Load(byte[] currentCrl, out System.Numerics.BigInteger currentCrlNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder Load(System.ReadOnlySpan<byte> currentCrl, out System.Numerics.BigInteger currentCrlNumber, out int bytesConsumed) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder LoadPem(System.ReadOnlySpan<char> currentCrl, out System.Numerics.BigInteger currentCrlNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder LoadPem(string currentCrl, out System.Numerics.BigInteger currentCrlNumber) => throw null;
                    public bool RemoveEntry(byte[] serialNumber) => throw null;
                    public bool RemoveEntry(System.ReadOnlySpan<byte> serialNumber) => throw null;
                }
                public static partial class DSACertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.DSA privateKey) => throw null;
                    public static System.Security.Cryptography.DSA GetDSAPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.DSA GetDSAPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }
                public static partial class ECDsaCertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.ECDsa privateKey) => throw null;
                    public static System.Security.Cryptography.ECDsa GetECDsaPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.ECDsa GetECDsaPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }
                [System.Flags]
                public enum OpenFlags
                {
                    ReadOnly = 0,
                    ReadWrite = 1,
                    MaxAllowed = 2,
                    OpenExistingOnly = 4,
                    IncludeArchived = 8,
                }
                public sealed class PublicKey
                {
                    public static System.Security.Cryptography.X509Certificates.PublicKey CreateFromSubjectPublicKeyInfo(System.ReadOnlySpan<byte> source, out int bytesRead) => throw null;
                    public PublicKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                    public PublicKey(System.Security.Cryptography.Oid oid, System.Security.Cryptography.AsnEncodedData parameters, System.Security.Cryptography.AsnEncodedData keyValue) => throw null;
                    public System.Security.Cryptography.AsnEncodedData EncodedKeyValue { get => throw null; }
                    public System.Security.Cryptography.AsnEncodedData EncodedParameters { get => throw null; }
                    public byte[] ExportSubjectPublicKeyInfo() => throw null;
                    public System.Security.Cryptography.DSA GetDSAPublicKey() => throw null;
                    public System.Security.Cryptography.ECDiffieHellman GetECDiffieHellmanPublicKey() => throw null;
                    public System.Security.Cryptography.ECDsa GetECDsaPublicKey() => throw null;
                    public System.Security.Cryptography.RSA GetRSAPublicKey() => throw null;
                    public System.Security.Cryptography.AsymmetricAlgorithm Key { get => throw null; }
                    public System.Security.Cryptography.Oid Oid { get => throw null; }
                    public bool TryExportSubjectPublicKeyInfo(System.Span<byte> destination, out int bytesWritten) => throw null;
                }
                public static partial class RSACertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.RSA privateKey) => throw null;
                    public static System.Security.Cryptography.RSA GetRSAPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.RSA GetRSAPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }
                public enum StoreLocation
                {
                    CurrentUser = 1,
                    LocalMachine = 2,
                }
                public enum StoreName
                {
                    AddressBook = 1,
                    AuthRoot = 2,
                    CertificateAuthority = 3,
                    Disallowed = 4,
                    My = 5,
                    Root = 6,
                    TrustedPeople = 7,
                    TrustedPublisher = 8,
                }
                public sealed class SubjectAlternativeNameBuilder
                {
                    public void AddDnsName(string dnsName) => throw null;
                    public void AddEmailAddress(string emailAddress) => throw null;
                    public void AddIpAddress(System.Net.IPAddress ipAddress) => throw null;
                    public void AddUri(System.Uri uri) => throw null;
                    public void AddUserPrincipalName(string upn) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Extension Build(bool critical = default(bool)) => throw null;
                    public SubjectAlternativeNameBuilder() => throw null;
                }
                public sealed class X500DistinguishedName : System.Security.Cryptography.AsnEncodedData
                {
                    public X500DistinguishedName(byte[] encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.ReadOnlySpan<byte> encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.Security.Cryptography.AsnEncodedData encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.Security.Cryptography.X509Certificates.X500DistinguishedName distinguishedName) => throw null;
                    public X500DistinguishedName(string distinguishedName) => throw null;
                    public X500DistinguishedName(string distinguishedName, System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags flag) => throw null;
                    public string Decode(System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags flag) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X500RelativeDistinguishedName> EnumerateRelativeDistinguishedNames(bool reversed = default(bool)) => throw null;
                    public override string Format(bool multiLine) => throw null;
                    public string Name { get => throw null; }
                }
                public sealed class X500DistinguishedNameBuilder
                {
                    public void Add(System.Security.Cryptography.Oid oid, string value, System.Formats.Asn1.UniversalTagNumber? stringEncodingType = default(System.Formats.Asn1.UniversalTagNumber?)) => throw null;
                    public void Add(string oidValue, string value, System.Formats.Asn1.UniversalTagNumber? stringEncodingType = default(System.Formats.Asn1.UniversalTagNumber?)) => throw null;
                    public void AddCommonName(string commonName) => throw null;
                    public void AddCountryOrRegion(string twoLetterCode) => throw null;
                    public void AddDomainComponent(string domainComponent) => throw null;
                    public void AddEmailAddress(string emailAddress) => throw null;
                    public void AddLocalityName(string localityName) => throw null;
                    public void AddOrganizationalUnitName(string organizationalUnitName) => throw null;
                    public void AddOrganizationName(string organizationName) => throw null;
                    public void AddStateOrProvinceName(string stateOrProvinceName) => throw null;
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName Build() => throw null;
                    public X500DistinguishedNameBuilder() => throw null;
                }
                [System.Flags]
                public enum X500DistinguishedNameFlags
                {
                    None = 0,
                    Reversed = 1,
                    UseSemicolons = 16,
                    DoNotUsePlusSign = 32,
                    DoNotUseQuotes = 64,
                    UseCommas = 128,
                    UseNewLines = 256,
                    UseUTF8Encoding = 4096,
                    UseT61Encoding = 8192,
                    ForceUTF8Encoding = 16384,
                }
                public sealed class X500RelativeDistinguishedName
                {
                    public System.Security.Cryptography.Oid GetSingleElementType() => throw null;
                    public string GetSingleElementValue() => throw null;
                    public bool HasMultipleElements { get => throw null; }
                    public System.ReadOnlyMemory<byte> RawData { get => throw null; }
                }
                public sealed class X509AuthorityInformationAccessExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public X509AuthorityInformationAccessExtension() => throw null;
                    public X509AuthorityInformationAccessExtension(byte[] rawData, bool critical = default(bool)) => throw null;
                    public X509AuthorityInformationAccessExtension(System.Collections.Generic.IEnumerable<string> ocspUris, System.Collections.Generic.IEnumerable<string> caIssuersUris, bool critical = default(bool)) => throw null;
                    public X509AuthorityInformationAccessExtension(System.ReadOnlySpan<byte> rawData, bool critical = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateCAIssuersUris() => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateOcspUris() => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateUris(System.Security.Cryptography.Oid accessMethodOid) => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateUris(string accessMethodOid) => throw null;
                }
                public sealed class X509AuthorityKeyIdentifierExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension Create(byte[] keyIdentifier, System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, byte[] serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension Create(System.ReadOnlySpan<byte> keyIdentifier, System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.ReadOnlySpan<byte> serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool includeKeyIdentifier, bool includeIssuerAndSerial) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromIssuerNameAndSerialNumber(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, byte[] serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromIssuerNameAndSerialNumber(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.ReadOnlySpan<byte> serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromSubjectKeyIdentifier(byte[] subjectKeyIdentifier) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromSubjectKeyIdentifier(System.ReadOnlySpan<byte> subjectKeyIdentifier) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromSubjectKeyIdentifier(System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierExtension subjectKeyIdentifier) => throw null;
                    public X509AuthorityKeyIdentifierExtension() => throw null;
                    public X509AuthorityKeyIdentifierExtension(byte[] rawData, bool critical = default(bool)) => throw null;
                    public X509AuthorityKeyIdentifierExtension(System.ReadOnlySpan<byte> rawData, bool critical = default(bool)) => throw null;
                    public System.ReadOnlyMemory<byte>? KeyIdentifier { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName NamedIssuer { get => throw null; }
                    public System.ReadOnlyMemory<byte>? RawIssuer { get => throw null; }
                    public System.ReadOnlyMemory<byte>? SerialNumber { get => throw null; }
                }
                public sealed class X509BasicConstraintsExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public bool CertificateAuthority { get => throw null; }
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension CreateForCertificateAuthority(int? pathLengthConstraint = default(int?)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension CreateForEndEntity(bool critical = default(bool)) => throw null;
                    public X509BasicConstraintsExtension() => throw null;
                    public X509BasicConstraintsExtension(bool certificateAuthority, bool hasPathLengthConstraint, int pathLengthConstraint, bool critical) => throw null;
                    public X509BasicConstraintsExtension(System.Security.Cryptography.AsnEncodedData encodedBasicConstraints, bool critical) => throw null;
                    public bool HasPathLengthConstraint { get => throw null; }
                    public int PathLengthConstraint { get => throw null; }
                }
                public class X509Certificate : System.Runtime.Serialization.IDeserializationCallback, System.IDisposable, System.Runtime.Serialization.ISerializable
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate CreateFromCertFile(string filename) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate CreateFromSignedFile(string filename) => throw null;
                    public X509Certificate() => throw null;
                    public X509Certificate(byte[] data) => throw null;
                    public X509Certificate(byte[] rawData, System.Security.SecureString password) => throw null;
                    public X509Certificate(byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate(byte[] rawData, string password) => throw null;
                    public X509Certificate(byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate(nint handle) => throw null;
                    public X509Certificate(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public X509Certificate(System.Security.Cryptography.X509Certificates.X509Certificate cert) => throw null;
                    public X509Certificate(string fileName) => throw null;
                    public X509Certificate(string fileName, System.Security.SecureString password) => throw null;
                    public X509Certificate(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate(string fileName, string password) => throw null;
                    public X509Certificate(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public virtual bool Equals(System.Security.Cryptography.X509Certificates.X509Certificate other) => throw null;
                    public virtual byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType) => throw null;
                    public virtual byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, System.Security.SecureString password) => throw null;
                    public virtual byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, string password) => throw null;
                    protected static string FormatDate(System.DateTime date) => throw null;
                    public virtual byte[] GetCertHash() => throw null;
                    public virtual byte[] GetCertHash(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public virtual string GetCertHashString() => throw null;
                    public virtual string GetCertHashString(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public virtual string GetEffectiveDateString() => throw null;
                    public virtual string GetExpirationDateString() => throw null;
                    public virtual string GetFormat() => throw null;
                    public override int GetHashCode() => throw null;
                    public virtual string GetIssuerName() => throw null;
                    public virtual string GetKeyAlgorithm() => throw null;
                    public virtual byte[] GetKeyAlgorithmParameters() => throw null;
                    public virtual string GetKeyAlgorithmParametersString() => throw null;
                    public virtual string GetName() => throw null;
                    void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public virtual byte[] GetPublicKey() => throw null;
                    public virtual string GetPublicKeyString() => throw null;
                    public virtual byte[] GetRawCertData() => throw null;
                    public virtual string GetRawCertDataString() => throw null;
                    public virtual byte[] GetSerialNumber() => throw null;
                    public virtual string GetSerialNumberString() => throw null;
                    public nint Handle { get => throw null; }
                    public virtual void Import(byte[] rawData) => throw null;
                    public virtual void Import(byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public virtual void Import(byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public virtual void Import(string fileName) => throw null;
                    public virtual void Import(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public virtual void Import(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public string Issuer { get => throw null; }
                    void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                    public virtual void Reset() => throw null;
                    public System.ReadOnlyMemory<byte> SerialNumberBytes { get => throw null; }
                    public string Subject { get => throw null; }
                    public override string ToString() => throw null;
                    public virtual string ToString(bool fVerbose) => throw null;
                    public virtual bool TryGetCertHash(System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Span<byte> destination, out int bytesWritten) => throw null;
                }
                public class X509Certificate2 : System.Security.Cryptography.X509Certificates.X509Certificate
                {
                    public bool Archived { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(System.Security.Cryptography.ECDiffieHellman privateKey) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromEncryptedPem(System.ReadOnlySpan<char> certPem, System.ReadOnlySpan<char> keyPem, System.ReadOnlySpan<char> password) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromEncryptedPemFile(string certPemFilePath, System.ReadOnlySpan<char> password, string keyPemFilePath = default(string)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPem(System.ReadOnlySpan<char> certPem) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPem(System.ReadOnlySpan<char> certPem, System.ReadOnlySpan<char> keyPem) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPemFile(string certPemFilePath, string keyPemFilePath = default(string)) => throw null;
                    public X509Certificate2() => throw null;
                    public X509Certificate2(byte[] rawData) => throw null;
                    public X509Certificate2(byte[] rawData, System.Security.SecureString password) => throw null;
                    public X509Certificate2(byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate2(byte[] rawData, string password) => throw null;
                    public X509Certificate2(byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate2(nint handle) => throw null;
                    public X509Certificate2(System.ReadOnlySpan<byte> rawData) => throw null;
                    public X509Certificate2(System.ReadOnlySpan<byte> rawData, System.ReadOnlySpan<char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    protected X509Certificate2(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public X509Certificate2(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                    public X509Certificate2(string fileName) => throw null;
                    public X509Certificate2(string fileName, System.ReadOnlySpan<char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public X509Certificate2(string fileName, System.Security.SecureString password) => throw null;
                    public X509Certificate2(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate2(string fileName, string password) => throw null;
                    public X509Certificate2(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public string ExportCertificatePem() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509ExtensionCollection Extensions { get => throw null; }
                    public string FriendlyName { get => throw null; set { } }
                    public static System.Security.Cryptography.X509Certificates.X509ContentType GetCertContentType(byte[] rawData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509ContentType GetCertContentType(System.ReadOnlySpan<byte> rawData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509ContentType GetCertContentType(string fileName) => throw null;
                    public System.Security.Cryptography.ECDiffieHellman GetECDiffieHellmanPrivateKey() => throw null;
                    public System.Security.Cryptography.ECDiffieHellman GetECDiffieHellmanPublicKey() => throw null;
                    public string GetNameInfo(System.Security.Cryptography.X509Certificates.X509NameType nameType, bool forIssuer) => throw null;
                    public bool HasPrivateKey { get => throw null; }
                    public override void Import(byte[] rawData) => throw null;
                    public override void Import(byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public override void Import(byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public override void Import(string fileName) => throw null;
                    public override void Import(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public override void Import(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName IssuerName { get => throw null; }
                    public bool MatchesHostname(string hostname, bool allowWildcards = default(bool), bool allowCommonName = default(bool)) => throw null;
                    public System.DateTime NotAfter { get => throw null; }
                    public System.DateTime NotBefore { get => throw null; }
                    public System.Security.Cryptography.AsymmetricAlgorithm PrivateKey { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public byte[] RawData { get => throw null; }
                    public System.ReadOnlyMemory<byte> RawDataMemory { get => throw null; }
                    public override void Reset() => throw null;
                    public string SerialNumber { get => throw null; }
                    public System.Security.Cryptography.Oid SignatureAlgorithm { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName SubjectName { get => throw null; }
                    public string Thumbprint { get => throw null; }
                    public override string ToString() => throw null;
                    public override string ToString(bool verbose) => throw null;
                    public bool TryExportCertificatePem(System.Span<char> destination, out int charsWritten) => throw null;
                    public bool Verify() => throw null;
                    public int Version { get => throw null; }
                }
                public class X509Certificate2Collection : System.Security.Cryptography.X509Certificates.X509CertificateCollection, System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Certificate2>, System.Collections.IEnumerable
                {
                    public int Add(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                    public bool Contains(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public X509Certificate2Collection() => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                    public byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType) => throw null;
                    public byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, string password) => throw null;
                    public string ExportCertificatePems() => throw null;
                    public string ExportPkcs7Pem() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Find(System.Security.Cryptography.X509Certificates.X509FindType findType, object findValue, bool validOnly) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Certificate2> System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Certificate2>.GetEnumerator() => throw null;
                    public void Import(byte[] rawData) => throw null;
                    public void Import(byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(System.ReadOnlySpan<byte> rawData) => throw null;
                    public void Import(System.ReadOnlySpan<byte> rawData, System.ReadOnlySpan<char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(System.ReadOnlySpan<byte> rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(string fileName) => throw null;
                    public void Import(string fileName, System.ReadOnlySpan<char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void ImportFromPem(System.ReadOnlySpan<char> certPem) => throw null;
                    public void ImportFromPemFile(string certPemFilePath) => throw null;
                    public void Insert(int index, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void Remove(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void RemoveRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public void RemoveRange(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 this[int index] { get => throw null; set { } }
                    public bool TryExportCertificatePems(System.Span<char> destination, out int charsWritten) => throw null;
                    public bool TryExportPkcs7Pem(System.Span<char> destination, out int charsWritten) => throw null;
                }
                public sealed class X509Certificate2Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Certificate2>, System.Collections.IEnumerator
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    bool System.Collections.IEnumerator.MoveNext() => throw null;
                    public void Reset() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public class X509CertificateCollection : System.Collections.CollectionBase
                {
                    public int Add(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509CertificateCollection value) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate[] value) => throw null;
                    public bool Contains(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public void CopyTo(System.Security.Cryptography.X509Certificates.X509Certificate[] array, int index) => throw null;
                    public X509CertificateCollection() => throw null;
                    public X509CertificateCollection(System.Security.Cryptography.X509Certificates.X509CertificateCollection value) => throw null;
                    public X509CertificateCollection(System.Security.Cryptography.X509Certificates.X509Certificate[] value) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509CertificateCollection.X509CertificateEnumerator GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    public int IndexOf(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public void Insert(int index, System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    protected override void OnValidate(object value) => throw null;
                    public void Remove(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate this[int index] { get => throw null; set { } }
                    public class X509CertificateEnumerator : System.Collections.IEnumerator
                    {
                        public X509CertificateEnumerator(System.Security.Cryptography.X509Certificates.X509CertificateCollection mappings) => throw null;
                        public System.Security.Cryptography.X509Certificates.X509Certificate Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public bool MoveNext() => throw null;
                        bool System.Collections.IEnumerator.MoveNext() => throw null;
                        public void Reset() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                }
                public class X509Chain : System.IDisposable
                {
                    public bool Build(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public nint ChainContext { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainElementCollection ChainElements { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainPolicy ChainPolicy { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509ChainStatus[] ChainStatus { get => throw null; }
                    public static System.Security.Cryptography.X509Certificates.X509Chain Create() => throw null;
                    public X509Chain() => throw null;
                    public X509Chain(bool useMachineContext) => throw null;
                    public X509Chain(nint chainContext) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public void Reset() => throw null;
                    public Microsoft.Win32.SafeHandles.SafeX509ChainHandle SafeHandle { get => throw null; }
                }
                public class X509ChainElement
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainStatus[] ChainElementStatus { get => throw null; }
                    public string Information { get => throw null; }
                }
                public sealed class X509ChainElementCollection : System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509ChainElement>, System.Collections.IEnumerable
                {
                    public void CopyTo(System.Security.Cryptography.X509Certificates.X509ChainElement[] array, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainElementEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509ChainElement> System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509ChainElement>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public object SyncRoot { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainElement this[int index] { get => throw null; }
                }
                public sealed class X509ChainElementEnumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509ChainElement>, System.Collections.IEnumerator
                {
                    public System.Security.Cryptography.X509Certificates.X509ChainElement Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public sealed class X509ChainPolicy
                {
                    public System.Security.Cryptography.OidCollection ApplicationPolicy { get => throw null; }
                    public System.Security.Cryptography.OidCollection CertificatePolicy { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainPolicy Clone() => throw null;
                    public X509ChainPolicy() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection CustomTrustStore { get => throw null; }
                    public bool DisableCertificateDownloads { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection ExtraStore { get => throw null; }
                    public void Reset() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509RevocationFlag RevocationFlag { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509RevocationMode RevocationMode { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509ChainTrustMode TrustMode { get => throw null; set { } }
                    public System.TimeSpan UrlRetrievalTimeout { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509VerificationFlags VerificationFlags { get => throw null; set { } }
                    public System.DateTime VerificationTime { get => throw null; set { } }
                    public bool VerificationTimeIgnored { get => throw null; set { } }
                }
                public struct X509ChainStatus
                {
                    public System.Security.Cryptography.X509Certificates.X509ChainStatusFlags Status { get => throw null; set { } }
                    public string StatusInformation { get => throw null; set { } }
                }
                [System.Flags]
                public enum X509ChainStatusFlags
                {
                    NoError = 0,
                    NotTimeValid = 1,
                    NotTimeNested = 2,
                    Revoked = 4,
                    NotSignatureValid = 8,
                    NotValidForUsage = 16,
                    UntrustedRoot = 32,
                    RevocationStatusUnknown = 64,
                    Cyclic = 128,
                    InvalidExtension = 256,
                    InvalidPolicyConstraints = 512,
                    InvalidBasicConstraints = 1024,
                    InvalidNameConstraints = 2048,
                    HasNotSupportedNameConstraint = 4096,
                    HasNotDefinedNameConstraint = 8192,
                    HasNotPermittedNameConstraint = 16384,
                    HasExcludedNameConstraint = 32768,
                    PartialChain = 65536,
                    CtlNotTimeValid = 131072,
                    CtlNotSignatureValid = 262144,
                    CtlNotValidForUsage = 524288,
                    HasWeakSignature = 1048576,
                    OfflineRevocation = 16777216,
                    NoIssuanceChainPolicy = 33554432,
                    ExplicitDistrust = 67108864,
                    HasNotSupportedCriticalExtension = 134217728,
                }
                public enum X509ChainTrustMode
                {
                    System = 0,
                    CustomRootTrust = 1,
                }
                public enum X509ContentType
                {
                    Unknown = 0,
                    Cert = 1,
                    SerializedCert = 2,
                    Pfx = 3,
                    Pkcs12 = 3,
                    SerializedStore = 4,
                    Pkcs7 = 5,
                    Authenticode = 6,
                }
                public sealed class X509EnhancedKeyUsageExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public X509EnhancedKeyUsageExtension() => throw null;
                    public X509EnhancedKeyUsageExtension(System.Security.Cryptography.AsnEncodedData encodedEnhancedKeyUsages, bool critical) => throw null;
                    public X509EnhancedKeyUsageExtension(System.Security.Cryptography.OidCollection enhancedKeyUsages, bool critical) => throw null;
                    public System.Security.Cryptography.OidCollection EnhancedKeyUsages { get => throw null; }
                }
                public class X509Extension : System.Security.Cryptography.AsnEncodedData
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public bool Critical { get => throw null; set { } }
                    protected X509Extension() => throw null;
                    public X509Extension(System.Security.Cryptography.AsnEncodedData encodedExtension, bool critical) => throw null;
                    public X509Extension(System.Security.Cryptography.Oid oid, byte[] rawData, bool critical) => throw null;
                    public X509Extension(System.Security.Cryptography.Oid oid, System.ReadOnlySpan<byte> rawData, bool critical) => throw null;
                    public X509Extension(string oid, byte[] rawData, bool critical) => throw null;
                    public X509Extension(string oid, System.ReadOnlySpan<byte> rawData, bool critical) => throw null;
                }
                public sealed class X509ExtensionCollection : System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Extension>, System.Collections.IEnumerable
                {
                    public int Add(System.Security.Cryptography.X509Certificates.X509Extension extension) => throw null;
                    public void CopyTo(System.Security.Cryptography.X509Certificates.X509Extension[] array, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public X509ExtensionCollection() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509ExtensionEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Extension> System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Extension>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public object SyncRoot { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Extension this[int index] { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Extension this[string oid] { get => throw null; }
                }
                public sealed class X509ExtensionEnumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Extension>, System.Collections.IEnumerator
                {
                    public System.Security.Cryptography.X509Certificates.X509Extension Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public enum X509FindType
                {
                    FindByThumbprint = 0,
                    FindBySubjectName = 1,
                    FindBySubjectDistinguishedName = 2,
                    FindByIssuerName = 3,
                    FindByIssuerDistinguishedName = 4,
                    FindBySerialNumber = 5,
                    FindByTimeValid = 6,
                    FindByTimeNotYetValid = 7,
                    FindByTimeExpired = 8,
                    FindByTemplateName = 9,
                    FindByApplicationPolicy = 10,
                    FindByCertificatePolicy = 11,
                    FindByExtension = 12,
                    FindByKeyUsage = 13,
                    FindBySubjectKeyIdentifier = 14,
                }
                public enum X509IncludeOption
                {
                    None = 0,
                    ExcludeRoot = 1,
                    EndCertOnly = 2,
                    WholeChain = 3,
                }
                [System.Flags]
                public enum X509KeyStorageFlags
                {
                    DefaultKeySet = 0,
                    UserKeySet = 1,
                    MachineKeySet = 2,
                    Exportable = 4,
                    UserProtected = 8,
                    PersistKeySet = 16,
                    EphemeralKeySet = 32,
                }
                public sealed class X509KeyUsageExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public X509KeyUsageExtension() => throw null;
                    public X509KeyUsageExtension(System.Security.Cryptography.AsnEncodedData encodedKeyUsage, bool critical) => throw null;
                    public X509KeyUsageExtension(System.Security.Cryptography.X509Certificates.X509KeyUsageFlags keyUsages, bool critical) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509KeyUsageFlags KeyUsages { get => throw null; }
                }
                [System.Flags]
                public enum X509KeyUsageFlags
                {
                    None = 0,
                    EncipherOnly = 1,
                    CrlSign = 2,
                    KeyCertSign = 4,
                    KeyAgreement = 8,
                    DataEncipherment = 16,
                    KeyEncipherment = 32,
                    NonRepudiation = 64,
                    DigitalSignature = 128,
                    DecipherOnly = 32768,
                }
                public enum X509NameType
                {
                    SimpleName = 0,
                    EmailName = 1,
                    UpnName = 2,
                    DnsName = 3,
                    DnsFromAlternativeName = 4,
                    UrlName = 5,
                }
                public enum X509RevocationFlag
                {
                    EndCertificateOnly = 0,
                    EntireChain = 1,
                    ExcludeRoot = 2,
                }
                public enum X509RevocationMode
                {
                    NoCheck = 0,
                    Online = 1,
                    Offline = 2,
                }
                public enum X509RevocationReason
                {
                    Unspecified = 0,
                    KeyCompromise = 1,
                    CACompromise = 2,
                    AffiliationChanged = 3,
                    Superseded = 4,
                    CessationOfOperation = 5,
                    CertificateHold = 6,
                    RemoveFromCrl = 8,
                    PrivilegeWithdrawn = 9,
                    AACompromise = 10,
                    WeakAlgorithmOrKey = 11,
                }
                public abstract class X509SignatureGenerator
                {
                    protected abstract System.Security.Cryptography.X509Certificates.PublicKey BuildPublicKey();
                    public static System.Security.Cryptography.X509Certificates.X509SignatureGenerator CreateForECDsa(System.Security.Cryptography.ECDsa key) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509SignatureGenerator CreateForRSA(System.Security.Cryptography.RSA key, System.Security.Cryptography.RSASignaturePadding signaturePadding) => throw null;
                    protected X509SignatureGenerator() => throw null;
                    public abstract byte[] GetSignatureAlgorithmIdentifier(System.Security.Cryptography.HashAlgorithmName hashAlgorithm);
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public abstract byte[] SignData(byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm);
                }
                public sealed class X509Store : System.IDisposable
                {
                    public void Add(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Certificates { get => throw null; }
                    public void Close() => throw null;
                    public X509Store() => throw null;
                    public X509Store(nint storeHandle) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreLocation storeLocation) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreName storeName) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreName storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreName storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, System.Security.Cryptography.X509Certificates.OpenFlags flags) => throw null;
                    public X509Store(string storeName) => throw null;
                    public X509Store(string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation) => throw null;
                    public X509Store(string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, System.Security.Cryptography.X509Certificates.OpenFlags flags) => throw null;
                    public void Dispose() => throw null;
                    public bool IsOpen { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.StoreLocation Location { get => throw null; }
                    public string Name { get => throw null; }
                    public void Open(System.Security.Cryptography.X509Certificates.OpenFlags flags) => throw null;
                    public void Remove(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void RemoveRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public nint StoreHandle { get => throw null; }
                }
                public sealed class X509SubjectAlternativeNameExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public X509SubjectAlternativeNameExtension() => throw null;
                    public X509SubjectAlternativeNameExtension(byte[] rawData, bool critical = default(bool)) => throw null;
                    public X509SubjectAlternativeNameExtension(System.ReadOnlySpan<byte> rawData, bool critical = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateDnsNames() => throw null;
                    public System.Collections.Generic.IEnumerable<System.Net.IPAddress> EnumerateIPAddresses() => throw null;
                }
                public sealed class X509SubjectKeyIdentifierExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public X509SubjectKeyIdentifierExtension() => throw null;
                    public X509SubjectKeyIdentifierExtension(byte[] subjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.ReadOnlySpan<byte> subjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.AsnEncodedData encodedSubjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.X509Certificates.PublicKey key, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.X509Certificates.PublicKey key, System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierHashAlgorithm algorithm, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(string subjectKeyIdentifier, bool critical) => throw null;
                    public string SubjectKeyIdentifier { get => throw null; }
                    public System.ReadOnlyMemory<byte> SubjectKeyIdentifierBytes { get => throw null; }
                }
                public enum X509SubjectKeyIdentifierHashAlgorithm
                {
                    Sha1 = 0,
                    ShortSha1 = 1,
                    CapiSha1 = 2,
                }
                [System.Flags]
                public enum X509VerificationFlags
                {
                    NoFlag = 0,
                    IgnoreNotTimeValid = 1,
                    IgnoreCtlNotTimeValid = 2,
                    IgnoreNotTimeNested = 4,
                    IgnoreInvalidBasicConstraints = 8,
                    AllowUnknownCertificateAuthority = 16,
                    IgnoreWrongUsage = 32,
                    IgnoreInvalidName = 64,
                    IgnoreInvalidPolicy = 128,
                    IgnoreEndRevocationUnknown = 256,
                    IgnoreCtlSignerRevocationUnknown = 512,
                    IgnoreCertificateAuthorityRevocationUnknown = 1024,
                    IgnoreRootRevocationUnknown = 2048,
                    AllFlags = 4095,
                }
            }
        }
    }
}
