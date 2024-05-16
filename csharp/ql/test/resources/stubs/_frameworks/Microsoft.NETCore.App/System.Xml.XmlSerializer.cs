// This file contains auto-generated code.
// Generated from `System.Xml.XmlSerializer, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Xml
    {
        namespace Serialization
        {
            [System.Flags]
            public enum CodeGenerationOptions
            {
                None = 0,
                GenerateProperties = 1,
                GenerateNewAsync = 2,
                GenerateOldAsync = 4,
                GenerateOrder = 8,
                EnableDataBinding = 16,
            }
            public class CodeIdentifier
            {
                public CodeIdentifier() => throw null;
                public static string MakeCamel(string identifier) => throw null;
                public static string MakePascal(string identifier) => throw null;
                public static string MakeValid(string identifier) => throw null;
            }
            public class CodeIdentifiers
            {
                public void Add(string identifier, object value) => throw null;
                public void AddReserved(string identifier) => throw null;
                public string AddUnique(string identifier, object value) => throw null;
                public void Clear() => throw null;
                public CodeIdentifiers() => throw null;
                public CodeIdentifiers(bool caseSensitive) => throw null;
                public bool IsInUse(string identifier) => throw null;
                public string MakeRightCase(string identifier) => throw null;
                public string MakeUnique(string identifier) => throw null;
                public void Remove(string identifier) => throw null;
                public void RemoveReserved(string identifier) => throw null;
                public object ToArray(System.Type type) => throw null;
                public bool UseCamelCasing { get => throw null; set { } }
            }
            public class ImportContext
            {
                public ImportContext(System.Xml.Serialization.CodeIdentifiers identifiers, bool shareTypes) => throw null;
                public bool ShareTypes { get => throw null; }
                public System.Xml.Serialization.CodeIdentifiers TypeIdentifiers { get => throw null; }
                public System.Collections.Specialized.StringCollection Warnings { get => throw null; }
            }
            public interface IXmlTextParser
            {
                bool Normalized { get; set; }
                System.Xml.WhitespaceHandling WhitespaceHandling { get; set; }
            }
            public abstract class SchemaImporter
            {
            }
            [System.AttributeUsage((System.AttributeTargets)10624)]
            public class SoapAttributeAttribute : System.Attribute
            {
                public string AttributeName { get => throw null; set { } }
                public SoapAttributeAttribute() => throw null;
                public SoapAttributeAttribute(string attributeName) => throw null;
                public string DataType { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
            }
            public class SoapAttributeOverrides
            {
                public void Add(System.Type type, string member, System.Xml.Serialization.SoapAttributes attributes) => throw null;
                public void Add(System.Type type, System.Xml.Serialization.SoapAttributes attributes) => throw null;
                public SoapAttributeOverrides() => throw null;
                public System.Xml.Serialization.SoapAttributes this[System.Type type] { get => throw null; }
                public System.Xml.Serialization.SoapAttributes this[System.Type type, string member] { get => throw null; }
            }
            public class SoapAttributes
            {
                public SoapAttributes() => throw null;
                public SoapAttributes(System.Reflection.ICustomAttributeProvider provider) => throw null;
                public System.Xml.Serialization.SoapAttributeAttribute SoapAttribute { get => throw null; set { } }
                public object SoapDefaultValue { get => throw null; set { } }
                public System.Xml.Serialization.SoapElementAttribute SoapElement { get => throw null; set { } }
                public System.Xml.Serialization.SoapEnumAttribute SoapEnum { get => throw null; set { } }
                public bool SoapIgnore { get => throw null; set { } }
                public System.Xml.Serialization.SoapTypeAttribute SoapType { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)10624)]
            public class SoapElementAttribute : System.Attribute
            {
                public SoapElementAttribute() => throw null;
                public SoapElementAttribute(string elementName) => throw null;
                public string DataType { get => throw null; set { } }
                public string ElementName { get => throw null; set { } }
                public bool IsNullable { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)256)]
            public class SoapEnumAttribute : System.Attribute
            {
                public SoapEnumAttribute() => throw null;
                public SoapEnumAttribute(string name) => throw null;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)10624)]
            public class SoapIgnoreAttribute : System.Attribute
            {
                public SoapIgnoreAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1100, AllowMultiple = true)]
            public class SoapIncludeAttribute : System.Attribute
            {
                public SoapIncludeAttribute(System.Type type) => throw null;
                public System.Type Type { get => throw null; set { } }
            }
            public class SoapReflectionImporter
            {
                public SoapReflectionImporter() => throw null;
                public SoapReflectionImporter(string defaultNamespace) => throw null;
                public SoapReflectionImporter(System.Xml.Serialization.SoapAttributeOverrides attributeOverrides) => throw null;
                public SoapReflectionImporter(System.Xml.Serialization.SoapAttributeOverrides attributeOverrides, string defaultNamespace) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement, bool writeAccessors) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement, bool writeAccessors, bool validate) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement, bool writeAccessors, bool validate, System.Xml.Serialization.XmlMappingAccess access) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Type type) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Type type, string defaultNamespace) => throw null;
                public void IncludeType(System.Type type) => throw null;
                public void IncludeTypes(System.Reflection.ICustomAttributeProvider provider) => throw null;
            }
            public class SoapSchemaMember
            {
                public SoapSchemaMember() => throw null;
                public string MemberName { get => throw null; set { } }
                public System.Xml.XmlQualifiedName MemberType { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)1052)]
            public class SoapTypeAttribute : System.Attribute
            {
                public SoapTypeAttribute() => throw null;
                public SoapTypeAttribute(string typeName) => throw null;
                public SoapTypeAttribute(string typeName, string ns) => throw null;
                public bool IncludeInSchema { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
                public string TypeName { get => throw null; set { } }
            }
            public class UnreferencedObjectEventArgs : System.EventArgs
            {
                public UnreferencedObjectEventArgs(object o, string id) => throw null;
                public string UnreferencedId { get => throw null; }
                public object UnreferencedObject { get => throw null; }
            }
            public delegate void UnreferencedObjectEventHandler(object sender, System.Xml.Serialization.UnreferencedObjectEventArgs e);
            public class XmlAnyElementAttributes : System.Collections.CollectionBase
            {
                public int Add(System.Xml.Serialization.XmlAnyElementAttribute attribute) => throw null;
                public bool Contains(System.Xml.Serialization.XmlAnyElementAttribute attribute) => throw null;
                public void CopyTo(System.Xml.Serialization.XmlAnyElementAttribute[] array, int index) => throw null;
                public XmlAnyElementAttributes() => throw null;
                public int IndexOf(System.Xml.Serialization.XmlAnyElementAttribute attribute) => throw null;
                public void Insert(int index, System.Xml.Serialization.XmlAnyElementAttribute attribute) => throw null;
                public void Remove(System.Xml.Serialization.XmlAnyElementAttribute attribute) => throw null;
                public System.Xml.Serialization.XmlAnyElementAttribute this[int index] { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)10624, AllowMultiple = false)]
            public class XmlArrayAttribute : System.Attribute
            {
                public XmlArrayAttribute() => throw null;
                public XmlArrayAttribute(string elementName) => throw null;
                public string ElementName { get => throw null; set { } }
                public System.Xml.Schema.XmlSchemaForm Form { get => throw null; set { } }
                public bool IsNullable { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
                public int Order { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)10624, AllowMultiple = true)]
            public class XmlArrayItemAttribute : System.Attribute
            {
                public XmlArrayItemAttribute() => throw null;
                public XmlArrayItemAttribute(string elementName) => throw null;
                public XmlArrayItemAttribute(string elementName, System.Type type) => throw null;
                public XmlArrayItemAttribute(System.Type type) => throw null;
                public string DataType { get => throw null; set { } }
                public string ElementName { get => throw null; set { } }
                public System.Xml.Schema.XmlSchemaForm Form { get => throw null; set { } }
                public bool IsNullable { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
                public int NestingLevel { get => throw null; set { } }
                public System.Type Type { get => throw null; set { } }
            }
            public class XmlArrayItemAttributes : System.Collections.CollectionBase
            {
                public int Add(System.Xml.Serialization.XmlArrayItemAttribute attribute) => throw null;
                public bool Contains(System.Xml.Serialization.XmlArrayItemAttribute attribute) => throw null;
                public void CopyTo(System.Xml.Serialization.XmlArrayItemAttribute[] array, int index) => throw null;
                public XmlArrayItemAttributes() => throw null;
                public int IndexOf(System.Xml.Serialization.XmlArrayItemAttribute attribute) => throw null;
                public void Insert(int index, System.Xml.Serialization.XmlArrayItemAttribute attribute) => throw null;
                public void Remove(System.Xml.Serialization.XmlArrayItemAttribute attribute) => throw null;
                public System.Xml.Serialization.XmlArrayItemAttribute this[int index] { get => throw null; set { } }
            }
            public class XmlAttributeEventArgs : System.EventArgs
            {
                public System.Xml.XmlAttribute Attr { get => throw null; }
                public string ExpectedAttributes { get => throw null; }
                public int LineNumber { get => throw null; }
                public int LinePosition { get => throw null; }
                public object ObjectBeingDeserialized { get => throw null; }
            }
            public delegate void XmlAttributeEventHandler(object sender, System.Xml.Serialization.XmlAttributeEventArgs e);
            public class XmlAttributeOverrides
            {
                public void Add(System.Type type, string member, System.Xml.Serialization.XmlAttributes attributes) => throw null;
                public void Add(System.Type type, System.Xml.Serialization.XmlAttributes attributes) => throw null;
                public XmlAttributeOverrides() => throw null;
                public System.Xml.Serialization.XmlAttributes this[System.Type type] { get => throw null; }
                public System.Xml.Serialization.XmlAttributes this[System.Type type, string member] { get => throw null; }
            }
            public class XmlAttributes
            {
                public XmlAttributes() => throw null;
                public XmlAttributes(System.Reflection.ICustomAttributeProvider provider) => throw null;
                public System.Xml.Serialization.XmlAnyAttributeAttribute XmlAnyAttribute { get => throw null; set { } }
                public System.Xml.Serialization.XmlAnyElementAttributes XmlAnyElements { get => throw null; }
                public System.Xml.Serialization.XmlArrayAttribute XmlArray { get => throw null; set { } }
                public System.Xml.Serialization.XmlArrayItemAttributes XmlArrayItems { get => throw null; }
                public System.Xml.Serialization.XmlAttributeAttribute XmlAttribute { get => throw null; set { } }
                public System.Xml.Serialization.XmlChoiceIdentifierAttribute XmlChoiceIdentifier { get => throw null; }
                public object XmlDefaultValue { get => throw null; set { } }
                public System.Xml.Serialization.XmlElementAttributes XmlElements { get => throw null; }
                public System.Xml.Serialization.XmlEnumAttribute XmlEnum { get => throw null; set { } }
                public bool XmlIgnore { get => throw null; set { } }
                public bool Xmlns { get => throw null; set { } }
                public System.Xml.Serialization.XmlRootAttribute XmlRoot { get => throw null; set { } }
                public System.Xml.Serialization.XmlTextAttribute XmlText { get => throw null; set { } }
                public System.Xml.Serialization.XmlTypeAttribute XmlType { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)10624, AllowMultiple = false)]
            public class XmlChoiceIdentifierAttribute : System.Attribute
            {
                public XmlChoiceIdentifierAttribute() => throw null;
                public XmlChoiceIdentifierAttribute(string name) => throw null;
                public string MemberName { get => throw null; set { } }
            }
            public struct XmlDeserializationEvents
            {
                public System.Xml.Serialization.XmlAttributeEventHandler OnUnknownAttribute { get => throw null; set { } }
                public System.Xml.Serialization.XmlElementEventHandler OnUnknownElement { get => throw null; set { } }
                public System.Xml.Serialization.XmlNodeEventHandler OnUnknownNode { get => throw null; set { } }
                public System.Xml.Serialization.UnreferencedObjectEventHandler OnUnreferencedObject { get => throw null; set { } }
            }
            public class XmlElementAttributes : System.Collections.CollectionBase
            {
                public int Add(System.Xml.Serialization.XmlElementAttribute attribute) => throw null;
                public bool Contains(System.Xml.Serialization.XmlElementAttribute attribute) => throw null;
                public void CopyTo(System.Xml.Serialization.XmlElementAttribute[] array, int index) => throw null;
                public XmlElementAttributes() => throw null;
                public int IndexOf(System.Xml.Serialization.XmlElementAttribute attribute) => throw null;
                public void Insert(int index, System.Xml.Serialization.XmlElementAttribute attribute) => throw null;
                public void Remove(System.Xml.Serialization.XmlElementAttribute attribute) => throw null;
                public System.Xml.Serialization.XmlElementAttribute this[int index] { get => throw null; set { } }
            }
            public class XmlElementEventArgs : System.EventArgs
            {
                public System.Xml.XmlElement Element { get => throw null; }
                public string ExpectedElements { get => throw null; }
                public int LineNumber { get => throw null; }
                public int LinePosition { get => throw null; }
                public object ObjectBeingDeserialized { get => throw null; }
            }
            public delegate void XmlElementEventHandler(object sender, System.Xml.Serialization.XmlElementEventArgs e);
            [System.AttributeUsage((System.AttributeTargets)1100, AllowMultiple = true)]
            public class XmlIncludeAttribute : System.Attribute
            {
                public XmlIncludeAttribute(System.Type type) => throw null;
                public System.Type Type { get => throw null; set { } }
            }
            public abstract class XmlMapping
            {
                public string ElementName { get => throw null; }
                public string Namespace { get => throw null; }
                public void SetKey(string key) => throw null;
                public string XsdElementName { get => throw null; }
            }
            [System.Flags]
            public enum XmlMappingAccess
            {
                None = 0,
                Read = 1,
                Write = 2,
            }
            public class XmlMemberMapping
            {
                public bool Any { get => throw null; }
                public bool CheckSpecified { get => throw null; }
                public string ElementName { get => throw null; }
                public string MemberName { get => throw null; }
                public string Namespace { get => throw null; }
                public string TypeFullName { get => throw null; }
                public string TypeName { get => throw null; }
                public string TypeNamespace { get => throw null; }
                public string XsdElementName { get => throw null; }
            }
            public class XmlMembersMapping : System.Xml.Serialization.XmlMapping
            {
                public int Count { get => throw null; }
                public System.Xml.Serialization.XmlMemberMapping this[int index] { get => throw null; }
                public string TypeName { get => throw null; }
                public string TypeNamespace { get => throw null; }
            }
            public class XmlNodeEventArgs : System.EventArgs
            {
                public int LineNumber { get => throw null; }
                public int LinePosition { get => throw null; }
                public string LocalName { get => throw null; }
                public string Name { get => throw null; }
                public string NamespaceURI { get => throw null; }
                public System.Xml.XmlNodeType NodeType { get => throw null; }
                public object ObjectBeingDeserialized { get => throw null; }
                public string Text { get => throw null; }
            }
            public delegate void XmlNodeEventHandler(object sender, System.Xml.Serialization.XmlNodeEventArgs e);
            public class XmlReflectionImporter
            {
                public XmlReflectionImporter() => throw null;
                public XmlReflectionImporter(string defaultNamespace) => throw null;
                public XmlReflectionImporter(System.Xml.Serialization.XmlAttributeOverrides attributeOverrides) => throw null;
                public XmlReflectionImporter(System.Xml.Serialization.XmlAttributeOverrides attributeOverrides, string defaultNamespace) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement, bool rpc) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement, bool rpc, bool openModel) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string elementName, string ns, System.Xml.Serialization.XmlReflectionMember[] members, bool hasWrapperElement, bool rpc, bool openModel, System.Xml.Serialization.XmlMappingAccess access) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Type type) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Type type, string defaultNamespace) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Type type, System.Xml.Serialization.XmlRootAttribute root) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Type type, System.Xml.Serialization.XmlRootAttribute root, string defaultNamespace) => throw null;
                public void IncludeType(System.Type type) => throw null;
                public void IncludeTypes(System.Reflection.ICustomAttributeProvider provider) => throw null;
            }
            public class XmlReflectionMember
            {
                public XmlReflectionMember() => throw null;
                public bool IsReturnValue { get => throw null; set { } }
                public string MemberName { get => throw null; set { } }
                public System.Type MemberType { get => throw null; set { } }
                public bool OverrideIsNullable { get => throw null; set { } }
                public System.Xml.Serialization.SoapAttributes SoapAttributes { get => throw null; set { } }
                public System.Xml.Serialization.XmlAttributes XmlAttributes { get => throw null; set { } }
            }
            public class XmlSchemaEnumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Xml.Schema.XmlSchema>, System.Collections.IEnumerator
            {
                public XmlSchemaEnumerator(System.Xml.Serialization.XmlSchemas list) => throw null;
                public System.Xml.Schema.XmlSchema Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public void Dispose() => throw null;
                public bool MoveNext() => throw null;
                void System.Collections.IEnumerator.Reset() => throw null;
            }
            public class XmlSchemaExporter
            {
                public XmlSchemaExporter(System.Xml.Serialization.XmlSchemas schemas) => throw null;
                public string ExportAnyType(string ns) => throw null;
                public string ExportAnyType(System.Xml.Serialization.XmlMembersMapping members) => throw null;
                public void ExportMembersMapping(System.Xml.Serialization.XmlMembersMapping xmlMembersMapping) => throw null;
                public void ExportMembersMapping(System.Xml.Serialization.XmlMembersMapping xmlMembersMapping, bool exportEnclosingType) => throw null;
                public System.Xml.XmlQualifiedName ExportTypeMapping(System.Xml.Serialization.XmlMembersMapping xmlMembersMapping) => throw null;
                public void ExportTypeMapping(System.Xml.Serialization.XmlTypeMapping xmlTypeMapping) => throw null;
            }
            public class XmlSchemaImporter : System.Xml.Serialization.SchemaImporter
            {
                public XmlSchemaImporter(System.Xml.Serialization.XmlSchemas schemas) => throw null;
                public XmlSchemaImporter(System.Xml.Serialization.XmlSchemas schemas, System.Xml.Serialization.CodeIdentifiers typeIdentifiers) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportAnyType(System.Xml.XmlQualifiedName typeName, string elementName) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportDerivedTypeMapping(System.Xml.XmlQualifiedName name, System.Type baseType) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportDerivedTypeMapping(System.Xml.XmlQualifiedName name, System.Type baseType, bool baseTypeCanBeIndirect) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(string name, string ns, System.Xml.Serialization.SoapSchemaMember[] members) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(System.Xml.XmlQualifiedName name) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(System.Xml.XmlQualifiedName[] names) => throw null;
                public System.Xml.Serialization.XmlMembersMapping ImportMembersMapping(System.Xml.XmlQualifiedName[] names, System.Type baseType, bool baseTypeCanBeIndirect) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportSchemaType(System.Xml.XmlQualifiedName typeName) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportSchemaType(System.Xml.XmlQualifiedName typeName, System.Type baseType) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportSchemaType(System.Xml.XmlQualifiedName typeName, System.Type baseType, bool baseTypeCanBeIndirect) => throw null;
                public System.Xml.Serialization.XmlTypeMapping ImportTypeMapping(System.Xml.XmlQualifiedName name) => throw null;
            }
            public class XmlSchemas : System.Collections.CollectionBase, System.Collections.Generic.IEnumerable<System.Xml.Schema.XmlSchema>, System.Collections.IEnumerable
            {
                public int Add(System.Xml.Schema.XmlSchema schema) => throw null;
                public int Add(System.Xml.Schema.XmlSchema schema, System.Uri baseUri) => throw null;
                public void Add(System.Xml.Serialization.XmlSchemas schemas) => throw null;
                public void AddReference(System.Xml.Schema.XmlSchema schema) => throw null;
                public void Compile(System.Xml.Schema.ValidationEventHandler handler, bool fullCompile) => throw null;
                public bool Contains(string targetNamespace) => throw null;
                public bool Contains(System.Xml.Schema.XmlSchema schema) => throw null;
                public void CopyTo(System.Xml.Schema.XmlSchema[] array, int index) => throw null;
                public XmlSchemas() => throw null;
                public object Find(System.Xml.XmlQualifiedName name, System.Type type) => throw null;
                System.Collections.Generic.IEnumerator<System.Xml.Schema.XmlSchema> System.Collections.Generic.IEnumerable<System.Xml.Schema.XmlSchema>.GetEnumerator() => throw null;
                public System.Collections.IList GetSchemas(string ns) => throw null;
                public int IndexOf(System.Xml.Schema.XmlSchema schema) => throw null;
                public void Insert(int index, System.Xml.Schema.XmlSchema schema) => throw null;
                public bool IsCompiled { get => throw null; }
                public static bool IsDataSet(System.Xml.Schema.XmlSchema schema) => throw null;
                protected override void OnClear() => throw null;
                protected override void OnInsert(int index, object value) => throw null;
                protected override void OnRemove(int index, object value) => throw null;
                protected override void OnSet(int index, object oldValue, object newValue) => throw null;
                public void Remove(System.Xml.Schema.XmlSchema schema) => throw null;
                public System.Xml.Schema.XmlSchema this[int index] { get => throw null; set { } }
                public System.Xml.Schema.XmlSchema this[string ns] { get => throw null; }
            }
            public delegate void XmlSerializationCollectionFixupCallback(object collection, object collectionItems);
            public delegate void XmlSerializationFixupCallback(object fixup);
            public abstract class XmlSerializationGeneratedCode
            {
                protected XmlSerializationGeneratedCode() => throw null;
            }
            public delegate object XmlSerializationReadCallback();
            public abstract class XmlSerializationReader : System.Xml.Serialization.XmlSerializationGeneratedCode
            {
                protected void AddFixup(System.Xml.Serialization.XmlSerializationReader.CollectionFixup fixup) => throw null;
                protected void AddFixup(System.Xml.Serialization.XmlSerializationReader.Fixup fixup) => throw null;
                protected void AddReadCallback(string name, string ns, System.Type type, System.Xml.Serialization.XmlSerializationReadCallback read) => throw null;
                protected void AddTarget(string id, object o) => throw null;
                protected void CheckReaderCount(ref int whileIterations, ref int readerCount) => throw null;
                protected string CollapseWhitespace(string value) => throw null;
                protected class CollectionFixup
                {
                    public System.Xml.Serialization.XmlSerializationCollectionFixupCallback Callback { get => throw null; }
                    public object Collection { get => throw null; }
                    public object CollectionItems { get => throw null; }
                    public CollectionFixup(object collection, System.Xml.Serialization.XmlSerializationCollectionFixupCallback callback, object collectionItems) => throw null;
                }
                protected System.Exception CreateAbstractTypeException(string name, string ns) => throw null;
                protected System.Exception CreateBadDerivationException(string xsdDerived, string nsDerived, string xsdBase, string nsBase, string clrDerived, string clrBase) => throw null;
                protected System.Exception CreateCtorHasSecurityException(string typeName) => throw null;
                protected System.Exception CreateInaccessibleConstructorException(string typeName) => throw null;
                protected System.Exception CreateInvalidCastException(System.Type type, object value) => throw null;
                protected System.Exception CreateInvalidCastException(System.Type type, object value, string id) => throw null;
                protected System.Exception CreateMissingIXmlSerializableType(string name, string ns, string clrType) => throw null;
                protected System.Exception CreateReadOnlyCollectionException(string name) => throw null;
                protected System.Exception CreateUnknownConstantException(string value, System.Type enumType) => throw null;
                protected System.Exception CreateUnknownNodeException() => throw null;
                protected System.Exception CreateUnknownTypeException(System.Xml.XmlQualifiedName type) => throw null;
                protected XmlSerializationReader() => throw null;
                protected bool DecodeName { get => throw null; set { } }
                protected System.Xml.XmlDocument Document { get => throw null; }
                protected System.Array EnsureArrayIndex(System.Array a, int index, System.Type elementType) => throw null;
                protected class Fixup
                {
                    public System.Xml.Serialization.XmlSerializationFixupCallback Callback { get => throw null; }
                    public Fixup(object o, System.Xml.Serialization.XmlSerializationFixupCallback callback, int count) => throw null;
                    public Fixup(object o, System.Xml.Serialization.XmlSerializationFixupCallback callback, string[] ids) => throw null;
                    public string[] Ids { get => throw null; }
                    public object Source { get => throw null; set { } }
                }
                protected void FixupArrayRefs(object fixup) => throw null;
                protected int GetArrayLength(string name, string ns) => throw null;
                protected bool GetNullAttr() => throw null;
                protected object GetTarget(string id) => throw null;
                protected System.Xml.XmlQualifiedName GetXsiType() => throw null;
                protected abstract void InitCallbacks();
                protected abstract void InitIDs();
                protected bool IsReturnValue { get => throw null; set { } }
                protected bool IsXmlnsAttribute(string name) => throw null;
                protected void ParseWsdlArrayType(System.Xml.XmlAttribute attr) => throw null;
                protected System.Xml.XmlQualifiedName ReadElementQualifiedName() => throw null;
                protected void ReadEndElement() => throw null;
                protected System.Xml.XmlReader Reader { get => throw null; }
                protected int ReaderCount { get => throw null; }
                protected bool ReadNull() => throw null;
                protected System.Xml.XmlQualifiedName ReadNullableQualifiedName() => throw null;
                protected string ReadNullableString() => throw null;
                protected bool ReadReference(out string fixupReference) => throw null;
                protected object ReadReferencedElement() => throw null;
                protected object ReadReferencedElement(string name, string ns) => throw null;
                protected void ReadReferencedElements() => throw null;
                protected object ReadReferencingElement(string name, string ns, bool elementCanBeType, out string fixupReference) => throw null;
                protected object ReadReferencingElement(string name, string ns, out string fixupReference) => throw null;
                protected object ReadReferencingElement(out string fixupReference) => throw null;
                protected System.Xml.Serialization.IXmlSerializable ReadSerializable(System.Xml.Serialization.IXmlSerializable serializable) => throw null;
                protected System.Xml.Serialization.IXmlSerializable ReadSerializable(System.Xml.Serialization.IXmlSerializable serializable, bool wrappedAny) => throw null;
                protected string ReadString(string value) => throw null;
                protected string ReadString(string value, bool trim) => throw null;
                protected object ReadTypedNull(System.Xml.XmlQualifiedName type) => throw null;
                protected object ReadTypedPrimitive(System.Xml.XmlQualifiedName type) => throw null;
                protected System.Xml.XmlDocument ReadXmlDocument(bool wrapped) => throw null;
                protected System.Xml.XmlNode ReadXmlNode(bool wrapped) => throw null;
                protected void Referenced(object o) => throw null;
                protected static System.Reflection.Assembly ResolveDynamicAssembly(string assemblyFullName) => throw null;
                protected System.Array ShrinkArray(System.Array a, int length, System.Type elementType, bool isNullable) => throw null;
                protected byte[] ToByteArrayBase64(bool isNull) => throw null;
                protected static byte[] ToByteArrayBase64(string value) => throw null;
                protected byte[] ToByteArrayHex(bool isNull) => throw null;
                protected static byte[] ToByteArrayHex(string value) => throw null;
                protected static char ToChar(string value) => throw null;
                protected static System.DateTime ToDate(string value) => throw null;
                protected static System.DateTime ToDateTime(string value) => throw null;
                protected static long ToEnum(string value, System.Collections.Hashtable h, string typeName) => throw null;
                protected static System.DateTime ToTime(string value) => throw null;
                protected static string ToXmlName(string value) => throw null;
                protected static string ToXmlNCName(string value) => throw null;
                protected static string ToXmlNmToken(string value) => throw null;
                protected static string ToXmlNmTokens(string value) => throw null;
                protected System.Xml.XmlQualifiedName ToXmlQualifiedName(string value) => throw null;
                protected void UnknownAttribute(object o, System.Xml.XmlAttribute attr) => throw null;
                protected void UnknownAttribute(object o, System.Xml.XmlAttribute attr, string qnames) => throw null;
                protected void UnknownElement(object o, System.Xml.XmlElement elem) => throw null;
                protected void UnknownElement(object o, System.Xml.XmlElement elem, string qnames) => throw null;
                protected void UnknownNode(object o) => throw null;
                protected void UnknownNode(object o, string qnames) => throw null;
                protected void UnreferencedObject(string id, object o) => throw null;
            }
            public delegate void XmlSerializationWriteCallback(object o);
            public abstract class XmlSerializationWriter : System.Xml.Serialization.XmlSerializationGeneratedCode
            {
                protected void AddWriteCallback(System.Type type, string typeName, string typeNs, System.Xml.Serialization.XmlSerializationWriteCallback callback) => throw null;
                protected System.Exception CreateChoiceIdentifierValueException(string value, string identifier, string name, string ns) => throw null;
                protected System.Exception CreateInvalidAnyTypeException(object o) => throw null;
                protected System.Exception CreateInvalidAnyTypeException(System.Type type) => throw null;
                protected System.Exception CreateInvalidChoiceIdentifierValueException(string type, string identifier) => throw null;
                protected System.Exception CreateInvalidEnumValueException(object value, string typeName) => throw null;
                protected System.Exception CreateMismatchChoiceException(string value, string elementName, string enumValue) => throw null;
                protected System.Exception CreateUnknownAnyElementException(string name, string ns) => throw null;
                protected System.Exception CreateUnknownTypeException(object o) => throw null;
                protected System.Exception CreateUnknownTypeException(System.Type type) => throw null;
                protected XmlSerializationWriter() => throw null;
                protected bool EscapeName { get => throw null; set { } }
                protected static byte[] FromByteArrayBase64(byte[] value) => throw null;
                protected static string FromByteArrayHex(byte[] value) => throw null;
                protected static string FromChar(char value) => throw null;
                protected static string FromDate(System.DateTime value) => throw null;
                protected static string FromDateTime(System.DateTime value) => throw null;
                protected static string FromEnum(long value, string[] values, long[] ids) => throw null;
                protected static string FromEnum(long value, string[] values, long[] ids, string typeName) => throw null;
                protected static string FromTime(System.DateTime value) => throw null;
                protected static string FromXmlName(string name) => throw null;
                protected static string FromXmlNCName(string ncName) => throw null;
                protected static string FromXmlNmToken(string nmToken) => throw null;
                protected static string FromXmlNmTokens(string nmTokens) => throw null;
                protected string FromXmlQualifiedName(System.Xml.XmlQualifiedName xmlQualifiedName) => throw null;
                protected string FromXmlQualifiedName(System.Xml.XmlQualifiedName xmlQualifiedName, bool ignoreEmpty) => throw null;
                protected abstract void InitCallbacks();
                protected System.Collections.ArrayList Namespaces { get => throw null; set { } }
                protected static System.Reflection.Assembly ResolveDynamicAssembly(string assemblyFullName) => throw null;
                protected void TopLevelElement() => throw null;
                protected void WriteAttribute(string localName, byte[] value) => throw null;
                protected void WriteAttribute(string localName, string value) => throw null;
                protected void WriteAttribute(string localName, string ns, byte[] value) => throw null;
                protected void WriteAttribute(string localName, string ns, string value) => throw null;
                protected void WriteAttribute(string prefix, string localName, string ns, string value) => throw null;
                protected void WriteElementEncoded(System.Xml.XmlNode node, string name, string ns, bool isNullable, bool any) => throw null;
                protected void WriteElementLiteral(System.Xml.XmlNode node, string name, string ns, bool isNullable, bool any) => throw null;
                protected void WriteElementQualifiedName(string localName, string ns, System.Xml.XmlQualifiedName value) => throw null;
                protected void WriteElementQualifiedName(string localName, string ns, System.Xml.XmlQualifiedName value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementQualifiedName(string localName, System.Xml.XmlQualifiedName value) => throw null;
                protected void WriteElementQualifiedName(string localName, System.Xml.XmlQualifiedName value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementString(string localName, string value) => throw null;
                protected void WriteElementString(string localName, string ns, string value) => throw null;
                protected void WriteElementString(string localName, string ns, string value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementString(string localName, string value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementStringRaw(string localName, byte[] value) => throw null;
                protected void WriteElementStringRaw(string localName, byte[] value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementStringRaw(string localName, string value) => throw null;
                protected void WriteElementStringRaw(string localName, string ns, byte[] value) => throw null;
                protected void WriteElementStringRaw(string localName, string ns, byte[] value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementStringRaw(string localName, string ns, string value) => throw null;
                protected void WriteElementStringRaw(string localName, string ns, string value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteElementStringRaw(string localName, string value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteEmptyTag(string name) => throw null;
                protected void WriteEmptyTag(string name, string ns) => throw null;
                protected void WriteEndElement() => throw null;
                protected void WriteEndElement(object o) => throw null;
                protected void WriteId(object o) => throw null;
                protected void WriteNamespaceDeclarations(System.Xml.Serialization.XmlSerializerNamespaces xmlns) => throw null;
                protected void WriteNullableQualifiedNameEncoded(string name, string ns, System.Xml.XmlQualifiedName value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteNullableQualifiedNameLiteral(string name, string ns, System.Xml.XmlQualifiedName value) => throw null;
                protected void WriteNullableStringEncoded(string name, string ns, string value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteNullableStringEncodedRaw(string name, string ns, byte[] value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteNullableStringEncodedRaw(string name, string ns, string value, System.Xml.XmlQualifiedName xsiType) => throw null;
                protected void WriteNullableStringLiteral(string name, string ns, string value) => throw null;
                protected void WriteNullableStringLiteralRaw(string name, string ns, byte[] value) => throw null;
                protected void WriteNullableStringLiteralRaw(string name, string ns, string value) => throw null;
                protected void WriteNullTagEncoded(string name) => throw null;
                protected void WriteNullTagEncoded(string name, string ns) => throw null;
                protected void WriteNullTagLiteral(string name) => throw null;
                protected void WriteNullTagLiteral(string name, string ns) => throw null;
                protected void WritePotentiallyReferencingElement(string n, string ns, object o) => throw null;
                protected void WritePotentiallyReferencingElement(string n, string ns, object o, System.Type ambientType) => throw null;
                protected void WritePotentiallyReferencingElement(string n, string ns, object o, System.Type ambientType, bool suppressReference) => throw null;
                protected void WritePotentiallyReferencingElement(string n, string ns, object o, System.Type ambientType, bool suppressReference, bool isNullable) => throw null;
                protected System.Xml.XmlWriter Writer { get => throw null; set { } }
                protected void WriteReferencedElements() => throw null;
                protected void WriteReferencingElement(string n, string ns, object o) => throw null;
                protected void WriteReferencingElement(string n, string ns, object o, bool isNullable) => throw null;
                protected void WriteRpcResult(string name, string ns) => throw null;
                protected void WriteSerializable(System.Xml.Serialization.IXmlSerializable serializable, string name, string ns, bool isNullable) => throw null;
                protected void WriteSerializable(System.Xml.Serialization.IXmlSerializable serializable, string name, string ns, bool isNullable, bool wrapped) => throw null;
                protected void WriteStartDocument() => throw null;
                protected void WriteStartElement(string name) => throw null;
                protected void WriteStartElement(string name, string ns) => throw null;
                protected void WriteStartElement(string name, string ns, bool writePrefixed) => throw null;
                protected void WriteStartElement(string name, string ns, object o) => throw null;
                protected void WriteStartElement(string name, string ns, object o, bool writePrefixed) => throw null;
                protected void WriteStartElement(string name, string ns, object o, bool writePrefixed, System.Xml.Serialization.XmlSerializerNamespaces xmlns) => throw null;
                protected void WriteTypedPrimitive(string name, string ns, object o, bool xsiType) => throw null;
                protected void WriteValue(byte[] value) => throw null;
                protected void WriteValue(string value) => throw null;
                protected void WriteXmlAttribute(System.Xml.XmlNode node) => throw null;
                protected void WriteXmlAttribute(System.Xml.XmlNode node, object container) => throw null;
                protected void WriteXsiType(string name, string ns) => throw null;
            }
            public class XmlSerializer
            {
                public virtual bool CanDeserialize(System.Xml.XmlReader xmlReader) => throw null;
                protected virtual System.Xml.Serialization.XmlSerializationReader CreateReader() => throw null;
                protected virtual System.Xml.Serialization.XmlSerializationWriter CreateWriter() => throw null;
                protected XmlSerializer() => throw null;
                public XmlSerializer(System.Type type) => throw null;
                public XmlSerializer(System.Type type, string defaultNamespace) => throw null;
                public XmlSerializer(System.Type type, System.Type[] extraTypes) => throw null;
                public XmlSerializer(System.Type type, System.Xml.Serialization.XmlAttributeOverrides overrides) => throw null;
                public XmlSerializer(System.Type type, System.Xml.Serialization.XmlAttributeOverrides overrides, System.Type[] extraTypes, System.Xml.Serialization.XmlRootAttribute root, string defaultNamespace) => throw null;
                public XmlSerializer(System.Type type, System.Xml.Serialization.XmlAttributeOverrides overrides, System.Type[] extraTypes, System.Xml.Serialization.XmlRootAttribute root, string defaultNamespace, string location) => throw null;
                public XmlSerializer(System.Type type, System.Xml.Serialization.XmlRootAttribute root) => throw null;
                public XmlSerializer(System.Xml.Serialization.XmlTypeMapping xmlTypeMapping) => throw null;
                public object Deserialize(System.IO.Stream stream) => throw null;
                public object Deserialize(System.IO.TextReader textReader) => throw null;
                protected virtual object Deserialize(System.Xml.Serialization.XmlSerializationReader reader) => throw null;
                public object Deserialize(System.Xml.XmlReader xmlReader) => throw null;
                public object Deserialize(System.Xml.XmlReader xmlReader, string encodingStyle) => throw null;
                public object Deserialize(System.Xml.XmlReader xmlReader, string encodingStyle, System.Xml.Serialization.XmlDeserializationEvents events) => throw null;
                public object Deserialize(System.Xml.XmlReader xmlReader, System.Xml.Serialization.XmlDeserializationEvents events) => throw null;
                public static System.Xml.Serialization.XmlSerializer[] FromMappings(System.Xml.Serialization.XmlMapping[] mappings) => throw null;
                public static System.Xml.Serialization.XmlSerializer[] FromMappings(System.Xml.Serialization.XmlMapping[] mappings, System.Type type) => throw null;
                public static System.Xml.Serialization.XmlSerializer[] FromTypes(System.Type[] types) => throw null;
                public static string GetXmlSerializerAssemblyName(System.Type type) => throw null;
                public static string GetXmlSerializerAssemblyName(System.Type type, string defaultNamespace) => throw null;
                public void Serialize(System.IO.Stream stream, object o) => throw null;
                public void Serialize(System.IO.Stream stream, object o, System.Xml.Serialization.XmlSerializerNamespaces namespaces) => throw null;
                public void Serialize(System.IO.TextWriter textWriter, object o) => throw null;
                public void Serialize(System.IO.TextWriter textWriter, object o, System.Xml.Serialization.XmlSerializerNamespaces namespaces) => throw null;
                protected virtual void Serialize(object o, System.Xml.Serialization.XmlSerializationWriter writer) => throw null;
                public void Serialize(System.Xml.XmlWriter xmlWriter, object o) => throw null;
                public void Serialize(System.Xml.XmlWriter xmlWriter, object o, System.Xml.Serialization.XmlSerializerNamespaces namespaces) => throw null;
                public void Serialize(System.Xml.XmlWriter xmlWriter, object o, System.Xml.Serialization.XmlSerializerNamespaces namespaces, string encodingStyle) => throw null;
                public void Serialize(System.Xml.XmlWriter xmlWriter, object o, System.Xml.Serialization.XmlSerializerNamespaces namespaces, string encodingStyle, string id) => throw null;
                public event System.Xml.Serialization.XmlAttributeEventHandler UnknownAttribute;
                public event System.Xml.Serialization.XmlElementEventHandler UnknownElement;
                public event System.Xml.Serialization.XmlNodeEventHandler UnknownNode;
                public event System.Xml.Serialization.UnreferencedObjectEventHandler UnreferencedObject;
            }
            [System.AttributeUsage((System.AttributeTargets)1052, AllowMultiple = false)]
            public sealed class XmlSerializerAssemblyAttribute : System.Attribute
            {
                public string AssemblyName { get => throw null; set { } }
                public string CodeBase { get => throw null; set { } }
                public XmlSerializerAssemblyAttribute() => throw null;
                public XmlSerializerAssemblyAttribute(string assemblyName) => throw null;
                public XmlSerializerAssemblyAttribute(string assemblyName, string codeBase) => throw null;
            }
            public class XmlSerializerFactory
            {
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type, string defaultNamespace) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type, System.Type[] extraTypes) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type, System.Xml.Serialization.XmlAttributeOverrides overrides) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type, System.Xml.Serialization.XmlAttributeOverrides overrides, System.Type[] extraTypes, System.Xml.Serialization.XmlRootAttribute root, string defaultNamespace) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type, System.Xml.Serialization.XmlAttributeOverrides overrides, System.Type[] extraTypes, System.Xml.Serialization.XmlRootAttribute root, string defaultNamespace, string location) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type, System.Xml.Serialization.XmlRootAttribute root) => throw null;
                public System.Xml.Serialization.XmlSerializer CreateSerializer(System.Xml.Serialization.XmlTypeMapping xmlTypeMapping) => throw null;
                public XmlSerializerFactory() => throw null;
            }
            public abstract class XmlSerializerImplementation
            {
                public virtual bool CanSerialize(System.Type type) => throw null;
                protected XmlSerializerImplementation() => throw null;
                public virtual System.Xml.Serialization.XmlSerializer GetSerializer(System.Type type) => throw null;
                public virtual System.Xml.Serialization.XmlSerializationReader Reader { get => throw null; }
                public virtual System.Collections.Hashtable ReadMethods { get => throw null; }
                public virtual System.Collections.Hashtable TypedSerializers { get => throw null; }
                public virtual System.Collections.Hashtable WriteMethods { get => throw null; }
                public virtual System.Xml.Serialization.XmlSerializationWriter Writer { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1)]
            public sealed class XmlSerializerVersionAttribute : System.Attribute
            {
                public XmlSerializerVersionAttribute() => throw null;
                public XmlSerializerVersionAttribute(System.Type type) => throw null;
                public string Namespace { get => throw null; set { } }
                public string ParentAssemblyId { get => throw null; set { } }
                public System.Type Type { get => throw null; set { } }
                public string Version { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)1052)]
            public class XmlTypeAttribute : System.Attribute
            {
                public bool AnonymousType { get => throw null; set { } }
                public XmlTypeAttribute() => throw null;
                public XmlTypeAttribute(string typeName) => throw null;
                public bool IncludeInSchema { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
                public string TypeName { get => throw null; set { } }
            }
            public class XmlTypeMapping : System.Xml.Serialization.XmlMapping
            {
                public string TypeFullName { get => throw null; }
                public string TypeName { get => throw null; }
                public string XsdTypeName { get => throw null; }
                public string XsdTypeNamespace { get => throw null; }
            }
        }
    }
}
