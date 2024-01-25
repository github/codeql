// This file contains auto-generated code.
// Generated from `System.Xml.XDocument, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Xml
    {
        namespace Linq
        {
            public static partial class Extensions
            {
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Ancestors<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XNode => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Ancestors<T>(this System.Collections.Generic.IEnumerable<T> source, System.Xml.Linq.XName name) where T : System.Xml.Linq.XNode => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> AncestorsAndSelf(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> AncestorsAndSelf(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source, System.Xml.Linq.XName name) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XAttribute> Attributes(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XAttribute> Attributes(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source, System.Xml.Linq.XName name) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> DescendantNodes<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XContainer => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> DescendantNodesAndSelf(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Descendants<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XContainer => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Descendants<T>(this System.Collections.Generic.IEnumerable<T> source, System.Xml.Linq.XName name) where T : System.Xml.Linq.XContainer => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> DescendantsAndSelf(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> DescendantsAndSelf(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> source, System.Xml.Linq.XName name) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Elements<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XContainer => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Elements<T>(this System.Collections.Generic.IEnumerable<T> source, System.Xml.Linq.XName name) where T : System.Xml.Linq.XContainer => throw null;
                public static System.Collections.Generic.IEnumerable<T> InDocumentOrder<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XNode => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> Nodes<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XContainer => throw null;
                public static void Remove(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XAttribute> source) => throw null;
                public static void Remove<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Xml.Linq.XNode => throw null;
            }
            [System.Flags]
            public enum LoadOptions
            {
                None = 0,
                PreserveWhitespace = 1,
                SetBaseUri = 2,
                SetLineInfo = 4,
            }
            [System.Flags]
            public enum ReaderOptions
            {
                None = 0,
                OmitDuplicateNamespaces = 1,
            }
            [System.Flags]
            public enum SaveOptions
            {
                None = 0,
                DisableFormatting = 1,
                OmitDuplicateNamespaces = 2,
            }
            public class XAttribute : System.Xml.Linq.XObject
            {
                public XAttribute(System.Xml.Linq.XAttribute other) => throw null;
                public XAttribute(System.Xml.Linq.XName name, object value) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XAttribute> EmptySequence { get => throw null; }
                public bool IsNamespaceDeclaration { get => throw null; }
                public System.Xml.Linq.XName Name { get => throw null; }
                public System.Xml.Linq.XAttribute NextAttribute { get => throw null; }
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public static explicit operator bool(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.DateTime(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.DateTimeOffset(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator decimal(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator double(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.Guid(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator int(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator long(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator bool?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.DateTimeOffset?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.DateTime?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator decimal?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator double?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.Guid?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator int?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator long?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator float?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.TimeSpan?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator uint?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator ulong?(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator float(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator string(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator System.TimeSpan(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator uint(System.Xml.Linq.XAttribute attribute) => throw null;
                public static explicit operator ulong(System.Xml.Linq.XAttribute attribute) => throw null;
                public System.Xml.Linq.XAttribute PreviousAttribute { get => throw null; }
                public void Remove() => throw null;
                public void SetValue(object value) => throw null;
                public override string ToString() => throw null;
                public string Value { get => throw null; set { } }
            }
            public class XCData : System.Xml.Linq.XText
            {
                public XCData(string value) : base(default(string)) => throw null;
                public XCData(System.Xml.Linq.XCData other) : base(default(string)) => throw null;
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public class XComment : System.Xml.Linq.XNode
            {
                public XComment(string value) => throw null;
                public XComment(System.Xml.Linq.XComment other) => throw null;
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public string Value { get => throw null; set { } }
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public abstract class XContainer : System.Xml.Linq.XNode
            {
                public void Add(object content) => throw null;
                public void Add(params object[] content) => throw null;
                public void AddFirst(object content) => throw null;
                public void AddFirst(params object[] content) => throw null;
                public System.Xml.XmlWriter CreateWriter() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> DescendantNodes() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Descendants() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Descendants(System.Xml.Linq.XName name) => throw null;
                public System.Xml.Linq.XElement Element(System.Xml.Linq.XName name) => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Elements() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Elements(System.Xml.Linq.XName name) => throw null;
                public System.Xml.Linq.XNode FirstNode { get => throw null; }
                public System.Xml.Linq.XNode LastNode { get => throw null; }
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> Nodes() => throw null;
                public void RemoveNodes() => throw null;
                public void ReplaceNodes(object content) => throw null;
                public void ReplaceNodes(params object[] content) => throw null;
            }
            public class XDeclaration
            {
                public XDeclaration(string version, string encoding, string standalone) => throw null;
                public XDeclaration(System.Xml.Linq.XDeclaration other) => throw null;
                public string Encoding { get => throw null; set { } }
                public string Standalone { get => throw null; set { } }
                public override string ToString() => throw null;
                public string Version { get => throw null; set { } }
            }
            public class XDocument : System.Xml.Linq.XContainer
            {
                public XDocument() => throw null;
                public XDocument(params object[] content) => throw null;
                public XDocument(System.Xml.Linq.XDeclaration declaration, params object[] content) => throw null;
                public XDocument(System.Xml.Linq.XDocument other) => throw null;
                public System.Xml.Linq.XDeclaration Declaration { get => throw null; set { } }
                public System.Xml.Linq.XDocumentType DocumentType { get => throw null; }
                public static System.Xml.Linq.XDocument Load(System.IO.Stream stream) => throw null;
                public static System.Xml.Linq.XDocument Load(System.IO.Stream stream, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Xml.Linq.XDocument Load(System.IO.TextReader textReader) => throw null;
                public static System.Xml.Linq.XDocument Load(System.IO.TextReader textReader, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Xml.Linq.XDocument Load(string uri) => throw null;
                public static System.Xml.Linq.XDocument Load(string uri, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Xml.Linq.XDocument Load(System.Xml.XmlReader reader) => throw null;
                public static System.Xml.Linq.XDocument Load(System.Xml.XmlReader reader, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XDocument> LoadAsync(System.IO.Stream stream, System.Xml.Linq.LoadOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XDocument> LoadAsync(System.IO.TextReader textReader, System.Xml.Linq.LoadOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XDocument> LoadAsync(System.Xml.XmlReader reader, System.Xml.Linq.LoadOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public static System.Xml.Linq.XDocument Parse(string text) => throw null;
                public static System.Xml.Linq.XDocument Parse(string text, System.Xml.Linq.LoadOptions options) => throw null;
                public System.Xml.Linq.XElement Root { get => throw null; }
                public void Save(System.IO.Stream stream) => throw null;
                public void Save(System.IO.Stream stream, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(System.IO.TextWriter textWriter) => throw null;
                public void Save(System.IO.TextWriter textWriter, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(string fileName) => throw null;
                public void Save(string fileName, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(System.Xml.XmlWriter writer) => throw null;
                public System.Threading.Tasks.Task SaveAsync(System.IO.Stream stream, System.Xml.Linq.SaveOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task SaveAsync(System.IO.TextWriter textWriter, System.Xml.Linq.SaveOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task SaveAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public class XDocumentType : System.Xml.Linq.XNode
            {
                public XDocumentType(string name, string publicId, string systemId, string internalSubset) => throw null;
                public XDocumentType(System.Xml.Linq.XDocumentType other) => throw null;
                public string InternalSubset { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public string PublicId { get => throw null; set { } }
                public string SystemId { get => throw null; set { } }
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public class XElement : System.Xml.Linq.XContainer, System.Xml.Serialization.IXmlSerializable
            {
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> AncestorsAndSelf() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> AncestorsAndSelf(System.Xml.Linq.XName name) => throw null;
                public System.Xml.Linq.XAttribute Attribute(System.Xml.Linq.XName name) => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XAttribute> Attributes() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XAttribute> Attributes(System.Xml.Linq.XName name) => throw null;
                public XElement(System.Xml.Linq.XElement other) => throw null;
                public XElement(System.Xml.Linq.XName name) => throw null;
                public XElement(System.Xml.Linq.XName name, object content) => throw null;
                public XElement(System.Xml.Linq.XName name, params object[] content) => throw null;
                public XElement(System.Xml.Linq.XStreamingElement other) => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> DescendantNodesAndSelf() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> DescendantsAndSelf() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> DescendantsAndSelf(System.Xml.Linq.XName name) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> EmptySequence { get => throw null; }
                public System.Xml.Linq.XAttribute FirstAttribute { get => throw null; }
                public System.Xml.Linq.XNamespace GetDefaultNamespace() => throw null;
                public System.Xml.Linq.XNamespace GetNamespaceOfPrefix(string prefix) => throw null;
                public string GetPrefixOfNamespace(System.Xml.Linq.XNamespace ns) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public bool HasAttributes { get => throw null; }
                public bool HasElements { get => throw null; }
                public bool IsEmpty { get => throw null; }
                public System.Xml.Linq.XAttribute LastAttribute { get => throw null; }
                public static System.Xml.Linq.XElement Load(System.IO.Stream stream) => throw null;
                public static System.Xml.Linq.XElement Load(System.IO.Stream stream, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Xml.Linq.XElement Load(System.IO.TextReader textReader) => throw null;
                public static System.Xml.Linq.XElement Load(System.IO.TextReader textReader, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Xml.Linq.XElement Load(string uri) => throw null;
                public static System.Xml.Linq.XElement Load(string uri, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Xml.Linq.XElement Load(System.Xml.XmlReader reader) => throw null;
                public static System.Xml.Linq.XElement Load(System.Xml.XmlReader reader, System.Xml.Linq.LoadOptions options) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XElement> LoadAsync(System.IO.Stream stream, System.Xml.Linq.LoadOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XElement> LoadAsync(System.IO.TextReader textReader, System.Xml.Linq.LoadOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XElement> LoadAsync(System.Xml.XmlReader reader, System.Xml.Linq.LoadOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Xml.Linq.XName Name { get => throw null; set { } }
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public static explicit operator bool(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.DateTime(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.DateTimeOffset(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator decimal(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator double(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.Guid(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator int(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator long(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator bool?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.DateTimeOffset?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.DateTime?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator decimal?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator double?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.Guid?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator int?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator long?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator float?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.TimeSpan?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator uint?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator ulong?(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator float(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator string(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator System.TimeSpan(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator uint(System.Xml.Linq.XElement element) => throw null;
                public static explicit operator ulong(System.Xml.Linq.XElement element) => throw null;
                public static System.Xml.Linq.XElement Parse(string text) => throw null;
                public static System.Xml.Linq.XElement Parse(string text, System.Xml.Linq.LoadOptions options) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public void RemoveAll() => throw null;
                public void RemoveAttributes() => throw null;
                public void ReplaceAll(object content) => throw null;
                public void ReplaceAll(params object[] content) => throw null;
                public void ReplaceAttributes(object content) => throw null;
                public void ReplaceAttributes(params object[] content) => throw null;
                public void Save(System.IO.Stream stream) => throw null;
                public void Save(System.IO.Stream stream, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(System.IO.TextWriter textWriter) => throw null;
                public void Save(System.IO.TextWriter textWriter, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(string fileName) => throw null;
                public void Save(string fileName, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(System.Xml.XmlWriter writer) => throw null;
                public System.Threading.Tasks.Task SaveAsync(System.IO.Stream stream, System.Xml.Linq.SaveOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task SaveAsync(System.IO.TextWriter textWriter, System.Xml.Linq.SaveOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task SaveAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
                public void SetAttributeValue(System.Xml.Linq.XName name, object value) => throw null;
                public void SetElementValue(System.Xml.Linq.XName name, object value) => throw null;
                public void SetValue(object value) => throw null;
                public string Value { get => throw null; set { } }
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public sealed class XName : System.IEquatable<System.Xml.Linq.XName>, System.Runtime.Serialization.ISerializable
            {
                public override bool Equals(object obj) => throw null;
                bool System.IEquatable<System.Xml.Linq.XName>.Equals(System.Xml.Linq.XName other) => throw null;
                public static System.Xml.Linq.XName Get(string expandedName) => throw null;
                public static System.Xml.Linq.XName Get(string localName, string namespaceName) => throw null;
                public override int GetHashCode() => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string LocalName { get => throw null; }
                public System.Xml.Linq.XNamespace Namespace { get => throw null; }
                public string NamespaceName { get => throw null; }
                public static bool operator ==(System.Xml.Linq.XName left, System.Xml.Linq.XName right) => throw null;
                public static implicit operator System.Xml.Linq.XName(string expandedName) => throw null;
                public static bool operator !=(System.Xml.Linq.XName left, System.Xml.Linq.XName right) => throw null;
                public override string ToString() => throw null;
            }
            public sealed class XNamespace
            {
                public override bool Equals(object obj) => throw null;
                public static System.Xml.Linq.XNamespace Get(string namespaceName) => throw null;
                public override int GetHashCode() => throw null;
                public System.Xml.Linq.XName GetName(string localName) => throw null;
                public string NamespaceName { get => throw null; }
                public static System.Xml.Linq.XNamespace None { get => throw null; }
                public static System.Xml.Linq.XName operator +(System.Xml.Linq.XNamespace ns, string localName) => throw null;
                public static bool operator ==(System.Xml.Linq.XNamespace left, System.Xml.Linq.XNamespace right) => throw null;
                public static implicit operator System.Xml.Linq.XNamespace(string namespaceName) => throw null;
                public static bool operator !=(System.Xml.Linq.XNamespace left, System.Xml.Linq.XNamespace right) => throw null;
                public override string ToString() => throw null;
                public static System.Xml.Linq.XNamespace Xml { get => throw null; }
                public static System.Xml.Linq.XNamespace Xmlns { get => throw null; }
            }
            public abstract class XNode : System.Xml.Linq.XObject
            {
                public void AddAfterSelf(object content) => throw null;
                public void AddAfterSelf(params object[] content) => throw null;
                public void AddBeforeSelf(object content) => throw null;
                public void AddBeforeSelf(params object[] content) => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Ancestors() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> Ancestors(System.Xml.Linq.XName name) => throw null;
                public static int CompareDocumentOrder(System.Xml.Linq.XNode n1, System.Xml.Linq.XNode n2) => throw null;
                public System.Xml.XmlReader CreateReader() => throw null;
                public System.Xml.XmlReader CreateReader(System.Xml.Linq.ReaderOptions readerOptions) => throw null;
                public static bool DeepEquals(System.Xml.Linq.XNode n1, System.Xml.Linq.XNode n2) => throw null;
                public static System.Xml.Linq.XNodeDocumentOrderComparer DocumentOrderComparer { get => throw null; }
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> ElementsAfterSelf() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> ElementsAfterSelf(System.Xml.Linq.XName name) => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> ElementsBeforeSelf() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> ElementsBeforeSelf(System.Xml.Linq.XName name) => throw null;
                public static System.Xml.Linq.XNodeEqualityComparer EqualityComparer { get => throw null; }
                public bool IsAfter(System.Xml.Linq.XNode node) => throw null;
                public bool IsBefore(System.Xml.Linq.XNode node) => throw null;
                public System.Xml.Linq.XNode NextNode { get => throw null; }
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> NodesAfterSelf() => throw null;
                public System.Collections.Generic.IEnumerable<System.Xml.Linq.XNode> NodesBeforeSelf() => throw null;
                public System.Xml.Linq.XNode PreviousNode { get => throw null; }
                public static System.Xml.Linq.XNode ReadFrom(System.Xml.XmlReader reader) => throw null;
                public static System.Threading.Tasks.Task<System.Xml.Linq.XNode> ReadFromAsync(System.Xml.XmlReader reader, System.Threading.CancellationToken cancellationToken) => throw null;
                public void Remove() => throw null;
                public void ReplaceWith(object content) => throw null;
                public void ReplaceWith(params object[] content) => throw null;
                public override string ToString() => throw null;
                public string ToString(System.Xml.Linq.SaveOptions options) => throw null;
                public abstract void WriteTo(System.Xml.XmlWriter writer);
                public abstract System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken);
            }
            public sealed class XNodeDocumentOrderComparer : System.Collections.Generic.IComparer<System.Xml.Linq.XNode>, System.Collections.IComparer
            {
                public int Compare(System.Xml.Linq.XNode x, System.Xml.Linq.XNode y) => throw null;
                int System.Collections.IComparer.Compare(object x, object y) => throw null;
                public XNodeDocumentOrderComparer() => throw null;
            }
            public sealed class XNodeEqualityComparer : System.Collections.Generic.IEqualityComparer<System.Xml.Linq.XNode>, System.Collections.IEqualityComparer
            {
                public XNodeEqualityComparer() => throw null;
                public bool Equals(System.Xml.Linq.XNode x, System.Xml.Linq.XNode y) => throw null;
                bool System.Collections.IEqualityComparer.Equals(object x, object y) => throw null;
                public int GetHashCode(System.Xml.Linq.XNode obj) => throw null;
                int System.Collections.IEqualityComparer.GetHashCode(object obj) => throw null;
            }
            public abstract class XObject : System.Xml.IXmlLineInfo
            {
                public void AddAnnotation(object annotation) => throw null;
                public object Annotation(System.Type type) => throw null;
                public T Annotation<T>() where T : class => throw null;
                public System.Collections.Generic.IEnumerable<object> Annotations(System.Type type) => throw null;
                public System.Collections.Generic.IEnumerable<T> Annotations<T>() where T : class => throw null;
                public string BaseUri { get => throw null; }
                public event System.EventHandler<System.Xml.Linq.XObjectChangeEventArgs> Changed;
                public event System.EventHandler<System.Xml.Linq.XObjectChangeEventArgs> Changing;
                public System.Xml.Linq.XDocument Document { get => throw null; }
                bool System.Xml.IXmlLineInfo.HasLineInfo() => throw null;
                int System.Xml.IXmlLineInfo.LineNumber { get => throw null; }
                int System.Xml.IXmlLineInfo.LinePosition { get => throw null; }
                public abstract System.Xml.XmlNodeType NodeType { get; }
                public System.Xml.Linq.XElement Parent { get => throw null; }
                public void RemoveAnnotations(System.Type type) => throw null;
                public void RemoveAnnotations<T>() where T : class => throw null;
            }
            public enum XObjectChange
            {
                Add = 0,
                Remove = 1,
                Name = 2,
                Value = 3,
            }
            public class XObjectChangeEventArgs : System.EventArgs
            {
                public static readonly System.Xml.Linq.XObjectChangeEventArgs Add;
                public XObjectChangeEventArgs(System.Xml.Linq.XObjectChange objectChange) => throw null;
                public static readonly System.Xml.Linq.XObjectChangeEventArgs Name;
                public System.Xml.Linq.XObjectChange ObjectChange { get => throw null; }
                public static readonly System.Xml.Linq.XObjectChangeEventArgs Remove;
                public static readonly System.Xml.Linq.XObjectChangeEventArgs Value;
            }
            public class XProcessingInstruction : System.Xml.Linq.XNode
            {
                public XProcessingInstruction(string target, string data) => throw null;
                public XProcessingInstruction(System.Xml.Linq.XProcessingInstruction other) => throw null;
                public string Data { get => throw null; set { } }
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public string Target { get => throw null; set { } }
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public class XStreamingElement
            {
                public void Add(object content) => throw null;
                public void Add(params object[] content) => throw null;
                public XStreamingElement(System.Xml.Linq.XName name) => throw null;
                public XStreamingElement(System.Xml.Linq.XName name, object content) => throw null;
                public XStreamingElement(System.Xml.Linq.XName name, params object[] content) => throw null;
                public System.Xml.Linq.XName Name { get => throw null; set { } }
                public void Save(System.IO.Stream stream) => throw null;
                public void Save(System.IO.Stream stream, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(System.IO.TextWriter textWriter) => throw null;
                public void Save(System.IO.TextWriter textWriter, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(string fileName) => throw null;
                public void Save(string fileName, System.Xml.Linq.SaveOptions options) => throw null;
                public void Save(System.Xml.XmlWriter writer) => throw null;
                public override string ToString() => throw null;
                public string ToString(System.Xml.Linq.SaveOptions options) => throw null;
                public void WriteTo(System.Xml.XmlWriter writer) => throw null;
            }
            public class XText : System.Xml.Linq.XNode
            {
                public XText(string value) => throw null;
                public XText(System.Xml.Linq.XText other) => throw null;
                public override System.Xml.XmlNodeType NodeType { get => throw null; }
                public string Value { get => throw null; set { } }
                public override void WriteTo(System.Xml.XmlWriter writer) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(System.Xml.XmlWriter writer, System.Threading.CancellationToken cancellationToken) => throw null;
            }
        }
        namespace Schema
        {
            public static partial class Extensions
            {
                public static System.Xml.Schema.IXmlSchemaInfo GetSchemaInfo(this System.Xml.Linq.XAttribute source) => throw null;
                public static System.Xml.Schema.IXmlSchemaInfo GetSchemaInfo(this System.Xml.Linq.XElement source) => throw null;
                public static void Validate(this System.Xml.Linq.XAttribute source, System.Xml.Schema.XmlSchemaObject partialValidationType, System.Xml.Schema.XmlSchemaSet schemas, System.Xml.Schema.ValidationEventHandler validationEventHandler) => throw null;
                public static void Validate(this System.Xml.Linq.XAttribute source, System.Xml.Schema.XmlSchemaObject partialValidationType, System.Xml.Schema.XmlSchemaSet schemas, System.Xml.Schema.ValidationEventHandler validationEventHandler, bool addSchemaInfo) => throw null;
                public static void Validate(this System.Xml.Linq.XDocument source, System.Xml.Schema.XmlSchemaSet schemas, System.Xml.Schema.ValidationEventHandler validationEventHandler) => throw null;
                public static void Validate(this System.Xml.Linq.XDocument source, System.Xml.Schema.XmlSchemaSet schemas, System.Xml.Schema.ValidationEventHandler validationEventHandler, bool addSchemaInfo) => throw null;
                public static void Validate(this System.Xml.Linq.XElement source, System.Xml.Schema.XmlSchemaObject partialValidationType, System.Xml.Schema.XmlSchemaSet schemas, System.Xml.Schema.ValidationEventHandler validationEventHandler) => throw null;
                public static void Validate(this System.Xml.Linq.XElement source, System.Xml.Schema.XmlSchemaObject partialValidationType, System.Xml.Schema.XmlSchemaSet schemas, System.Xml.Schema.ValidationEventHandler validationEventHandler, bool addSchemaInfo) => throw null;
            }
        }
    }
}
