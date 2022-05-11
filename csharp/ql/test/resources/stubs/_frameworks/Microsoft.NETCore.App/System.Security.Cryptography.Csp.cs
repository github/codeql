// This file contains auto-generated code.

namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.AesCryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.CspKeyContainerInfo` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.CspParameters` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.CspProviderFlags` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CspProviderFlags
            {
                CreateEphemeralKey,
                NoFlags,
                NoPrompt,
                UseArchivableKey,
                UseDefaultKeyContainer,
                UseExistingKey,
                UseMachineKeyStore,
                UseNonExportableKey,
                UseUserProtectedKey,
            }

            // Generated from `System.Security.Cryptography.DESCryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.DSACryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.ICspAsymmetricAlgorithm` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICspAsymmetricAlgorithm
            {
                System.Security.Cryptography.CspKeyContainerInfo CspKeyContainerInfo { get; }
                System.Byte[] ExportCspBlob(bool includePrivateParameters);
                void ImportCspBlob(System.Byte[] rawData);
            }

            // Generated from `System.Security.Cryptography.KeyNumber` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum KeyNumber
            {
                Exchange,
                Signature,
            }

            // Generated from `System.Security.Cryptography.MD5CryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.PasswordDeriveBytes` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RC2CryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RNGCryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RSACryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public void ImportCspBlob(System.Byte[] keyBlob) => throw null;
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

            // Generated from `System.Security.Cryptography.SHA1CryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SHA256CryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SHA384CryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SHA512CryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.TripleDESCryptoServiceProvider` in `System.Security.Cryptography.Csp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        }
    }
}
