// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafeX509ChainHandle` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            namespace X509Certificates
            {
                // Generated from `System.Security.Cryptography.X509Certificates.CertificateRequest` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class CertificateRequest
                {
                    public System.Collections.ObjectModel.Collection<System.Security.Cryptography.X509Certificates.X509Extension> CertificateExtensions { get => throw null; }
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.ECDsa key, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
                    public CertificateRequest(System.Security.Cryptography.X509Certificates.X500DistinguishedName subjectName, System.Security.Cryptography.X509Certificates.PublicKey publicKey, System.Security.Cryptography.HashAlgorithmName hashAlgorithm) => throw null;
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
                    public System.Security.Cryptography.HashAlgorithmName HashAlgorithm { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName SubjectName { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.X509Certificates.DSACertificateExtensions` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public static class DSACertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.DSA privateKey) => throw null;
                    public static System.Security.Cryptography.DSA GetDSAPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.DSA GetDSAPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.ECDsaCertificateExtensions` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public static class ECDsaCertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.ECDsa privateKey) => throw null;
                    public static System.Security.Cryptography.ECDsa GetECDsaPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.ECDsa GetECDsaPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.OpenFlags` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum OpenFlags : int
                {
                    IncludeArchived = 8,
                    MaxAllowed = 2,
                    OpenExistingOnly = 4,
                    ReadOnly = 0,
                    ReadWrite = 1,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.PublicKey` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.RSACertificateExtensions` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public static class RSACertificateExtensions
                {
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.RSA privateKey) => throw null;
                    public static System.Security.Cryptography.RSA GetRSAPrivateKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.RSA GetRSAPublicKey(this System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.StoreLocation` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum StoreLocation : int
                {
                    CurrentUser = 1,
                    LocalMachine = 2,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.StoreName` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.SubjectAlternativeNameBuilder` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X500DistinguishedName` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X500DistinguishedName : System.Security.Cryptography.AsnEncodedData
                {
                    public string Decode(System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags flag) => throw null;
                    public override string Format(bool multiLine) => throw null;
                    public string Name { get => throw null; }
                    public X500DistinguishedName(System.Security.Cryptography.AsnEncodedData encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.Byte[] encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.ReadOnlySpan<System.Byte> encodedDistinguishedName) => throw null;
                    public X500DistinguishedName(System.Security.Cryptography.X509Certificates.X500DistinguishedName distinguishedName) => throw null;
                    public X500DistinguishedName(string distinguishedName) => throw null;
                    public X500DistinguishedName(string distinguishedName, System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags flag) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X500DistinguishedNameFlags` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509BasicConstraintsExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public bool CertificateAuthority { get => throw null; }
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public bool HasPathLengthConstraint { get => throw null; }
                    public int PathLengthConstraint { get => throw null; }
                    public X509BasicConstraintsExtension() => throw null;
                    public X509BasicConstraintsExtension(System.Security.Cryptography.AsnEncodedData encodedBasicConstraints, bool critical) => throw null;
                    public X509BasicConstraintsExtension(bool certificateAuthority, bool hasPathLengthConstraint, int pathLengthConstraint, bool critical) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509Certificate` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509Certificate2` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509Certificate2 : System.Security.Cryptography.X509Certificates.X509Certificate
                {
                    public bool Archived { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 CopyWithPrivateKey(System.Security.Cryptography.ECDiffieHellman privateKey) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromEncryptedPem(System.ReadOnlySpan<System.Char> certPem, System.ReadOnlySpan<System.Char> keyPem, System.ReadOnlySpan<System.Char> password) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromEncryptedPemFile(string certPemFilePath, System.ReadOnlySpan<System.Char> password, string keyPemFilePath = default(string)) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPem(System.ReadOnlySpan<System.Char> certPem) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPem(System.ReadOnlySpan<System.Char> certPem, System.ReadOnlySpan<System.Char> keyPem) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2 CreateFromPemFile(string certPemFilePath, string keyPemFilePath = default(string)) => throw null;
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
                    public System.DateTime NotAfter { get => throw null; }
                    public System.DateTime NotBefore { get => throw null; }
                    public System.Security.Cryptography.AsymmetricAlgorithm PrivateKey { get => throw null; set => throw null; }
                    public System.Security.Cryptography.X509Certificates.PublicKey PublicKey { get => throw null; }
                    public System.Byte[] RawData { get => throw null; }
                    public override void Reset() => throw null;
                    public string SerialNumber { get => throw null; }
                    public System.Security.Cryptography.Oid SignatureAlgorithm { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X500DistinguishedName SubjectName { get => throw null; }
                    public string Thumbprint { get => throw null; }
                    public override string ToString() => throw null;
                    public override string ToString(bool verbose) => throw null;
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509Certificate2Collection` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509Certificate2Collection : System.Security.Cryptography.X509Certificates.X509CertificateCollection, System.Collections.Generic.IEnumerable<System.Security.Cryptography.X509Certificates.X509Certificate2>, System.Collections.IEnumerable
                {
                    public int Add(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public void AddRange(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                    public bool Contains(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType) => throw null;
                    public System.Byte[] Export(System.Security.Cryptography.X509Certificates.X509ContentType contentType, string password) => throw null;
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
                    public X509Certificate2Collection() => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public X509Certificate2Collection(System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509Certificate2Enumerator` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509CertificateCollection` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509CertificateCollection : System.Collections.CollectionBase
                {
                    // Generated from `System.Security.Cryptography.X509Certificates.X509CertificateCollection+X509CertificateEnumerator` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509Chain` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainElement` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509ChainElement
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509ChainStatus[] ChainElementStatus { get => throw null; }
                    public string Information { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainElementCollection` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainElementEnumerator` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509ChainElementEnumerator : System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509ChainElement>, System.Collections.IEnumerator, System.IDisposable
                {
                    public System.Security.Cryptography.X509Certificates.X509ChainElement Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainPolicy` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509ChainPolicy
                {
                    public System.Security.Cryptography.OidCollection ApplicationPolicy { get => throw null; }
                    public System.Security.Cryptography.OidCollection CertificatePolicy { get => throw null; }
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
                    public X509ChainPolicy() => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainStatus` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct X509ChainStatus
                {
                    public System.Security.Cryptography.X509Certificates.X509ChainStatusFlags Status { get => throw null; set => throw null; }
                    public string StatusInformation { get => throw null; set => throw null; }
                    // Stub generator skipped constructor 
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainStatusFlags` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509ChainTrustMode` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum X509ChainTrustMode : int
                {
                    CustomRootTrust = 1,
                    System = 0,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509ContentType` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509EnhancedKeyUsageExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Security.Cryptography.OidCollection EnhancedKeyUsages { get => throw null; }
                    public X509EnhancedKeyUsageExtension() => throw null;
                    public X509EnhancedKeyUsageExtension(System.Security.Cryptography.AsnEncodedData encodedEnhancedKeyUsages, bool critical) => throw null;
                    public X509EnhancedKeyUsageExtension(System.Security.Cryptography.OidCollection enhancedKeyUsages, bool critical) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509Extension` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509ExtensionCollection` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509ExtensionEnumerator` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509ExtensionEnumerator : System.Collections.Generic.IEnumerator<System.Security.Cryptography.X509Certificates.X509Extension>, System.Collections.IEnumerator, System.IDisposable
                {
                    public System.Security.Cryptography.X509Certificates.X509Extension Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509FindType` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509IncludeOption` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum X509IncludeOption : int
                {
                    EndCertOnly = 2,
                    ExcludeRoot = 1,
                    None = 0,
                    WholeChain = 3,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509KeyStorageFlags` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509KeyUsageExtension` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509KeyUsageExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509KeyUsageFlags KeyUsages { get => throw null; }
                    public X509KeyUsageExtension() => throw null;
                    public X509KeyUsageExtension(System.Security.Cryptography.AsnEncodedData encodedKeyUsage, bool critical) => throw null;
                    public X509KeyUsageExtension(System.Security.Cryptography.X509Certificates.X509KeyUsageFlags keyUsages, bool critical) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509KeyUsageFlags` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509NameType` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum X509NameType : int
                {
                    DnsFromAlternativeName = 4,
                    DnsName = 3,
                    EmailName = 1,
                    SimpleName = 0,
                    UpnName = 2,
                    UrlName = 5,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509RevocationFlag` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum X509RevocationFlag : int
                {
                    EndCertificateOnly = 0,
                    EntireChain = 1,
                    ExcludeRoot = 2,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509RevocationMode` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum X509RevocationMode : int
                {
                    NoCheck = 0,
                    Offline = 2,
                    Online = 1,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509SignatureGenerator` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509Store` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierExtension` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class X509SubjectKeyIdentifierExtension : System.Security.Cryptography.X509Certificates.X509Extension
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public string SubjectKeyIdentifier { get => throw null; }
                    public X509SubjectKeyIdentifierExtension() => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.AsnEncodedData encodedSubjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Byte[] subjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.X509Certificates.PublicKey key, System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierHashAlgorithm algorithm, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.Security.Cryptography.X509Certificates.PublicKey key, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(System.ReadOnlySpan<System.Byte> subjectKeyIdentifier, bool critical) => throw null;
                    public X509SubjectKeyIdentifierExtension(string subjectKeyIdentifier, bool critical) => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierHashAlgorithm` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum X509SubjectKeyIdentifierHashAlgorithm : int
                {
                    CapiSha1 = 2,
                    Sha1 = 0,
                    ShortSha1 = 1,
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509VerificationFlags` in `System.Security.Cryptography.X509Certificates, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
