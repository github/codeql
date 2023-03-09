// This file contains auto-generated code.
// Generated from `System.Security.Cryptography, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public abstract class SafeNCryptHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                protected override bool ReleaseHandle() => throw null;
                protected abstract bool ReleaseNativeHandle();
                protected SafeNCryptHandle() : base(default(bool)) => throw null;
                protected SafeNCryptHandle(System.IntPtr handle, System.Runtime.InteropServices.SafeHandle parentHandle) : base(default(bool)) => throw null;
            }

            public class SafeNCryptKeyHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                protected override bool ReleaseNativeHandle() => throw null;
                public SafeNCryptKeyHandle() => throw null;
                public SafeNCryptKeyHandle(System.IntPtr handle, System.Runtime.InteropServices.SafeHandle parentHandle) => throw null;
            }

            public class SafeNCryptProviderHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                protected override bool ReleaseNativeHandle() => throw null;
                public SafeNCryptProviderHandle() => throw null;
            }

            public class SafeNCryptSecretHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                protected override bool ReleaseNativeHandle() => throw null;
                public SafeNCryptSecretHandle() => throw null;
            }

            public class SafeX509ChainHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override bool ReleaseHandle() => throw null;
                public SafeX509ChainHandle() : base(default(bool)) => throw null;
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
                protected Aes() => throw null;
                public static System.Security.Cryptography.Aes Create() => throw null;
                public static System.Security.Cryptography.Aes Create(string algorithmName) => throw null;
            }

            public class AesCcm : System.IDisposable
            {
                public AesCcm(System.Byte[] key) => throw null;
                public AesCcm(System.ReadOnlySpan<System.Byte> key) => throw null;
                public void Decrypt(System.Byte[] nonce, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] plaintext, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> tag, System.Span<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(System.Byte[] nonce, System.Byte[] plaintext, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> ciphertext, System.Span<System.Byte> tag, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public static bool IsSupported { get => throw null; }
                public static System.Security.Cryptography.KeySizes NonceByteSizes { get => throw null; }
                public static System.Security.Cryptography.KeySizes TagByteSizes { get => throw null; }
            }

            public class AesCng : System.Security.Cryptography.Aes
            {
                public AesCng() => throw null;
                public AesCng(string keyName) => throw null;
                public AesCng(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public AesCng(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                protected override bool TryDecryptCbcCore(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryDecryptCfbCore(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryDecryptEcbCore(System.ReadOnlySpan<System.Byte> ciphertext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCbcCore(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCfbCore(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryEncryptEcbCore(System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
            }

            public class AesCryptoServiceProvider : System.Security.Cryptography.Aes
            {
                public AesCryptoServiceProvider() => throw null;
                public override int BlockSize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set => throw null; }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] IV { get => throw null; set => throw null; }
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set => throw null; }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set => throw null; }
            }

            public class AesGcm : System.IDisposable
            {
                public AesGcm(System.Byte[] key) => throw null;
                public AesGcm(System.ReadOnlySpan<System.Byte> key) => throw null;
                public void Decrypt(System.Byte[] nonce, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] plaintext, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> tag, System.Span<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(System.Byte[] nonce, System.Byte[] plaintext, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> ciphertext, System.Span<System.Byte> tag, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public static bool IsSupported { get => throw null; }
                public static System.Security.Cryptography.KeySizes NonceByteSizes { get => throw null; }
                public static System.Security.Cryptography.KeySizes TagByteSizes { get => throw null; }
            }

            public class AesManaged : System.Security.Cryptography.Aes
            {
                public AesManaged() => throw null;
                public override int BlockSize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set => throw null; }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] IV { get => throw null; set => throw null; }
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set => throw null; }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set => throw null; }
            }

            public class AsnEncodedData
            {
                protected AsnEncodedData() => throw null;
                public AsnEncodedData(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public AsnEncodedData(System.Byte[] rawData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.Oid oid, System.Byte[] rawData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.Oid oid, System.ReadOnlySpan<System.Byte> rawData) => throw null;
                public AsnEncodedData(System.ReadOnlySpan<System.Byte> rawData) => throw null;
                public AsnEncodedData(string oid, System.Byte[] rawData) => throw null;
                public AsnEncodedData(string oid, System.ReadOnlySpan<System.Byte> rawData) => throw null;
                public virtual void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public virtual string Format(bool multiLine) => throw null;
                public System.Security.Cryptography.Oid Oid { get => throw null; set => throw null; }
                public System.Byte[] RawData { get => throw null; set => throw null; }
            }

            public class AsnEncodedDataCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public AsnEncodedDataCollection() => throw null;
                public AsnEncodedDataCollection(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.Cryptography.AsnEncodedData[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Cryptography.AsnEncodedDataEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Security.Cryptography.AsnEncodedData this[int index] { get => throw null; }
                public void Remove(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public object SyncRoot { get => throw null; }
            }

            public class AsnEncodedDataEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.AsnEncodedData Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

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
                public string ExportEncryptedPkcs8PrivateKeyPem(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public virtual System.Byte[] ExportPkcs8PrivateKey() => throw null;
                public string ExportPkcs8PrivateKeyPem() => throw null;
                public virtual System.Byte[] ExportSubjectPublicKeyInfo() => throw null;
                public string ExportSubjectPublicKeyInfoPem() => throw null;
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
                public bool TryExportEncryptedPkcs8PrivateKeyPem(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Char> destination, out int charsWritten) => throw null;
                public virtual bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool TryExportPkcs8PrivateKeyPem(System.Span<System.Char> destination, out int charsWritten) => throw null;
                public virtual bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool TryExportSubjectPublicKeyInfoPem(System.Span<System.Char> destination, out int charsWritten) => throw null;
            }

            public abstract class AsymmetricKeyExchangeDeformatter
            {
                protected AsymmetricKeyExchangeDeformatter() => throw null;
                public abstract System.Byte[] DecryptKeyExchange(System.Byte[] rgb);
                public abstract string Parameters { get; set; }
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }

            public abstract class AsymmetricKeyExchangeFormatter
            {
                protected AsymmetricKeyExchangeFormatter() => throw null;
                public abstract System.Byte[] CreateKeyExchange(System.Byte[] data);
                public abstract System.Byte[] CreateKeyExchange(System.Byte[] data, System.Type symAlgType);
                public abstract string Parameters { get; }
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }

            public abstract class AsymmetricSignatureDeformatter
            {
                protected AsymmetricSignatureDeformatter() => throw null;
                public abstract void SetHashAlgorithm(string strName);
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
                public abstract bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature);
                public virtual bool VerifySignature(System.Security.Cryptography.HashAlgorithm hash, System.Byte[] rgbSignature) => throw null;
            }

            public abstract class AsymmetricSignatureFormatter
            {
                protected AsymmetricSignatureFormatter() => throw null;
                public abstract System.Byte[] CreateSignature(System.Byte[] rgbHash);
                public virtual System.Byte[] CreateSignature(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                public abstract void SetHashAlgorithm(string strName);
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }

            public class ChaCha20Poly1305 : System.IDisposable
            {
                public ChaCha20Poly1305(System.Byte[] key) => throw null;
                public ChaCha20Poly1305(System.ReadOnlySpan<System.Byte> key) => throw null;
                public void Decrypt(System.Byte[] nonce, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] plaintext, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> tag, System.Span<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(System.Byte[] nonce, System.Byte[] plaintext, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> ciphertext, System.Span<System.Byte> tag, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public static bool IsSupported { get => throw null; }
            }

            public enum CipherMode : int
            {
                CBC = 1,
                CFB = 4,
                CTS = 5,
                ECB = 2,
                OFB = 3,
            }

            public class CngAlgorithm : System.IEquatable<System.Security.Cryptography.CngAlgorithm>
            {
                public static bool operator !=(System.Security.Cryptography.CngAlgorithm left, System.Security.Cryptography.CngAlgorithm right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngAlgorithm left, System.Security.Cryptography.CngAlgorithm right) => throw null;
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
                public bool Equals(System.Security.Cryptography.CngAlgorithm other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngAlgorithm MD5 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Rsa { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha1 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha256 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha384 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha512 { get => throw null; }
                public override string ToString() => throw null;
            }

            public class CngAlgorithmGroup : System.IEquatable<System.Security.Cryptography.CngAlgorithmGroup>
            {
                public static bool operator !=(System.Security.Cryptography.CngAlgorithmGroup left, System.Security.Cryptography.CngAlgorithmGroup right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngAlgorithmGroup left, System.Security.Cryptography.CngAlgorithmGroup right) => throw null;
                public string AlgorithmGroup { get => throw null; }
                public CngAlgorithmGroup(string algorithmGroup) => throw null;
                public static System.Security.Cryptography.CngAlgorithmGroup DiffieHellman { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithmGroup Dsa { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithmGroup ECDiffieHellman { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithmGroup ECDsa { get => throw null; }
                public bool Equals(System.Security.Cryptography.CngAlgorithmGroup other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngAlgorithmGroup Rsa { get => throw null; }
                public override string ToString() => throw null;
            }

            [System.Flags]
            public enum CngExportPolicies : int
            {
                AllowArchiving = 4,
                AllowExport = 1,
                AllowPlaintextArchiving = 8,
                AllowPlaintextExport = 2,
                None = 0,
            }

            public class CngKey : System.IDisposable
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
                public System.Byte[] Export(System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public System.Security.Cryptography.CngExportPolicies ExportPolicy { get => throw null; }
                public System.Security.Cryptography.CngProperty GetProperty(string name, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle Handle { get => throw null; }
                public bool HasProperty(string name, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public static System.Security.Cryptography.CngKey Import(System.Byte[] keyBlob, System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public static System.Security.Cryptography.CngKey Import(System.Byte[] keyBlob, System.Security.Cryptography.CngKeyBlobFormat format, System.Security.Cryptography.CngProvider provider) => throw null;
                public bool IsEphemeral { get => throw null; }
                public bool IsMachineKey { get => throw null; }
                public string KeyName { get => throw null; }
                public int KeySize { get => throw null; }
                public System.Security.Cryptography.CngKeyUsages KeyUsage { get => throw null; }
                public static System.Security.Cryptography.CngKey Open(Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle keyHandle, System.Security.Cryptography.CngKeyHandleOpenOptions keyHandleOpenOptions) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                public System.IntPtr ParentWindowHandle { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngProvider Provider { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeNCryptProviderHandle ProviderHandle { get => throw null; }
                public void SetProperty(System.Security.Cryptography.CngProperty property) => throw null;
                public System.Security.Cryptography.CngUIPolicy UIPolicy { get => throw null; }
                public string UniqueName { get => throw null; }
            }

            public class CngKeyBlobFormat : System.IEquatable<System.Security.Cryptography.CngKeyBlobFormat>
            {
                public static bool operator !=(System.Security.Cryptography.CngKeyBlobFormat left, System.Security.Cryptography.CngKeyBlobFormat right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngKeyBlobFormat left, System.Security.Cryptography.CngKeyBlobFormat right) => throw null;
                public CngKeyBlobFormat(string format) => throw null;
                public static System.Security.Cryptography.CngKeyBlobFormat EccFullPrivateBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat EccFullPublicBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat EccPrivateBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat EccPublicBlob { get => throw null; }
                public bool Equals(System.Security.Cryptography.CngKeyBlobFormat other) => throw null;
                public override bool Equals(object obj) => throw null;
                public string Format { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat GenericPrivateBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat GenericPublicBlob { get => throw null; }
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngKeyBlobFormat OpaqueTransportBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat Pkcs8PrivateBlob { get => throw null; }
                public override string ToString() => throw null;
            }

            [System.Flags]
            public enum CngKeyCreationOptions : int
            {
                MachineKey = 32,
                None = 0,
                OverwriteExistingKey = 128,
            }

            public class CngKeyCreationParameters
            {
                public CngKeyCreationParameters() => throw null;
                public System.Security.Cryptography.CngExportPolicies? ExportPolicy { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngKeyCreationOptions KeyCreationOptions { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngKeyUsages? KeyUsage { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngPropertyCollection Parameters { get => throw null; }
                public System.IntPtr ParentWindowHandle { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngProvider Provider { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngUIPolicy UIPolicy { get => throw null; set => throw null; }
            }

            [System.Flags]
            public enum CngKeyHandleOpenOptions : int
            {
                EphemeralKey = 1,
                None = 0,
            }

            [System.Flags]
            public enum CngKeyOpenOptions : int
            {
                MachineKey = 32,
                None = 0,
                Silent = 64,
                UserKey = 0,
            }

            [System.Flags]
            public enum CngKeyUsages : int
            {
                AllUsages = 16777215,
                Decryption = 1,
                KeyAgreement = 4,
                None = 0,
                Signing = 2,
            }

            public struct CngProperty : System.IEquatable<System.Security.Cryptography.CngProperty>
            {
                public static bool operator !=(System.Security.Cryptography.CngProperty left, System.Security.Cryptography.CngProperty right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngProperty left, System.Security.Cryptography.CngProperty right) => throw null;
                // Stub generator skipped constructor 
                public CngProperty(string name, System.Byte[] value, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public bool Equals(System.Security.Cryptography.CngProperty other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Byte[] GetValue() => throw null;
                public string Name { get => throw null; }
                public System.Security.Cryptography.CngPropertyOptions Options { get => throw null; }
            }

            public class CngPropertyCollection : System.Collections.ObjectModel.Collection<System.Security.Cryptography.CngProperty>
            {
                public CngPropertyCollection() => throw null;
            }

            [System.Flags]
            public enum CngPropertyOptions : int
            {
                CustomProperty = 1073741824,
                None = 0,
                Persist = -2147483648,
            }

            public class CngProvider : System.IEquatable<System.Security.Cryptography.CngProvider>
            {
                public static bool operator !=(System.Security.Cryptography.CngProvider left, System.Security.Cryptography.CngProvider right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngProvider left, System.Security.Cryptography.CngProvider right) => throw null;
                public CngProvider(string provider) => throw null;
                public bool Equals(System.Security.Cryptography.CngProvider other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngProvider MicrosoftPlatformCryptoProvider { get => throw null; }
                public static System.Security.Cryptography.CngProvider MicrosoftSmartCardKeyStorageProvider { get => throw null; }
                public static System.Security.Cryptography.CngProvider MicrosoftSoftwareKeyStorageProvider { get => throw null; }
                public string Provider { get => throw null; }
                public override string ToString() => throw null;
            }

            public class CngUIPolicy
            {
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description, string useContext) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description, string useContext, string creationTitle) => throw null;
                public string CreationTitle { get => throw null; }
                public string Description { get => throw null; }
                public string FriendlyName { get => throw null; }
                public System.Security.Cryptography.CngUIProtectionLevels ProtectionLevel { get => throw null; }
                public string UseContext { get => throw null; }
            }

            [System.Flags]
            public enum CngUIProtectionLevels : int
            {
                ForceHighProtection = 2,
                None = 0,
                ProtectKey = 1,
            }

            public class CryptoConfig
            {
                public static void AddAlgorithm(System.Type algorithm, params string[] names) => throw null;
                public static void AddOID(string oid, params string[] names) => throw null;
                public static bool AllowOnlyFipsAlgorithms { get => throw null; }
                public static object CreateFromName(string name) => throw null;
                public static object CreateFromName(string name, params object[] args) => throw null;
                public CryptoConfig() => throw null;
                public static System.Byte[] EncodeOID(string str) => throw null;
                public static string MapNameToOID(string name) => throw null;
            }

            public class CryptoStream : System.IO.Stream, System.IDisposable
            {
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
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
                public override System.Int64 Length { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(System.Byte value) => throw null;
            }

            public enum CryptoStreamMode : int
            {
                Read = 0,
                Write = 1,
            }

            public static class CryptographicOperations
            {
                public static bool FixedTimeEquals(System.ReadOnlySpan<System.Byte> left, System.ReadOnlySpan<System.Byte> right) => throw null;
                public static void ZeroMemory(System.Span<System.Byte> buffer) => throw null;
            }

            public class CryptographicUnexpectedOperationException : System.Security.Cryptography.CryptographicException
            {
                public CryptographicUnexpectedOperationException() => throw null;
                protected CryptographicUnexpectedOperationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CryptographicUnexpectedOperationException(string message) => throw null;
                public CryptographicUnexpectedOperationException(string message, System.Exception inner) => throw null;
                public CryptographicUnexpectedOperationException(string format, string insert) => throw null;
            }

            public class CspKeyContainerInfo
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

            public class CspParameters
            {
                public CspParameters() => throw null;
                public CspParameters(int dwTypeIn) => throw null;
                public CspParameters(int dwTypeIn, string strProviderNameIn) => throw null;
                public CspParameters(int dwTypeIn, string strProviderNameIn, string strContainerNameIn) => throw null;
                public System.Security.Cryptography.CspProviderFlags Flags { get => throw null; set => throw null; }
                public string KeyContainerName;
                public int KeyNumber;
                public System.Security.SecureString KeyPassword { get => throw null; set => throw null; }
                public System.IntPtr ParentWindowHandle { get => throw null; set => throw null; }
                public string ProviderName;
                public int ProviderType;
            }

            [System.Flags]
            public enum CspProviderFlags : int
            {
                CreateEphemeralKey = 128,
                NoFlags = 0,
                NoPrompt = 64,
                UseArchivableKey = 16,
                UseDefaultKeyContainer = 2,
                UseExistingKey = 8,
                UseMachineKeyStore = 1,
                UseNonExportableKey = 4,
                UseUserProtectedKey = 32,
            }

            public abstract class DES : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.DES Create() => throw null;
                public static System.Security.Cryptography.DES Create(string algName) => throw null;
                protected DES() => throw null;
                public static bool IsSemiWeakKey(System.Byte[] rgbKey) => throw null;
                public static bool IsWeakKey(System.Byte[] rgbKey) => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
            }

            public class DESCryptoServiceProvider : System.Security.Cryptography.DES
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public DESCryptoServiceProvider() => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
            }

            public abstract class DSA : System.Security.Cryptography.AsymmetricAlgorithm
            {
                public static System.Security.Cryptography.DSA Create() => throw null;
                public static System.Security.Cryptography.DSA Create(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public static System.Security.Cryptography.DSA Create(int keySizeInBits) => throw null;
                public static System.Security.Cryptography.DSA Create(string algName) => throw null;
                public abstract System.Byte[] CreateSignature(System.Byte[] rgbHash);
                public System.Byte[] CreateSignature(System.Byte[] rgbHash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] CreateSignatureCore(System.ReadOnlySpan<System.Byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected DSA() => throw null;
                public abstract System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters);
                public override void FromXmlString(string xmlString) => throw null;
                public int GetMaxSignatureSize(System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<System.Char> input) => throw null;
                public abstract void ImportParameters(System.Security.Cryptography.DSAParameters parameters);
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignDataCore(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignDataCore(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public bool TryCreateSignature(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public virtual bool TryCreateSignature(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryCreateSignatureCore(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryHashData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public bool TrySignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public virtual bool TrySignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                protected virtual bool TrySignDataCore(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.IO.Stream data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.IO.Stream data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.IO.Stream data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature);
                public bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifySignature(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature) => throw null;
                public bool VerifySignature(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifySignatureCore(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }

            public class DSACng : System.Security.Cryptography.DSA
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public DSACng() => throw null;
                public DSACng(System.Security.Cryptography.CngKey key) => throw null;
                public DSACng(int keySize) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                protected override bool TryCreateSignatureCore(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
                protected override bool VerifySignatureCore(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }

            public class DSACryptoServiceProvider : System.Security.Cryptography.DSA, System.Security.Cryptography.ICspAsymmetricAlgorithm
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get => throw null; }
                public DSACryptoServiceProvider() => throw null;
                public DSACryptoServiceProvider(System.Security.Cryptography.CspParameters parameters) => throw null;
                public DSACryptoServiceProvider(int dwKeySize) => throw null;
                public DSACryptoServiceProvider(int dwKeySize, System.Security.Cryptography.CspParameters parameters) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Byte[] ExportCspBlob(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public void ImportCspBlob(System.Byte[] keyBlob) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override int KeySize { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public bool PersistKeyInCsp { get => throw null; set => throw null; }
                public bool PublicOnly { get => throw null; }
                public System.Byte[] SignData(System.Byte[] buffer) => throw null;
                public System.Byte[] SignData(System.Byte[] buffer, int offset, int count) => throw null;
                public System.Byte[] SignData(System.IO.Stream inputStream) => throw null;
                public System.Byte[] SignHash(System.Byte[] rgbHash, string str) => throw null;
                public override string SignatureAlgorithm { get => throw null; }
                public static bool UseMachineKeyStore { get => throw null; set => throw null; }
                public bool VerifyData(System.Byte[] rgbData, System.Byte[] rgbSignature) => throw null;
                public bool VerifyHash(System.Byte[] rgbHash, string str, System.Byte[] rgbSignature) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            public class DSAOpenSsl : System.Security.Cryptography.DSA
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public DSAOpenSsl() => throw null;
                public DSAOpenSsl(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public DSAOpenSsl(System.IntPtr handle) => throw null;
                public DSAOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public DSAOpenSsl(int keySize) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            public struct DSAParameters
            {
                public int Counter;
                // Stub generator skipped constructor 
                public System.Byte[] G;
                public System.Byte[] J;
                public System.Byte[] P;
                public System.Byte[] Q;
                public System.Byte[] Seed;
                public System.Byte[] X;
                public System.Byte[] Y;
            }

            public class DSASignatureDeformatter : System.Security.Cryptography.AsymmetricSignatureDeformatter
            {
                public DSASignatureDeformatter() => throw null;
                public DSASignatureDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            public enum DSASignatureFormat : int
            {
                IeeeP1363FixedFieldConcatenation = 0,
                Rfc3279DerSequence = 1,
            }

            public class DSASignatureFormatter : System.Security.Cryptography.AsymmetricSignatureFormatter
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public DSASignatureFormatter() => throw null;
                public DSASignatureFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            public abstract class DeriveBytes : System.IDisposable
            {
                protected DeriveBytes() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public abstract System.Byte[] GetBytes(int cb);
                public abstract void Reset();
            }

            public abstract class ECAlgorithm : System.Security.Cryptography.AsymmetricAlgorithm
            {
                protected ECAlgorithm() => throw null;
                public virtual System.Byte[] ExportECPrivateKey() => throw null;
                public string ExportECPrivateKeyPem() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public virtual void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public virtual void ImportECPrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<System.Char> input) => throw null;
                public virtual void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual bool TryExportECPrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool TryExportECPrivateKeyPem(System.Span<System.Char> destination, out int charsWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public struct ECCurve
            {
                public enum ECCurveType : int
                {
                    Characteristic2 = 4,
                    Implicit = 0,
                    Named = 5,
                    PrimeMontgomery = 3,
                    PrimeShortWeierstrass = 1,
                    PrimeTwistedEdwards = 2,
                }


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


                public System.Byte[] A;
                public System.Byte[] B;
                public System.Byte[] Cofactor;
                public static System.Security.Cryptography.ECCurve CreateFromFriendlyName(string oidFriendlyName) => throw null;
                public static System.Security.Cryptography.ECCurve CreateFromOid(System.Security.Cryptography.Oid curveOid) => throw null;
                public static System.Security.Cryptography.ECCurve CreateFromValue(string oidValue) => throw null;
                public System.Security.Cryptography.ECCurve.ECCurveType CurveType;
                // Stub generator skipped constructor 
                public System.Security.Cryptography.ECPoint G;
                public System.Security.Cryptography.HashAlgorithmName? Hash;
                public bool IsCharacteristic2 { get => throw null; }
                public bool IsExplicit { get => throw null; }
                public bool IsNamed { get => throw null; }
                public bool IsPrime { get => throw null; }
                public System.Security.Cryptography.Oid Oid { get => throw null; }
                public System.Byte[] Order;
                public System.Byte[] Polynomial;
                public System.Byte[] Prime;
                public System.Byte[] Seed;
                public void Validate() => throw null;
            }

            public abstract class ECDiffieHellman : System.Security.Cryptography.ECAlgorithm
            {
                public static System.Security.Cryptography.ECDiffieHellman Create() => throw null;
                public static System.Security.Cryptography.ECDiffieHellman Create(System.Security.Cryptography.ECCurve curve) => throw null;
                public static System.Security.Cryptography.ECDiffieHellman Create(System.Security.Cryptography.ECParameters parameters) => throw null;
                public static System.Security.Cryptography.ECDiffieHellman Create(string algorithm) => throw null;
                public System.Byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public virtual System.Byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public System.Byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] hmacKey) => throw null;
                public virtual System.Byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] hmacKey, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public virtual System.Byte[] DeriveKeyMaterial(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public virtual System.Byte[] DeriveKeyTls(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Byte[] prfLabel, System.Byte[] prfSeed) => throw null;
                protected ECDiffieHellman() => throw null;
                public override void FromXmlString(string xmlString) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public abstract System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get; }
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
            }

            public class ECDiffieHellmanCng : System.Security.Cryptography.ECDiffieHellman
            {
                public override System.Byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public override System.Byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] hmacKey, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public System.Byte[] DeriveKeyMaterial(System.Security.Cryptography.CngKey otherPartyPublicKey) => throw null;
                public override System.Byte[] DeriveKeyMaterial(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public override System.Byte[] DeriveKeyTls(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Byte[] prfLabel, System.Byte[] prfSeed) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle DeriveSecretAgreementHandle(System.Security.Cryptography.CngKey otherPartyPublicKey) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle DeriveSecretAgreementHandle(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public ECDiffieHellmanCng() => throw null;
                public ECDiffieHellmanCng(System.Security.Cryptography.CngKey key) => throw null;
                public ECDiffieHellmanCng(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDiffieHellmanCng(int keySize) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void FromXmlString(string xml, System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public System.Security.Cryptography.CngAlgorithm HashAlgorithm { get => throw null; set => throw null; }
                public System.Byte[] HmacKey { get => throw null; set => throw null; }
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public System.Security.Cryptography.ECDiffieHellmanKeyDerivationFunction KeyDerivationFunction { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public System.Byte[] Label { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get => throw null; }
                public System.Byte[] SecretAppend { get => throw null; set => throw null; }
                public System.Byte[] SecretPrepend { get => throw null; set => throw null; }
                public System.Byte[] Seed { get => throw null; set => throw null; }
                public string ToXmlString(System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool UseSecretAgreementAsHmacKey { get => throw null; }
            }

            public class ECDiffieHellmanCngPublicKey : System.Security.Cryptography.ECDiffieHellmanPublicKey
            {
                public System.Security.Cryptography.CngKeyBlobFormat BlobFormat { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters() => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters() => throw null;
                public static System.Security.Cryptography.ECDiffieHellmanPublicKey FromByteArray(System.Byte[] publicKeyBlob, System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public static System.Security.Cryptography.ECDiffieHellmanCngPublicKey FromXmlString(string xml) => throw null;
                public System.Security.Cryptography.CngKey Import() => throw null;
                public override string ToXmlString() => throw null;
            }

            public enum ECDiffieHellmanKeyDerivationFunction : int
            {
                Hash = 0,
                Hmac = 1,
                Tls = 2,
            }

            public class ECDiffieHellmanOpenSsl : System.Security.Cryptography.ECDiffieHellman
            {
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public ECDiffieHellmanOpenSsl() => throw null;
                public ECDiffieHellmanOpenSsl(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDiffieHellmanOpenSsl(System.IntPtr handle) => throw null;
                public ECDiffieHellmanOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public ECDiffieHellmanOpenSsl(int keySize) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get => throw null; }
            }

            public abstract class ECDiffieHellmanPublicKey : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                protected ECDiffieHellmanPublicKey() => throw null;
                protected ECDiffieHellmanPublicKey(System.Byte[] keyBlob) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters() => throw null;
                public virtual System.Byte[] ExportSubjectPublicKeyInfo() => throw null;
                public virtual System.Byte[] ToByteArray() => throw null;
                public virtual string ToXmlString() => throw null;
                public virtual bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
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
                protected virtual System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public virtual System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public System.Byte[] SignData(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public int SignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public int SignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignDataCore(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignDataCore(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract System.Byte[] SignHash(System.Byte[] hash);
                public System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public System.Byte[] SignHash(System.ReadOnlySpan<System.Byte> hash) => throw null;
                public System.Byte[] SignHash(System.ReadOnlySpan<System.Byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public int SignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination) => throw null;
                public int SignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignHashCore(System.ReadOnlySpan<System.Byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                protected virtual bool TryHashData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public bool TrySignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public virtual bool TrySignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                protected virtual bool TrySignDataCore(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool TrySignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public virtual bool TrySignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TrySignHashCore(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyData(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public bool VerifyData(System.IO.Stream data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool VerifyData(System.IO.Stream data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyDataCore(System.IO.Stream data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract bool VerifyHash(System.Byte[] hash, System.Byte[] signature);
                public bool VerifyHash(System.Byte[] hash, System.Byte[] signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual bool VerifyHash(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature) => throw null;
                public bool VerifyHash(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual bool VerifyHashCore(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }

            public class ECDsaCng : System.Security.Cryptography.ECDsa
            {
                protected override void Dispose(bool disposing) => throw null;
                public ECDsaCng() => throw null;
                public ECDsaCng(System.Security.Cryptography.CngKey key) => throw null;
                public ECDsaCng(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDsaCng(int keySize) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void FromXmlString(string xml, System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public System.Security.Cryptography.CngAlgorithm HashAlgorithm { get => throw null; set => throw null; }
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public System.Byte[] SignData(System.Byte[] data) => throw null;
                public System.Byte[] SignData(System.Byte[] data, int offset, int count) => throw null;
                public System.Byte[] SignData(System.IO.Stream data) => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash) => throw null;
                public string ToXmlString(System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TrySignHash(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected override bool TrySignHashCore(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.DSASignatureFormat signatureFormat, out int bytesWritten) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature) => throw null;
                public bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature) => throw null;
                public bool VerifyData(System.IO.Stream data, System.Byte[] signature) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature) => throw null;
                public override bool VerifyHash(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature) => throw null;
                protected override bool VerifyHashCore(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
            }

            public class ECDsaOpenSsl : System.Security.Cryptography.ECDsa
            {
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public ECDsaOpenSsl() => throw null;
                public ECDsaOpenSsl(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDsaOpenSsl(System.IntPtr handle) => throw null;
                public ECDsaOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public ECDsaOpenSsl(int keySize) => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature) => throw null;
            }

            public enum ECKeyXmlFormat : int
            {
                Rfc4050 = 0,
            }

            public struct ECParameters
            {
                public System.Security.Cryptography.ECCurve Curve;
                public System.Byte[] D;
                // Stub generator skipped constructor 
                public System.Security.Cryptography.ECPoint Q;
                public void Validate() => throw null;
            }

            public struct ECPoint
            {
                // Stub generator skipped constructor 
                public System.Byte[] X;
                public System.Byte[] Y;
            }

            public class FromBase64Transform : System.IDisposable, System.Security.Cryptography.ICryptoTransform
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public FromBase64Transform() => throw null;
                public FromBase64Transform(System.Security.Cryptography.FromBase64TransformMode whitespaces) => throw null;
                public int InputBlockSize { get => throw null; }
                public int OutputBlockSize { get => throw null; }
                public int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset) => throw null;
                public System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
                // ERR: Stub generator didn't handle member: ~FromBase64Transform
            }

            public enum FromBase64TransformMode : int
            {
                DoNotIgnoreWhiteSpaces = 1,
                IgnoreWhiteSpaces = 0,
            }

            public static class HKDF
            {
                public static System.Byte[] DeriveKey(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.Byte[] ikm, int outputLength, System.Byte[] salt = default(System.Byte[]), System.Byte[] info = default(System.Byte[])) => throw null;
                public static void DeriveKey(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<System.Byte> ikm, System.Span<System.Byte> output, System.ReadOnlySpan<System.Byte> salt, System.ReadOnlySpan<System.Byte> info) => throw null;
                public static System.Byte[] Expand(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.Byte[] prk, int outputLength, System.Byte[] info = default(System.Byte[])) => throw null;
                public static void Expand(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<System.Byte> prk, System.Span<System.Byte> output, System.ReadOnlySpan<System.Byte> info) => throw null;
                public static System.Byte[] Extract(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.Byte[] ikm, System.Byte[] salt = default(System.Byte[])) => throw null;
                public static int Extract(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<System.Byte> ikm, System.ReadOnlySpan<System.Byte> salt, System.Span<System.Byte> prk) => throw null;
            }

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

            public class HMACMD5 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACMD5() => throw null;
                public HMACMD5(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.IO.Stream source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.Byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class HMACSHA1 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA1() => throw null;
                public HMACSHA1(System.Byte[] key) => throw null;
                public HMACSHA1(System.Byte[] key, bool useManagedSha1) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.IO.Stream source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.Byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class HMACSHA256 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA256() => throw null;
                public HMACSHA256(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.IO.Stream source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.Byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class HMACSHA384 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA384() => throw null;
                public HMACSHA384(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.IO.Stream source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.Byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public bool ProduceLegacyHmacValues { get => throw null; set => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class HMACSHA512 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA512() => throw null;
                public HMACSHA512(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.Byte[] key, System.IO.Stream source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> key, System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.Byte[] key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.ReadOnlyMemory<System.Byte> key, System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public bool ProduceLegacyHmacValues { get => throw null; set => throw null; }
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> key, System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

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

            public interface ICryptoTransform : System.IDisposable
            {
                bool CanReuseTransform { get; }
                bool CanTransformMultipleBlocks { get; }
                int InputBlockSize { get; }
                int OutputBlockSize { get; }
                int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset);
                System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount);
            }

            public interface ICspAsymmetricAlgorithm
            {
                System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get; }
                System.Byte[] ExportCspBlob(bool includePrivateParameters);
                void ImportCspBlob(System.Byte[] rawData);
            }

            public class IncrementalHash : System.IDisposable
            {
                public System.Security.Cryptography.HashAlgorithmName AlgorithmName { get => throw null; }
                public void AppendData(System.Byte[] data) => throw null;
                public void AppendData(System.Byte[] data, int offset, int count) => throw null;
                public void AppendData(System.ReadOnlySpan<System.Byte> data) => throw null;
                public static System.Security.Cryptography.IncrementalHash CreateHMAC(System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] key) => throw null;
                public static System.Security.Cryptography.IncrementalHash CreateHMAC(System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.ReadOnlySpan<System.Byte> key) => throw null;
                public static System.Security.Cryptography.IncrementalHash CreateHash(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public void Dispose() => throw null;
                public System.Byte[] GetCurrentHash() => throw null;
                public int GetCurrentHash(System.Span<System.Byte> destination) => throw null;
                public System.Byte[] GetHashAndReset() => throw null;
                public int GetHashAndReset(System.Span<System.Byte> destination) => throw null;
                public int HashLengthInBytes { get => throw null; }
                public bool TryGetCurrentHash(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool TryGetHashAndReset(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public enum KeyNumber : int
            {
                Exchange = 1,
                Signature = 2,
            }

            public class KeySizes
            {
                public KeySizes(int minSize, int maxSize, int skipSize) => throw null;
                public int MaxSize { get => throw null; }
                public int MinSize { get => throw null; }
                public int SkipSize { get => throw null; }
            }

            public abstract class KeyedHashAlgorithm : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.KeyedHashAlgorithm Create() => throw null;
                public static System.Security.Cryptography.KeyedHashAlgorithm Create(string algName) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public virtual System.Byte[] Key { get => throw null; set => throw null; }
                protected System.Byte[] KeyValue;
                protected KeyedHashAlgorithm() => throw null;
            }

            public abstract class MD5 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.MD5 Create() => throw null;
                public static System.Security.Cryptography.MD5 Create(string algName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                protected MD5() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class MD5CryptoServiceProvider : System.Security.Cryptography.MD5
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public MD5CryptoServiceProvider() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public abstract class MaskGenerationMethod
            {
                public abstract System.Byte[] GenerateMask(System.Byte[] rgbSeed, int cbReturn);
                protected MaskGenerationMethod() => throw null;
            }

            public class Oid
            {
                public string FriendlyName { get => throw null; set => throw null; }
                public static System.Security.Cryptography.Oid FromFriendlyName(string friendlyName, System.Security.Cryptography.OidGroup group) => throw null;
                public static System.Security.Cryptography.Oid FromOidValue(string oidValue, System.Security.Cryptography.OidGroup group) => throw null;
                public Oid() => throw null;
                public Oid(System.Security.Cryptography.Oid oid) => throw null;
                public Oid(string oid) => throw null;
                public Oid(string value, string friendlyName) => throw null;
                public string Value { get => throw null; set => throw null; }
            }

            public class OidCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.Oid oid) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.Cryptography.Oid[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Cryptography.OidEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Security.Cryptography.Oid this[int index] { get => throw null; }
                public System.Security.Cryptography.Oid this[string oid] { get => throw null; }
                public OidCollection() => throw null;
                public object SyncRoot { get => throw null; }
            }

            public class OidEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.Oid Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            public enum OidGroup : int
            {
                All = 0,
                Attribute = 5,
                EncryptionAlgorithm = 2,
                EnhancedKeyUsage = 7,
                ExtensionOrAttribute = 6,
                HashAlgorithm = 1,
                KeyDerivationFunction = 10,
                Policy = 8,
                PublicKeyAlgorithm = 3,
                SignatureAlgorithm = 4,
                Template = 9,
            }

            public class PKCS1MaskGenerationMethod : System.Security.Cryptography.MaskGenerationMethod
            {
                public override System.Byte[] GenerateMask(System.Byte[] rgbSeed, int cbReturn) => throw null;
                public string HashName { get => throw null; set => throw null; }
                public PKCS1MaskGenerationMethod() => throw null;
            }

            public enum PaddingMode : int
            {
                ANSIX923 = 4,
                ISO10126 = 5,
                None = 1,
                PKCS7 = 2,
                Zeros = 3,
            }

            public class PasswordDeriveBytes : System.Security.Cryptography.DeriveBytes
            {
                public System.Byte[] CryptDeriveKey(string algname, string alghashname, int keySize, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] GetBytes(int cb) => throw null;
                public string HashName { get => throw null; set => throw null; }
                public int IterationCount { get => throw null; set => throw null; }
                public PasswordDeriveBytes(System.Byte[] password, System.Byte[] salt) => throw null;
                public PasswordDeriveBytes(System.Byte[] password, System.Byte[] salt, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public PasswordDeriveBytes(System.Byte[] password, System.Byte[] salt, string hashName, int iterations) => throw null;
                public PasswordDeriveBytes(System.Byte[] password, System.Byte[] salt, string hashName, int iterations, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public PasswordDeriveBytes(string strPassword, System.Byte[] rgbSalt) => throw null;
                public PasswordDeriveBytes(string strPassword, System.Byte[] rgbSalt, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public PasswordDeriveBytes(string strPassword, System.Byte[] rgbSalt, string strHashName, int iterations) => throw null;
                public PasswordDeriveBytes(string strPassword, System.Byte[] rgbSalt, string strHashName, int iterations, System.Security.Cryptography.CspParameters cspParams) => throw null;
                public override void Reset() => throw null;
                public System.Byte[] Salt { get => throw null; set => throw null; }
            }

            public enum PbeEncryptionAlgorithm : int
            {
                Aes128Cbc = 1,
                Aes192Cbc = 2,
                Aes256Cbc = 3,
                TripleDes3KeyPkcs12 = 4,
                Unknown = 0,
            }

            public class PbeParameters
            {
                public System.Security.Cryptography.PbeEncryptionAlgorithm EncryptionAlgorithm { get => throw null; }
                public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                public int IterationCount { get => throw null; }
                public PbeParameters(System.Security.Cryptography.PbeEncryptionAlgorithm encryptionAlgorithm, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int iterationCount) => throw null;
            }

            public static class PemEncoding
            {
                public static System.Security.Cryptography.PemFields Find(System.ReadOnlySpan<System.Char> pemData) => throw null;
                public static int GetEncodedSize(int labelLength, int dataLength) => throw null;
                public static bool TryFind(System.ReadOnlySpan<System.Char> pemData, out System.Security.Cryptography.PemFields fields) => throw null;
                public static bool TryWrite(System.ReadOnlySpan<System.Char> label, System.ReadOnlySpan<System.Byte> data, System.Span<System.Char> destination, out int charsWritten) => throw null;
                public static System.Char[] Write(System.ReadOnlySpan<System.Char> label, System.ReadOnlySpan<System.Byte> data) => throw null;
                public static string WriteString(System.ReadOnlySpan<System.Char> label, System.ReadOnlySpan<System.Byte> data) => throw null;
            }

            public struct PemFields
            {
                public System.Range Base64Data { get => throw null; }
                public int DecodedDataLength { get => throw null; }
                public System.Range Label { get => throw null; }
                public System.Range Location { get => throw null; }
                // Stub generator skipped constructor 
            }

            public abstract class RC2 : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.RC2 Create() => throw null;
                public static System.Security.Cryptography.RC2 Create(string AlgName) => throw null;
                public virtual int EffectiveKeySize { get => throw null; set => throw null; }
                protected int EffectiveKeySizeValue;
                public override int KeySize { get => throw null; set => throw null; }
                protected RC2() => throw null;
            }

            public class RC2CryptoServiceProvider : System.Security.Cryptography.RC2
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override int EffectiveKeySize { get => throw null; set => throw null; }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public RC2CryptoServiceProvider() => throw null;
                public bool UseSalt { get => throw null; set => throw null; }
            }

            public class RNGCryptoServiceProvider : System.Security.Cryptography.RandomNumberGenerator
            {
                protected override void Dispose(bool disposing) => throw null;
                public override void GetBytes(System.Byte[] data) => throw null;
                public override void GetBytes(System.Byte[] data, int offset, int count) => throw null;
                public override void GetBytes(System.Span<System.Byte> data) => throw null;
                public override void GetNonZeroBytes(System.Byte[] data) => throw null;
                public override void GetNonZeroBytes(System.Span<System.Byte> data) => throw null;
                public RNGCryptoServiceProvider() => throw null;
                public RNGCryptoServiceProvider(System.Byte[] rgb) => throw null;
                public RNGCryptoServiceProvider(System.Security.Cryptography.CspParameters cspParams) => throw null;
                public RNGCryptoServiceProvider(string str) => throw null;
            }

            public abstract class RSA : System.Security.Cryptography.AsymmetricAlgorithm
            {
                public static System.Security.Cryptography.RSA Create() => throw null;
                public static System.Security.Cryptography.RSA Create(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public static System.Security.Cryptography.RSA Create(int keySizeInBits) => throw null;
                public static System.Security.Cryptography.RSA Create(string algName) => throw null;
                public virtual System.Byte[] Decrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public System.Byte[] Decrypt(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public int Decrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public virtual System.Byte[] DecryptValue(System.Byte[] rgb) => throw null;
                public virtual System.Byte[] Encrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public System.Byte[] Encrypt(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public int Encrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public virtual System.Byte[] EncryptValue(System.Byte[] rgb) => throw null;
                public abstract System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters);
                public virtual System.Byte[] ExportRSAPrivateKey() => throw null;
                public string ExportRSAPrivateKeyPem() => throw null;
                public virtual System.Byte[] ExportRSAPublicKey() => throw null;
                public string ExportRSAPublicKeyPem() => throw null;
                public override void FromXmlString(string xmlString) => throw null;
                protected virtual System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<System.Char> input) => throw null;
                public abstract void ImportParameters(System.Security.Cryptography.RSAParameters parameters);
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual void ImportRSAPrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public virtual void ImportRSAPublicKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                protected RSA() => throw null;
                public System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public System.Byte[] SignData(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public int SignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public System.Byte[] SignHash(System.ReadOnlySpan<System.Byte> hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public int SignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryDecrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public virtual bool TryEncrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportRSAPrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool TryExportRSAPrivateKeyPem(System.Span<System.Char> destination, out int charsWritten) => throw null;
                public virtual bool TryExportRSAPublicKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public bool TryExportRSAPublicKeyPem(System.Span<System.Char> destination, out int charsWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                protected virtual bool TryHashData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out int bytesWritten) => throw null;
                public virtual bool TrySignData(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding, out int bytesWritten) => throw null;
                public virtual bool TrySignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding, out int bytesWritten) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyData(System.ReadOnlySpan<System.Byte> data, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public bool VerifyData(System.IO.Stream data, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyHash(System.Byte[] hash, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual bool VerifyHash(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
            }

            public class RSACng : System.Security.Cryptography.RSA
            {
                public override System.Byte[] Decrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] Encrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Byte[] ExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public RSACng() => throw null;
                public RSACng(System.Security.Cryptography.CngKey key) => throw null;
                public RSACng(int keySize) => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override bool TryDecrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryEncrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TrySignHash(System.ReadOnlySpan<System.Byte> hash, System.Span<System.Byte> destination, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding, out int bytesWritten) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override bool VerifyHash(System.ReadOnlySpan<System.Byte> hash, System.ReadOnlySpan<System.Byte> signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
            }

            public class RSACryptoServiceProvider : System.Security.Cryptography.RSA, System.Security.Cryptography.ICspAsymmetricAlgorithm
            {
                public System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get => throw null; }
                public override System.Byte[] Decrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public System.Byte[] Decrypt(System.Byte[] rgb, bool fOAEP) => throw null;
                public override System.Byte[] DecryptValue(System.Byte[] rgb) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] Encrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public System.Byte[] Encrypt(System.Byte[] rgb, bool fOAEP) => throw null;
                public override System.Byte[] EncryptValue(System.Byte[] rgb) => throw null;
                public System.Byte[] ExportCspBlob(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void ImportCspBlob(System.Byte[] keyBlob) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override int KeySize { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public bool PersistKeyInCsp { get => throw null; set => throw null; }
                public bool PublicOnly { get => throw null; }
                public RSACryptoServiceProvider() => throw null;
                public RSACryptoServiceProvider(System.Security.Cryptography.CspParameters parameters) => throw null;
                public RSACryptoServiceProvider(int dwKeySize) => throw null;
                public RSACryptoServiceProvider(int dwKeySize, System.Security.Cryptography.CspParameters parameters) => throw null;
                public System.Byte[] SignData(System.Byte[] buffer, int offset, int count, object halg) => throw null;
                public System.Byte[] SignData(System.Byte[] buffer, object halg) => throw null;
                public System.Byte[] SignData(System.IO.Stream inputStream, object halg) => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public System.Byte[] SignHash(System.Byte[] rgbHash, string str) => throw null;
                public override string SignatureAlgorithm { get => throw null; }
                public static bool UseMachineKeyStore { get => throw null; set => throw null; }
                public bool VerifyData(System.Byte[] buffer, object halg, System.Byte[] signature) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public bool VerifyHash(System.Byte[] rgbHash, string str, System.Byte[] rgbSignature) => throw null;
            }

            public class RSAEncryptionPadding : System.IEquatable<System.Security.Cryptography.RSAEncryptionPadding>
            {
                public static bool operator !=(System.Security.Cryptography.RSAEncryptionPadding left, System.Security.Cryptography.RSAEncryptionPadding right) => throw null;
                public static bool operator ==(System.Security.Cryptography.RSAEncryptionPadding left, System.Security.Cryptography.RSAEncryptionPadding right) => throw null;
                public static System.Security.Cryptography.RSAEncryptionPadding CreateOaep(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public bool Equals(System.Security.Cryptography.RSAEncryptionPadding other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.Cryptography.RSAEncryptionPaddingMode Mode { get => throw null; }
                public System.Security.Cryptography.HashAlgorithmName OaepHashAlgorithm { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA1 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA256 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA384 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding OaepSHA512 { get => throw null; }
                public static System.Security.Cryptography.RSAEncryptionPadding Pkcs1 { get => throw null; }
                public override string ToString() => throw null;
            }

            public enum RSAEncryptionPaddingMode : int
            {
                Oaep = 1,
                Pkcs1 = 0,
            }

            public class RSAOAEPKeyExchangeDeformatter : System.Security.Cryptography.AsymmetricKeyExchangeDeformatter
            {
                public override System.Byte[] DecryptKeyExchange(System.Byte[] rgbData) => throw null;
                public override string Parameters { get => throw null; set => throw null; }
                public RSAOAEPKeyExchangeDeformatter() => throw null;
                public RSAOAEPKeyExchangeDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            public class RSAOAEPKeyExchangeFormatter : System.Security.Cryptography.AsymmetricKeyExchangeFormatter
            {
                public override System.Byte[] CreateKeyExchange(System.Byte[] rgbData) => throw null;
                public override System.Byte[] CreateKeyExchange(System.Byte[] rgbData, System.Type symAlgType) => throw null;
                public System.Byte[] Parameter { get => throw null; set => throw null; }
                public override string Parameters { get => throw null; }
                public RSAOAEPKeyExchangeFormatter() => throw null;
                public RSAOAEPKeyExchangeFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public System.Security.Cryptography.RandomNumberGenerator Rng { get => throw null; set => throw null; }
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            public class RSAOpenSsl : System.Security.Cryptography.RSA
            {
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public RSAOpenSsl() => throw null;
                public RSAOpenSsl(System.IntPtr handle) => throw null;
                public RSAOpenSsl(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public RSAOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public RSAOpenSsl(int keySize) => throw null;
            }

            public class RSAPKCS1KeyExchangeDeformatter : System.Security.Cryptography.AsymmetricKeyExchangeDeformatter
            {
                public override System.Byte[] DecryptKeyExchange(System.Byte[] rgbIn) => throw null;
                public override string Parameters { get => throw null; set => throw null; }
                public System.Security.Cryptography.RandomNumberGenerator RNG { get => throw null; set => throw null; }
                public RSAPKCS1KeyExchangeDeformatter() => throw null;
                public RSAPKCS1KeyExchangeDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            public class RSAPKCS1KeyExchangeFormatter : System.Security.Cryptography.AsymmetricKeyExchangeFormatter
            {
                public override System.Byte[] CreateKeyExchange(System.Byte[] rgbData) => throw null;
                public override System.Byte[] CreateKeyExchange(System.Byte[] rgbData, System.Type symAlgType) => throw null;
                public override string Parameters { get => throw null; }
                public RSAPKCS1KeyExchangeFormatter() => throw null;
                public RSAPKCS1KeyExchangeFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public System.Security.Cryptography.RandomNumberGenerator Rng { get => throw null; set => throw null; }
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            public class RSAPKCS1SignatureDeformatter : System.Security.Cryptography.AsymmetricSignatureDeformatter
            {
                public RSAPKCS1SignatureDeformatter() => throw null;
                public RSAPKCS1SignatureDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            public class RSAPKCS1SignatureFormatter : System.Security.Cryptography.AsymmetricSignatureFormatter
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public RSAPKCS1SignatureFormatter() => throw null;
                public RSAPKCS1SignatureFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            public struct RSAParameters
            {
                public System.Byte[] D;
                public System.Byte[] DP;
                public System.Byte[] DQ;
                public System.Byte[] Exponent;
                public System.Byte[] InverseQ;
                public System.Byte[] Modulus;
                public System.Byte[] P;
                public System.Byte[] Q;
                // Stub generator skipped constructor 
            }

            public class RSASignaturePadding : System.IEquatable<System.Security.Cryptography.RSASignaturePadding>
            {
                public static bool operator !=(System.Security.Cryptography.RSASignaturePadding left, System.Security.Cryptography.RSASignaturePadding right) => throw null;
                public static bool operator ==(System.Security.Cryptography.RSASignaturePadding left, System.Security.Cryptography.RSASignaturePadding right) => throw null;
                public bool Equals(System.Security.Cryptography.RSASignaturePadding other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.Cryptography.RSASignaturePaddingMode Mode { get => throw null; }
                public static System.Security.Cryptography.RSASignaturePadding Pkcs1 { get => throw null; }
                public static System.Security.Cryptography.RSASignaturePadding Pss { get => throw null; }
                public override string ToString() => throw null;
            }

            public enum RSASignaturePaddingMode : int
            {
                Pkcs1 = 0,
                Pss = 1,
            }

            public abstract class RandomNumberGenerator : System.IDisposable
            {
                public static System.Security.Cryptography.RandomNumberGenerator Create() => throw null;
                public static System.Security.Cryptography.RandomNumberGenerator Create(string rngName) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public static void Fill(System.Span<System.Byte> data) => throw null;
                public abstract void GetBytes(System.Byte[] data);
                public virtual void GetBytes(System.Byte[] data, int offset, int count) => throw null;
                public virtual void GetBytes(System.Span<System.Byte> data) => throw null;
                public static System.Byte[] GetBytes(int count) => throw null;
                public static int GetInt32(int toExclusive) => throw null;
                public static int GetInt32(int fromInclusive, int toExclusive) => throw null;
                public virtual void GetNonZeroBytes(System.Byte[] data) => throw null;
                public virtual void GetNonZeroBytes(System.Span<System.Byte> data) => throw null;
                protected RandomNumberGenerator() => throw null;
            }

            public class Rfc2898DeriveBytes : System.Security.Cryptography.DeriveBytes
            {
                public System.Byte[] CryptDeriveKey(string algname, string alghashname, int keySize, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] GetBytes(int cb) => throw null;
                public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                public int IterationCount { get => throw null; set => throw null; }
                public static System.Byte[] Pbkdf2(System.Byte[] password, System.Byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public static void Pbkdf2(System.ReadOnlySpan<System.Byte> password, System.ReadOnlySpan<System.Byte> salt, System.Span<System.Byte> destination, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public static System.Byte[] Pbkdf2(System.ReadOnlySpan<System.Byte> password, System.ReadOnlySpan<System.Byte> salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public static void Pbkdf2(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> salt, System.Span<System.Byte> destination, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public static System.Byte[] Pbkdf2(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public static System.Byte[] Pbkdf2(string password, System.Byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int outputLength) => throw null;
                public override void Reset() => throw null;
                public Rfc2898DeriveBytes(System.Byte[] password, System.Byte[] salt, int iterations) => throw null;
                public Rfc2898DeriveBytes(System.Byte[] password, System.Byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public Rfc2898DeriveBytes(string password, System.Byte[] salt) => throw null;
                public Rfc2898DeriveBytes(string password, System.Byte[] salt, int iterations) => throw null;
                public Rfc2898DeriveBytes(string password, System.Byte[] salt, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public Rfc2898DeriveBytes(string password, int saltSize) => throw null;
                public Rfc2898DeriveBytes(string password, int saltSize, int iterations) => throw null;
                public Rfc2898DeriveBytes(string password, int saltSize, int iterations, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] Salt { get => throw null; set => throw null; }
            }

            public abstract class Rijndael : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.Rijndael Create() => throw null;
                public static System.Security.Cryptography.Rijndael Create(string algName) => throw null;
                protected Rijndael() => throw null;
            }

            public class RijndaelManaged : System.Security.Cryptography.Rijndael
            {
                public override int BlockSize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set => throw null; }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] IV { get => throw null; set => throw null; }
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set => throw null; }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set => throw null; }
                public RijndaelManaged() => throw null;
            }

            public abstract class SHA1 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA1 Create() => throw null;
                public static System.Security.Cryptography.SHA1 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                protected SHA1() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA1CryptoServiceProvider : System.Security.Cryptography.SHA1
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA1CryptoServiceProvider() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA1Managed : System.Security.Cryptography.SHA1
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA1Managed() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public abstract class SHA256 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA256 Create() => throw null;
                public static System.Security.Cryptography.SHA256 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                protected SHA256() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA256CryptoServiceProvider : System.Security.Cryptography.SHA256
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA256CryptoServiceProvider() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA256Managed : System.Security.Cryptography.SHA256
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA256Managed() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public abstract class SHA384 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA384 Create() => throw null;
                public static System.Security.Cryptography.SHA384 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                protected SHA384() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA384CryptoServiceProvider : System.Security.Cryptography.SHA384
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA384CryptoServiceProvider() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA384Managed : System.Security.Cryptography.SHA384
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA384Managed() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public abstract class SHA512 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA512 Create() => throw null;
                public static System.Security.Cryptography.SHA512 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                public static System.Byte[] HashData(System.IO.Stream source) => throw null;
                public static int HashData(System.IO.Stream source, System.Span<System.Byte> destination) => throw null;
                public static System.Threading.Tasks.ValueTask<System.Byte[]> HashDataAsync(System.IO.Stream source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.ValueTask<int> HashDataAsync(System.IO.Stream source, System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public const int HashSizeInBits = default;
                public const int HashSizeInBytes = default;
                protected SHA512() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA512CryptoServiceProvider : System.Security.Cryptography.SHA512
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA512CryptoServiceProvider() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SHA512Managed : System.Security.Cryptography.SHA512
            {
                protected override void Dispose(bool disposing) => throw null;
                protected override void HashCore(System.Byte[] array, int ibStart, int cbSize) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public SHA512Managed() => throw null;
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            public class SafeEvpPKeyHandle : System.Runtime.InteropServices.SafeHandle
            {
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateHandle() => throw null;
                public override bool IsInvalid { get => throw null; }
                public static System.Int64 OpenSslVersion { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafeEvpPKeyHandle() : base(default(System.IntPtr), default(bool)) => throw null;
                public SafeEvpPKeyHandle(System.IntPtr handle, bool ownsHandle) : base(default(System.IntPtr), default(bool)) => throw null;
            }

            public class SignatureDescription
            {
                public virtual System.Security.Cryptography.AsymmetricSignatureDeformatter CreateDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public virtual System.Security.Cryptography.HashAlgorithm CreateDigest() => throw null;
                public virtual System.Security.Cryptography.AsymmetricSignatureFormatter CreateFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public string DeformatterAlgorithm { get => throw null; set => throw null; }
                public string DigestAlgorithm { get => throw null; set => throw null; }
                public string FormatterAlgorithm { get => throw null; set => throw null; }
                public string KeyAlgorithm { get => throw null; set => throw null; }
                public SignatureDescription() => throw null;
                public SignatureDescription(System.Security.SecurityElement el) => throw null;
            }

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
                public System.Byte[] DecryptCbc(System.Byte[] ciphertext, System.Byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public System.Byte[] DecryptCbc(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public int DecryptCbc(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public System.Byte[] DecryptCfb(System.Byte[] ciphertext, System.Byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public System.Byte[] DecryptCfb(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public int DecryptCfb(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public System.Byte[] DecryptEcb(System.Byte[] ciphertext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public System.Byte[] DecryptEcb(System.ReadOnlySpan<System.Byte> ciphertext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public int DecryptEcb(System.ReadOnlySpan<System.Byte> ciphertext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Byte[] EncryptCbc(System.Byte[] plaintext, System.Byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public System.Byte[] EncryptCbc(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public int EncryptCbc(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public System.Byte[] EncryptCfb(System.Byte[] plaintext, System.Byte[] iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public System.Byte[] EncryptCfb(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public int EncryptCfb(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public System.Byte[] EncryptEcb(System.Byte[] plaintext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public System.Byte[] EncryptEcb(System.ReadOnlySpan<System.Byte> plaintext, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public int EncryptEcb(System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
                public virtual int FeedbackSize { get => throw null; set => throw null; }
                protected int FeedbackSizeValue;
                public abstract void GenerateIV();
                public abstract void GenerateKey();
                public int GetCiphertextLengthCbc(int plaintextLength, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                public int GetCiphertextLengthCfb(int plaintextLength, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                public int GetCiphertextLengthEcb(int plaintextLength, System.Security.Cryptography.PaddingMode paddingMode) => throw null;
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
                public bool TryDecryptCbc(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                protected virtual bool TryDecryptCbcCore(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool TryDecryptCfb(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                protected virtual bool TryDecryptCfbCore(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                public bool TryDecryptEcb(System.ReadOnlySpan<System.Byte> ciphertext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected virtual bool TryDecryptEcbCore(System.ReadOnlySpan<System.Byte> ciphertext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool TryEncryptCbc(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode)) => throw null;
                protected virtual bool TryEncryptCbcCore(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool TryEncryptCfb(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, out int bytesWritten, System.Security.Cryptography.PaddingMode paddingMode = default(System.Security.Cryptography.PaddingMode), int feedbackSizeInBits = default(int)) => throw null;
                protected virtual bool TryEncryptCfbCore(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                public bool TryEncryptEcb(System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected virtual bool TryEncryptEcbCore(System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                public bool ValidKeySize(int bitLength) => throw null;
            }

            public class ToBase64Transform : System.IDisposable, System.Security.Cryptography.ICryptoTransform
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public int InputBlockSize { get => throw null; }
                public int OutputBlockSize { get => throw null; }
                public ToBase64Transform() => throw null;
                public int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset) => throw null;
                public System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
                // ERR: Stub generator didn't handle member: ~ToBase64Transform
            }

            public abstract class TripleDES : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.TripleDES Create() => throw null;
                public static System.Security.Cryptography.TripleDES Create(string str) => throw null;
                public static bool IsWeakKey(System.Byte[] rgbKey) => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                protected TripleDES() => throw null;
            }

            public class TripleDESCng : System.Security.Cryptography.TripleDES
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public TripleDESCng() => throw null;
                public TripleDESCng(string keyName) => throw null;
                public TripleDESCng(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public TripleDESCng(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                protected override bool TryDecryptCbcCore(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryDecryptCfbCore(System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryDecryptEcbCore(System.ReadOnlySpan<System.Byte> ciphertext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCbcCore(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
                protected override bool TryEncryptCfbCore(System.ReadOnlySpan<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> iv, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, int feedbackSizeInBits, out int bytesWritten) => throw null;
                protected override bool TryEncryptEcbCore(System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> destination, System.Security.Cryptography.PaddingMode paddingMode, out int bytesWritten) => throw null;
            }

            public class TripleDESCryptoServiceProvider : System.Security.Cryptography.TripleDES
            {
                public override int BlockSize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int FeedbackSize { get => throw null; set => throw null; }
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] IV { get => throw null; set => throw null; }
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalBlockSizes { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Security.Cryptography.CipherMode Mode { get => throw null; set => throw null; }
                public override System.Security.Cryptography.PaddingMode Padding { get => throw null; set => throw null; }
                public TripleDESCryptoServiceProvider() => throw null;
            }

            namespace X509Certificates
            {
                public class CertificateRequest
                {
                    public System.Collections.ObjectModel.Collection<System.Security.Cryptography.X509Certificates.X509Extension> CertificateExtensions { get => throw null; }
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.ECDsa key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.X509Certificates.PublicKey publicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.X509Certificates.PublicKey publicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding rsaSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.RSA key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                    public CertificateRequest(string subjectName, System.Security.Cryptography.ECDsa key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(string subjectName, System.Security.Cryptography.RSA key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Security.Cryptography.X509Certificates.X509SignatureGenerator generator, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, System.Byte[] serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Security.Cryptography.X509Certificates.X509SignatureGenerator generator, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, System.ReadOnlySpan<System.Byte> serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X509Certificate2 issuerCertificate, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, System.Byte[] serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Create(System.Security.Cryptography.X509Certificates.X509Certificate2 issuerCertificate, System.DateTimeOffset notBefore, System.DateTimeOffset notAfter, System.ReadOnlySpan<System.Byte> serialNumber) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 CreateSelfSigned(System.DateTimeOffset notBefore, System.DateTimeOffset notAfter) => throw null;
                    public System.Byte[] CreateSigningRequest() => throw null;
                    public System.Byte[] CreateSigningRequest(System.Security.Cryptography.X509Certificates.X509SignatureGenerator signatureGenerator) => throw null;
                    public string CreateSigningRequestPem() => throw null;
                    public string CreateSigningRequestPem(System.Security.Cryptography.X509Certificates.X509SignatureGenerator signatureGenerator) => throw null;
                    public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequest(System.Byte[] pkcs10, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequest(System.ReadOnlySpan<System.Byte> pkcs10, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, out int bytesConsumed, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequestPem(System.ReadOnlySpan<System.Char> pkcs10Pem, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRequest LoadSigningRequestPem(string pkcs10Pem, System.Security.Cryptography.HashAlgorithmName signerHashAlgorithm, System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions options = default(System.Security.Cryptography.X509Certificates.CertificateRequestLoadOptions), System.Security.Cryptography.RSASignaturePadding signerSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding)) => throw null;
                    public System.Collections.ObjectModel.Collection<System.Security.Cryptography.AsnEncodedData> OtherRequestAttributes { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName SubjectName { get => throw null; }
                }

                [System.Flags]
                public enum CertificateRequestLoadOptions : int
                {
                    Default = 0,
                    SkipSignatureValidation = 1,
                    UnsafeLoadCertificateExtensions = 2,
                }

                public class CertificateRevocationListBuilder
                {
                    public void AddEntry(System.Byte[] serialNumber, System.DateTimeOffset? revocationTime = default(System.DateTimeOffset?), System.Security.Cryptography.X509Certificates.X509RevocationReason? reason = default(System.Security.Cryptography.X509Certificates.X509RevocationReason?)) => throw null;
                    public void AddEntry(System.ReadOnlySpan<System.Byte> serialNumber, System.DateTimeOffset? revocationTime = default(System.DateTimeOffset?), System.Security.Cryptography.X509Certificates.X509RevocationReason? reason = default(System.Security.Cryptography.X509Certificates.X509RevocationReason?)) => throw null;
                    public void AddEntry(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.DateTimeOffset? revocationTime = default(System.DateTimeOffset?), System.Security.Cryptography.X509Certificates.X509RevocationReason? reason = default(System.Security.Cryptography.X509Certificates.X509RevocationReason?)) => throw null;
                    public System.Byte[] Build(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Security.Cryptography.X509Certificates.X509SignatureGenerator generator, System.Numerics.BigInteger crlNumber, System.DateTimeOffset nextUpdate, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension authorityKeyIdentifier, System.DateTimeOffset? thisUpdate = default(System.DateTimeOffset?)) => throw null;
                    public System.Byte[] Build(System.Security.Cryptography.X509Certificates.X509Certificate2 issuerCertificate, System.Numerics.BigInteger crlNumber, System.DateTimeOffset nextUpdate, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding rsaSignaturePadding = default(System.Security.Cryptography.RSASignaturePadding), System.DateTimeOffset? thisUpdate = default(System.DateTimeOffset?)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Extension BuildCrlDistributionPointExtension(System.Collections.Generic.IEnumerable<string> uris, bool critical = default(bool)) => throw null;
                    public CertificateRevocationListBuilder() => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder Load(System.Byte[] currentCrl, out System.Numerics.BigInteger currentCrlNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder Load(System.ReadOnlySpan<System.Byte> currentCrl, out System.Numerics.BigInteger currentCrlNumber, out int bytesConsumed) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder LoadPem(System.ReadOnlySpan<System.Char> currentCrl, out System.Numerics.BigInteger currentCrlNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.CertificateRevocationListBuilder LoadPem(string currentCrl, out System.Numerics.BigInteger currentCrlNumber) => throw null;
                    public bool RemoveEntry(System.Byte[] serialNumber) => throw null;
                    public bool RemoveEntry(System.ReadOnlySpan<System.Byte> serialNumber) => throw null;
                }

                public static class DSACertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.DSA privateKey) => throw null;
                    public static System.Security.Cryptography.DSA GetDSAPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.DSA GetDSAPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }

                public static class ECDsaCertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.ECDsa privateKey) => throw null;
                    public static System.Security.Cryptography.ECDsa GetECDsaPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.ECDsa GetECDsaPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }

                [System.Flags]
                public enum OpenFlags : int
                {
                    IncludeArchived = 8,
                    MaxAllowed = 2,
                    OpenExistingOnly = 4,
                    ReadOnly = 0,
                    ReadWrite = 1,
                }

                public class PublicKey
                {
                    public static System.Security.Cryptography.X509Certificates.PublicKey CreateFromSubjectPublicKeyInfo(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                    public System.Security.Cryptography.AsnEncodedData EncodedKeyValue { get => throw null; }
                    public System.Security.Cryptography.AsnEncodedData EncodedParameters { get => throw null; }
                    public System.Byte[] ExportSubjectPublicKeyInfo() => throw null;
                    public System.Security.Cryptography.DSA GetDSAPublicKey() => throw null;
                    public System.Security.Cryptography.ECDiffieHellman GetECDiffieHellmanPublicKey() => throw null;
                    public System.Security.Cryptography.ECDsa GetECDsaPublicKey() => throw null;
                    public System.Security.Cryptography.RSA GetRSAPublicKey() => throw null;
                    public System.Security.Cryptography.AsymmetricAlgorithm Key { get => throw null; }
                    public System.Security.Cryptography.Oid Oid { get => throw null; }
                    public PublicKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                    public PublicKey(System.Security.Cryptography.Oid oid, System.Security.Cryptography.AsnEncodedData parameters, System.Security.Cryptography.AsnEncodedData keyValue) => throw null;
                    public bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                }

                public static class RSACertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.RSA privateKey) => throw null;
                    public static System.Security.Cryptography.RSA GetRSAPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.RSA GetRSAPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }

                public enum StoreLocation : int
                {
                    CurrentUser = 1,
                    LocalMachine = 2,
                }

                public enum StoreName : int
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

                public class SubjectAlternativeNameBuilder
                {
                    public void AddDnsName(string dnsName) => throw null;
                    public void AddEmailAddress(string emailAddress) => throw null;
                    public void AddIpAddress(System.Net.IPAddress ipAddress) => throw null;
                    public void AddUri(System.Uri uri) => throw null;
                    public void AddUserPrincipalName(string upn) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Extension Build(bool critical = default(bool)) => throw null;
                    public SubjectAlternativeNameBuilder() => throw null;
                }

                public class X500DistinguishedName : System.Security.Cryptography.AsnEncodedData
                {
                    public string Decode(System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags flag) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X500RelativeDistinguishedName> EnumerateRelativeDistinguishedNames(bool reversed = default(bool)) => throw null;
                    public override string Format(bool multiLine) => throw null;
                    public string Name { get => throw null; }
                    public X500DistinguishedName(System.Security.Cryptography.AsnEncodedData encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.Byte[] encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.ReadOnlySpan<System.Byte> encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.Security.Cryptography.X509Certificates.X500DistinguishedName distinguishedName) => throw null;
                    public X500DistinguishedName(string distinguishedName) => throw null;
                    public X500DistinguishedName(string distinguishedName, System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags flag) => throw null;
                }

                public class X500DistinguishedNameBuilder
                {
                    public void Add(System.Security.Cryptography.Oid oid, string value, System.Formats.Asn1.UniversalTagNumber? stringEncodingType = default(System.Formats.Asn1.UniversalTagNumber?)) => throw null;
                    public void Add(string oidValue, string value, System.Formats.Asn1.UniversalTagNumber? stringEncodingType = default(System.Formats.Asn1.UniversalTagNumber?)) => throw null;
                    public void AddCommonName(string commonName) => throw null;
                    public void AddCountryOrRegion(string twoLetterCode) => throw null;
                    public void AddDomainComponent(string domainComponent) => throw null;
                    public void AddEmailAddress(string emailAddress) => throw null;
                    public void AddLocalityName(string localityName) => throw null;
                    public void AddOrganizationName(string organizationName) => throw null;
                    public void AddOrganizationalUnitName(string organizationalUnitName) => throw null;
                    public void AddStateOrProvinceName(string stateOrProvinceName) => throw null;
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName Build() => throw null;
                    public X500DistinguishedNameBuilder() => throw null;
                }

                [System.Flags]
                public enum X500DistinguishedNameFlags : int
                {
                    DoNotUsePlusSign = 32,
                    DoNotUseQuotes = 64,
                    ForceUTF8Encoding = 16384,
                    None = 0,
                    Reversed = 1,
                    UseCommas = 128,
                    UseNewLines = 256,
                    UseSemicolons = 16,
                    UseT61Encoding = 8192,
                    UseUTF8Encoding = 4096,
                }

                public class X500RelativeDistinguishedName
                {
                    public System.Security.Cryptography.Oid GetSingleElementType() => throw null;
                    public string GetSingleElementValue() => throw null;
                    public bool HasMultipleElements { get => throw null; }
                    public System.ReadOnlyMemory<System.Byte> RawData { get => throw null; }
                }

                public class X509AuthorityInformationAccessExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateCAIssuersUris() => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateOcspUris() => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateUris(System.Security.Cryptography.Oid accessMethodOid) => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateUris(string accessMethodOid) => throw null;
                    public X509AuthorityInformationAccessExtension() => throw null;
                    public X509AuthorityInformationAccessExtension(System.Byte[] rawData, bool critical = default(bool)) => throw null;
                    public X509AuthorityInformationAccessExtension(System.Collections.Generic.IEnumerable<string> ocspUris, System.Collections.Generic.IEnumerable<string> caIssuersUris, bool critical = default(bool)) => throw null;
                    public X509AuthorityInformationAccessExtension(System.ReadOnlySpan<System.Byte> rawData, bool critical = default(bool)) => throw null;
                }

                public class X509AuthorityKeyIdentifierExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension Create(System.Byte[] keyIdentifier, System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Byte[] serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension Create(System.ReadOnlySpan<System.Byte> keyIdentifier, System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.ReadOnlySpan<System.Byte> serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool includeKeyIdentifier, bool includeIssuerAndSerial) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromIssuerNameAndSerialNumber(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.Byte[] serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromIssuerNameAndSerialNumber(System.Security.Cryptography.X509Certificates.X500DistinguishedName issuerName, System.ReadOnlySpan<System.Byte> serialNumber) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromSubjectKeyIdentifier(System.Byte[] subjectKeyIdentifier) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromSubjectKeyIdentifier(System.ReadOnlySpan<System.Byte> subjectKeyIdentifier) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509AuthorityKeyIdentifierExtension CreateFromSubjectKeyIdentifier(System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierExtension subjectKeyIdentifier) => throw null;
                    public System.ReadOnlyMemory<System.Byte>? KeyIdentifier { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName NamedIssuer { get => throw null; }
                    public System.ReadOnlyMemory<System.Byte>? RawIssuer { get => throw null; }
                    public System.ReadOnlyMemory<System.Byte>? SerialNumber { get => throw null; }
                    public X509AuthorityKeyIdentifierExtension() => throw null;
                    public X509AuthorityKeyIdentifierExtension(System.Byte[] rawData, bool critical = default(bool)) => throw null;
                    public X509AuthorityKeyIdentifierExtension(System.ReadOnlySpan<System.Byte> rawData, bool critical = default(bool)) => throw null;
                }

                public class X509BasicConstraintsExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public bool CertificateAuthority { get => throw null; }
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension CreateForCertificateAuthority(int? pathLengthConstraint = default(int?)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension CreateForEndEntity(bool critical = default(bool)) => throw null;
                    public bool HasPathLengthConstraint { get => throw null; }
                    public int PathLengthConstraint { get => throw null; }
                    public X509BasicConstraintsExtension() => throw null;
                    public X509BasicConstraintsExtension(System.Security.Cryptography.AsnEncodedData encodedBasicConstraints, bool critical) => throw null;
                    public X509BasicConstraintsExtension(bool certificateAuthority, bool hasPathLengthConstraint, int pathLengthConstraint, bool critical) => throw null;
                }

                public class X509Certificate : System.IDisposable, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate CreateFromCertFile(string filename) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate CreateFromSignedFile(string filename) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public virtual bool Equals(System.Security.Cryptography.X509Certificates.X509Certificate other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public virtual System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType) => throw null;
                    public virtual System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, System.Security.SecureString password) => throw null;
                    public virtual System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, string password) => throw null;
                    protected static string FormatDate(System.DateTime date) => throw null;
                    public virtual System.Byte[] GetCertHash() => throw null;
                    public virtual System.Byte[] GetCertHash(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public virtual string GetCertHashString() => throw null;
                    public virtual string GetCertHashString(System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public virtual string GetEffectiveDateString() => throw null;
                    public virtual string GetExpirationDateString() => throw null;
                    public virtual string GetFormat() => throw null;
                    public override int GetHashCode() => throw null;
                    public virtual string GetIssuerName() => throw null;
                    public virtual string GetKeyAlgorithm() => throw null;
                    public virtual System.Byte[] GetKeyAlgorithmParameters() => throw null;
                    public virtual string GetKeyAlgorithmParametersString() => throw null;
                    public virtual string GetName() => throw null;
                    void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public virtual System.Byte[] GetPublicKey() => throw null;
                    public virtual string GetPublicKeyString() => throw null;
                    public virtual System.Byte[] GetRawCertData() => throw null;
                    public virtual string GetRawCertDataString() => throw null;
                    public virtual System.Byte[] GetSerialNumber() => throw null;
                    public virtual string GetSerialNumberString() => throw null;
                    public System.IntPtr Handle { get => throw null; }
                    public virtual void Import(System.Byte[] rawData) => throw null;
                    public virtual void Import(System.Byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public virtual void Import(System.Byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public virtual void Import(string fileName) => throw null;
                    public virtual void Import(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public virtual void Import(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public string Issuer { get => throw null; }
                    void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                    public virtual void Reset() => throw null;
                    public System.ReadOnlyMemory<System.Byte> SerialNumberBytes { get => throw null; }
                    public string Subject { get => throw null; }
                    public override string ToString() => throw null;
                    public virtual string ToString(bool fVerbose) => throw null;
                    public virtual bool TryGetCertHash(System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                    public X509Certificate() => throw null;
                    public X509Certificate(System.Byte[] data) => throw null;
                    public X509Certificate(System.Byte[] rawData, System.Security.SecureString password) => throw null;
                    public X509Certificate(System.Byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate(System.Byte[] rawData, string password) => throw null;
                    public X509Certificate(System.Byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate(System.IntPtr handle) => throw null;
                    public X509Certificate(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public X509Certificate(System.Security.Cryptography.X509Certificates.X509Certificate cert) => throw null;
                    public X509Certificate(string fileName) => throw null;
                    public X509Certificate(string fileName, System.Security.SecureString password) => throw null;
                    public X509Certificate(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate(string fileName, string password) => throw null;
                    public X509Certificate(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                }

                public class X509Certificate2 : System.Security.Cryptography.X509Certificates.X509Certificate
                {
                    public bool Archived { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(System.Security.Cryptography.ECDiffieHellman privateKey) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromEncryptedPem(System.ReadOnlySpan<System.Char> certPem, System.ReadOnlySpan<System.Char> keyPem, System.ReadOnlySpan<System.Char> password) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromEncryptedPemFile(string certPemFilePath, System.ReadOnlySpan<System.Char> password, string keyPemFilePath = default(string)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPem(System.ReadOnlySpan<System.Char> certPem) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPem(System.ReadOnlySpan<System.Char> certPem, System.ReadOnlySpan<System.Char> keyPem) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPemFile(string certPemFilePath, string keyPemFilePath = default(string)) => throw null;
                    public string ExportCertificatePem() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509ExtensionCollection Extensions { get => throw null; }
                    public string FriendlyName { get => throw null; set => throw null; }
                    public static System.Security.Cryptography.X509Certificates.X509ContentType GetCertContentType(System.Byte[] rawData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509ContentType GetCertContentType(System.ReadOnlySpan<System.Byte> rawData) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509ContentType GetCertContentType(string fileName) => throw null;
                    public System.Security.Cryptography.ECDiffieHellman GetECDiffieHellmanPrivateKey() => throw null;
                    public System.Security.Cryptography.ECDiffieHellman GetECDiffieHellmanPublicKey() => throw null;
                    public string GetNameInfo(System.Security.Cryptography.X509Certificates.X509NameType nameType, bool forIssuer) => throw null;
                    public bool HasPrivateKey { get => throw null; }
                    public override void Import(System.Byte[] rawData) => throw null;
                    public override void Import(System.Byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public override void Import(System.Byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public override void Import(string fileName) => throw null;
                    public override void Import(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public override void Import(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName IssuerName { get => throw null; }
                    public bool MatchesHostname(string hostname, bool allowWildcards = default(bool), bool allowCommonName = default(bool)) => throw null;
                    public System.DateTime NotAfter { get => throw null; }
                    public System.DateTime NotBefore { get => throw null; }
                    public System.Security.Cryptography.AsymmetricAlgorithm PrivateKey { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public System.Byte[] RawData { get => throw null; }
                    public System.ReadOnlyMemory<System.Byte> RawDataMemory { get => throw null; }
                    public override void Reset() => throw null;
                    public string SerialNumber { get => throw null; }
                    public System.Security.Cryptography.Oid SignatureAlgorithm { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName SubjectName { get => throw null; }
                    public string Thumbprint { get => throw null; }
                    public override string ToString() => throw null;
                    public override string ToString(bool verbose) => throw null;
                    public bool TryExportCertificatePem(System.Span<System.Char> destination, out int charsWritten) => throw null;
                    public bool Verify() => throw null;
                    public int Version { get => throw null; }
                    public X509Certificate2() => throw null;
                    public X509Certificate2(System.Byte[] rawData) => throw null;
                    public X509Certificate2(System.Byte[] rawData, System.Security.SecureString password) => throw null;
                    public X509Certificate2(System.Byte[] rawData, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate2(System.Byte[] rawData, string password) => throw null;
                    public X509Certificate2(System.Byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate2(System.IntPtr handle) => throw null;
                    public X509Certificate2(System.ReadOnlySpan<System.Byte> rawData) => throw null;
                    public X509Certificate2(System.ReadOnlySpan<System.Byte> rawData, System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    protected X509Certificate2(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public X509Certificate2(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                    public X509Certificate2(string fileName) => throw null;
                    public X509Certificate2(string fileName, System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public X509Certificate2(string fileName, System.Security.SecureString password) => throw null;
                    public X509Certificate2(string fileName, System.Security.SecureString password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                    public X509Certificate2(string fileName, string password) => throw null;
                    public X509Certificate2(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags) => throw null;
                }

                public class X509Certificate2Collection : System.Security.Cryptography.X509Certificates.X509CertificateCollection, System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Certificate2>, System.Collections.IEnumerable
                {
                    public int Add(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                    public bool Contains(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType) => throw null;
                    public System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, string password) => throw null;
                    public string ExportCertificatePems() => throw null;
                    public string ExportPkcs7Pem() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Find(System.Security.Cryptography.X509Certificates.X509FindType findType, object findValue, bool validOnly) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Certificate2> System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Certificate2>.GetEnumerator() => throw null;
                    public void Import(System.Byte[] rawData) => throw null;
                    public void Import(System.Byte[] rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(System.ReadOnlySpan<System.Byte> rawData) => throw null;
                    public void Import(System.ReadOnlySpan<System.Byte> rawData, System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(System.ReadOnlySpan<System.Byte> rawData, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(string fileName) => throw null;
                    public void Import(string fileName, System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void Import(string fileName, string password, System.Security.Cryptography.X509Certificates.X509KeyStorageFlags keyStorageFlags = default(System.Security.Cryptography.X509Certificates.X509KeyStorageFlags)) => throw null;
                    public void ImportFromPem(System.ReadOnlySpan<System.Char> certPem) => throw null;
                    public void ImportFromPemFile(string certPemFilePath) => throw null;
                    public void Insert(int index, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 this[int index] { get => throw null; set => throw null; }
                    public void Remove(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void RemoveRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public void RemoveRange(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                    public bool TryExportCertificatePems(System.Span<System.Char> destination, out int charsWritten) => throw null;
                    public bool TryExportPkcs7Pem(System.Span<System.Char> destination, out int charsWritten) => throw null;
                    public X509Certificate2Collection() => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                }

                public class X509Certificate2Enumerator : System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Certificate2>, System.Collections.IEnumerator, System.IDisposable
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
                    public class X509CertificateEnumerator : System.Collections.IEnumerator
                    {
                        public System.Security.Cryptography.X509Certificates.X509Certificate Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public bool MoveNext() => throw null;
                        bool System.Collections.IEnumerator.MoveNext() => throw null;
                        public void Reset() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                        public X509CertificateEnumerator(System.Security.Cryptography.X509Certificates.X509CertificateCollection mappings) => throw null;
                    }


                    public int Add(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509CertificateCollection value) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate[] value) => throw null;
                    public bool Contains(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public void CopyTo(System.Security.Cryptography.X509Certificates.X509Certificate[] array, int index) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509CertificateCollection.X509CertificateEnumerator GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    public int IndexOf(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public void Insert(int index, System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate this[int index] { get => throw null; set => throw null; }
                    protected override void OnValidate(object value) => throw null;
                    public void Remove(System.Security.Cryptography.X509Certificates.X509Certificate value) => throw null;
                    public X509CertificateCollection() => throw null;
                    public X509CertificateCollection(System.Security.Cryptography.X509Certificates.X509CertificateCollection value) => throw null;
                    public X509CertificateCollection(System.Security.Cryptography.X509Certificates.X509Certificate[] value) => throw null;
                }

                public class X509Chain : System.IDisposable
                {
                    public bool Build(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.IntPtr ChainContext { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainElementCollection ChainElements { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainPolicy ChainPolicy { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainStatus[] ChainStatus { get => throw null; }
                    public static System.Security.Cryptography.X509Certificates.X509Chain Create() => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public void Reset() => throw null;
                    public Microsoft.Win32.SafeHandles.SafeX509ChainHandle SafeHandle { get => throw null; }
                    public X509Chain() => throw null;
                    public X509Chain(System.IntPtr chainContext) => throw null;
                    public X509Chain(bool useMachineContext) => throw null;
                }

                public class X509ChainElement
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainStatus[] ChainElementStatus { get => throw null; }
                    public string Information { get => throw null; }
                }

                public class X509ChainElementCollection : System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509ChainElement>, System.Collections.ICollection, System.Collections.IEnumerable
                {
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Security.Cryptography.X509Certificates.X509ChainElement[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainElementEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509ChainElement> System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509ChainElement>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainElement this[int index] { get => throw null; }
                    public object SyncRoot { get => throw null; }
                }

                public class X509ChainElementEnumerator : System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509ChainElement>, System.Collections.IEnumerator, System.IDisposable
                {
                    public System.Security.Cryptography.X509Certificates.X509ChainElement Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }

                public class X509ChainPolicy
                {
                    public System.Security.Cryptography.OidCollection ApplicationPolicy { get => throw null; }
                    public System.Security.Cryptography.OidCollection CertificatePolicy { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainPolicy Clone() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection CustomTrustStore { get => throw null; }
                    public bool DisableCertificateDownloads { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection ExtraStore { get => throw null; }
                    public void Reset() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509RevocationFlag RevocationFlag { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509RevocationMode RevocationMode { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainTrustMode TrustMode { get => throw null; set => throw null; }
                    public System.TimeSpan UrlRetrievalTimeout { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509VerificationFlags VerificationFlags { get => throw null; set => throw null; }
                    public System.DateTime VerificationTime { get => throw null; set => throw null; }
                    public bool VerificationTimeIgnored { get => throw null; set => throw null; }
                    public X509ChainPolicy() => throw null;
                }

                public struct X509ChainStatus
                {
                    public System.Security.Cryptography.X509Certificates.X509ChainStatusFlags Status { get => throw null; set => throw null; }
                    public string StatusInformation { get => throw null; set => throw null; }
                    // Stub generator skipped constructor 
                }

                [System.Flags]
                public enum X509ChainStatusFlags : int
                {
                    CtlNotSignatureValid = 262144,
                    CtlNotTimeValid = 131072,
                    CtlNotValidForUsage = 524288,
                    Cyclic = 128,
                    ExplicitDistrust = 67108864,
                    HasExcludedNameConstraint = 32768,
                    HasNotDefinedNameConstraint = 8192,
                    HasNotPermittedNameConstraint = 16384,
                    HasNotSupportedCriticalExtension = 134217728,
                    HasNotSupportedNameConstraint = 4096,
                    HasWeakSignature = 1048576,
                    InvalidBasicConstraints = 1024,
                    InvalidExtension = 256,
                    InvalidNameConstraints = 2048,
                    InvalidPolicyConstraints = 512,
                    NoError = 0,
                    NoIssuanceChainPolicy = 33554432,
                    NotSignatureValid = 8,
                    NotTimeNested = 2,
                    NotTimeValid = 1,
                    NotValidForUsage = 16,
                    OfflineRevocation = 16777216,
                    PartialChain = 65536,
                    RevocationStatusUnknown = 64,
                    Revoked = 4,
                    UntrustedRoot = 32,
                }

                public enum X509ChainTrustMode : int
                {
                    CustomRootTrust = 1,
                    System = 0,
                }

                public enum X509ContentType : int
                {
                    Authenticode = 6,
                    Cert = 1,
                    Pfx = 3,
                    Pkcs12 = 3,
                    Pkcs7 = 5,
                    SerializedCert = 2,
                    SerializedStore = 4,
                    Unknown = 0,
                }

                public class X509EnhancedKeyUsageExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Security.Cryptography.OidCollection EnhancedKeyUsages { get => throw null; }
                    public X509EnhancedKeyUsageExtension() => throw null;
                    public X509EnhancedKeyUsageExtension(System.Security.Cryptography.AsnEncodedData encodedEnhancedKeyUsages, bool critical) => throw null;
                    public X509EnhancedKeyUsageExtension(System.Security.Cryptography.OidCollection enhancedKeyUsages, bool critical) => throw null;
                }

                public class X509Extension : System.Security.Cryptography.AsnEncodedData
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public bool Critical { get => throw null; set => throw null; }
                    protected X509Extension() => throw null;
                    public X509Extension(System.Security.Cryptography.AsnEncodedData encodedExtension, bool critical) => throw null;
                    public X509Extension(System.Security.Cryptography.Oid oid, System.Byte[] rawData, bool critical) => throw null;
                    public X509Extension(System.Security.Cryptography.Oid oid, System.ReadOnlySpan<System.Byte> rawData, bool critical) => throw null;
                    public X509Extension(string oid, System.Byte[] rawData, bool critical) => throw null;
                    public X509Extension(string oid, System.ReadOnlySpan<System.Byte> rawData, bool critical) => throw null;
                }

                public class X509ExtensionCollection : System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Extension>, System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public int Add(System.Security.Cryptography.X509Certificates.X509Extension extension) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Security.Cryptography.X509Certificates.X509Extension[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ExtensionEnumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Extension> System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Extension>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Extension this[int index] { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Extension this[string oid] { get => throw null; }
                    public object SyncRoot { get => throw null; }
                    public X509ExtensionCollection() => throw null;
                }

                public class X509ExtensionEnumerator : System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Extension>, System.Collections.IEnumerator, System.IDisposable
                {
                    public System.Security.Cryptography.X509Certificates.X509Extension Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }

                public enum X509FindType : int
                {
                    FindByApplicationPolicy = 10,
                    FindByCertificatePolicy = 11,
                    FindByExtension = 12,
                    FindByIssuerDistinguishedName = 4,
                    FindByIssuerName = 3,
                    FindByKeyUsage = 13,
                    FindBySerialNumber = 5,
                    FindBySubjectDistinguishedName = 2,
                    FindBySubjectKeyIdentifier = 14,
                    FindBySubjectName = 1,
                    FindByTemplateName = 9,
                    FindByThumbprint = 0,
                    FindByTimeExpired = 8,
                    FindByTimeNotYetValid = 7,
                    FindByTimeValid = 6,
                }

                public enum X509IncludeOption : int
                {
                    EndCertOnly = 2,
                    ExcludeRoot = 1,
                    None = 0,
                    WholeChain = 3,
                }

                [System.Flags]
                public enum X509KeyStorageFlags : int
                {
                    DefaultKeySet = 0,
                    EphemeralKeySet = 32,
                    Exportable = 4,
                    MachineKeySet = 2,
                    PersistKeySet = 16,
                    UserKeySet = 1,
                    UserProtected = 8,
                }

                public class X509KeyUsageExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509KeyUsageFlags KeyUsages { get => throw null; }
                    public X509KeyUsageExtension() => throw null;
                    public X509KeyUsageExtension(System.Security.Cryptography.AsnEncodedData encodedKeyUsage, bool critical) => throw null;
                    public X509KeyUsageExtension(System.Security.Cryptography.X509Certificates.X509KeyUsageFlags keyUsages, bool critical) => throw null;
                }

                [System.Flags]
                public enum X509KeyUsageFlags : int
                {
                    CrlSign = 2,
                    DataEncipherment = 16,
                    DecipherOnly = 32768,
                    DigitalSignature = 128,
                    EncipherOnly = 1,
                    KeyAgreement = 8,
                    KeyCertSign = 4,
                    KeyEncipherment = 32,
                    NonRepudiation = 64,
                    None = 0,
                }

                public enum X509NameType : int
                {
                    DnsFromAlternativeName = 4,
                    DnsName = 3,
                    EmailName = 1,
                    SimpleName = 0,
                    UpnName = 2,
                    UrlName = 5,
                }

                public enum X509RevocationFlag : int
                {
                    EndCertificateOnly = 0,
                    EntireChain = 1,
                    ExcludeRoot = 2,
                }

                public enum X509RevocationMode : int
                {
                    NoCheck = 0,
                    Offline = 2,
                    Online = 1,
                }

                public enum X509RevocationReason : int
                {
                    AACompromise = 10,
                    AffiliationChanged = 3,
                    CACompromise = 2,
                    CertificateHold = 6,
                    CessationOfOperation = 5,
                    KeyCompromise = 1,
                    PrivilegeWithdrawn = 9,
                    RemoveFromCrl = 8,
                    Superseded = 4,
                    Unspecified = 0,
                    WeakAlgorithmOrKey = 11,
                }

                public abstract class X509SignatureGenerator
                {
                    protected abstract System.Security.Cryptography.X509Certificates.PublicKey BuildPublicKey();
                    public static System.Security.Cryptography.X509Certificates.X509SignatureGenerator CreateForECDsa(System.Security.Cryptography.ECDsa key) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509SignatureGenerator CreateForRSA(System.Security.Cryptography.RSA key, System.Security.Cryptography.RSASignaturePadding signaturePadding) => throw null;
                    public abstract System.Byte[] GetSignatureAlgorithmIdentifier(System.Security.Cryptography.HashAlgorithmName hashAlgorithm);
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public abstract System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm);
                    protected X509SignatureGenerator() => throw null;
                }

                public class X509Store : System.IDisposable
                {
                    public void Add(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Certificates { get => throw null; }
                    public void Close() => throw null;
                    public void Dispose() => throw null;
                    public bool IsOpen { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.StoreLocation Location { get => throw null; }
                    public string Name { get => throw null; }
                    public void Open(System.Security.Cryptography.X509Certificates.OpenFlags flags) => throw null;
                    public void Remove(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void RemoveRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public System.IntPtr StoreHandle { get => throw null; }
                    public X509Store() => throw null;
                    public X509Store(System.IntPtr storeHandle) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreLocation storeLocation) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreName storeName) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreName storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation) => throw null;
                    public X509Store(System.Security.Cryptography.X509Certificates.StoreName storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, System.Security.Cryptography.X509Certificates.OpenFlags flags) => throw null;
                    public X509Store(string storeName) => throw null;
                    public X509Store(string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation) => throw null;
                    public X509Store(string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, System.Security.Cryptography.X509Certificates.OpenFlags flags) => throw null;
                }

                public class X509SubjectAlternativeNameExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Collections.Generic.IEnumerable<string> EnumerateDnsNames() => throw null;
                    public System.Collections.Generic.IEnumerable<System.Net.IPAddress> EnumerateIPAddresses() => throw null;
                    public X509SubjectAlternativeNameExtension() => throw null;
                    public X509SubjectAlternativeNameExtension(System.Byte[] rawData, bool critical = default(bool)) => throw null;
                    public X509SubjectAlternativeNameExtension(System.ReadOnlySpan<System.Byte> rawData, bool critical = default(bool)) => throw null;
                }

                public class X509SubjectKeyIdentifierExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public string SubjectKeyIdentifier { get => throw null; }
                    public System.ReadOnlyMemory<System.Byte> SubjectKeyIdentifierBytes { get => throw null; }
                    public X509SubjectKeyIdentifierExtension() => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.AsnEncodedData encodedSubjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Byte[] subjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.X509Certificates.PublicKey key, System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierHashAlgorithm algorithm, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.X509Certificates.PublicKey key, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.ReadOnlySpan<System.Byte> subjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(string subjectKeyIdentifier, bool critical) => throw null;
                }

                public enum X509SubjectKeyIdentifierHashAlgorithm : int
                {
                    CapiSha1 = 2,
                    Sha1 = 0,
                    ShortSha1 = 1,
                }

                [System.Flags]
                public enum X509VerificationFlags : int
                {
                    AllFlags = 4095,
                    AllowUnknownCertificateAuthority = 16,
                    IgnoreCertificateAuthorityRevocationUnknown = 1024,
                    IgnoreCtlNotTimeValid = 2,
                    IgnoreCtlSignerRevocationUnknown = 512,
                    IgnoreEndRevocationUnknown = 256,
                    IgnoreInvalidBasicConstraints = 8,
                    IgnoreInvalidName = 64,
                    IgnoreInvalidPolicy = 128,
                    IgnoreNotTimeNested = 4,
                    IgnoreNotTimeValid = 1,
                    IgnoreRootRevocationUnknown = 2048,
                    IgnoreWrongUsage = 32,
                    NoFlag = 0,
                }

            }
        }
    }
}
