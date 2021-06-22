// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafeNCryptHandle` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SafeNCryptHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                protected abstract bool ReleaseNativeHandle();
                protected SafeNCryptHandle(System.IntPtr handle, System.Runtime.InteropServices.SafeHandle parentHandle) : base(default(bool)) => throw null;
                protected SafeNCryptHandle() : base(default(bool)) => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeNCryptKeyHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                protected override bool ReleaseNativeHandle() => throw null;
                public SafeNCryptKeyHandle(System.IntPtr handle, System.Runtime.InteropServices.SafeHandle parentHandle) => throw null;
                public SafeNCryptKeyHandle() => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeNCryptProviderHandle` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeNCryptProviderHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                protected override bool ReleaseNativeHandle() => throw null;
                public SafeNCryptProviderHandle() => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeNCryptSecretHandle : Microsoft.Win32.SafeHandles.SafeNCryptHandle
            {
                protected override bool ReleaseNativeHandle() => throw null;
                public SafeNCryptSecretHandle() => throw null;
            }

        }
    }
}
namespace System
{
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

        }
    }
    namespace Security
    {
        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.AesCng` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AesCng : System.Security.Cryptography.Aes
            {
                public AesCng(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                public AesCng(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public AesCng(string keyName) => throw null;
                public AesCng() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Cryptography.CngAlgorithm` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngAlgorithm other) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngAlgorithm MD5 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Rsa { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha1 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha256 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha384 { get => throw null; }
                public static System.Security.Cryptography.CngAlgorithm Sha512 { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Cryptography.CngAlgorithmGroup` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngAlgorithmGroup other) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngAlgorithmGroup Rsa { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Cryptography.CngExportPolicies` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngExportPolicies
            {
                AllowArchiving,
                AllowExport,
                AllowPlaintextArchiving,
                AllowPlaintextExport,
                None,
            }

            // Generated from `System.Security.Cryptography.CngKey` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CngKey : System.IDisposable
            {
                public System.Security.Cryptography.CngAlgorithm Algorithm { get => throw null; }
                public System.Security.Cryptography.CngAlgorithmGroup AlgorithmGroup { get => throw null; }
                public static System.Security.Cryptography.CngKey Create(System.Security.Cryptography.CngAlgorithm algorithm, string keyName, System.Security.Cryptography.CngKeyCreationParameters creationParameters) => throw null;
                public static System.Security.Cryptography.CngKey Create(System.Security.Cryptography.CngAlgorithm algorithm, string keyName) => throw null;
                public static System.Security.Cryptography.CngKey Create(System.Security.Cryptography.CngAlgorithm algorithm) => throw null;
                public void Delete() => throw null;
                public void Dispose() => throw null;
                public static bool Exists(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions options) => throw null;
                public static bool Exists(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public static bool Exists(string keyName) => throw null;
                public System.Byte[] Export(System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public System.Security.Cryptography.CngExportPolicies ExportPolicy { get => throw null; }
                public System.Security.Cryptography.CngProperty GetProperty(string name, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle Handle { get => throw null; }
                public bool HasProperty(string name, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                public static System.Security.Cryptography.CngKey Import(System.Byte[] keyBlob, System.Security.Cryptography.CngKeyBlobFormat format, System.Security.Cryptography.CngProvider provider) => throw null;
                public static System.Security.Cryptography.CngKey Import(System.Byte[] keyBlob, System.Security.Cryptography.CngKeyBlobFormat format) => throw null;
                public bool IsEphemeral { get => throw null; }
                public bool IsMachineKey { get => throw null; }
                public string KeyName { get => throw null; }
                public int KeySize { get => throw null; }
                public System.Security.Cryptography.CngKeyUsages KeyUsage { get => throw null; }
                public static System.Security.Cryptography.CngKey Open(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public static System.Security.Cryptography.CngKey Open(string keyName) => throw null;
                public static System.Security.Cryptography.CngKey Open(Microsoft.Win32.SafeHandles.SafeNCryptKeyHandle keyHandle, System.Security.Cryptography.CngKeyHandleOpenOptions keyHandleOpenOptions) => throw null;
                public System.IntPtr ParentWindowHandle { get => throw null; set => throw null; }
                public System.Security.Cryptography.CngProvider Provider { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeNCryptProviderHandle ProviderHandle { get => throw null; }
                public void SetProperty(System.Security.Cryptography.CngProperty property) => throw null;
                public System.Security.Cryptography.CngUIPolicy UIPolicy { get => throw null; }
                public string UniqueName { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.CngKeyBlobFormat` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CngKeyBlobFormat : System.IEquatable<System.Security.Cryptography.CngKeyBlobFormat>
            {
                public static bool operator !=(System.Security.Cryptography.CngKeyBlobFormat left, System.Security.Cryptography.CngKeyBlobFormat right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngKeyBlobFormat left, System.Security.Cryptography.CngKeyBlobFormat right) => throw null;
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
                public static System.Security.Cryptography.CngKeyBlobFormat OpaqueTransportBlob { get => throw null; }
                public static System.Security.Cryptography.CngKeyBlobFormat Pkcs8PrivateBlob { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Cryptography.CngKeyCreationOptions` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngKeyCreationOptions
            {
                MachineKey,
                None,
                OverwriteExistingKey,
            }

            // Generated from `System.Security.Cryptography.CngKeyCreationParameters` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.CngKeyHandleOpenOptions` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngKeyHandleOpenOptions
            {
                EphemeralKey,
                None,
            }

            // Generated from `System.Security.Cryptography.CngKeyOpenOptions` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngKeyOpenOptions
            {
                MachineKey,
                None,
                Silent,
                UserKey,
            }

            // Generated from `System.Security.Cryptography.CngKeyUsages` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngKeyUsages
            {
                AllUsages,
                Decryption,
                KeyAgreement,
                None,
                Signing,
            }

            // Generated from `System.Security.Cryptography.CngProperty` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct CngProperty : System.IEquatable<System.Security.Cryptography.CngProperty>
            {
                public static bool operator !=(System.Security.Cryptography.CngProperty left, System.Security.Cryptography.CngProperty right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngProperty left, System.Security.Cryptography.CngProperty right) => throw null;
                public CngProperty(string name, System.Byte[] value, System.Security.Cryptography.CngPropertyOptions options) => throw null;
                // Stub generator skipped constructor 
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngProperty other) => throw null;
                public override int GetHashCode() => throw null;
                public System.Byte[] GetValue() => throw null;
                public string Name { get => throw null; }
                public System.Security.Cryptography.CngPropertyOptions Options { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.CngPropertyCollection` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CngPropertyCollection : System.Collections.ObjectModel.Collection<System.Security.Cryptography.CngProperty>
            {
                public CngPropertyCollection() => throw null;
            }

            // Generated from `System.Security.Cryptography.CngPropertyOptions` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngPropertyOptions
            {
                CustomProperty,
                None,
                Persist,
            }

            // Generated from `System.Security.Cryptography.CngProvider` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CngProvider : System.IEquatable<System.Security.Cryptography.CngProvider>
            {
                public static bool operator !=(System.Security.Cryptography.CngProvider left, System.Security.Cryptography.CngProvider right) => throw null;
                public static bool operator ==(System.Security.Cryptography.CngProvider left, System.Security.Cryptography.CngProvider right) => throw null;
                public CngProvider(string provider) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Security.Cryptography.CngProvider other) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Security.Cryptography.CngProvider MicrosoftSmartCardKeyStorageProvider { get => throw null; }
                public static System.Security.Cryptography.CngProvider MicrosoftSoftwareKeyStorageProvider { get => throw null; }
                public string Provider { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Cryptography.CngUIPolicy` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CngUIPolicy
            {
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description, string useContext, string creationTitle) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description, string useContext) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName, string description) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel, string friendlyName) => throw null;
                public CngUIPolicy(System.Security.Cryptography.CngUIProtectionLevels protectionLevel) => throw null;
                public string CreationTitle { get => throw null; }
                public string Description { get => throw null; }
                public string FriendlyName { get => throw null; }
                public System.Security.Cryptography.CngUIProtectionLevels ProtectionLevel { get => throw null; }
                public string UseContext { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.CngUIProtectionLevels` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CngUIProtectionLevels
            {
                ForceHighProtection,
                None,
                ProtectKey,
            }

            // Generated from `System.Security.Cryptography.DSACng` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DSACng : System.Security.Cryptography.DSA
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public DSACng(int keySize) => throw null;
                public DSACng(System.Security.Cryptography.CngKey key) => throw null;
                public DSACng() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override string KeyExchangeAlgorithm { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override string SignatureAlgorithm { get => throw null; }
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            // Generated from `System.Security.Cryptography.ECDiffieHellmanCng` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ECDiffieHellmanCng : System.Security.Cryptography.ECDiffieHellman
            {
                public override System.Byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public override System.Byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] hmacKey, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public override System.Byte[] DeriveKeyMaterial(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public System.Byte[] DeriveKeyMaterial(System.Security.Cryptography.CngKey otherPartyPublicKey) => throw null;
                public override System.Byte[] DeriveKeyTls(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Byte[] prfLabel, System.Byte[] prfSeed) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle DeriveSecretAgreementHandle(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public Microsoft.Win32.SafeHandles.SafeNCryptSecretHandle DeriveSecretAgreementHandle(System.Security.Cryptography.CngKey otherPartyPublicKey) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public ECDiffieHellmanCng(int keySize) => throw null;
                public ECDiffieHellmanCng(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDiffieHellmanCng(System.Security.Cryptography.CngKey key) => throw null;
                public ECDiffieHellmanCng() => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void FromXmlString(string xml, System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public System.Security.Cryptography.CngAlgorithm HashAlgorithm { get => throw null; set => throw null; }
                public System.Byte[] HmacKey { get => throw null; set => throw null; }
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public System.Security.Cryptography.ECDiffieHellmanKeyDerivationFunction KeyDerivationFunction { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public System.Byte[] Label { get => throw null; set => throw null; }
                public override System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get => throw null; }
                public System.Byte[] SecretAppend { get => throw null; set => throw null; }
                public System.Byte[] SecretPrepend { get => throw null; set => throw null; }
                public System.Byte[] Seed { get => throw null; set => throw null; }
                public string ToXmlString(System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public bool UseSecretAgreementAsHmacKey { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.ECDiffieHellmanCngPublicKey` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.ECDiffieHellmanKeyDerivationFunction` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ECDiffieHellmanKeyDerivationFunction
            {
                Hash,
                Hmac,
                Tls,
            }

            // Generated from `System.Security.Cryptography.ECDsaCng` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ECDsaCng : System.Security.Cryptography.ECDsa
            {
                protected override void Dispose(bool disposing) => throw null;
                public ECDsaCng(int keySize) => throw null;
                public ECDsaCng(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDsaCng(System.Security.Cryptography.CngKey key) => throw null;
                public ECDsaCng() => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public void FromXmlString(string xml, System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public System.Security.Cryptography.CngAlgorithm HashAlgorithm { get => throw null; set => throw null; }
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public System.Byte[] SignData(System.IO.Stream data) => throw null;
                public System.Byte[] SignData(System.Byte[] data, int offset, int count) => throw null;
                public System.Byte[] SignData(System.Byte[] data) => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash) => throw null;
                public string ToXmlString(System.Security.Cryptography.ECKeyXmlFormat format) => throw null;
                public bool VerifyData(System.IO.Stream data, System.Byte[] signature) => throw null;
                public bool VerifyData(System.Byte[] data, int offset, int count, System.Byte[] signature) => throw null;
                public bool VerifyData(System.Byte[] data, System.Byte[] signature) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature) => throw null;
            }

            // Generated from `System.Security.Cryptography.ECKeyXmlFormat` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ECKeyXmlFormat
            {
                Rfc4050,
            }

            // Generated from `System.Security.Cryptography.RSACng` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RSACng : System.Security.Cryptography.RSA
            {
                public override System.Byte[] Decrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] Encrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public System.Security.Cryptography.CngKey Key { get => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public RSACng(int keySize) => throw null;
                public RSACng(System.Security.Cryptography.CngKey key) => throw null;
                public RSACng() => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
            }

            // Generated from `System.Security.Cryptography.TripleDESCng` in `System.Security.Cryptography.Cng, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TripleDESCng : System.Security.Cryptography.TripleDES
            {
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override void GenerateIV() => throw null;
                public override void GenerateKey() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public override int KeySize { get => throw null; set => throw null; }
                public TripleDESCng(string keyName, System.Security.Cryptography.CngProvider provider, System.Security.Cryptography.CngKeyOpenOptions openOptions) => throw null;
                public TripleDESCng(string keyName, System.Security.Cryptography.CngProvider provider) => throw null;
                public TripleDESCng(string keyName) => throw null;
                public TripleDESCng() => throw null;
            }

        }
    }
}
