// This file contains auto-generated code.
// Generated from `System.Runtime.Serialization.Xml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            public abstract class DataContractResolver
            {
                protected DataContractResolver() => throw null;
                public abstract System.Type ResolveName(string typeName, string typeNamespace, System.Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver);
                public abstract bool TryResolveType(System.Type type, System.Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver, out System.Xml.XmlDictionaryString typeName, out System.Xml.XmlDictionaryString typeNamespace);
            }
            namespace DataContracts
            {
                public abstract class DataContract
                {
                    public virtual System.Runtime.Serialization.DataContracts.DataContract BaseContract { get => throw null; }
                    public virtual string ContractType { get => throw null; }
                    public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Runtime.Serialization.DataContracts.DataMember> DataMembers { get => throw null; }
                    public virtual System.Xml.XmlQualifiedName GetArrayTypeName(bool isNullable) => throw null;
                    public static System.Runtime.Serialization.DataContracts.DataContract GetBuiltInDataContract(string name, string ns) => throw null;
                    public static System.Xml.XmlQualifiedName GetXmlName(System.Type type) => throw null;
                    public virtual bool IsBuiltInDataContract { get => throw null; }
                    public virtual bool IsDictionaryLike(out string keyName, out string valueName, out string itemName) => throw null;
                    public virtual bool IsISerializable { get => throw null; }
                    public virtual bool IsReference { get => throw null; }
                    public virtual bool IsValueType { get => throw null; }
                    public virtual System.Collections.Generic.Dictionary<System.Xml.XmlQualifiedName, System.Runtime.Serialization.DataContracts.DataContract> KnownDataContracts { get => throw null; }
                    public virtual System.Type OriginalUnderlyingType { get => throw null; }
                    public virtual System.Xml.XmlDictionaryString TopLevelElementName { get => throw null; }
                    public virtual System.Xml.XmlDictionaryString TopLevelElementNamespace { get => throw null; }
                    public virtual System.Type UnderlyingType { get => throw null; }
                    public virtual System.Xml.XmlQualifiedName XmlName { get => throw null; }
                }
                public sealed class DataContractSet
                {
                    public System.Collections.Generic.Dictionary<System.Xml.XmlQualifiedName, System.Runtime.Serialization.DataContracts.DataContract> Contracts { get => throw null; }
                    public DataContractSet(System.Runtime.Serialization.DataContracts.DataContractSet dataContractSet) => throw null;
                    public DataContractSet(System.Runtime.Serialization.ISerializationSurrogateProvider dataContractSurrogate, System.Collections.Generic.IEnumerable<System.Type> referencedTypes, System.Collections.Generic.IEnumerable<System.Type> referencedCollectionTypes) => throw null;
                    public System.Runtime.Serialization.DataContracts.DataContract GetDataContract(System.Type type) => throw null;
                    public System.Runtime.Serialization.DataContracts.DataContract GetDataContract(System.Xml.XmlQualifiedName key) => throw null;
                    public System.Type GetReferencedType(System.Xml.XmlQualifiedName xmlName, System.Runtime.Serialization.DataContracts.DataContract dataContract, out System.Runtime.Serialization.DataContracts.DataContract referencedContract, out object[] genericParameters, bool? supportGenericTypes = default(bool?)) => throw null;
                    public void ImportSchemaSet(System.Xml.Schema.XmlSchemaSet schemaSet, System.Collections.Generic.IEnumerable<System.Xml.XmlQualifiedName> typeNames, bool importXmlDataType) => throw null;
                    public System.Collections.Generic.List<System.Xml.XmlQualifiedName> ImportSchemaSet(System.Xml.Schema.XmlSchemaSet schemaSet, System.Collections.Generic.IEnumerable<System.Xml.Schema.XmlSchemaElement> elements, bool importXmlDataType) => throw null;
                    public System.Collections.Generic.Dictionary<System.Xml.XmlQualifiedName, System.Runtime.Serialization.DataContracts.DataContract> KnownTypesForObject { get => throw null; }
                    public System.Collections.Generic.Dictionary<System.Runtime.Serialization.DataContracts.DataContract, object> ProcessedContracts { get => throw null; }
                    public System.Collections.Hashtable SurrogateData { get => throw null; }
                }
                public sealed class DataMember
                {
                    public bool EmitDefaultValue { get => throw null; }
                    public bool IsNullable { get => throw null; }
                    public bool IsRequired { get => throw null; }
                    public System.Runtime.Serialization.DataContracts.DataContract MemberTypeContract { get => throw null; }
                    public string Name { get => throw null; }
                    public long Order { get => throw null; }
                }
                public sealed class XmlDataContract : System.Runtime.Serialization.DataContracts.DataContract
                {
                    public bool HasRoot { get => throw null; }
                    public bool IsAnonymous { get => throw null; }
                    public bool IsTopLevelElementNullable { get => throw null; }
                    public bool IsTypeDefinedOnImport { get => throw null; set { } }
                    public bool IsValueType { get => throw null; set { } }
                    public System.Xml.Schema.XmlSchemaType XsdType { get => throw null; }
                }
            }
            public sealed class DataContractSerializer : System.Runtime.Serialization.XmlObjectSerializer
            {
                public DataContractSerializer(System.Type type) => throw null;
                public DataContractSerializer(System.Type type, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                public DataContractSerializer(System.Type type, System.Runtime.Serialization.DataContractSerializerSettings settings) => throw null;
                public DataContractSerializer(System.Type type, string rootName, string rootNamespace) => throw null;
                public DataContractSerializer(System.Type type, string rootName, string rootNamespace, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                public DataContractSerializer(System.Type type, System.Xml.XmlDictionaryString rootName, System.Xml.XmlDictionaryString rootNamespace) => throw null;
                public DataContractSerializer(System.Type type, System.Xml.XmlDictionaryString rootName, System.Xml.XmlDictionaryString rootNamespace, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                public System.Runtime.Serialization.DataContractResolver DataContractResolver { get => throw null; }
                public bool IgnoreExtensionDataObject { get => throw null; }
                public override bool IsStartObject(System.Xml.XmlDictionaryReader reader) => throw null;
                public override bool IsStartObject(System.Xml.XmlReader reader) => throw null;
                public System.Collections.ObjectModel.ReadOnlyCollection<System.Type> KnownTypes { get => throw null; }
                public int MaxItemsInObjectGraph { get => throw null; }
                public bool PreserveObjectReferences { get => throw null; }
                public override object ReadObject(System.Xml.XmlDictionaryReader reader, bool verifyObjectName) => throw null;
                public object ReadObject(System.Xml.XmlDictionaryReader reader, bool verifyObjectName, System.Runtime.Serialization.DataContractResolver dataContractResolver) => throw null;
                public override object ReadObject(System.Xml.XmlReader reader) => throw null;
                public override object ReadObject(System.Xml.XmlReader reader, bool verifyObjectName) => throw null;
                public bool SerializeReadOnlyTypes { get => throw null; }
                public override void WriteEndObject(System.Xml.XmlDictionaryWriter writer) => throw null;
                public override void WriteEndObject(System.Xml.XmlWriter writer) => throw null;
                public void WriteObject(System.Xml.XmlDictionaryWriter writer, object graph, System.Runtime.Serialization.DataContractResolver dataContractResolver) => throw null;
                public override void WriteObject(System.Xml.XmlWriter writer, object graph) => throw null;
                public override void WriteObjectContent(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
                public override void WriteObjectContent(System.Xml.XmlWriter writer, object graph) => throw null;
                public override void WriteStartObject(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
                public override void WriteStartObject(System.Xml.XmlWriter writer, object graph) => throw null;
            }
            public static partial class DataContractSerializerExtensions
            {
                public static System.Runtime.Serialization.ISerializationSurrogateProvider GetSerializationSurrogateProvider(this System.Runtime.Serialization.DataContractSerializer serializer) => throw null;
                public static void SetSerializationSurrogateProvider(this System.Runtime.Serialization.DataContractSerializer serializer, System.Runtime.Serialization.ISerializationSurrogateProvider provider) => throw null;
            }
            public class DataContractSerializerSettings
            {
                public DataContractSerializerSettings() => throw null;
                public System.Runtime.Serialization.DataContractResolver DataContractResolver { get => throw null; set { } }
                public bool IgnoreExtensionDataObject { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<System.Type> KnownTypes { get => throw null; set { } }
                public int MaxItemsInObjectGraph { get => throw null; set { } }
                public bool PreserveObjectReferences { get => throw null; set { } }
                public System.Xml.XmlDictionaryString RootName { get => throw null; set { } }
                public System.Xml.XmlDictionaryString RootNamespace { get => throw null; set { } }
                public bool SerializeReadOnlyTypes { get => throw null; set { } }
            }
            public class ExportOptions
            {
                public ExportOptions() => throw null;
                public System.Runtime.Serialization.ISerializationSurrogateProvider DataContractSurrogate { get => throw null; set { } }
                public System.Collections.ObjectModel.Collection<System.Type> KnownTypes { get => throw null; }
            }
            public sealed class ExtensionDataObject
            {
            }
            public interface IExtensibleDataObject
            {
                System.Runtime.Serialization.ExtensionDataObject ExtensionData { get; set; }
            }
            public abstract class XmlObjectSerializer
            {
                protected XmlObjectSerializer() => throw null;
                public abstract bool IsStartObject(System.Xml.XmlDictionaryReader reader);
                public virtual bool IsStartObject(System.Xml.XmlReader reader) => throw null;
                public virtual object ReadObject(System.IO.Stream stream) => throw null;
                public virtual object ReadObject(System.Xml.XmlDictionaryReader reader) => throw null;
                public abstract object ReadObject(System.Xml.XmlDictionaryReader reader, bool verifyObjectName);
                public virtual object ReadObject(System.Xml.XmlReader reader) => throw null;
                public virtual object ReadObject(System.Xml.XmlReader reader, bool verifyObjectName) => throw null;
                public abstract void WriteEndObject(System.Xml.XmlDictionaryWriter writer);
                public virtual void WriteEndObject(System.Xml.XmlWriter writer) => throw null;
                public virtual void WriteObject(System.IO.Stream stream, object graph) => throw null;
                public virtual void WriteObject(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
                public virtual void WriteObject(System.Xml.XmlWriter writer, object graph) => throw null;
                public abstract void WriteObjectContent(System.Xml.XmlDictionaryWriter writer, object graph);
                public virtual void WriteObjectContent(System.Xml.XmlWriter writer, object graph) => throw null;
                public abstract void WriteStartObject(System.Xml.XmlDictionaryWriter writer, object graph);
                public virtual void WriteStartObject(System.Xml.XmlWriter writer, object graph) => throw null;
            }
            public static class XmlSerializableServices
            {
                public static void AddDefaultSchema(System.Xml.Schema.XmlSchemaSet schemas, System.Xml.XmlQualifiedName typeQName) => throw null;
                public static System.Xml.XmlNode[] ReadNodes(System.Xml.XmlReader xmlReader) => throw null;
                public static void WriteNodes(System.Xml.XmlWriter xmlWriter, System.Xml.XmlNode[] nodes) => throw null;
            }
            public static class XPathQueryGenerator
            {
                public static string CreateFromDataContractSerializer(System.Type type, System.Reflection.MemberInfo[] pathToMember, System.Text.StringBuilder rootElementXpath, out System.Xml.XmlNamespaceManager namespaces) => throw null;
                public static string CreateFromDataContractSerializer(System.Type type, System.Reflection.MemberInfo[] pathToMember, out System.Xml.XmlNamespaceManager namespaces) => throw null;
            }
            public class XsdDataContractExporter
            {
                public bool CanExport(System.Collections.Generic.ICollection<System.Reflection.Assembly> assemblies) => throw null;
                public bool CanExport(System.Collections.Generic.ICollection<System.Type> types) => throw null;
                public bool CanExport(System.Type type) => throw null;
                public XsdDataContractExporter() => throw null;
                public XsdDataContractExporter(System.Xml.Schema.XmlSchemaSet schemas) => throw null;
                public void Export(System.Collections.Generic.ICollection<System.Reflection.Assembly> assemblies) => throw null;
                public void Export(System.Collections.Generic.ICollection<System.Type> types) => throw null;
                public void Export(System.Type type) => throw null;
                public System.Xml.XmlQualifiedName GetRootElementName(System.Type type) => throw null;
                public System.Xml.Schema.XmlSchemaType GetSchemaType(System.Type type) => throw null;
                public System.Xml.XmlQualifiedName GetSchemaTypeName(System.Type type) => throw null;
                public System.Runtime.Serialization.ExportOptions Options { get => throw null; set { } }
                public System.Xml.Schema.XmlSchemaSet Schemas { get => throw null; }
            }
        }
    }
    namespace Xml
    {
        public interface IFragmentCapableXmlDictionaryWriter
        {
            bool CanFragment { get; }
            void EndFragment();
            void StartFragment(System.IO.Stream stream, bool generateSelfContainedTextFragment);
            void WriteFragment(byte[] buffer, int offset, int count);
        }
        public interface IStreamProvider
        {
            System.IO.Stream GetStream();
            void ReleaseStream(System.IO.Stream stream);
        }
        public interface IXmlBinaryReaderInitializer
        {
            void SetInput(byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose);
            void SetInput(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose);
        }
        public interface IXmlBinaryWriterInitializer
        {
            void SetOutput(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlBinaryWriterSession session, bool ownsStream);
        }
        public interface IXmlDictionary
        {
            bool TryLookup(int key, out System.Xml.XmlDictionaryString result);
            bool TryLookup(string value, out System.Xml.XmlDictionaryString result);
            bool TryLookup(System.Xml.XmlDictionaryString value, out System.Xml.XmlDictionaryString result);
        }
        public interface IXmlTextReaderInitializer
        {
            void SetInput(byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
            void SetInput(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
        }
        public interface IXmlTextWriterInitializer
        {
            void SetOutput(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream);
        }
        public delegate void OnXmlDictionaryReaderClose(System.Xml.XmlDictionaryReader reader);
        public class UniqueId
        {
            public int CharArrayLength { get => throw null; }
            public UniqueId() => throw null;
            public UniqueId(byte[] guid) => throw null;
            public UniqueId(byte[] guid, int offset) => throw null;
            public UniqueId(char[] chars, int offset, int count) => throw null;
            public UniqueId(System.Guid guid) => throw null;
            public UniqueId(string value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsGuid { get => throw null; }
            public static bool operator ==(System.Xml.UniqueId id1, System.Xml.UniqueId id2) => throw null;
            public static bool operator !=(System.Xml.UniqueId id1, System.Xml.UniqueId id2) => throw null;
            public int ToCharArray(char[] chars, int offset) => throw null;
            public override string ToString() => throw null;
            public bool TryGetGuid(byte[] buffer, int offset) => throw null;
            public bool TryGetGuid(out System.Guid guid) => throw null;
        }
        public class XmlBinaryReaderSession : System.Xml.IXmlDictionary
        {
            public System.Xml.XmlDictionaryString Add(int id, string value) => throw null;
            public void Clear() => throw null;
            public XmlBinaryReaderSession() => throw null;
            public bool TryLookup(int key, out System.Xml.XmlDictionaryString result) => throw null;
            public bool TryLookup(string value, out System.Xml.XmlDictionaryString result) => throw null;
            public bool TryLookup(System.Xml.XmlDictionaryString value, out System.Xml.XmlDictionaryString result) => throw null;
        }
        public class XmlBinaryWriterSession
        {
            public XmlBinaryWriterSession() => throw null;
            public void Reset() => throw null;
            public virtual bool TryAdd(System.Xml.XmlDictionaryString value, out int key) => throw null;
        }
        public class XmlDictionary : System.Xml.IXmlDictionary
        {
            public virtual System.Xml.XmlDictionaryString Add(string value) => throw null;
            public XmlDictionary() => throw null;
            public XmlDictionary(int capacity) => throw null;
            public static System.Xml.IXmlDictionary Empty { get => throw null; }
            public virtual bool TryLookup(int key, out System.Xml.XmlDictionaryString result) => throw null;
            public virtual bool TryLookup(string value, out System.Xml.XmlDictionaryString result) => throw null;
            public virtual bool TryLookup(System.Xml.XmlDictionaryString value, out System.Xml.XmlDictionaryString result) => throw null;
        }
        public abstract class XmlDictionaryReader : System.Xml.XmlReader
        {
            public virtual bool CanCanonicalize { get => throw null; }
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(byte[] buffer, int offset, int count, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(byte[] buffer, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateDictionaryReader(System.Xml.XmlReader reader) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(byte[] buffer, int offset, int count, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(byte[] buffer, int offset, int count, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas, int maxBufferSize, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(byte[] buffer, int offset, int count, System.Text.Encoding[] encodings, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas, int maxBufferSize, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding[] encodings, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(byte[] buffer, int offset, int count, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(byte[] buffer, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.IO.Stream stream, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            protected XmlDictionaryReader() => throw null;
            public virtual void EndCanonicalization() => throw null;
            public virtual string GetAttribute(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void GetNonAtomizedNames(out string localName, out string namespaceUri) => throw null;
            public virtual int IndexOfLocalName(string[] localNames, string namespaceUri) => throw null;
            public virtual int IndexOfLocalName(System.Xml.XmlDictionaryString[] localNames, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool IsLocalName(string localName) => throw null;
            public virtual bool IsLocalName(System.Xml.XmlDictionaryString localName) => throw null;
            public virtual bool IsNamespaceUri(string namespaceUri) => throw null;
            public virtual bool IsNamespaceUri(System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool IsStartArray(out System.Type type) => throw null;
            public virtual bool IsStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            protected bool IsTextNode(System.Xml.XmlNodeType nodeType) => throw null;
            public virtual void MoveToStartElement() => throw null;
            public virtual void MoveToStartElement(string name) => throw null;
            public virtual void MoveToStartElement(string localName, string namespaceUri) => throw null;
            public virtual void MoveToStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.Xml.XmlDictionaryReaderQuotas Quotas { get => throw null; }
            public virtual int ReadArray(string localName, string namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, decimal[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, short[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, long[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, decimal[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, short[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, long[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public virtual bool[] ReadBooleanArray(string localName, string namespaceUri) => throw null;
            public virtual bool[] ReadBooleanArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public override object ReadContentAs(System.Type type, System.Xml.IXmlNamespaceResolver namespaceResolver) => throw null;
            public virtual byte[] ReadContentAsBase64() => throw null;
            public virtual byte[] ReadContentAsBinHex() => throw null;
            protected byte[] ReadContentAsBinHex(int maxByteArrayContentLength) => throw null;
            public virtual int ReadContentAsChars(char[] chars, int offset, int count) => throw null;
            public override decimal ReadContentAsDecimal() => throw null;
            public override float ReadContentAsFloat() => throw null;
            public virtual System.Guid ReadContentAsGuid() => throw null;
            public virtual void ReadContentAsQualifiedName(out string localName, out string namespaceUri) => throw null;
            public override string ReadContentAsString() => throw null;
            protected string ReadContentAsString(int maxStringContentLength) => throw null;
            public virtual string ReadContentAsString(string[] strings, out int index) => throw null;
            public virtual string ReadContentAsString(System.Xml.XmlDictionaryString[] strings, out int index) => throw null;
            public virtual System.TimeSpan ReadContentAsTimeSpan() => throw null;
            public virtual System.Xml.UniqueId ReadContentAsUniqueId() => throw null;
            public virtual System.DateTime[] ReadDateTimeArray(string localName, string namespaceUri) => throw null;
            public virtual System.DateTime[] ReadDateTimeArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual decimal[] ReadDecimalArray(string localName, string namespaceUri) => throw null;
            public virtual decimal[] ReadDecimalArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual double[] ReadDoubleArray(string localName, string namespaceUri) => throw null;
            public virtual double[] ReadDoubleArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual byte[] ReadElementContentAsBase64() => throw null;
            public virtual byte[] ReadElementContentAsBinHex() => throw null;
            public override bool ReadElementContentAsBoolean() => throw null;
            public override System.DateTime ReadElementContentAsDateTime() => throw null;
            public override decimal ReadElementContentAsDecimal() => throw null;
            public override double ReadElementContentAsDouble() => throw null;
            public override float ReadElementContentAsFloat() => throw null;
            public virtual System.Guid ReadElementContentAsGuid() => throw null;
            public override int ReadElementContentAsInt() => throw null;
            public override long ReadElementContentAsLong() => throw null;
            public override string ReadElementContentAsString() => throw null;
            public virtual System.TimeSpan ReadElementContentAsTimeSpan() => throw null;
            public virtual System.Xml.UniqueId ReadElementContentAsUniqueId() => throw null;
            public virtual void ReadFullStartElement() => throw null;
            public virtual void ReadFullStartElement(string name) => throw null;
            public virtual void ReadFullStartElement(string localName, string namespaceUri) => throw null;
            public virtual void ReadFullStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.Guid[] ReadGuidArray(string localName, string namespaceUri) => throw null;
            public virtual System.Guid[] ReadGuidArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual short[] ReadInt16Array(string localName, string namespaceUri) => throw null;
            public virtual short[] ReadInt16Array(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual int[] ReadInt32Array(string localName, string namespaceUri) => throw null;
            public virtual int[] ReadInt32Array(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual long[] ReadInt64Array(string localName, string namespaceUri) => throw null;
            public virtual long[] ReadInt64Array(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual float[] ReadSingleArray(string localName, string namespaceUri) => throw null;
            public virtual float[] ReadSingleArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void ReadStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public override string ReadString() => throw null;
            protected string ReadString(int maxStringContentLength) => throw null;
            public virtual System.TimeSpan[] ReadTimeSpanArray(string localName, string namespaceUri) => throw null;
            public virtual System.TimeSpan[] ReadTimeSpanArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual int ReadValueAsBase64(byte[] buffer, int offset, int count) => throw null;
            public virtual void StartCanonicalization(System.IO.Stream stream, bool includeComments, string[] inclusivePrefixes) => throw null;
            public virtual bool TryGetArrayLength(out int count) => throw null;
            public virtual bool TryGetBase64ContentLength(out int length) => throw null;
            public virtual bool TryGetLocalNameAsDictionaryString(out System.Xml.XmlDictionaryString localName) => throw null;
            public virtual bool TryGetNamespaceUriAsDictionaryString(out System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool TryGetValueAsDictionaryString(out System.Xml.XmlDictionaryString value) => throw null;
        }
        public sealed class XmlDictionaryReaderQuotas
        {
            public void CopyTo(System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public XmlDictionaryReaderQuotas() => throw null;
            public static System.Xml.XmlDictionaryReaderQuotas Max { get => throw null; }
            public int MaxArrayLength { get => throw null; set { } }
            public int MaxBytesPerRead { get => throw null; set { } }
            public int MaxDepth { get => throw null; set { } }
            public int MaxNameTableCharCount { get => throw null; set { } }
            public int MaxStringContentLength { get => throw null; set { } }
            public System.Xml.XmlDictionaryReaderQuotaTypes ModifiedQuotas { get => throw null; }
        }
        [System.Flags]
        public enum XmlDictionaryReaderQuotaTypes
        {
            MaxDepth = 1,
            MaxStringContentLength = 2,
            MaxArrayLength = 4,
            MaxBytesPerRead = 8,
            MaxNameTableCharCount = 16,
        }
        public class XmlDictionaryString
        {
            public XmlDictionaryString(System.Xml.IXmlDictionary dictionary, string value, int key) => throw null;
            public System.Xml.IXmlDictionary Dictionary { get => throw null; }
            public static System.Xml.XmlDictionaryString Empty { get => throw null; }
            public int Key { get => throw null; }
            public override string ToString() => throw null;
            public string Value { get => throw null; }
        }
        public abstract class XmlDictionaryWriter : System.Xml.XmlWriter
        {
            public virtual bool CanCanonicalize { get => throw null; }
            public static System.Xml.XmlDictionaryWriter CreateBinaryWriter(System.IO.Stream stream) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateBinaryWriter(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateBinaryWriter(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlBinaryWriterSession session) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateBinaryWriter(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlBinaryWriterSession session, bool ownsStream) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateDictionaryWriter(System.Xml.XmlWriter writer) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateMtomWriter(System.IO.Stream stream, System.Text.Encoding encoding, int maxSizeInBytes, string startInfo) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateMtomWriter(System.IO.Stream stream, System.Text.Encoding encoding, int maxSizeInBytes, string startInfo, string boundary, string startUri, bool writeMessageHeaders, bool ownsStream) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateTextWriter(System.IO.Stream stream) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateTextWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
            public static System.Xml.XmlDictionaryWriter CreateTextWriter(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream) => throw null;
            protected XmlDictionaryWriter() => throw null;
            public virtual void EndCanonicalization() => throw null;
            public virtual void StartCanonicalization(System.IO.Stream stream, bool includeComments, string[] inclusivePrefixes) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, decimal[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, short[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, long[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, decimal[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, short[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, long[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public void WriteAttributeString(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public void WriteAttributeString(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public override System.Threading.Tasks.Task WriteBase64Async(byte[] buffer, int index, int count) => throw null;
            public void WriteElementString(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public void WriteElementString(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public virtual void WriteNode(System.Xml.XmlDictionaryReader reader, bool defattr) => throw null;
            public override void WriteNode(System.Xml.XmlReader reader, bool defattr) => throw null;
            public virtual void WriteQualifiedName(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteStartAttribute(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public void WriteStartAttribute(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteStartElement(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public void WriteStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteString(System.Xml.XmlDictionaryString value) => throw null;
            protected virtual void WriteTextNode(System.Xml.XmlDictionaryReader reader, bool isAttribute) => throw null;
            public virtual void WriteValue(System.Guid value) => throw null;
            public virtual void WriteValue(System.TimeSpan value) => throw null;
            public virtual void WriteValue(System.Xml.IStreamProvider value) => throw null;
            public virtual void WriteValue(System.Xml.UniqueId value) => throw null;
            public virtual void WriteValue(System.Xml.XmlDictionaryString value) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Xml.IStreamProvider value) => throw null;
            public virtual void WriteXmlAttribute(string localName, string value) => throw null;
            public virtual void WriteXmlAttribute(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString value) => throw null;
            public virtual void WriteXmlnsAttribute(string prefix, string namespaceUri) => throw null;
            public virtual void WriteXmlnsAttribute(string prefix, System.Xml.XmlDictionaryString namespaceUri) => throw null;
        }
    }
}
