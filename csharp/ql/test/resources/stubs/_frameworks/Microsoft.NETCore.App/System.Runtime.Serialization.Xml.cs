// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            // Generated from `System.Runtime.Serialization.DataContractResolver` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DataContractResolver
            {
                protected DataContractResolver() => throw null;
                public abstract System.Type ResolveName(string typeName, string typeNamespace, System.Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver);
                public abstract bool TryResolveType(System.Type type, System.Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver, out System.Xml.XmlDictionaryString typeName, out System.Xml.XmlDictionaryString typeNamespace);
            }

            // Generated from `System.Runtime.Serialization.DataContractSerializer` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataContractSerializer : System.Runtime.Serialization.XmlObjectSerializer
            {
                public System.Runtime.Serialization.DataContractResolver DataContractResolver { get => throw null; }
                public DataContractSerializer(System.Type type) => throw null;
                public DataContractSerializer(System.Type type, System.Runtime.Serialization.DataContractSerializerSettings settings) => throw null;
                public DataContractSerializer(System.Type type, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                public DataContractSerializer(System.Type type, System.Xml.XmlDictionaryString rootName, System.Xml.XmlDictionaryString rootNamespace) => throw null;
                public DataContractSerializer(System.Type type, System.Xml.XmlDictionaryString rootName, System.Xml.XmlDictionaryString rootNamespace, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                public DataContractSerializer(System.Type type, string rootName, string rootNamespace) => throw null;
                public DataContractSerializer(System.Type type, string rootName, string rootNamespace, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
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

            // Generated from `System.Runtime.Serialization.DataContractSerializerExtensions` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class DataContractSerializerExtensions
            {
                public static System.Runtime.Serialization.ISerializationSurrogateProvider GetSerializationSurrogateProvider(this System.Runtime.Serialization.DataContractSerializer serializer) => throw null;
                public static void SetSerializationSurrogateProvider(this System.Runtime.Serialization.DataContractSerializer serializer, System.Runtime.Serialization.ISerializationSurrogateProvider provider) => throw null;
            }

            // Generated from `System.Runtime.Serialization.DataContractSerializerSettings` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataContractSerializerSettings
            {
                public System.Runtime.Serialization.DataContractResolver DataContractResolver { get => throw null; set => throw null; }
                public DataContractSerializerSettings() => throw null;
                public bool IgnoreExtensionDataObject { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<System.Type> KnownTypes { get => throw null; set => throw null; }
                public int MaxItemsInObjectGraph { get => throw null; set => throw null; }
                public bool PreserveObjectReferences { get => throw null; set => throw null; }
                public System.Xml.XmlDictionaryString RootName { get => throw null; set => throw null; }
                public System.Xml.XmlDictionaryString RootNamespace { get => throw null; set => throw null; }
                public bool SerializeReadOnlyTypes { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.Serialization.ExportOptions` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ExportOptions
            {
                public ExportOptions() => throw null;
                public System.Collections.ObjectModel.Collection<System.Type> KnownTypes { get => throw null; }
            }

            // Generated from `System.Runtime.Serialization.ExtensionDataObject` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ExtensionDataObject
            {
            }

            // Generated from `System.Runtime.Serialization.IExtensibleDataObject` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IExtensibleDataObject
            {
                System.Runtime.Serialization.ExtensionDataObject ExtensionData { get; set; }
            }

            // Generated from `System.Runtime.Serialization.XPathQueryGenerator` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class XPathQueryGenerator
            {
                public static string CreateFromDataContractSerializer(System.Type type, System.Reflection.MemberInfo[] pathToMember, System.Text.StringBuilder rootElementXpath, out System.Xml.XmlNamespaceManager namespaces) => throw null;
                public static string CreateFromDataContractSerializer(System.Type type, System.Reflection.MemberInfo[] pathToMember, out System.Xml.XmlNamespaceManager namespaces) => throw null;
            }

            // Generated from `System.Runtime.Serialization.XmlObjectSerializer` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class XmlObjectSerializer
            {
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
                protected XmlObjectSerializer() => throw null;
            }

            // Generated from `System.Runtime.Serialization.XmlSerializableServices` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class XmlSerializableServices
            {
                public static void AddDefaultSchema(System.Xml.Schema.XmlSchemaSet schemas, System.Xml.XmlQualifiedName typeQName) => throw null;
                public static System.Xml.XmlNode[] ReadNodes(System.Xml.XmlReader xmlReader) => throw null;
                public static void WriteNodes(System.Xml.XmlWriter xmlWriter, System.Xml.XmlNode[] nodes) => throw null;
            }

            // Generated from `System.Runtime.Serialization.XsdDataContractExporter` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class XsdDataContractExporter
            {
                public bool CanExport(System.Collections.Generic.ICollection<System.Reflection.Assembly> assemblies) => throw null;
                public bool CanExport(System.Collections.Generic.ICollection<System.Type> types) => throw null;
                public bool CanExport(System.Type type) => throw null;
                public void Export(System.Collections.Generic.ICollection<System.Reflection.Assembly> assemblies) => throw null;
                public void Export(System.Collections.Generic.ICollection<System.Type> types) => throw null;
                public void Export(System.Type type) => throw null;
                public System.Xml.XmlQualifiedName GetRootElementName(System.Type type) => throw null;
                public System.Xml.Schema.XmlSchemaType GetSchemaType(System.Type type) => throw null;
                public System.Xml.XmlQualifiedName GetSchemaTypeName(System.Type type) => throw null;
                public System.Runtime.Serialization.ExportOptions Options { get => throw null; set => throw null; }
                public System.Xml.Schema.XmlSchemaSet Schemas { get => throw null; }
                public XsdDataContractExporter() => throw null;
                public XsdDataContractExporter(System.Xml.Schema.XmlSchemaSet schemas) => throw null;
            }

        }
    }
    namespace Xml
    {
        // Generated from `System.Xml.IFragmentCapableXmlDictionaryWriter` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IFragmentCapableXmlDictionaryWriter
        {
            bool CanFragment { get; }
            void EndFragment();
            void StartFragment(System.IO.Stream stream, bool generateSelfContainedTextFragment);
            void WriteFragment(System.Byte[] buffer, int offset, int count);
        }

        // Generated from `System.Xml.IStreamProvider` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IStreamProvider
        {
            System.IO.Stream GetStream();
            void ReleaseStream(System.IO.Stream stream);
        }

        // Generated from `System.Xml.IXmlBinaryReaderInitializer` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IXmlBinaryReaderInitializer
        {
            void SetInput(System.Byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose);
            void SetInput(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose);
        }

        // Generated from `System.Xml.IXmlBinaryWriterInitializer` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IXmlBinaryWriterInitializer
        {
            void SetOutput(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlBinaryWriterSession session, bool ownsStream);
        }

        // Generated from `System.Xml.IXmlDictionary` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IXmlDictionary
        {
            bool TryLookup(System.Xml.XmlDictionaryString value, out System.Xml.XmlDictionaryString result);
            bool TryLookup(int key, out System.Xml.XmlDictionaryString result);
            bool TryLookup(string value, out System.Xml.XmlDictionaryString result);
        }

        // Generated from `System.Xml.IXmlTextReaderInitializer` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IXmlTextReaderInitializer
        {
            void SetInput(System.Byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
            void SetInput(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
        }

        // Generated from `System.Xml.IXmlTextWriterInitializer` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IXmlTextWriterInitializer
        {
            void SetOutput(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream);
        }

        // Generated from `System.Xml.OnXmlDictionaryReaderClose` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void OnXmlDictionaryReaderClose(System.Xml.XmlDictionaryReader reader);

        // Generated from `System.Xml.UniqueId` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UniqueId
        {
            public static bool operator !=(System.Xml.UniqueId id1, System.Xml.UniqueId id2) => throw null;
            public static bool operator ==(System.Xml.UniqueId id1, System.Xml.UniqueId id2) => throw null;
            public int CharArrayLength { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsGuid { get => throw null; }
            public int ToCharArray(System.Char[] chars, int offset) => throw null;
            public override string ToString() => throw null;
            public bool TryGetGuid(System.Byte[] buffer, int offset) => throw null;
            public bool TryGetGuid(out System.Guid guid) => throw null;
            public UniqueId() => throw null;
            public UniqueId(System.Byte[] guid) => throw null;
            public UniqueId(System.Byte[] guid, int offset) => throw null;
            public UniqueId(System.Char[] chars, int offset, int count) => throw null;
            public UniqueId(System.Guid guid) => throw null;
            public UniqueId(string value) => throw null;
        }

        // Generated from `System.Xml.XmlBinaryReaderSession` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlBinaryReaderSession : System.Xml.IXmlDictionary
        {
            public System.Xml.XmlDictionaryString Add(int id, string value) => throw null;
            public void Clear() => throw null;
            public bool TryLookup(System.Xml.XmlDictionaryString value, out System.Xml.XmlDictionaryString result) => throw null;
            public bool TryLookup(int key, out System.Xml.XmlDictionaryString result) => throw null;
            public bool TryLookup(string value, out System.Xml.XmlDictionaryString result) => throw null;
            public XmlBinaryReaderSession() => throw null;
        }

        // Generated from `System.Xml.XmlBinaryWriterSession` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlBinaryWriterSession
        {
            public void Reset() => throw null;
            public virtual bool TryAdd(System.Xml.XmlDictionaryString value, out int key) => throw null;
            public XmlBinaryWriterSession() => throw null;
        }

        // Generated from `System.Xml.XmlDictionary` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlDictionary : System.Xml.IXmlDictionary
        {
            public virtual System.Xml.XmlDictionaryString Add(string value) => throw null;
            public static System.Xml.IXmlDictionary Empty { get => throw null; }
            public virtual bool TryLookup(System.Xml.XmlDictionaryString value, out System.Xml.XmlDictionaryString result) => throw null;
            public virtual bool TryLookup(int key, out System.Xml.XmlDictionaryString result) => throw null;
            public virtual bool TryLookup(string value, out System.Xml.XmlDictionaryString result) => throw null;
            public XmlDictionary() => throw null;
            public XmlDictionary(int capacity) => throw null;
        }

        // Generated from `System.Xml.XmlDictionaryReader` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class XmlDictionaryReader : System.Xml.XmlReader
        {
            public virtual bool CanCanonicalize { get => throw null; }
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.Byte[] buffer, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.Byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.Byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.Byte[] buffer, int offset, int count, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.Byte[] buffer, int offset, int count, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.IXmlDictionary dictionary, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.XmlBinaryReaderSession session, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateBinaryReader(System.IO.Stream stream, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateDictionaryReader(System.Xml.XmlReader reader) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.Byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.Byte[] buffer, int offset, int count, System.Text.Encoding[] encodings, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.Byte[] buffer, int offset, int count, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.Byte[] buffer, int offset, int count, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas, int maxBufferSize, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding[] encodings, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateMtomReader(System.IO.Stream stream, System.Text.Encoding[] encodings, string contentType, System.Xml.XmlDictionaryReaderQuotas quotas, int maxBufferSize, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.Byte[] buffer, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.Byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.Byte[] buffer, int offset, int count, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
            public static System.Xml.XmlDictionaryReader CreateTextReader(System.IO.Stream stream, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public virtual void EndCanonicalization() => throw null;
            public virtual string GetAttribute(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void GetNonAtomizedNames(out string localName, out string namespaceUri) => throw null;
            public virtual int IndexOfLocalName(string[] localNames, string namespaceUri) => throw null;
            public virtual int IndexOfLocalName(System.Xml.XmlDictionaryString[] localNames, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool IsLocalName(System.Xml.XmlDictionaryString localName) => throw null;
            public virtual bool IsLocalName(string localName) => throw null;
            public virtual bool IsNamespaceUri(System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool IsNamespaceUri(string namespaceUri) => throw null;
            public virtual bool IsStartArray(out System.Type type) => throw null;
            public virtual bool IsStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            protected bool IsTextNode(System.Xml.XmlNodeType nodeType) => throw null;
            public virtual void MoveToStartElement() => throw null;
            public virtual void MoveToStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void MoveToStartElement(string name) => throw null;
            public virtual void MoveToStartElement(string localName, string namespaceUri) => throw null;
            public virtual System.Xml.XmlDictionaryReaderQuotas Quotas { get => throw null; }
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Decimal[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Int16[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Int64[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual int ReadArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.Decimal[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.Int16[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.Int64[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual int ReadArray(string localName, string namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public virtual bool[] ReadBooleanArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool[] ReadBooleanArray(string localName, string namespaceUri) => throw null;
            public override object ReadContentAs(System.Type type, System.Xml.IXmlNamespaceResolver namespaceResolver) => throw null;
            public virtual System.Byte[] ReadContentAsBase64() => throw null;
            public virtual System.Byte[] ReadContentAsBinHex() => throw null;
            protected System.Byte[] ReadContentAsBinHex(int maxByteArrayContentLength) => throw null;
            public virtual int ReadContentAsChars(System.Char[] chars, int offset, int count) => throw null;
            public override System.Decimal ReadContentAsDecimal() => throw null;
            public override float ReadContentAsFloat() => throw null;
            public virtual System.Guid ReadContentAsGuid() => throw null;
            public virtual void ReadContentAsQualifiedName(out string localName, out string namespaceUri) => throw null;
            public override string ReadContentAsString() => throw null;
            public virtual string ReadContentAsString(string[] strings, out int index) => throw null;
            public virtual string ReadContentAsString(System.Xml.XmlDictionaryString[] strings, out int index) => throw null;
            protected string ReadContentAsString(int maxStringContentLength) => throw null;
            public virtual System.TimeSpan ReadContentAsTimeSpan() => throw null;
            public virtual System.Xml.UniqueId ReadContentAsUniqueId() => throw null;
            public virtual System.DateTime[] ReadDateTimeArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.DateTime[] ReadDateTimeArray(string localName, string namespaceUri) => throw null;
            public virtual System.Decimal[] ReadDecimalArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.Decimal[] ReadDecimalArray(string localName, string namespaceUri) => throw null;
            public virtual double[] ReadDoubleArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual double[] ReadDoubleArray(string localName, string namespaceUri) => throw null;
            public virtual System.Byte[] ReadElementContentAsBase64() => throw null;
            public virtual System.Byte[] ReadElementContentAsBinHex() => throw null;
            public override bool ReadElementContentAsBoolean() => throw null;
            public override System.DateTime ReadElementContentAsDateTime() => throw null;
            public override System.Decimal ReadElementContentAsDecimal() => throw null;
            public override double ReadElementContentAsDouble() => throw null;
            public override float ReadElementContentAsFloat() => throw null;
            public virtual System.Guid ReadElementContentAsGuid() => throw null;
            public override int ReadElementContentAsInt() => throw null;
            public override System.Int64 ReadElementContentAsLong() => throw null;
            public override string ReadElementContentAsString() => throw null;
            public virtual System.TimeSpan ReadElementContentAsTimeSpan() => throw null;
            public virtual System.Xml.UniqueId ReadElementContentAsUniqueId() => throw null;
            public virtual void ReadFullStartElement() => throw null;
            public virtual void ReadFullStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void ReadFullStartElement(string name) => throw null;
            public virtual void ReadFullStartElement(string localName, string namespaceUri) => throw null;
            public virtual System.Guid[] ReadGuidArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.Guid[] ReadGuidArray(string localName, string namespaceUri) => throw null;
            public virtual System.Int16[] ReadInt16Array(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.Int16[] ReadInt16Array(string localName, string namespaceUri) => throw null;
            public virtual int[] ReadInt32Array(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual int[] ReadInt32Array(string localName, string namespaceUri) => throw null;
            public virtual System.Int64[] ReadInt64Array(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.Int64[] ReadInt64Array(string localName, string namespaceUri) => throw null;
            public virtual float[] ReadSingleArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual float[] ReadSingleArray(string localName, string namespaceUri) => throw null;
            public virtual void ReadStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public override string ReadString() => throw null;
            protected string ReadString(int maxStringContentLength) => throw null;
            public virtual System.TimeSpan[] ReadTimeSpanArray(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual System.TimeSpan[] ReadTimeSpanArray(string localName, string namespaceUri) => throw null;
            public virtual int ReadValueAsBase64(System.Byte[] buffer, int offset, int count) => throw null;
            public virtual void StartCanonicalization(System.IO.Stream stream, bool includeComments, string[] inclusivePrefixes) => throw null;
            public virtual bool TryGetArrayLength(out int count) => throw null;
            public virtual bool TryGetBase64ContentLength(out int length) => throw null;
            public virtual bool TryGetLocalNameAsDictionaryString(out System.Xml.XmlDictionaryString localName) => throw null;
            public virtual bool TryGetNamespaceUriAsDictionaryString(out System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual bool TryGetValueAsDictionaryString(out System.Xml.XmlDictionaryString value) => throw null;
            protected XmlDictionaryReader() => throw null;
        }

        // Generated from `System.Xml.XmlDictionaryReaderQuotaTypes` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum XmlDictionaryReaderQuotaTypes
        {
            MaxArrayLength,
            MaxBytesPerRead,
            MaxDepth,
            MaxNameTableCharCount,
            MaxStringContentLength,
        }

        // Generated from `System.Xml.XmlDictionaryReaderQuotas` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlDictionaryReaderQuotas
        {
            public void CopyTo(System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
            public static System.Xml.XmlDictionaryReaderQuotas Max { get => throw null; }
            public int MaxArrayLength { get => throw null; set => throw null; }
            public int MaxBytesPerRead { get => throw null; set => throw null; }
            public int MaxDepth { get => throw null; set => throw null; }
            public int MaxNameTableCharCount { get => throw null; set => throw null; }
            public int MaxStringContentLength { get => throw null; set => throw null; }
            public System.Xml.XmlDictionaryReaderQuotaTypes ModifiedQuotas { get => throw null; }
            public XmlDictionaryReaderQuotas() => throw null;
        }

        // Generated from `System.Xml.XmlDictionaryString` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlDictionaryString
        {
            public System.Xml.IXmlDictionary Dictionary { get => throw null; }
            public static System.Xml.XmlDictionaryString Empty { get => throw null; }
            public int Key { get => throw null; }
            public override string ToString() => throw null;
            public string Value { get => throw null; }
            public XmlDictionaryString(System.Xml.IXmlDictionary dictionary, string value, int key) => throw null;
        }

        // Generated from `System.Xml.XmlDictionaryWriter` in `System.Runtime.Serialization.Xml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            public virtual void EndCanonicalization() => throw null;
            public virtual void StartCanonicalization(System.IO.Stream stream, bool includeComments, string[] inclusivePrefixes) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Decimal[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Int16[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.Int64[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, bool[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.DateTime[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.Decimal[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, double[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.Guid[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.Int16[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, int[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.Int64[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, float[] array, int offset, int count) => throw null;
            public virtual void WriteArray(string prefix, string localName, string namespaceUri, System.TimeSpan[] array, int offset, int count) => throw null;
            public void WriteAttributeString(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public void WriteAttributeString(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public override System.Threading.Tasks.Task WriteBase64Async(System.Byte[] buffer, int index, int count) => throw null;
            public void WriteElementString(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public void WriteElementString(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri, string value) => throw null;
            public virtual void WriteNode(System.Xml.XmlDictionaryReader reader, bool defattr) => throw null;
            public override void WriteNode(System.Xml.XmlReader reader, bool defattr) => throw null;
            public virtual void WriteQualifiedName(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public void WriteStartAttribute(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteStartAttribute(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public void WriteStartElement(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteStartElement(string prefix, System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteString(System.Xml.XmlDictionaryString value) => throw null;
            protected virtual void WriteTextNode(System.Xml.XmlDictionaryReader reader, bool isAttribute) => throw null;
            public virtual void WriteValue(System.Guid value) => throw null;
            public virtual void WriteValue(System.Xml.IStreamProvider value) => throw null;
            public virtual void WriteValue(System.TimeSpan value) => throw null;
            public virtual void WriteValue(System.Xml.UniqueId value) => throw null;
            public virtual void WriteValue(System.Xml.XmlDictionaryString value) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Xml.IStreamProvider value) => throw null;
            public virtual void WriteXmlAttribute(System.Xml.XmlDictionaryString localName, System.Xml.XmlDictionaryString value) => throw null;
            public virtual void WriteXmlAttribute(string localName, string value) => throw null;
            public virtual void WriteXmlnsAttribute(string prefix, System.Xml.XmlDictionaryString namespaceUri) => throw null;
            public virtual void WriteXmlnsAttribute(string prefix, string namespaceUri) => throw null;
            protected XmlDictionaryWriter() => throw null;
        }

    }
}
