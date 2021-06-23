// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
    namespace Security
    {
        namespace Cryptography
        {
            namespace Xml
            {
                // Generated from `System.Security.Cryptography.Xml.CipherData` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class CipherData
                {
                    public CipherData(System.Security.Cryptography.Xml.CipherReference cipherReference) => throw null;
                    public CipherData(System.Byte[] cipherValue) => throw null;
                    public CipherData() => throw null;
                    public System.Security.Cryptography.Xml.CipherReference CipherReference { get => throw null; set => throw null; }
                    public System.Byte[] CipherValue { get => throw null; set => throw null; }
                    public System.Xml.XmlElement GetXml() => throw null;
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.CipherReference` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class CipherReference : System.Security.Cryptography.Xml.EncryptedReference
                {
                    public CipherReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                    public CipherReference(string uri) => throw null;
                    public CipherReference() => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.DSAKeyValue` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class DSAKeyValue : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public DSAKeyValue(System.Security.Cryptography.DSA key) => throw null;
                    public DSAKeyValue() => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public System.Security.Cryptography.DSA Key { get => throw null; set => throw null; }
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.DataObject` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class DataObject
                {
                    public System.Xml.XmlNodeList Data { get => throw null; set => throw null; }
                    public DataObject(string id, string mimeType, string encoding, System.Xml.XmlElement data) => throw null;
                    public DataObject() => throw null;
                    public string Encoding { get => throw null; set => throw null; }
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string MimeType { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.DataReference` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class DataReference : System.Security.Cryptography.Xml.EncryptedReference
                {
                    public DataReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                    public DataReference(string uri) => throw null;
                    public DataReference() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptedData` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EncryptedData : System.Security.Cryptography.Xml.EncryptedType
                {
                    public EncryptedData() => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptedKey` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EncryptedKey : System.Security.Cryptography.Xml.EncryptedType
                {
                    public void AddReference(System.Security.Cryptography.Xml.KeyReference keyReference) => throw null;
                    public void AddReference(System.Security.Cryptography.Xml.DataReference dataReference) => throw null;
                    public string CarriedKeyName { get => throw null; set => throw null; }
                    public EncryptedKey() => throw null;
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string Recipient { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.ReferenceList ReferenceList { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptedReference` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class EncryptedReference
                {
                    public void AddTransform(System.Security.Cryptography.Xml.Transform transform) => throw null;
                    protected internal bool CacheValid { get => throw null; }
                    protected EncryptedReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                    protected EncryptedReference(string uri) => throw null;
                    protected EncryptedReference() => throw null;
                    public virtual System.Xml.XmlElement GetXml() => throw null;
                    public virtual void LoadXml(System.Xml.XmlElement value) => throw null;
                    protected string ReferenceType { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.TransformChain TransformChain { get => throw null; set => throw null; }
                    public string Uri { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptedType` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class EncryptedType
                {
                    public void AddProperty(System.Security.Cryptography.Xml.EncryptionProperty ep) => throw null;
                    public virtual System.Security.Cryptography.Xml.CipherData CipherData { get => throw null; set => throw null; }
                    public virtual string Encoding { get => throw null; set => throw null; }
                    protected EncryptedType() => throw null;
                    public virtual System.Security.Cryptography.Xml.EncryptionMethod EncryptionMethod { get => throw null; set => throw null; }
                    public virtual System.Security.Cryptography.Xml.EncryptionPropertyCollection EncryptionProperties { get => throw null; }
                    public abstract System.Xml.XmlElement GetXml();
                    public virtual string Id { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.KeyInfo KeyInfo { get => throw null; set => throw null; }
                    public abstract void LoadXml(System.Xml.XmlElement value);
                    public virtual string MimeType { get => throw null; set => throw null; }
                    public virtual string Type { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptedXml` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EncryptedXml
                {
                    public void AddKeyNameMapping(string keyName, object keyObject) => throw null;
                    public void ClearKeyNameMappings() => throw null;
                    public System.Byte[] DecryptData(System.Security.Cryptography.Xml.EncryptedData encryptedData, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public void DecryptDocument() => throw null;
                    public virtual System.Byte[] DecryptEncryptedKey(System.Security.Cryptography.Xml.EncryptedKey encryptedKey) => throw null;
                    public static System.Byte[] DecryptKey(System.Byte[] keyData, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public static System.Byte[] DecryptKey(System.Byte[] keyData, System.Security.Cryptography.RSA rsa, bool useOAEP) => throw null;
                    public System.Security.Policy.Evidence DocumentEvidence { get => throw null; set => throw null; }
                    public System.Text.Encoding Encoding { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.EncryptedData Encrypt(System.Xml.XmlElement inputElement, string keyName) => throw null;
                    public System.Security.Cryptography.Xml.EncryptedData Encrypt(System.Xml.XmlElement inputElement, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Byte[] EncryptData(System.Xml.XmlElement inputElement, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm, bool content) => throw null;
                    public System.Byte[] EncryptData(System.Byte[] plaintext, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public static System.Byte[] EncryptKey(System.Byte[] keyData, System.Security.Cryptography.SymmetricAlgorithm symmetricAlgorithm) => throw null;
                    public static System.Byte[] EncryptKey(System.Byte[] keyData, System.Security.Cryptography.RSA rsa, bool useOAEP) => throw null;
                    public EncryptedXml(System.Xml.XmlDocument document, System.Security.Policy.Evidence evidence) => throw null;
                    public EncryptedXml(System.Xml.XmlDocument document) => throw null;
                    public EncryptedXml() => throw null;
                    public virtual System.Byte[] GetDecryptionIV(System.Security.Cryptography.Xml.EncryptedData encryptedData, string symmetricAlgorithmUri) => throw null;
                    public virtual System.Security.Cryptography.SymmetricAlgorithm GetDecryptionKey(System.Security.Cryptography.Xml.EncryptedData encryptedData, string symmetricAlgorithmUri) => throw null;
                    public virtual System.Xml.XmlElement GetIdElement(System.Xml.XmlDocument document, string idValue) => throw null;
                    public System.Security.Cryptography.CipherMode Mode { get => throw null; set => throw null; }
                    public System.Security.Cryptography.PaddingMode Padding { get => throw null; set => throw null; }
                    public string Recipient { get => throw null; set => throw null; }
                    public void ReplaceData(System.Xml.XmlElement inputElement, System.Byte[] decryptedData) => throw null;
                    public static void ReplaceElement(System.Xml.XmlElement inputElement, System.Security.Cryptography.Xml.EncryptedData encryptedData, bool content) => throw null;
                    public System.Xml.XmlResolver Resolver { get => throw null; set => throw null; }
                    public int XmlDSigSearchDepth { get => throw null; set => throw null; }
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

                // Generated from `System.Security.Cryptography.Xml.EncryptionMethod` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EncryptionMethod
                {
                    public EncryptionMethod(string algorithm) => throw null;
                    public EncryptionMethod() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string KeyAlgorithm { get => throw null; set => throw null; }
                    public int KeySize { get => throw null; set => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptionProperty` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EncryptionProperty
                {
                    public EncryptionProperty(System.Xml.XmlElement elementProperty) => throw null;
                    public EncryptionProperty() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Xml.XmlElement PropertyElement { get => throw null; set => throw null; }
                    public string Target { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.EncryptionPropertyCollection` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EncryptionPropertyCollection : System.Collections.IList, System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public int Add(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    int System.Collections.IList.Add(object value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    bool System.Collections.IList.Contains(object value) => throw null;
                    public void CopyTo(System.Security.Cryptography.Xml.EncryptionProperty[] array, int index) => throw null;
                    public void CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public EncryptionPropertyCollection() => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public int IndexOf(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    int System.Collections.IList.IndexOf(object value) => throw null;
                    void System.Collections.IList.Insert(int index, object value) => throw null;
                    public void Insert(int index, System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    public bool IsFixedSize { get => throw null; }
                    public bool IsReadOnly { get => throw null; }
                    public bool IsSynchronized { get => throw null; }
                    public System.Security.Cryptography.Xml.EncryptionProperty Item(int index) => throw null;
                    object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                    [System.Runtime.CompilerServices.IndexerName("ItemOf")]
                    public System.Security.Cryptography.Xml.EncryptionProperty this[int index] { get => throw null; set => throw null; }
                    void System.Collections.IList.Remove(object value) => throw null;
                    public void Remove(System.Security.Cryptography.Xml.EncryptionProperty value) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public object SyncRoot { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.IRelDecryptor` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public interface IRelDecryptor
                {
                    System.IO.Stream Decrypt(System.Security.Cryptography.Xml.EncryptionMethod encryptionMethod, System.Security.Cryptography.Xml.KeyInfo keyInfo, System.IO.Stream toDecrypt);
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfo` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyInfo : System.Collections.IEnumerable
                {
                    public void AddClause(System.Security.Cryptography.Xml.KeyInfoClause clause) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator(System.Type requestedObjectType) => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set => throw null; }
                    public KeyInfo() => throw null;
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfoClause` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class KeyInfoClause
                {
                    public abstract System.Xml.XmlElement GetXml();
                    protected KeyInfoClause() => throw null;
                    public abstract void LoadXml(System.Xml.XmlElement element);
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfoEncryptedKey` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyInfoEncryptedKey : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public System.Security.Cryptography.Xml.EncryptedKey EncryptedKey { get => throw null; set => throw null; }
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public KeyInfoEncryptedKey(System.Security.Cryptography.Xml.EncryptedKey encryptedKey) => throw null;
                    public KeyInfoEncryptedKey() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfoName` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyInfoName : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public KeyInfoName(string keyName) => throw null;
                    public KeyInfoName() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string Value { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfoNode` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyInfoNode : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public KeyInfoNode(System.Xml.XmlElement node) => throw null;
                    public KeyInfoNode() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Xml.XmlElement Value { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfoRetrievalMethod` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyInfoRetrievalMethod : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public KeyInfoRetrievalMethod(string strUri, string typeName) => throw null;
                    public KeyInfoRetrievalMethod(string strUri) => throw null;
                    public KeyInfoRetrievalMethod() => throw null;
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public string Type { get => throw null; set => throw null; }
                    public string Uri { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.KeyInfoX509Data` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyInfoX509Data : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public void AddCertificate(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                    public void AddIssuerSerial(string issuerName, string serialNumber) => throw null;
                    public void AddSubjectKeyId(string subjectKeyId) => throw null;
                    public void AddSubjectKeyId(System.Byte[] subjectKeyId) => throw null;
                    public void AddSubjectName(string subjectName) => throw null;
                    public System.Byte[] CRL { get => throw null; set => throw null; }
                    public System.Collections.ArrayList Certificates { get => throw null; }
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public System.Collections.ArrayList IssuerSerials { get => throw null; }
                    public KeyInfoX509Data(System.Security.Cryptography.X509Certificates.X509Certificate cert, System.Security.Cryptography.X509Certificates.X509IncludeOption includeOption) => throw null;
                    public KeyInfoX509Data(System.Security.Cryptography.X509Certificates.X509Certificate cert) => throw null;
                    public KeyInfoX509Data(System.Byte[] rgbCert) => throw null;
                    public KeyInfoX509Data() => throw null;
                    public override void LoadXml(System.Xml.XmlElement element) => throw null;
                    public System.Collections.ArrayList SubjectKeyIds { get => throw null; }
                    public System.Collections.ArrayList SubjectNames { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.KeyReference` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class KeyReference : System.Security.Cryptography.Xml.EncryptedReference
                {
                    public KeyReference(string uri, System.Security.Cryptography.Xml.TransformChain transformChain) => throw null;
                    public KeyReference(string uri) => throw null;
                    public KeyReference() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.RSAKeyValue` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class RSAKeyValue : System.Security.Cryptography.Xml.KeyInfoClause
                {
                    public override System.Xml.XmlElement GetXml() => throw null;
                    public System.Security.Cryptography.RSA Key { get => throw null; set => throw null; }
                    public override void LoadXml(System.Xml.XmlElement value) => throw null;
                    public RSAKeyValue(System.Security.Cryptography.RSA key) => throw null;
                    public RSAKeyValue() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.Reference` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class Reference
                {
                    public void AddTransform(System.Security.Cryptography.Xml.Transform transform) => throw null;
                    public string DigestMethod { get => throw null; set => throw null; }
                    public System.Byte[] DigestValue { get => throw null; set => throw null; }
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public Reference(string uri) => throw null;
                    public Reference(System.IO.Stream stream) => throw null;
                    public Reference() => throw null;
                    public System.Security.Cryptography.Xml.TransformChain TransformChain { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                    public string Uri { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.ReferenceList` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class ReferenceList : System.Collections.IList, System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public int Add(object value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(object value) => throw null;
                    public void CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public int IndexOf(object value) => throw null;
                    public void Insert(int index, object value) => throw null;
                    bool System.Collections.IList.IsFixedSize { get => throw null; }
                    bool System.Collections.IList.IsReadOnly { get => throw null; }
                    public bool IsSynchronized { get => throw null; }
                    public System.Security.Cryptography.Xml.EncryptedReference Item(int index) => throw null;
                    object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                    [System.Runtime.CompilerServices.IndexerName("ItemOf")]
                    public System.Security.Cryptography.Xml.EncryptedReference this[int index] { get => throw null; set => throw null; }
                    public ReferenceList() => throw null;
                    public void Remove(object value) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public object SyncRoot { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.Signature` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class Signature
                {
                    public void AddObject(System.Security.Cryptography.Xml.DataObject dataObject) => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.KeyInfo KeyInfo { get => throw null; set => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Collections.IList ObjectList { get => throw null; set => throw null; }
                    public Signature() => throw null;
                    public System.Byte[] SignatureValue { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.SignedInfo SignedInfo { get => throw null; set => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.SignedInfo` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class SignedInfo : System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public void AddReference(System.Security.Cryptography.Xml.Reference reference) => throw null;
                    public string CanonicalizationMethod { get => throw null; set => throw null; }
                    public System.Security.Cryptography.Xml.Transform CanonicalizationMethodObject { get => throw null; }
                    public void CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public string Id { get => throw null; set => throw null; }
                    public bool IsReadOnly { get => throw null; }
                    public bool IsSynchronized { get => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Collections.ArrayList References { get => throw null; }
                    public string SignatureLength { get => throw null; set => throw null; }
                    public string SignatureMethod { get => throw null; set => throw null; }
                    public SignedInfo() => throw null;
                    public object SyncRoot { get => throw null; }
                }

                // Generated from `System.Security.Cryptography.Xml.SignedXml` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class SignedXml
                {
                    public void AddObject(System.Security.Cryptography.Xml.DataObject dataObject) => throw null;
                    public void AddReference(System.Security.Cryptography.Xml.Reference reference) => throw null;
                    public bool CheckSignature(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool verifySignatureOnly) => throw null;
                    public bool CheckSignature(System.Security.Cryptography.KeyedHashAlgorithm macAlg) => throw null;
                    public bool CheckSignature(System.Security.Cryptography.AsymmetricAlgorithm key) => throw null;
                    public bool CheckSignature() => throw null;
                    public bool CheckSignatureReturningKey(out System.Security.Cryptography.AsymmetricAlgorithm signingKey) => throw null;
                    public void ComputeSignature(System.Security.Cryptography.KeyedHashAlgorithm macAlg) => throw null;
                    public void ComputeSignature() => throw null;
                    public System.Security.Cryptography.Xml.EncryptedXml EncryptedXml { get => throw null; set => throw null; }
                    public virtual System.Xml.XmlElement GetIdElement(System.Xml.XmlDocument document, string idValue) => throw null;
                    protected virtual System.Security.Cryptography.AsymmetricAlgorithm GetPublicKey() => throw null;
                    public System.Xml.XmlElement GetXml() => throw null;
                    public System.Security.Cryptography.Xml.KeyInfo KeyInfo { get => throw null; set => throw null; }
                    public void LoadXml(System.Xml.XmlElement value) => throw null;
                    public System.Xml.XmlResolver Resolver { set => throw null; }
                    public System.Collections.ObjectModel.Collection<string> SafeCanonicalizationMethods { get => throw null; }
                    public System.Security.Cryptography.Xml.Signature Signature { get => throw null; }
                    public System.Func<System.Security.Cryptography.Xml.SignedXml, bool> SignatureFormatValidator { get => throw null; set => throw null; }
                    public string SignatureLength { get => throw null; }
                    public string SignatureMethod { get => throw null; }
                    public System.Byte[] SignatureValue { get => throw null; }
                    public System.Security.Cryptography.Xml.SignedInfo SignedInfo { get => throw null; }
                    public SignedXml(System.Xml.XmlElement elem) => throw null;
                    public SignedXml(System.Xml.XmlDocument document) => throw null;
                    public SignedXml() => throw null;
                    public System.Security.Cryptography.AsymmetricAlgorithm SigningKey { get => throw null; set => throw null; }
                    public string SigningKeyName { get => throw null; set => throw null; }
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
                    protected System.Security.Cryptography.Xml.Signature m_signature;
                    protected string m_strSigningKeyName;
                }

                // Generated from `System.Security.Cryptography.Xml.Transform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class Transform
                {
                    public string Algorithm { get => throw null; set => throw null; }
                    public System.Xml.XmlElement Context { get => throw null; set => throw null; }
                    public virtual System.Byte[] GetDigestedOutput(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                    protected abstract System.Xml.XmlNodeList GetInnerXml();
                    public abstract object GetOutput(System.Type type);
                    public abstract object GetOutput();
                    public System.Xml.XmlElement GetXml() => throw null;
                    public abstract System.Type[] InputTypes { get; }
                    public abstract void LoadInnerXml(System.Xml.XmlNodeList nodeList);
                    public abstract void LoadInput(object obj);
                    public abstract System.Type[] OutputTypes { get; }
                    public System.Collections.Hashtable PropagatedNamespaces { get => throw null; }
                    public System.Xml.XmlResolver Resolver { set => throw null; }
                    protected Transform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.TransformChain` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class TransformChain
                {
                    public void Add(System.Security.Cryptography.Xml.Transform transform) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public System.Security.Cryptography.Xml.Transform this[int index] { get => throw null; }
                    public TransformChain() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDecryptionTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDecryptionTransform : System.Security.Cryptography.Xml.Transform
                {
                    public void AddExceptUri(string uri) => throw null;
                    public System.Security.Cryptography.Xml.EncryptedXml EncryptedXml { get => throw null; set => throw null; }
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    protected virtual bool IsTargetElement(System.Xml.XmlElement inputElement, string idValue) => throw null;
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDecryptionTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigBase64Transform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigBase64Transform : System.Security.Cryptography.Xml.Transform
                {
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDsigBase64Transform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigC14NTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigC14NTransform : System.Security.Cryptography.Xml.Transform
                {
                    public override System.Byte[] GetDigestedOutput(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDsigC14NTransform(bool includeComments) => throw null;
                    public XmlDsigC14NTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigC14NWithCommentsTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigC14NWithCommentsTransform : System.Security.Cryptography.Xml.XmlDsigC14NTransform
                {
                    public XmlDsigC14NWithCommentsTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigEnvelopedSignatureTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigEnvelopedSignatureTransform : System.Security.Cryptography.Xml.Transform
                {
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDsigEnvelopedSignatureTransform(bool includeComments) => throw null;
                    public XmlDsigEnvelopedSignatureTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigExcC14NTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigExcC14NTransform : System.Security.Cryptography.Xml.Transform
                {
                    public override System.Byte[] GetDigestedOutput(System.Security.Cryptography.HashAlgorithm hash) => throw null;
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public string InclusiveNamespacesPrefixList { get => throw null; set => throw null; }
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDsigExcC14NTransform(string inclusiveNamespacesPrefixList) => throw null;
                    public XmlDsigExcC14NTransform(bool includeComments, string inclusiveNamespacesPrefixList) => throw null;
                    public XmlDsigExcC14NTransform(bool includeComments) => throw null;
                    public XmlDsigExcC14NTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigExcC14NWithCommentsTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigExcC14NWithCommentsTransform : System.Security.Cryptography.Xml.XmlDsigExcC14NTransform
                {
                    public XmlDsigExcC14NWithCommentsTransform(string inclusiveNamespacesPrefixList) => throw null;
                    public XmlDsigExcC14NWithCommentsTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigXPathTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigXPathTransform : System.Security.Cryptography.Xml.Transform
                {
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDsigXPathTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlDsigXsltTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlDsigXsltTransform : System.Security.Cryptography.Xml.Transform
                {
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlDsigXsltTransform(bool includeComments) => throw null;
                    public XmlDsigXsltTransform() => throw null;
                }

                // Generated from `System.Security.Cryptography.Xml.XmlLicenseTransform` in `System.Security.Cryptography.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class XmlLicenseTransform : System.Security.Cryptography.Xml.Transform
                {
                    public System.Security.Cryptography.Xml.IRelDecryptor Decryptor { get => throw null; set => throw null; }
                    protected override System.Xml.XmlNodeList GetInnerXml() => throw null;
                    public override object GetOutput(System.Type type) => throw null;
                    public override object GetOutput() => throw null;
                    public override System.Type[] InputTypes { get => throw null; }
                    public override void LoadInnerXml(System.Xml.XmlNodeList nodeList) => throw null;
                    public override void LoadInput(object obj) => throw null;
                    public override System.Type[] OutputTypes { get => throw null; }
                    public XmlLicenseTransform() => throw null;
                }

            }
        }
    }
}
