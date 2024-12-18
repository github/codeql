// This file contains auto-generated code.
// Generated from `System.Security.Cryptography.Xml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            namespace Xml
            {
                public sealed class CipherData
                {
                    public System.Security.Cryptography.Xml.CipherReference CipherReference { get => throw null; set { } }
                    public byte[] CipherValue { get => throw null; set { } }
                    public CipherData() => throw null;
                    public CipherData(byte[] cipherValue) => throw null;
                    public CipherData(System.Security.Cryptography.Xml.CipherReference cipherReference) => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public sealed class CipherReference : System.Security.Cryptography.Xml.EncryptedReference
                {
                    public CipherReference() => throw null;
                    public CipherReference(string uri) => throw null;
                    public CipherReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public class DataObject
                {
                    public DataObject() => throw null;
                    public DataObject(string id, string mimeType, string encoding, System.Xml.XmlElement data) => throw null;
                    public System.Xml.XmlNodeList Data { get => throw null; set { } }
                    public string Encoding { get => throw null; set { } }
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set { } }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string MimeType { get => throw null; set { } }
                }
                public sealed class DataReference : System.Security.Cryptography.Xml.EncryptedReference
                {
                    public DataReference() => throw null;
                    public DataReference(string uri) => throw null;
                    public DataReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                }
                public class DSAKeyValue : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public DSAKeyValue() => throw null;
                    public DSAKeyValue(System.Security.Cryptography.DSA key) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public System.Security.Cryptography.DSA Key { get => throw null; set { } }
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public sealed class EncryptedData : System.Security.Cryptography.Xml.EncryptedType
                {
                    public EncryptedData() => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public sealed class EncryptedKey : System.Security.Cryptography.Xml.EncryptedType
                {
                    public void AddReference(System.Security.Cryptography.Xml.DataReference dataReference) => throw null;
                    public void AddReference(System.Security.Cryptography.Xml.KeyReference keyReference) => throw null;
                    public string CarriedKeyName { get => throw null; set { } }
                    public EncryptedKey() => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string Recipient { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.ReferenceList ReferenceList { get => throw null; }
                }
                public abstract class EncryptedReference
                {
                    public void AddTransform(System.Security.Cryptography.Xml.Transform transform) => throw null;
                    protected bool CacheValid { get => throw null; }
                    protected EncryptedReference() => throw null;
                    protected EncryptedReference(string uri) => throw null;
                    protected EncryptedReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                    public virtual System.Xml.XmlElement GetXml() => throw null;
                    public virtual void LoadXml(System.Xml.XmlElement value) => throw null;
                    protected string ReferenceType { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.TransformChain TransformChain { get => throw null; set { } }
                    public string Uri { get => throw null; set { } }
                }
                public abstract class EncryptedType
                {
                    public void AddProperty(System.Security.Cryptography.Xml.EncryptionProperty ep) => throw null;
                    public virtual System.Security.Cryptography.Xml.CipherData CipherData { get => throw null; set { } }
                    protected EncryptedType() => throw null;
                    public virtual string Encoding { get => throw null; set { } }
                    public virtual System.Security.Cryptography.Xml.EncryptionMethod EncryptionMethod { get => throw null; set { } }
                    public virtual System.Security.Cryptography.Xml.EncryptionPropertyCollection EncryptionProperties { get => throw null; }
                    public abstract System.Xml.XmlElement GetXml();
                    public virtual string Id { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.KeyInfo KeyInfo { get => throw null; set { } }
                    public abstract void LoadXml(System.Xml.XmlElement value);
                    public virtual string MimeType { get => throw null; set { } }
                    public virtual string Type { get => throw null; set { } }
                }
                public class EncryptedXml
                {
                    public void AddKeyNameMapping(string keyName, object keyObject) => throw null;
                    public void ClearKeyNameMappings() => throw null;
                    public EncryptedXml() => throw null;
                    public EncryptedXml(System.Xml.XmlDocument document) => throw null;
                    public EncryptedXml(System.Xml.XmlDocument document, System.Security.Policy.Evidence evidence) => throw null;
                    public byte[] DecryptData(System.Security.Cryptography.Xml.EncryptedData encryptedData, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public void DecryptDocument() => throw null;
                    public virtual byte[] DecryptEncryptedKey(System.Security.Cryptography.Xml.EncryptedKey encryptedKey) => throw null;
                    public static byte[] DecryptKey(byte[] keyData, System.Security.Cryptography.RSA rsa, bool useOAEP) => throw null;
                    public static byte[] DecryptKey(byte[] keyData, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public System.Security.Policy.Evidence DocumentEvidence { get => throw null; set { } }
                    public System.Text.Encoding Encoding { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.EncryptedData Encrypt(System.Xml.XmlElement inputElement, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Security.Cryptography.Xml.EncryptedData Encrypt(System.Xml.XmlElement inputElement, string keyName) => throw null;
                    public byte[] EncryptData(byte[] plaintext, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public byte[] EncryptData(System.Xml.XmlElement inputElement, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm, bool content) => throw null;
                    public static byte[] EncryptKey(byte[] keyData, System.Security.Cryptography.RSA rsa, bool useOAEP) => throw null;
                    public static byte[] EncryptKey(byte[] keyData, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public virtual byte[] GetDecryptionIV(System.Security.Cryptography.Xml.EncryptedData encryptedData, string symmetricAlgorithmUri) => throw null;
                    public virtual System.Security.Cryptography.SymmetricAlgorithm GetDecryptionKey(System.Security.Cryptography.Xml.EncryptedData encryptedData, string symmetricAlgorithmUri) => throw null;
                    public virtual System.Xml.XmlElement GetIdElement(System.Xml.XmlDocument document, string idValue) => throw null;
                    public System.Security.Cryptography.CipherMode Mode { get => throw null; set { } }
                    public System.Security.Cryptography.PaddingMode Padding { get => throw null; set { } }
                    public string Recipient { get => throw null; set { } }
                    public void ReplaceData(System.Xml.XmlElement inputElement, byte[] decryptedData) => throw null;
                    public static void ReplaceElement(System.Xml.XmlElement inputElement, System.Security.Cryptography.Xml.EncryptedData encryptedData, bool content) => throw null;
                    public System.Xml.XmlResolver Resolver { get => throw null; set { } }
                    public int XmlDSigSearchDepth { get => throw null; set { } }
                    public const string XmlEncAES128KeyWrapUrl = default;
                    public const string XmlEncAES128Url = default;
                    public const string XmlEncAES192KeyWrapUrl = default;
                    public const string XmlEncAES192Url = default;
                    public const string XmlEncAES256KeyWrapUrl = default;
                    public const string XmlEncAES256Url = default;
                    public const string XmlEncDESUrl = default;
                    public const string XmlEncElementContentUrl = default;
                    public const string XmlEncElementUrl = default;
                    public const string XmlEncEncryptedKeyUrl = default;
                    public const string XmlEncNamespaceUrl = default;
                    public const string XmlEncRSA15Url = default;
                    public const string XmlEncRSAOAEPUrl = default;
                    public const string XmlEncSHA256Url = default;
                    public const string XmlEncSHA512Url = default;
                    public const string XmlEncTripleDESKeyWrapUrl = default;
                    public const string XmlEncTripleDESUrl = default;
                }
                public class EncryptionMethod
                {
                    public EncryptionMethod() => throw null;
                    public EncryptionMethod(string algorithm) => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string KeyAlgorithm { get => throw null; set { } }
                    public int KeySize { get => throw null; set { } }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public sealed class EncryptionProperty
                {
                    public EncryptionProperty() => throw null;
                    public EncryptionProperty(System.Xml.XmlElement elementProperty) => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Xml.XmlElement PropertyElement { get => throw null; set { } }
                    public string Target { get => throw null; }
                }
                public sealed class EncryptionPropertyCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
                {
                    public int Add(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    int System.Collections.IList.Add(object value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    bool System.Collections.IList.Contains(object value) => throw null;
                    public void CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Security.Cryptography.Xml.EncryptionProperty[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public EncryptionPropertyCollection() => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public int IndexOf(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    int System.Collections.IList.IndexOf(object value) => throw null;
                    public void Insert(int index, System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    void System.Collections.IList.Insert(int index, object value) => throw null;
                    public bool IsFixedSize { get => throw null; }
                    public bool IsReadOnly { get => throw null; }
                    public bool IsSynchronized { get => throw null; }
                    public System.Security.Cryptography.Xml.EncryptionProperty Item(int index) => throw null;
                    object System.Collections.IList.this[int index] { get => throw null; set { } }
                    public void Remove(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    void System.Collections.IList.Remove(object value) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public object SyncRoot { get => throw null; }
                    [System.Runtime.CompilerServices.IndexerName("ItemOf")]
                    public System.Security.Cryptography.Xml.EncryptionProperty this[int index] { get => throw null; set { } }
                }
                public interface IRelDecryptor
                {
                    System.IO.Stream Decrypt(System.Security.Cryptography.Xml.EncryptionMethod encryptionMethod, System.Security.Cryptography.Xml.KeyInfo keyInfo, System.IO.Stream toDecrypt);
                }
                public class KeyInfo : System.Collections.IEnumerable
                {
                    public void AddClause(System.Security.Cryptography.Xml.KeyInfoClause clause) => throw null;
                    public int Count { get => throw null; }
                    public KeyInfo() => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public System.Collections.IEnumerator GetEnumerator(System.Type requestedObjectType) => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set { } }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public abstract class KeyInfoClause
                {
                    protected KeyInfoClause() => throw null;
                    public abstract System.Xml.XmlElement GetXml();
                    public abstract void LoadXml(System.Xml.XmlElement element);
                }
                public class KeyInfoEncryptedKey : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public KeyInfoEncryptedKey() => throw null;
                    public KeyInfoEncryptedKey(System.Security.Cryptography.Xml.EncryptedKey encryptedKey) => throw null;
                    public System.Security.Cryptography.Xml.EncryptedKey EncryptedKey { get => throw null; set { } }
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public class KeyInfoName : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public KeyInfoName() => throw null;
                    public KeyInfoName(string keyName) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string Value { get => throw null; set { } }
                }
                public class KeyInfoNode : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public KeyInfoNode() => throw null;
                    public KeyInfoNode(System.Xml.XmlElement node) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Xml.XmlElement Value { get => throw null; set { } }
                }
                public class KeyInfoRetrievalMethod : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public KeyInfoRetrievalMethod() => throw null;
                    public KeyInfoRetrievalMethod(string strUri) => throw null;
                    public KeyInfoRetrievalMethod(string strUri, string typeName) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string Type { get => throw null; set { } }
                    public string Uri { get => throw null; set { } }
                }
                public class KeyInfoX509Data : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public void AddCertificate(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                    public void AddIssuerSerial(string issuerName, string serialNumber) => throw null;
                    public void AddSubjectKeyId(byte[] subjectKeyId) => throw null;
                    public void AddSubjectKeyId(string subjectKeyId) => throw null;
                    public void AddSubjectName(string subjectName) => throw null;
                    public System.Collections.ArrayList Certificates { get => throw null; }
                    public byte[] CRL { get => throw null; set { } }
                    public KeyInfoX509Data() => throw null;
                    public KeyInfoX509Data(byte[] rgbCert) => throw null;
                    public KeyInfoX509Data(System.Security.Cryptography.X509Certificates.X509Certificate cert) => throw null;
                    public KeyInfoX509Data(System.Security.Cryptography.X509Certificates.X509Certificate cert, System.Security.Cryptography.X509Certificates.X509IncludeOption includeOption) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public System.Collections.ArrayList IssuerSerials { get => throw null; }
                    public override void LoadXml(System.Xml.XmlElement element) => throw null;
                    public System.Collections.ArrayList SubjectKeyIds { get => throw null; }
                    public System.Collections.ArrayList SubjectNames { get => throw null; }
                }
                public sealed class KeyReference : System.Security.Cryptography.Xml.EncryptedReference
                {
                    public KeyReference() => throw null;
                    public KeyReference(string uri) => throw null;
                    public KeyReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                }
                public class Reference
                {
                    public void AddTransform(System.Security.Cryptography.Xml.Transform transform) => throw null;
                    public Reference() => throw null;
                    public Reference(System.IO.Stream stream) => throw null;
                    public Reference(string uri) => throw null;
                    public string DigestMethod { get => throw null; set { } }
                    public byte[] DigestValue { get => throw null; set { } }
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set { } }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Security.Cryptography.Xml.TransformChain TransformChain { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                    public string Uri { get => throw null; set { } }
                }
                public sealed class ReferenceList : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
                {
                    public int Add(object value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(object value) => throw null;
                    public void CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public ReferenceList() => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public int IndexOf(object value) => throw null;
                    public void Insert(int index, object value) => throw null;
                    bool System.Collections.IList.IsFixedSize { get => throw null; }
                    bool System.Collections.IList.IsReadOnly { get => throw null; }
                    public bool IsSynchronized { get => throw null; }
                    public System.Security.Cryptography.Xml.EncryptedReference Item(int index) => throw null;
                    object System.Collections.IList.this[int index] { get => throw null; set { } }
                    public void Remove(object value) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public object SyncRoot { get => throw null; }
                    [System.Runtime.CompilerServices.IndexerName("ItemOf")]
                    public System.Security.Cryptography.Xml.EncryptedReference this[int index] { get => throw null; set { } }
                }
                public class RSAKeyValue : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public RSAKeyValue() => throw null;
                    public RSAKeyValue(System.Security.Cryptography.RSA key) => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public System.Security.Cryptography.RSA Key { get => throw null; set { } }
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }
                public class Signature
                {
                    public void AddObject(System.Security.Cryptography.Xml.DataObject dataObject) => throw null;
                    public Signature() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.KeyInfo KeyInfo { get => throw null; set { } }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Collections.IList ObjectList { get => throw null; set { } }
                    public byte[] SignatureValue { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.SignedInfo SignedInfo { get => throw null; set { } }
                }
                public class SignedInfo : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public void AddReference(System.Security.Cryptography.Xml.Reference reference) => throw null;
                    public string CanonicalizationMethod { get => throw null; set { } }
                    public System.Security.Cryptography.Xml.Transform CanonicalizationMethodObject { get => throw null; }
                    public void CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public SignedInfo() => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set { } }
                    public bool IsReadOnly { get => throw null; }
                    public bool IsSynchronized { get => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Collections.ArrayList References { get => throw null; }
                    public string SignatureLength { get => throw null; set { } }
                    public string SignatureMethod { get => throw null; set { } }
                    public object SyncRoot { get => throw null; }
                }
                public class SignedXml
                {
                    public void AddObject(System.Security.Cryptography.Xml.DataObject dataObject) => throw null;
                    public void AddReference(System.Security.Cryptography.Xml.Reference reference) => throw null;
                    public bool CheckSignature() => throw null;
                    public bool CheckSignature(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                    public bool CheckSignature(System.Security.Cryptography.KeyedHashAlgorithm macAlg) => throw null;
                    public bool CheckSignature(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool verifySignatureOnly) => throw null;
                    public bool CheckSignatureReturningKey(out System.Security.Cryptography.AsymmetricAlgorithm signingKey) => throw null;
                    public void ComputeSignature() => throw null;
                    public void ComputeSignature(System.Security.Cryptography.KeyedHashAlgorithm macAlg) => throw null;
                    public SignedXml() => throw null;
                    public SignedXml(System.Xml.XmlDocument document) => throw null;
                    public SignedXml(System.Xml.XmlElement elem) => throw null;
                    public System.Security.Cryptography.Xml.EncryptedXml EncryptedXml { get => throw null; set { } }
                    public virtual System.Xml.XmlElement GetIdElement(System.Xml.XmlDocument document, string idValue) => throw null;
                    protected virtual System.Security.Cryptography.AsymmetricAlgorithm GetPublicKey() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public System.Security.Cryptography.Xml.KeyInfo KeyInfo { get => throw null; set { } }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    protected System.Security.Cryptography.Xml.Signature m_signature;
                    protected string m_strSigningKeyName;
                    public System.Xml.XmlResolver Resolver { set { } }
                    public System.Collections.ObjectModel.Collection<string> SafeCanonicalizationMethods { get => throw null; }
                    public System.Security.Cryptography.Xml.Signature Signature { get => throw null; }
                    public System.Func<System.Security.Cryptography.Xml.SignedXml, bool> SignatureFormatValidator { get => throw null; set { } }
                    public string SignatureLength { get => throw null; }
                    public string SignatureMethod { get => throw null; }
                    public byte[] SignatureValue { get => throw null; }
                    public System.Security.Cryptography.Xml.SignedInfo SignedInfo { get => throw null; }
                    public System.Security.Cryptography.AsymmetricAlgorithm SigningKey { get => throw null; set { } }
                    public string SigningKeyName { get => throw null; set { } }
                    public const string XmlDecryptionTransformUrl = default;
                    public const string XmlDsigBase64TransformUrl = default;
                    public const string XmlDsigC14NTransformUrl = default;
                    public const string XmlDsigC14NWithCommentsTransformUrl = default;
                    public const string XmlDsigCanonicalizationUrl = default;
                    public const string XmlDsigCanonicalizationWithCommentsUrl = default;
                    public const string XmlDsigDSAUrl = default;
                    public const string XmlDsigEnvelopedSignatureTransformUrl = default;
                    public const string XmlDsigExcC14NTransformUrl = default;
                    public const string XmlDsigExcC14NWithCommentsTransformUrl = default;
                    public const string XmlDsigHMACSHA1Url = default;
                    public const string XmlDsigMinimalCanonicalizationUrl = default;
                    public const string XmlDsigNamespaceUrl = default;
                    public const string XmlDsigRSASHA1Url = default;
                    public const string XmlDsigRSASHA256Url = default;
                    public const string XmlDsigRSASHA384Url = default;
                    public const string XmlDsigRSASHA512Url = default;
                    public const string XmlDsigSHA1Url = default;
                    public const string XmlDsigSHA256Url = default;
                    public const string XmlDsigSHA384Url = default;
                    public const string XmlDsigSHA512Url = default;
                    public const string XmlDsigXPathTransformUrl = default;
                    public const string XmlDsigXsltTransformUrl = default;
                    public const string XmlLicenseTransformUrl = default;
                }
                public abstract class Transform
                {
                    public string Algorithm { get => throw null; set { } }
                    public System.Xml.XmlElement Context { get => throw null; set { } }
                    protected Transform() => throw null;
                    public virtual byte[] GetDigestedOutput(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                    protected abstract System.Xml.XmlNodeList GetInnerXml();
                    public abstract object GetOutput();
                    public abstract object GetOutput(System.Type type);
                    public System.Xml.XmlElement GetXml() => throw null;
                    public abstract System.Type[] InputTypes { get; }
                    public abstract void LoadInnerXml(System.Xml.XmlNodeList nodeList);
                    public abstract void LoadInput(object obj);
                    public abstract System.Type[] OutputTypes { get; }
                    public System.Collections.Hashtable PropagatedNamespaces { get => throw null; }
                    public System.Xml.XmlResolver Resolver { set { } }
                }
                public class TransformChain
                {
                    public void Add(System.Security.Cryptography.Xml.Transform transform) => throw null;
                    public int Count { get => throw null; }
                    public TransformChain() => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public System.Security.Cryptography.Xml.Transform this[int index] { get => throw null; }
                }
                public class XmlDecryptionTransform : System.Security.Cryptography.Xml.Transform
                {
                    public void AddExceptUri(string uri) => throw null;
                    public XmlDecryptionTransform() => throw null;
                    public System.Security.Cryptography.Xml.EncryptedXml EncryptedXml { get => throw null; set { } }
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    protected virtual bool IsTargetElement(System.Xml.XmlElement inputElement, string idValue) => throw null;
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlDsigBase64Transform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlDsigBase64Transform() => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlDsigC14NTransform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlDsigC14NTransform() => throw null;
                    public XmlDsigC14NTransform(bool includeComments) => throw null;
                    public override byte[] GetDigestedOutput(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlDsigC14NWithCommentsTransform : System.Security.Cryptography.Xml.XmlDsigC14NTransform
                {
                    public XmlDsigC14NWithCommentsTransform() => throw null;
                }
                public class XmlDsigEnvelopedSignatureTransform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlDsigEnvelopedSignatureTransform() => throw null;
                    public XmlDsigEnvelopedSignatureTransform(bool includeComments) => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlDsigExcC14NTransform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlDsigExcC14NTransform() => throw null;
                    public XmlDsigExcC14NTransform(bool includeComments) => throw null;
                    public XmlDsigExcC14NTransform(bool includeComments, string inclusiveNamespacesPrefixList) => throw null;
                    public XmlDsigExcC14NTransform(string inclusiveNamespacesPrefixList) => throw null;
                    public override byte[] GetDigestedOutput(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public string InclusiveNamespacesPrefixList { get => throw null; set { } }
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlDsigExcC14NWithCommentsTransform : System.Security.Cryptography.Xml.XmlDsigExcC14NTransform
                {
                    public XmlDsigExcC14NWithCommentsTransform() => throw null;
                    public XmlDsigExcC14NWithCommentsTransform(string inclusiveNamespacesPrefixList) => throw null;
                }
                public class XmlDsigXPathTransform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlDsigXPathTransform() => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlDsigXsltTransform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlDsigXsltTransform() => throw null;
                    public XmlDsigXsltTransform(bool includeComments) => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
                public class XmlLicenseTransform : System.Security.Cryptography.Xml.Transform
                {
                    public XmlLicenseTransform() => throw null;
                    public System.Security.Cryptography.Xml.IRelDecryptor Decryptor { get => throw null; set { } }
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                }
            }
        }
    }
}
