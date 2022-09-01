// This file contains auto-generated code.

namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.DSAOpenSsl` in `System.Security.Cryptography.OpenSsl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DSAOpenSsl : System.Security.Cryptography.DSA
            {
                public override System.Byte[] CreateSignature(System.Byte[] rgbHash) => throw null;
                public DSAOpenSsl() => throw null;
                public DSAOpenSsl(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public DSAOpenSsl(System.IntPtr handle) => throw null;
                public DSAOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public DSAOpenSsl(int keySize) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Security.Cryptography.DSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportParameters(System.Security.Cryptography.DSAParameters parameters) => throw null;
                public override int KeySize { set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override bool VerifySignature(System.Byte[] rgbHash, System.Byte[] rgbSignature) => throw null;
            }

            // Generated from `System.Security.Cryptography.ECDiffieHellmanOpenSsl` in `System.Security.Cryptography.OpenSsl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ECDiffieHellmanOpenSsl : System.Security.Cryptography.ECDiffieHellman
            {
                public override System.Byte[] DeriveKeyFromHash(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public override System.Byte[] DeriveKeyFromHmac(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Byte[] hmacKey, System.Byte[] secretPrepend, System.Byte[] secretAppend) => throw null;
                public override System.Byte[] DeriveKeyMaterial(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey) => throw null;
                public override System.Byte[] DeriveKeyTls(System.Security.Cryptography.ECDiffieHellmanPublicKey otherPartyPublicKey, System.Byte[] prfLabel, System.Byte[] prfSeed) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public ECDiffieHellmanOpenSsl() => throw null;
                public ECDiffieHellmanOpenSsl(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDiffieHellmanOpenSsl(System.IntPtr handle) => throw null;
                public ECDiffieHellmanOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public ECDiffieHellmanOpenSsl(int keySize) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override System.Security.Cryptography.ECDiffieHellmanPublicKey PublicKey { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.ECDsaOpenSsl` in `System.Security.Cryptography.OpenSsl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ECDsaOpenSsl : System.Security.Cryptography.ECDsa
            {
                protected override void Dispose(bool disposing) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public ECDsaOpenSsl() => throw null;
                public ECDsaOpenSsl(System.Security.Cryptography.ECCurve curve) => throw null;
                public ECDsaOpenSsl(System.IntPtr handle) => throw null;
                public ECDsaOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public ECDsaOpenSsl(int keySize) => throw null;
                public override System.Security.Cryptography.ECParameters ExportExplicitParameters(bool includePrivateParameters) => throw null;
                public override System.Security.Cryptography.ECParameters ExportParameters(bool includePrivateParameters) => throw null;
                public override void GenerateKey(System.Security.Cryptography.ECCurve curve) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportParameters(System.Security.Cryptography.ECParameters parameters) => throw null;
                public override int KeySize { get => throw null; set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public override System.Byte[] SignHash(System.Byte[] hash) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature) => throw null;
            }

            // Generated from `System.Security.Cryptography.RSAOpenSsl` in `System.Security.Cryptography.OpenSsl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RSAOpenSsl : System.Security.Cryptography.RSA
            {
                public override System.Byte[] Decrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateKeyHandle() => throw null;
                public override System.Byte[] Encrypt(System.Byte[] data, System.Security.Cryptography.RSAEncryptionPadding padding) => throw null;
                public override System.Security.Cryptography.RSAParameters ExportParameters(bool includePrivateParameters) => throw null;
                protected override System.Byte[] HashData(System.Byte[] data, int offset, int count, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                protected override System.Byte[] HashData(System.IO.Stream data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                public override void ImportParameters(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public override int KeySize { set => throw null; }
                public override System.Security.Cryptography.KeySizes[] LegalKeySizes { get => throw null; }
                public RSAOpenSsl() => throw null;
                public RSAOpenSsl(System.IntPtr handle) => throw null;
                public RSAOpenSsl(System.Security.Cryptography.RSAParameters parameters) => throw null;
                public RSAOpenSsl(System.Security.Cryptography.SafeEvpPKeyHandle pkeyHandle) => throw null;
                public RSAOpenSsl(int keySize) => throw null;
                public override System.Byte[] SignHash(System.Byte[] hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
                public override bool VerifyHash(System.Byte[] hash, System.Byte[] signature, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.RSASignaturePadding padding) => throw null;
            }

            // Generated from `System.Security.Cryptography.SafeEvpPKeyHandle` in `System.Security.Cryptography.OpenSsl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeEvpPKeyHandle : System.Runtime.InteropServices.SafeHandle
            {
                public System.Security.Cryptography.SafeEvpPKeyHandle DuplicateHandle() => throw null;
                public override bool IsInvalid { get => throw null; }
                public static System.Int64 OpenSslVersion { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafeEvpPKeyHandle() : base(default(System.IntPtr), default(bool)) => throw null;
                public SafeEvpPKeyHandle(System.IntPtr handle, bool ownsHandle) : base(default(System.IntPtr), default(bool)) => throw null;
            }

        }
    }
}
