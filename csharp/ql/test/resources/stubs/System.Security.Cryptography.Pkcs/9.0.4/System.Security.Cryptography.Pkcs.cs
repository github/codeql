// This file contains auto-generated code.
// Generated from `System.Security.Cryptography.Pkcs, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            public sealed class CryptographicAttributeObject
            {
                public CryptographicAttributeObject(System.Security.Cryptography.Oid oid) => throw null;
                public CryptographicAttributeObject(System.Security.Cryptography.Oid oid, System.Security.Cryptography.AsnEncodedDataCollection values) => throw null;
                public System.Security.Cryptography.Oid Oid { get => throw null; }
                public System.Security.Cryptography.AsnEncodedDataCollection Values { get => throw null; }
            }
            public sealed class CryptographicAttributeObjectCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public int Add(System.Security.Cryptography.CryptographicAttributeObject attribute) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.Cryptography.CryptographicAttributeObject[] array, int index) => throw null;
                public int Count { get => throw null; }
                public CryptographicAttributeObjectCollection() => throw null;
                public CryptographicAttributeObjectCollection(System.Security.Cryptography.CryptographicAttributeObject attribute) => throw null;
                public System.Security.Cryptography.CryptographicAttributeObjectEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public void Remove(System.Security.Cryptography.CryptographicAttributeObject attribute) => throw null;
                public object SyncRoot { get => throw null; }
                public System.Security.Cryptography.CryptographicAttributeObject this[int index] { get => throw null; }
            }
            public sealed class CryptographicAttributeObjectEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.CryptographicAttributeObject Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            namespace Pkcs
            {
                public sealed class AlgorithmIdentifier
                {
                    public AlgorithmIdentifier() => throw null;
                    public AlgorithmIdentifier(System.Security.Cryptography.Oid oid) => throw null;
                    public AlgorithmIdentifier(System.Security.Cryptography.Oid oid, int keyLength) => throw null;
                    public int KeyLength { get => throw null; set { } }
                    public System.Security.Cryptography.Oid Oid { get => throw null; set { } }
                    public byte[] Parameters { get => throw null; set { } }
                }
                public sealed class CmsRecipient
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                    public CmsRecipient(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public CmsRecipient(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.RSAEncryptionPadding rsaEncryptionPadding) => throw null;
                    public CmsRecipient(System.Security.Cryptography.Pkcs.SubjectIdentifierType recipientIdentifierType, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.RSAEncryptionPadding rsaEncryptionPadding) => throw null;
                    public CmsRecipient(System.Security.Cryptography.Pkcs.SubjectIdentifierType recipientIdentifierType, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Security.Cryptography.Pkcs.SubjectIdentifierType RecipientIdentifierType { get => throw null; }
                    public System.Security.Cryptography.RSAEncryptionPadding RSAEncryptionPadding { get => throw null; }
                }
                public sealed class CmsRecipientCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public int Add(System.Security.Cryptography.Pkcs.CmsRecipient recipient) => throw null;
                    public void CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Security.Cryptography.Pkcs.CmsRecipient[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public CmsRecipientCollection() => throw null;
                    public CmsRecipientCollection(System.Security.Cryptography.Pkcs.CmsRecipient recipient) => throw null;
                    public CmsRecipientCollection(System.Security.Cryptography.Pkcs.SubjectIdentifierType recipientIdentifierType, System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates) => throw null;
                    public System.Security.Cryptography.Pkcs.CmsRecipientEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public void Remove(System.Security.Cryptography.Pkcs.CmsRecipient recipient) => throw null;
                    public object SyncRoot { get => throw null; }
                    public System.Security.Cryptography.Pkcs.CmsRecipient this[int index] { get => throw null; }
                }
                public sealed class CmsRecipientEnumerator : System.Collections.IEnumerator
                {
                    public System.Security.Cryptography.Pkcs.CmsRecipient Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public sealed class CmsSigner
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Certificates { get => throw null; }
                    public CmsSigner() => throw null;
                    public CmsSigner(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType) => throw null;
                    public CmsSigner(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public CmsSigner(System.Security.Cryptography.CspParameters parameters) => throw null;
                    public CmsSigner(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public CmsSigner(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.AsymmetricAlgorithm privateKey) => throw null;
                    public CmsSigner(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.RSA privateKey, System.Security.Cryptography.RSASignaturePadding signaturePadding) => throw null;
                    public System.Security.Cryptography.Oid DigestAlgorithm { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509IncludeOption IncludeOption { get => throw null; set { } }
                    public System.Security.Cryptography.AsymmetricAlgorithm PrivateKey { get => throw null; set { } }
                    public System.Security.Cryptography.RSASignaturePadding SignaturePadding { get => throw null; set { } }
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection SignedAttributes { get => throw null; }
                    public System.Security.Cryptography.Pkcs.SubjectIdentifierType SignerIdentifierType { get => throw null; set { } }
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection UnsignedAttributes { get => throw null; }
                }
                public sealed class ContentInfo
                {
                    public byte[] Content { get => throw null; }
                    public System.Security.Cryptography.Oid ContentType { get => throw null; }
                    public ContentInfo(byte[] content) => throw null;
                    public ContentInfo(System.Security.Cryptography.Oid contentType, byte[] content) => throw null;
                    public static System.Security.Cryptography.Oid GetContentType(byte[] encodedMessage) => throw null;
                    public static System.Security.Cryptography.Oid GetContentType(System.ReadOnlySpan<byte> encodedMessage) => throw null;
                }
                public sealed class EnvelopedCms
                {
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Certificates { get => throw null; }
                    public System.Security.Cryptography.Pkcs.AlgorithmIdentifier ContentEncryptionAlgorithm { get => throw null; }
                    public System.Security.Cryptography.Pkcs.ContentInfo ContentInfo { get => throw null; }
                    public EnvelopedCms() => throw null;
                    public EnvelopedCms(System.Security.Cryptography.Pkcs.ContentInfo contentInfo) => throw null;
                    public EnvelopedCms(System.Security.Cryptography.Pkcs.ContentInfo contentInfo, System.Security.Cryptography.Pkcs.AlgorithmIdentifier encryptionAlgorithm) => throw null;
                    public void Decode(byte[] encodedMessage) => throw null;
                    public void Decode(System.ReadOnlySpan<byte> encodedMessage) => throw null;
                    public void Decrypt() => throw null;
                    public void Decrypt(System.Security.Cryptography.Pkcs.RecipientInfo recipientInfo) => throw null;
                    public void Decrypt(System.Security.Cryptography.Pkcs.RecipientInfo recipientInfo, System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraStore) => throw null;
                    public void Decrypt(System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraStore) => throw null;
                    public void Decrypt(System.Security.Cryptography.Pkcs.RecipientInfo recipientInfo, System.Security.Cryptography.AsymmetricAlgorithm privateKey) => throw null;
                    public byte[] Encode() => throw null;
                    public void Encrypt(System.Security.Cryptography.Pkcs.CmsRecipient recipient) => throw null;
                    public void Encrypt(System.Security.Cryptography.Pkcs.CmsRecipientCollection recipients) => throw null;
                    public System.Security.Cryptography.Pkcs.RecipientInfoCollection RecipientInfos { get => throw null; }
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection UnprotectedAttributes { get => throw null; }
                    public int Version { get => throw null; }
                }
                public sealed class KeyAgreeRecipientInfo : System.Security.Cryptography.Pkcs.RecipientInfo
                {
                    public System.DateTime Date { get => throw null; }
                    public override byte[] EncryptedKey { get => throw null; }
                    public override System.Security.Cryptography.Pkcs.AlgorithmIdentifier KeyEncryptionAlgorithm { get => throw null; }
                    public System.Security.Cryptography.Pkcs.SubjectIdentifierOrKey OriginatorIdentifierOrKey { get => throw null; }
                    public System.Security.Cryptography.CryptographicAttributeObject OtherKeyAttribute { get => throw null; }
                    public override System.Security.Cryptography.Pkcs.SubjectIdentifier RecipientIdentifier { get => throw null; }
                    public override int Version { get => throw null; }
                }
                public sealed class KeyTransRecipientInfo : System.Security.Cryptography.Pkcs.RecipientInfo
                {
                    public override byte[] EncryptedKey { get => throw null; }
                    public override System.Security.Cryptography.Pkcs.AlgorithmIdentifier KeyEncryptionAlgorithm { get => throw null; }
                    public override System.Security.Cryptography.Pkcs.SubjectIdentifier RecipientIdentifier { get => throw null; }
                    public override int Version { get => throw null; }
                }
                public sealed class Pkcs12Builder
                {
                    public void AddSafeContentsEncrypted(System.Security.Cryptography.Pkcs.Pkcs12SafeContents safeContents, byte[] passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public void AddSafeContentsEncrypted(System.Security.Cryptography.Pkcs.Pkcs12SafeContents safeContents, System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public void AddSafeContentsEncrypted(System.Security.Cryptography.Pkcs.Pkcs12SafeContents safeContents, string password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public void AddSafeContentsEncrypted(System.Security.Cryptography.Pkcs.Pkcs12SafeContents safeContents, System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public void AddSafeContentsUnencrypted(System.Security.Cryptography.Pkcs.Pkcs12SafeContents safeContents) => throw null;
                    public Pkcs12Builder() => throw null;
                    public byte[] Encode() => throw null;
                    public bool IsSealed { get => throw null; }
                    public void SealWithMac(string password, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int iterationCount) => throw null;
                    public void SealWithMac(System.ReadOnlySpan<char> password, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, int iterationCount) => throw null;
                    public void SealWithoutIntegrity() => throw null;
                    public bool TryEncode(System.Span<byte> destination, out int bytesWritten) => throw null;
                }
                public sealed class Pkcs12CertBag : System.Security.Cryptography.Pkcs.Pkcs12SafeBag
                {
                    public Pkcs12CertBag(System.Security.Cryptography.Oid certificateType, System.ReadOnlyMemory<byte> encodedCertificate) : base(default(string), default(System.ReadOnlyMemory<byte>), default(bool)) => throw null;
                    public System.ReadOnlyMemory<byte> EncodedCertificate { get => throw null; }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 GetCertificate() => throw null;
                    public System.Security.Cryptography.Oid GetCertificateType() => throw null;
                    public bool IsX509Certificate { get => throw null; }
                }
                public enum Pkcs12ConfidentialityMode
                {
                    Unknown = 0,
                    None = 1,
                    Password = 2,
                    PublicKey = 3,
                }
                public sealed class Pkcs12Info
                {
                    public System.Collections.ObjectModel.ReadOnlyCollection<System.Security.Cryptography.Pkcs.Pkcs12SafeContents> AuthenticatedSafe { get => throw null; }
                    public static System.Security.Cryptography.Pkcs.Pkcs12Info Decode(System.ReadOnlyMemory<byte> encodedBytes, out int bytesConsumed, bool skipCopy = default(bool)) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12IntegrityMode IntegrityMode { get => throw null; }
                    public bool VerifyMac(string password) => throw null;
                    public bool VerifyMac(System.ReadOnlySpan<char> password) => throw null;
                }
                public enum Pkcs12IntegrityMode
                {
                    Unknown = 0,
                    None = 1,
                    Password = 2,
                    PublicKey = 3,
                }
                public sealed class Pkcs12KeyBag : System.Security.Cryptography.Pkcs.Pkcs12SafeBag
                {
                    public Pkcs12KeyBag(System.ReadOnlyMemory<byte> pkcs8PrivateKey, bool skipCopy = default(bool)) : base(default(string), default(System.ReadOnlyMemory<byte>), default(bool)) => throw null;
                    public System.ReadOnlyMemory<byte> Pkcs8PrivateKey { get => throw null; }
                }
                public abstract class Pkcs12SafeBag
                {
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection Attributes { get => throw null; }
                    protected Pkcs12SafeBag(string bagIdValue, System.ReadOnlyMemory<byte> encodedBagValue, bool skipCopy = default(bool)) => throw null;
                    public byte[] Encode() => throw null;
                    public System.ReadOnlyMemory<byte> EncodedBagValue { get => throw null; }
                    public System.Security.Cryptography.Oid GetBagId() => throw null;
                    public bool TryEncode(System.Span<byte> destination, out int bytesWritten) => throw null;
                }
                public sealed class Pkcs12SafeContents
                {
                    public System.Security.Cryptography.Pkcs.Pkcs12CertBag AddCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12KeyBag AddKeyUnencrypted(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12SafeContentsBag AddNestedContents(System.Security.Cryptography.Pkcs.Pkcs12SafeContents safeContents) => throw null;
                    public void AddSafeBag(System.Security.Cryptography.Pkcs.Pkcs12SafeBag safeBag) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12SecretBag AddSecret(System.Security.Cryptography.Oid secretType, System.ReadOnlyMemory<byte> secretValue) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12ShroudedKeyBag AddShroudedKey(System.Security.Cryptography.AsymmetricAlgorithm key, byte[] passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12ShroudedKeyBag AddShroudedKey(System.Security.Cryptography.AsymmetricAlgorithm key, System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12ShroudedKeyBag AddShroudedKey(System.Security.Cryptography.AsymmetricAlgorithm key, string password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12ShroudedKeyBag AddShroudedKey(System.Security.Cryptography.AsymmetricAlgorithm key, System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public System.Security.Cryptography.Pkcs.Pkcs12ConfidentialityMode ConfidentialityMode { get => throw null; }
                    public Pkcs12SafeContents() => throw null;
                    public void Decrypt(byte[] passwordBytes) => throw null;
                    public void Decrypt(System.ReadOnlySpan<byte> passwordBytes) => throw null;
                    public void Decrypt(string password) => throw null;
                    public void Decrypt(System.ReadOnlySpan<char> password) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Security.Cryptography.Pkcs.Pkcs12SafeBag> GetBags() => throw null;
                    public bool IsReadOnly { get => throw null; }
                }
                public sealed class Pkcs12SafeContentsBag : System.Security.Cryptography.Pkcs.Pkcs12SafeBag
                {
                    public System.Security.Cryptography.Pkcs.Pkcs12SafeContents SafeContents { get => throw null; }
                    internal Pkcs12SafeContentsBag() : base(default(string), default(System.ReadOnlyMemory<byte>), default(bool)) { }
                }
                public sealed class Pkcs12SecretBag : System.Security.Cryptography.Pkcs.Pkcs12SafeBag
                {
                    public System.Security.Cryptography.Oid GetSecretType() => throw null;
                    public System.ReadOnlyMemory<byte> SecretValue { get => throw null; }
                    internal Pkcs12SecretBag() : base(default(string), default(System.ReadOnlyMemory<byte>), default(bool)) { }
                }
                public sealed class Pkcs12ShroudedKeyBag : System.Security.Cryptography.Pkcs.Pkcs12SafeBag
                {
                    public Pkcs12ShroudedKeyBag(System.ReadOnlyMemory<byte> encryptedPkcs8PrivateKey, bool skipCopy = default(bool)) : base(default(string), default(System.ReadOnlyMemory<byte>), default(bool)) => throw null;
                    public System.ReadOnlyMemory<byte> EncryptedPkcs8PrivateKey { get => throw null; }
                }
                public sealed class Pkcs8PrivateKeyInfo
                {
                    public System.Security.Cryptography.Oid AlgorithmId { get => throw null; }
                    public System.ReadOnlyMemory<byte>? AlgorithmParameters { get => throw null; }
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection Attributes { get => throw null; }
                    public static System.Security.Cryptography.Pkcs.Pkcs8PrivateKeyInfo Create(System.Security.Cryptography.AsymmetricAlgorithm privateKey) => throw null;
                    public Pkcs8PrivateKeyInfo(System.Security.Cryptography.Oid algorithmId, System.ReadOnlyMemory<byte>? algorithmParameters, System.ReadOnlyMemory<byte> privateKey, bool skipCopies = default(bool)) => throw null;
                    public static System.Security.Cryptography.Pkcs.Pkcs8PrivateKeyInfo Decode(System.ReadOnlyMemory<byte> source, out int bytesRead, bool skipCopy = default(bool)) => throw null;
                    public static System.Security.Cryptography.Pkcs.Pkcs8PrivateKeyInfo DecryptAndDecode(System.ReadOnlySpan<char> password, System.ReadOnlyMemory<byte> source, out int bytesRead) => throw null;
                    public static System.Security.Cryptography.Pkcs.Pkcs8PrivateKeyInfo DecryptAndDecode(System.ReadOnlySpan<byte> passwordBytes, System.ReadOnlyMemory<byte> source, out int bytesRead) => throw null;
                    public byte[] Encode() => throw null;
                    public byte[] Encrypt(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public byte[] Encrypt(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters) => throw null;
                    public System.ReadOnlyMemory<byte> PrivateKeyBytes { get => throw null; }
                    public bool TryEncode(System.Span<byte> destination, out int bytesWritten) => throw null;
                    public bool TryEncrypt(System.ReadOnlySpan<char> password, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                    public bool TryEncrypt(System.ReadOnlySpan<byte> passwordBytes, System.Security.Cryptography.PbeParameters pbeParameters, System.Span<byte> destination, out int bytesWritten) => throw null;
                }
                public class Pkcs9AttributeObject : System.Security.Cryptography.AsnEncodedData
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9AttributeObject() => throw null;
                    public Pkcs9AttributeObject(string oid, byte[] encodedData) => throw null;
                    public Pkcs9AttributeObject(System.Security.Cryptography.Oid oid, byte[] encodedData) => throw null;
                    public Pkcs9AttributeObject(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public System.Security.Cryptography.Oid Oid { get => throw null; }
                }
                public sealed class Pkcs9ContentType : System.Security.Cryptography.Pkcs.Pkcs9AttributeObject
                {
                    public System.Security.Cryptography.Oid ContentType { get => throw null; }
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9ContentType() => throw null;
                }
                public sealed class Pkcs9DocumentDescription : System.Security.Cryptography.Pkcs.Pkcs9AttributeObject
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9DocumentDescription() => throw null;
                    public Pkcs9DocumentDescription(string documentDescription) => throw null;
                    public Pkcs9DocumentDescription(byte[] encodedDocumentDescription) => throw null;
                    public string DocumentDescription { get => throw null; }
                }
                public sealed class Pkcs9DocumentName : System.Security.Cryptography.Pkcs.Pkcs9AttributeObject
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9DocumentName() => throw null;
                    public Pkcs9DocumentName(string documentName) => throw null;
                    public Pkcs9DocumentName(byte[] encodedDocumentName) => throw null;
                    public string DocumentName { get => throw null; }
                }
                public sealed class Pkcs9LocalKeyId : System.Security.Cryptography.Pkcs.Pkcs9AttributeObject
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9LocalKeyId() => throw null;
                    public Pkcs9LocalKeyId(byte[] keyId) => throw null;
                    public Pkcs9LocalKeyId(System.ReadOnlySpan<byte> keyId) => throw null;
                    public System.ReadOnlyMemory<byte> KeyId { get => throw null; }
                }
                public sealed class Pkcs9MessageDigest : System.Security.Cryptography.Pkcs.Pkcs9AttributeObject
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9MessageDigest() => throw null;
                    public byte[] MessageDigest { get => throw null; }
                }
                public sealed class Pkcs9SigningTime : System.Security.Cryptography.Pkcs.Pkcs9AttributeObject
                {
                    public override void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                    public Pkcs9SigningTime() => throw null;
                    public Pkcs9SigningTime(System.DateTime signingTime) => throw null;
                    public Pkcs9SigningTime(byte[] encodedSigningTime) => throw null;
                    public System.DateTime SigningTime { get => throw null; }
                }
                public sealed class PublicKeyInfo
                {
                    public System.Security.Cryptography.Pkcs.AlgorithmIdentifier Algorithm { get => throw null; }
                    public byte[] KeyValue { get => throw null; }
                }
                public abstract class RecipientInfo
                {
                    public abstract byte[] EncryptedKey { get; }
                    public abstract System.Security.Cryptography.Pkcs.AlgorithmIdentifier KeyEncryptionAlgorithm { get; }
                    public abstract System.Security.Cryptography.Pkcs.SubjectIdentifier RecipientIdentifier { get; }
                    public System.Security.Cryptography.Pkcs.RecipientInfoType Type { get => throw null; }
                    public abstract int Version { get; }
                }
                public sealed class RecipientInfoCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public void CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Security.Cryptography.Pkcs.RecipientInfo[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Security.Cryptography.Pkcs.RecipientInfoEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public object SyncRoot { get => throw null; }
                    public System.Security.Cryptography.Pkcs.RecipientInfo this[int index] { get => throw null; }
                }
                public sealed class RecipientInfoEnumerator : System.Collections.IEnumerator
                {
                    public System.Security.Cryptography.Pkcs.RecipientInfo Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public enum RecipientInfoType
                {
                    Unknown = 0,
                    KeyTransport = 1,
                    KeyAgreement = 2,
                }
                public sealed class Rfc3161TimestampRequest
                {
                    public static System.Security.Cryptography.Pkcs.Rfc3161TimestampRequest CreateFromData(System.ReadOnlySpan<byte> data, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.Oid requestedPolicyId = default(System.Security.Cryptography.Oid), System.ReadOnlyMemory<byte>? nonce = default(System.ReadOnlyMemory<byte>?), bool requestSignerCertificates = default(bool), System.Security.Cryptography.X509Certificates.X509ExtensionCollection extensions = default(System.Security.Cryptography.X509Certificates.X509ExtensionCollection)) => throw null;
                    public static System.Security.Cryptography.Pkcs.Rfc3161TimestampRequest CreateFromHash(System.ReadOnlyMemory<byte> hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.Oid requestedPolicyId = default(System.Security.Cryptography.Oid), System.ReadOnlyMemory<byte>? nonce = default(System.ReadOnlyMemory<byte>?), bool requestSignerCertificates = default(bool), System.Security.Cryptography.X509Certificates.X509ExtensionCollection extensions = default(System.Security.Cryptography.X509Certificates.X509ExtensionCollection)) => throw null;
                    public static System.Security.Cryptography.Pkcs.Rfc3161TimestampRequest CreateFromHash(System.ReadOnlyMemory<byte> hash, System.Security.Cryptography.Oid hashAlgorithmId, System.Security.Cryptography.Oid requestedPolicyId = default(System.Security.Cryptography.Oid), System.ReadOnlyMemory<byte>? nonce = default(System.ReadOnlyMemory<byte>?), bool requestSignerCertificates = default(bool), System.Security.Cryptography.X509Certificates.X509ExtensionCollection extensions = default(System.Security.Cryptography.X509Certificates.X509ExtensionCollection)) => throw null;
                    public static System.Security.Cryptography.Pkcs.Rfc3161TimestampRequest CreateFromSignerInfo(System.Security.Cryptography.Pkcs.SignerInfo signerInfo, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, System.Security.Cryptography.Oid requestedPolicyId = default(System.Security.Cryptography.Oid), System.ReadOnlyMemory<byte>? nonce = default(System.ReadOnlyMemory<byte>?), bool requestSignerCertificates = default(bool), System.Security.Cryptography.X509Certificates.X509ExtensionCollection extensions = default(System.Security.Cryptography.X509Certificates.X509ExtensionCollection)) => throw null;
                    public byte[] Encode() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509ExtensionCollection GetExtensions() => throw null;
                    public System.ReadOnlyMemory<byte> GetMessageHash() => throw null;
                    public System.ReadOnlyMemory<byte>? GetNonce() => throw null;
                    public bool HasExtensions { get => throw null; }
                    public System.Security.Cryptography.Oid HashAlgorithmId { get => throw null; }
                    public System.Security.Cryptography.Pkcs.Rfc3161TimestampToken ProcessResponse(System.ReadOnlyMemory<byte> responseBytes, out int bytesConsumed) => throw null;
                    public System.Security.Cryptography.Oid RequestedPolicyId { get => throw null; }
                    public bool RequestSignerCertificate { get => throw null; }
                    public static bool TryDecode(System.ReadOnlyMemory<byte> encodedBytes, out System.Security.Cryptography.Pkcs.Rfc3161TimestampRequest request, out int bytesConsumed) => throw null;
                    public bool TryEncode(System.Span<byte> destination, out int bytesWritten) => throw null;
                    public int Version { get => throw null; }
                }
                public sealed class Rfc3161TimestampToken
                {
                    public System.Security.Cryptography.Pkcs.SignedCms AsSignedCms() => throw null;
                    public System.Security.Cryptography.Pkcs.Rfc3161TimestampTokenInfo TokenInfo { get => throw null; }
                    public static bool TryDecode(System.ReadOnlyMemory<byte> encodedBytes, out System.Security.Cryptography.Pkcs.Rfc3161TimestampToken token, out int bytesConsumed) => throw null;
                    public bool VerifySignatureForData(System.ReadOnlySpan<byte> data, out System.Security.Cryptography.X509Certificates.X509Certificate2 signerCertificate, System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraCandidates = default(System.Security.Cryptography.X509Certificates.X509Certificate2Collection)) => throw null;
                    public bool VerifySignatureForHash(System.ReadOnlySpan<byte> hash, System.Security.Cryptography.HashAlgorithmName hashAlgorithm, out System.Security.Cryptography.X509Certificates.X509Certificate2 signerCertificate, System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraCandidates = default(System.Security.Cryptography.X509Certificates.X509Certificate2Collection)) => throw null;
                    public bool VerifySignatureForHash(System.ReadOnlySpan<byte> hash, System.Security.Cryptography.Oid hashAlgorithmId, out System.Security.Cryptography.X509Certificates.X509Certificate2 signerCertificate, System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraCandidates = default(System.Security.Cryptography.X509Certificates.X509Certificate2Collection)) => throw null;
                    public bool VerifySignatureForSignerInfo(System.Security.Cryptography.Pkcs.SignerInfo signerInfo, out System.Security.Cryptography.X509Certificates.X509Certificate2 signerCertificate, System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraCandidates = default(System.Security.Cryptography.X509Certificates.X509Certificate2Collection)) => throw null;
                }
                public sealed class Rfc3161TimestampTokenInfo
                {
                    public long? AccuracyInMicroseconds { get => throw null; }
                    public Rfc3161TimestampTokenInfo(System.Security.Cryptography.Oid policyId, System.Security.Cryptography.Oid hashAlgorithmId, System.ReadOnlyMemory<byte> messageHash, System.ReadOnlyMemory<byte> serialNumber, System.DateTimeOffset timestamp, long? accuracyInMicroseconds = default(long?), bool isOrdering = default(bool), System.ReadOnlyMemory<byte>? nonce = default(System.ReadOnlyMemory<byte>?), System.ReadOnlyMemory<byte>? timestampAuthorityName = default(System.ReadOnlyMemory<byte>?), System.Security.Cryptography.X509Certificates.X509ExtensionCollection extensions = default(System.Security.Cryptography.X509Certificates.X509ExtensionCollection)) => throw null;
                    public byte[] Encode() => throw null;
                    public System.Security.Cryptography.X509Certificates.X509ExtensionCollection GetExtensions() => throw null;
                    public System.ReadOnlyMemory<byte> GetMessageHash() => throw null;
                    public System.ReadOnlyMemory<byte>? GetNonce() => throw null;
                    public System.ReadOnlyMemory<byte> GetSerialNumber() => throw null;
                    public System.ReadOnlyMemory<byte>? GetTimestampAuthorityName() => throw null;
                    public bool HasExtensions { get => throw null; }
                    public System.Security.Cryptography.Oid HashAlgorithmId { get => throw null; }
                    public bool IsOrdering { get => throw null; }
                    public System.Security.Cryptography.Oid PolicyId { get => throw null; }
                    public System.DateTimeOffset Timestamp { get => throw null; }
                    public static bool TryDecode(System.ReadOnlyMemory<byte> encodedBytes, out System.Security.Cryptography.Pkcs.Rfc3161TimestampTokenInfo timestampTokenInfo, out int bytesConsumed) => throw null;
                    public bool TryEncode(System.Span<byte> destination, out int bytesWritten) => throw null;
                    public int Version { get => throw null; }
                }
                public sealed class SignedCms
                {
                    public void AddCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2Collection Certificates { get => throw null; }
                    public void CheckHash() => throw null;
                    public void CheckSignature(bool verifySignatureOnly) => throw null;
                    public void CheckSignature(System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraStore, bool verifySignatureOnly) => throw null;
                    public void ComputeSignature() => throw null;
                    public void ComputeSignature(System.Security.Cryptography.Pkcs.CmsSigner signer) => throw null;
                    public void ComputeSignature(System.Security.Cryptography.Pkcs.CmsSigner signer, bool silent) => throw null;
                    public System.Security.Cryptography.Pkcs.ContentInfo ContentInfo { get => throw null; }
                    public SignedCms(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType, System.Security.Cryptography.Pkcs.ContentInfo contentInfo, bool detached) => throw null;
                    public SignedCms() => throw null;
                    public SignedCms(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType) => throw null;
                    public SignedCms(System.Security.Cryptography.Pkcs.ContentInfo contentInfo) => throw null;
                    public SignedCms(System.Security.Cryptography.Pkcs.SubjectIdentifierType signerIdentifierType, System.Security.Cryptography.Pkcs.ContentInfo contentInfo) => throw null;
                    public SignedCms(System.Security.Cryptography.Pkcs.ContentInfo contentInfo, bool detached) => throw null;
                    public void Decode(byte[] encodedMessage) => throw null;
                    public void Decode(System.ReadOnlySpan<byte> encodedMessage) => throw null;
                    public bool Detached { get => throw null; }
                    public byte[] Encode() => throw null;
                    public void RemoveCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public void RemoveSignature(int index) => throw null;
                    public void RemoveSignature(System.Security.Cryptography.Pkcs.SignerInfo signerInfo) => throw null;
                    public System.Security.Cryptography.Pkcs.SignerInfoCollection SignerInfos { get => throw null; }
                    public int Version { get => throw null; }
                }
                public sealed class SignerInfo
                {
                    public void AddUnsignedAttribute(System.Security.Cryptography.AsnEncodedData unsignedAttribute) => throw null;
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                    public void CheckHash() => throw null;
                    public void CheckSignature(bool verifySignatureOnly) => throw null;
                    public void CheckSignature(System.Security.Cryptography.X509Certificates.X509Certificate2Collection extraStore, bool verifySignatureOnly) => throw null;
                    public void ComputeCounterSignature() => throw null;
                    public void ComputeCounterSignature(System.Security.Cryptography.Pkcs.CmsSigner signer) => throw null;
                    public System.Security.Cryptography.Pkcs.SignerInfoCollection CounterSignerInfos { get => throw null; }
                    public System.Security.Cryptography.Oid DigestAlgorithm { get => throw null; }
                    public byte[] GetSignature() => throw null;
                    public void RemoveCounterSignature(int index) => throw null;
                    public void RemoveCounterSignature(System.Security.Cryptography.Pkcs.SignerInfo counterSignerInfo) => throw null;
                    public void RemoveUnsignedAttribute(System.Security.Cryptography.AsnEncodedData unsignedAttribute) => throw null;
                    public System.Security.Cryptography.Oid SignatureAlgorithm { get => throw null; }
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection SignedAttributes { get => throw null; }
                    public System.Security.Cryptography.Pkcs.SubjectIdentifier SignerIdentifier { get => throw null; }
                    public System.Security.Cryptography.CryptographicAttributeObjectCollection UnsignedAttributes { get => throw null; }
                    public int Version { get => throw null; }
                }
                public sealed class SignerInfoCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public void CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Security.Cryptography.Pkcs.SignerInfo[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Security.Cryptography.Pkcs.SignerInfoEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsSynchronized { get => throw null; }
                    public object SyncRoot { get => throw null; }
                    public System.Security.Cryptography.Pkcs.SignerInfo this[int index] { get => throw null; }
                }
                public sealed class SignerInfoEnumerator : System.Collections.IEnumerator
                {
                    public System.Security.Cryptography.Pkcs.SignerInfo Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public sealed class SubjectIdentifier
                {
                    public bool MatchesCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Security.Cryptography.Pkcs.SubjectIdentifierType Type { get => throw null; }
                    public object Value { get => throw null; }
                }
                public sealed class SubjectIdentifierOrKey
                {
                    public System.Security.Cryptography.Pkcs.SubjectIdentifierOrKeyType Type { get => throw null; }
                    public object Value { get => throw null; }
                }
                public enum SubjectIdentifierOrKeyType
                {
                    Unknown = 0,
                    IssuerAndSerialNumber = 1,
                    SubjectKeyIdentifier = 2,
                    PublicKeyInfo = 3,
                }
                public enum SubjectIdentifierType
                {
                    Unknown = 0,
                    IssuerAndSerialNumber = 1,
                    SubjectKeyIdentifier = 2,
                    NoSignature = 3,
                }
            }
            namespace Xml
            {
                public struct X509IssuerSerial
                {
                    public string IssuerName { get => throw null; set { } }
                    public string SerialNumber { get => throw null; set { } }
                }
            }
        }
    }
}
