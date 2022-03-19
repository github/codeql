// This file contains auto-generated code.

namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.Aes` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class Aes : System.Security.Cryptography.SymmetricAlgorithm
            {
                protected Aes() => throw null;
                public static System.Security.Cryptography.Aes Create() => throw null;
                public static System.Security.Cryptography.Aes Create(string algorithmName) => throw null;
            }

            // Generated from `System.Security.Cryptography.AesCcm` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AesCcm : System.IDisposable
            {
                public AesCcm(System.Byte[] key) => throw null;
                public AesCcm(System.ReadOnlySpan<System.Byte> key) => throw null;
                public void Decrypt(System.Byte[] nonce, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] plaintext, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> tag, System.Span<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(System.Byte[] nonce, System.Byte[] plaintext, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> ciphertext, System.Span<System.Byte> tag, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public static System.Security.Cryptography.KeySizes NonceByteSizes { get => throw null; }
                public static System.Security.Cryptography.KeySizes TagByteSizes { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.AesGcm` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AesGcm : System.IDisposable
            {
                public AesGcm(System.Byte[] key) => throw null;
                public AesGcm(System.ReadOnlySpan<System.Byte> key) => throw null;
                public void Decrypt(System.Byte[] nonce, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] plaintext, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Decrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> ciphertext, System.ReadOnlySpan<System.Byte> tag, System.Span<System.Byte> plaintext, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public void Dispose() => throw null;
                public void Encrypt(System.Byte[] nonce, System.Byte[] plaintext, System.Byte[] ciphertext, System.Byte[] tag, System.Byte[] associatedData = default(System.Byte[])) => throw null;
                public void Encrypt(System.ReadOnlySpan<System.Byte> nonce, System.ReadOnlySpan<System.Byte> plaintext, System.Span<System.Byte> ciphertext, System.Span<System.Byte> tag, System.ReadOnlySpan<System.Byte> associatedData = default(System.ReadOnlySpan<System.Byte>)) => throw null;
                public static System.Security.Cryptography.KeySizes NonceByteSizes { get => throw null; }
                public static System.Security.Cryptography.KeySizes TagByteSizes { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.AesManaged` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.AsymmetricKeyExchangeDeformatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AsymmetricKeyExchangeDeformatter
            {
                protected AsymmetricKeyExchangeDeformatter() => throw null;
                public abstract System.Byte[] DecryptKeyExchange(System.Byte[] rgb);
                public abstract string Parameters { get; set; }
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }

            // Generated from `System.Security.Cryptography.AsymmetricKeyExchangeFormatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AsymmetricKeyExchangeFormatter
            {
                protected AsymmetricKeyExchangeFormatter() => throw null;
                public abstract System.Byte[] CreateKeyExchange(System.Byte[] data);
                public abstract System.Byte[] CreateKeyExchange(System.Byte[] data, System.Type symAlgType);
                public abstract string Parameters { get; }
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }

            // Generated from `System.Security.Cryptography.AsymmetricSignatureDeformatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AsymmetricSignatureDeformatter
            {
                protected AsymmetricSignatureDeformatter() => throw null;
                public abstract void SetHashAlgorithm(string strName);
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
                public abstract bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature);
                public virtual bool VerifySignature(System.Security.Cryptography.HashAlgorithm hash, System.Byte[] rgbSignature) => throw null;
            }

            // Generated from `System.Security.Cryptography.AsymmetricSignatureFormatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AsymmetricSignatureFormatter
            {
                protected AsymmetricSignatureFormatter() => throw null;
                public abstract System.Byte[] CreateSignature(System.Byte[] rgbHash);
                public virtual System.Byte[] CreateSignature(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                public abstract void SetHashAlgorithm(string strName);
                public abstract void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key);
            }

            // Generated from `System.Security.Cryptography.CryptoConfig` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.DES` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DES : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.DES Create() => throw null;
                public static System.Security.Cryptography.DES Create(string algName) => throw null;
                protected DES() => throw null;
                public static bool IsSemiWeakKey(System.Byte[] rgbKey) => throw null;
                public static bool IsWeakKey(System.Byte[] rgbKey) => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Cryptography.DSA` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.DSAParameters` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.DSASignatureDeformatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DSASignatureDeformatter : System.Security.Cryptography.AsymmetricSignatureDeformatter
            {
                public DSASignatureDeformatter() => throw null;
                public DSASignatureDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            // Generated from `System.Security.Cryptography.DSASignatureFormat` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum DSASignatureFormat
            {
                IeeeP1363FixedFieldConcatenation,
                Rfc3279DerSequence,
            }

            // Generated from `System.Security.Cryptography.DSASignatureFormatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DSASignatureFormatter : System.Security.Cryptography.AsymmetricSignatureFormatter
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public DSASignatureFormatter() => throw null;
                public DSASignatureFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            // Generated from `System.Security.Cryptography.DeriveBytes` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DeriveBytes : System.IDisposable
            {
                protected DeriveBytes() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public abstract System.Byte[] GetBytes(int cb);
                public abstract void Reset();
            }

            // Generated from `System.Security.Cryptography.ECCurve` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ECCurve
            {
                // Generated from `System.Security.Cryptography.ECCurve+ECCurveType` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum ECCurveType
                {
                    Characteristic2,
                    Implicit,
                    Named,
                    PrimeMontgomery,
                    PrimeShortWeierstrass,
                    PrimeTwistedEdwards,
                }


                // Generated from `System.Security.Cryptography.ECCurve+NamedCurves` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.ECDiffieHellman` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ECDiffieHellman : System.Security.Cryptography.AsymmetricAlgorithm
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
                public virtual System.Byte[] ExportECPrivateKey() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void FromXmlString(string xmlString) => throw null;
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
                public override string KeyExchangeAlgorithm { get => throw null; }
                public abstract System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get; }
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryExportECPrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.ECDiffieHellmanPublicKey` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ECDiffieHellmanPublicKey : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                protected ECDiffieHellmanPublicKey() => throw null;
                protected ECDiffieHellmanPublicKey(System.Byte[] keyBlob) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters() => throw null;
                public virtual System.Byte[] ToByteArray() => throw null;
                public virtual string ToXmlString() => throw null;
            }

            // Generated from `System.Security.Cryptography.ECDsa` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ECDsa : System.Security.Cryptography.AsymmetricAlgorithm
            {
                public static System.Security.Cryptography.ECDsa Create() => throw null;
                public static System.Security.Cryptography.ECDsa Create(System.Security.Cryptography.ECCurve curve) => throw null;
                public static System.Security.Cryptography.ECDsa Create(System.Security.Cryptography.ECParameters parameters) => throw null;
                public static System.Security.Cryptography.ECDsa Create(string algorithm) => throw null;
                protected ECDsa() => throw null;
                public virtual System.Byte[] ExportECPrivateKey() => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public virtual System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void FromXmlString(string xmlString) => throw null;
                public virtual void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public int GetMaxSignatureSize(System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected virtual System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public virtual void ImportECPrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Byte> passwordBytes) => throw null;
                public override void ImportFromEncryptedPem(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> password) => throw null;
                public override void ImportFromPem(System.ReadOnlySpan<System.Char> input) => throw null;
                public virtual void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override void ImportPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override void ImportSubjectPublicKeyInfo(System.ReadOnlySpan<System.Byte> source, out int bytesRead) => throw null;
                public override string KeyExchangeAlgorithm { get => throw null; }
                public virtual System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.Byte[] data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public virtual System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignDataCore(System.ReadOnlySpan<System.Byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignDataCore(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public abstract System.Byte[] SignHash(System.Byte[] hash);
                public System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                protected virtual System.Byte[] SignHashCore(System.ReadOnlySpan<System.Byte> hash, System.Security.Cryptography.DSASignatureFormat signatureFormat) => throw null;
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryExportECPrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportSubjectPublicKeyInfo(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
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

            // Generated from `System.Security.Cryptography.ECParameters` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ECParameters
            {
                public System.Security.Cryptography.ECCurve Curve;
                public System.Byte[] D;
                // Stub generator skipped constructor 
                public System.Security.Cryptography.ECPoint Q;
                public void Validate() => throw null;
            }

            // Generated from `System.Security.Cryptography.ECPoint` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ECPoint
            {
                // Stub generator skipped constructor 
                public System.Byte[] X;
                public System.Byte[] Y;
            }

            // Generated from `System.Security.Cryptography.HKDF` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class HKDF
            {
                public static System.Byte[] DeriveKey(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.Byte[] ikm, int outputLength, System.Byte[] salt = default(System.Byte[]), System.Byte[] info = default(System.Byte[])) => throw null;
                public static void DeriveKey(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<System.Byte> ikm, System.Span<System.Byte> output, System.ReadOnlySpan<System.Byte> salt, System.ReadOnlySpan<System.Byte> info) => throw null;
                public static System.Byte[] Expand(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.Byte[] prk, int outputLength, System.Byte[] info = default(System.Byte[])) => throw null;
                public static void Expand(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<System.Byte> prk, System.Span<System.Byte> output, System.ReadOnlySpan<System.Byte> info) => throw null;
                public static System.Byte[] Extract(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.Byte[] ikm, System.Byte[] salt = default(System.Byte[])) => throw null;
                public static int Extract(System.Security.Cryptography.HashAlgorithmName hashAlgorithmName, System.ReadOnlySpan<System.Byte> ikm, System.ReadOnlySpan<System.Byte> salt, System.Span<System.Byte> prk) => throw null;
            }

            // Generated from `System.Security.Cryptography.HMACMD5` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HMACMD5 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACMD5() => throw null;
                public HMACMD5(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.HMACSHA1` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HMACSHA1 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA1() => throw null;
                public HMACSHA1(System.Byte[] key) => throw null;
                public HMACSHA1(System.Byte[] key, bool useManagedSha1) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.HMACSHA256` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HMACSHA256 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA256() => throw null;
                public HMACSHA256(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.HMACSHA384` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HMACSHA384 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA384() => throw null;
                public HMACSHA384(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public bool ProduceLegacyHmacValues { get => throw null; set => throw null; }
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.HMACSHA512` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HMACSHA512 : System.Security.Cryptography.HMAC
            {
                protected override void Dispose(bool disposing) => throw null;
                public HMACSHA512() => throw null;
                public HMACSHA512(System.Byte[] key) => throw null;
                protected override void HashCore(System.Byte[] rgb, int ib, int cb) => throw null;
                protected override void HashCore(System.ReadOnlySpan<System.Byte> source) => throw null;
                protected override System.Byte[] HashFinal() => throw null;
                public override void Initialize() => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                public bool ProduceLegacyHmacValues { get => throw null; set => throw null; }
                protected override bool TryHashFinal(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.IncrementalHash` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.MD5` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class MD5 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.MD5 Create() => throw null;
                public static System.Security.Cryptography.MD5 Create(string algName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                protected MD5() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.MaskGenerationMethod` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class MaskGenerationMethod
            {
                public abstract System.Byte[] GenerateMask(System.Byte[] rgbSeed, int cbReturn);
                protected MaskGenerationMethod() => throw null;
            }

            // Generated from `System.Security.Cryptography.PKCS1MaskGenerationMethod` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PKCS1MaskGenerationMethod : System.Security.Cryptography.MaskGenerationMethod
            {
                public override System.Byte[] GenerateMask(System.Byte[] rgbSeed, int cbReturn) => throw null;
                public string HashName { get => throw null; set => throw null; }
                public PKCS1MaskGenerationMethod() => throw null;
            }

            // Generated from `System.Security.Cryptography.RC2` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class RC2 : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.RC2 Create() => throw null;
                public static System.Security.Cryptography.RC2 Create(string AlgName) => throw null;
                public virtual int EffectiveKeySize { get => throw null; set => throw null; }
                protected int EffectiveKeySizeValue;
                public override int KeySize { get => throw null; set => throw null; }
                protected RC2() => throw null;
            }

            // Generated from `System.Security.Cryptography.RSA` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class RSA : System.Security.Cryptography.AsymmetricAlgorithm
            {
                public static System.Security.Cryptography.RSA Create() => throw null;
                public static System.Security.Cryptography.RSA Create(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public static System.Security.Cryptography.RSA Create(int keySizeInBits) => throw null;
                public static System.Security.Cryptography.RSA Create(string algName) => throw null;
                public virtual System.Byte[] Decrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public virtual System.Byte[] DecryptValue(System.Byte[] rgb) => throw null;
                public virtual System.Byte[] Encrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public virtual System.Byte[] EncryptValue(System.Byte[] rgb) => throw null;
                public abstract System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters);
                public virtual System.Byte[] ExportRSAPrivateKey() => throw null;
                public virtual System.Byte[] ExportRSAPublicKey() => throw null;
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
                public virtual System.Byte[] SignData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public virtual System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override string SignatureAlgorithm { get => throw null; }
                public override string ToXmlString(bool includePrivateParameters) => throw null;
                public virtual bool TryDecrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public virtual bool TryEncrypt(System.ReadOnlySpan<System.Byte> data, System.Span<System.Byte> destination, System.Security.Cryptography.RSAEncryptionPadding padding, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportEncryptedPkcs8PrivateKey(System.ReadOnlySpan<System.Char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public override bool TryExportPkcs8PrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportRSAPrivateKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public virtual bool TryExportRSAPublicKey(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
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

            // Generated from `System.Security.Cryptography.RSAEncryptionPadding` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RSAEncryptionPaddingMode` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum RSAEncryptionPaddingMode
            {
                Oaep,
                Pkcs1,
            }

            // Generated from `System.Security.Cryptography.RSAOAEPKeyExchangeDeformatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RSAOAEPKeyExchangeDeformatter : System.Security.Cryptography.AsymmetricKeyExchangeDeformatter
            {
                public override System.Byte[] DecryptKeyExchange(System.Byte[] rgbData) => throw null;
                public override string Parameters { get => throw null; set => throw null; }
                public RSAOAEPKeyExchangeDeformatter() => throw null;
                public RSAOAEPKeyExchangeDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            // Generated from `System.Security.Cryptography.RSAOAEPKeyExchangeFormatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RSAPKCS1KeyExchangeDeformatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RSAPKCS1KeyExchangeDeformatter : System.Security.Cryptography.AsymmetricKeyExchangeDeformatter
            {
                public override System.Byte[] DecryptKeyExchange(System.Byte[] rgbIn) => throw null;
                public override string Parameters { get => throw null; set => throw null; }
                public System.Security.Cryptography.RandomNumberGenerator RNG { get => throw null; set => throw null; }
                public RSAPKCS1KeyExchangeDeformatter() => throw null;
                public RSAPKCS1KeyExchangeDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            // Generated from `System.Security.Cryptography.RSAPKCS1KeyExchangeFormatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RSAPKCS1SignatureDeformatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RSAPKCS1SignatureDeformatter : System.Security.Cryptography.AsymmetricSignatureDeformatter
            {
                public RSAPKCS1SignatureDeformatter() => throw null;
                public RSAPKCS1SignatureDeformatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            // Generated from `System.Security.Cryptography.RSAPKCS1SignatureFormatter` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RSAPKCS1SignatureFormatter : System.Security.Cryptography.AsymmetricSignatureFormatter
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public RSAPKCS1SignatureFormatter() => throw null;
                public RSAPKCS1SignatureFormatter(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                public override void SetHashAlgorithm(string strName) => throw null;
                public override void SetKey(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
            }

            // Generated from `System.Security.Cryptography.RSAParameters` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RSASignaturePadding` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.RSASignaturePaddingMode` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum RSASignaturePaddingMode
            {
                Pkcs1,
                Pss,
            }

            // Generated from `System.Security.Cryptography.RandomNumberGenerator` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                public static int GetInt32(int toExclusive) => throw null;
                public static int GetInt32(int fromInclusive, int toExclusive) => throw null;
                public virtual void GetNonZeroBytes(System.Byte[] data) => throw null;
                public virtual void GetNonZeroBytes(System.Span<System.Byte> data) => throw null;
                protected RandomNumberGenerator() => throw null;
            }

            // Generated from `System.Security.Cryptography.Rfc2898DeriveBytes` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Rfc2898DeriveBytes : System.Security.Cryptography.DeriveBytes
            {
                public System.Byte[] CryptDeriveKey(string algname, string alghashname, int keySize, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Byte[] GetBytes(int cb) => throw null;
                public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                public int IterationCount { get => throw null; set => throw null; }
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

            // Generated from `System.Security.Cryptography.Rijndael` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class Rijndael : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.Rijndael Create() => throw null;
                public static System.Security.Cryptography.Rijndael Create(string algName) => throw null;
                protected Rijndael() => throw null;
            }

            // Generated from `System.Security.Cryptography.RijndaelManaged` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RijndaelManaged : System.Security.Cryptography.Rijndael
            {
                public override int BlockSize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateDecryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor() => throw null;
                public override System.Security.Cryptography.ICryptoTransform CreateEncryptor(System.Byte[] rgbKey, System.Byte[] rgbIV) => throw null;
                protected override void Dispose(bool disposing) => throw null;
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

            // Generated from `System.Security.Cryptography.SHA1` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SHA1 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA1 Create() => throw null;
                public static System.Security.Cryptography.SHA1 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                protected SHA1() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.SHA1Managed` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SHA256` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SHA256 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA256 Create() => throw null;
                public static System.Security.Cryptography.SHA256 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                protected SHA256() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.SHA256Managed` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SHA384` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SHA384 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA384 Create() => throw null;
                public static System.Security.Cryptography.SHA384 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                protected SHA384() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.SHA384Managed` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SHA512` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SHA512 : System.Security.Cryptography.HashAlgorithm
            {
                public static System.Security.Cryptography.SHA512 Create() => throw null;
                public static System.Security.Cryptography.SHA512 Create(string hashName) => throw null;
                public static System.Byte[] HashData(System.Byte[] source) => throw null;
                public static System.Byte[] HashData(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int HashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination) => throw null;
                protected SHA512() => throw null;
                public static bool TryHashData(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            }

            // Generated from `System.Security.Cryptography.SHA512Managed` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.SignatureDescription` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.Cryptography.TripleDES` in `System.Security.Cryptography.Algorithms, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class TripleDES : System.Security.Cryptography.SymmetricAlgorithm
            {
                public static System.Security.Cryptography.TripleDES Create() => throw null;
                public static System.Security.Cryptography.TripleDES Create(string str) => throw null;
                public static bool IsWeakKey(System.Byte[] rgbKey) => throw null;
                public override System.Byte[] Key { get => throw null; set => throw null; }
                protected TripleDES() => throw null;
            }

        }
    }
}
