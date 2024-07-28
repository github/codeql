// This file contains auto-generated code.
// Generated from `System.Runtime.Serialization.Json, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            public class DateTimeFormat
            {
                public DateTimeFormat(string formatString) => throw null;
                public DateTimeFormat(string formatString, System.IFormatProvider formatProvider) => throw null;
                public System.Globalization.DateTimeStyles DateTimeStyles { get => throw null; set { } }
                public System.IFormatProvider FormatProvider { get => throw null; }
                public string FormatString { get => throw null; }
            }
            public enum EmitTypeInformation
            {
                AsNeeded = 0,
                Always = 1,
                Never = 2,
            }
            namespace Json
            {
                public sealed class DataContractJsonSerializer : System.Runtime.Serialization.XmlObjectSerializer
                {
                    public DataContractJsonSerializer(System.Type type) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Runtime.Serialization.Json.DataContractJsonSerializerSettings settings) => throw null;
                    public DataContractJsonSerializer(System.Type type, string rootName) => throw null;
                    public DataContractJsonSerializer(System.Type type, string rootName, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Xml.XmlDictionaryString rootName) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Xml.XmlDictionaryString rootName, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                    public System.Runtime.Serialization.DateTimeFormat DateTimeFormat { get => throw null; }
                    public System.Runtime.Serialization.EmitTypeInformation EmitTypeInformation { get => throw null; }
                    public System.Runtime.Serialization.ISerializationSurrogateProvider GetSerializationSurrogateProvider() => throw null;
                    public bool IgnoreExtensionDataObject { get => throw null; }
                    public override bool IsStartObject(System.Xml.XmlDictionaryReader reader) => throw null;
                    public override bool IsStartObject(System.Xml.XmlReader reader) => throw null;
                    public System.Collections.ObjectModel.ReadOnlyCollection<System.Type> KnownTypes { get => throw null; }
                    public int MaxItemsInObjectGraph { get => throw null; }
                    public override object ReadObject(System.IO.Stream stream) => throw null;
                    public override object ReadObject(System.Xml.XmlDictionaryReader reader) => throw null;
                    public override object ReadObject(System.Xml.XmlDictionaryReader reader, bool verifyObjectName) => throw null;
                    public override object ReadObject(System.Xml.XmlReader reader) => throw null;
                    public override object ReadObject(System.Xml.XmlReader reader, bool verifyObjectName) => throw null;
                    public bool SerializeReadOnlyTypes { get => throw null; }
                    public void SetSerializationSurrogateProvider(System.Runtime.Serialization.ISerializationSurrogateProvider provider) => throw null;
                    public bool UseSimpleDictionaryFormat { get => throw null; }
                    public override void WriteEndObject(System.Xml.XmlDictionaryWriter writer) => throw null;
                    public override void WriteEndObject(System.Xml.XmlWriter writer) => throw null;
                    public override void WriteObject(System.IO.Stream stream, object graph) => throw null;
                    public override void WriteObject(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
                    public override void WriteObject(System.Xml.XmlWriter writer, object graph) => throw null;
                    public override void WriteObjectContent(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
                    public override void WriteObjectContent(System.Xml.XmlWriter writer, object graph) => throw null;
                    public override void WriteStartObject(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
                    public override void WriteStartObject(System.Xml.XmlWriter writer, object graph) => throw null;
                }
                public class DataContractJsonSerializerSettings
                {
                    public DataContractJsonSerializerSettings() => throw null;
                    public System.Runtime.Serialization.DateTimeFormat DateTimeFormat { get => throw null; set { } }
                    public System.Runtime.Serialization.EmitTypeInformation EmitTypeInformation { get => throw null; set { } }
                    public bool IgnoreExtensionDataObject { get => throw null; set { } }
                    public System.Collections.Generic.IEnumerable<System.Type> KnownTypes { get => throw null; set { } }
                    public int MaxItemsInObjectGraph { get => throw null; set { } }
                    public string RootName { get => throw null; set { } }
                    public bool SerializeReadOnlyTypes { get => throw null; set { } }
                    public bool UseSimpleDictionaryFormat { get => throw null; set { } }
                }
                public interface IXmlJsonReaderInitializer
                {
                    void SetInput(byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
                    void SetInput(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
                }
                public interface IXmlJsonWriterInitializer
                {
                    void SetOutput(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream);
                }
                public static class JsonReaderWriterFactory
                {
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(byte[] buffer, int offset, int count, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(byte[] buffer, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(System.IO.Stream stream, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
                    public static System.Xml.XmlDictionaryWriter CreateJsonWriter(System.IO.Stream stream) => throw null;
                    public static System.Xml.XmlDictionaryWriter CreateJsonWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
                    public static System.Xml.XmlDictionaryWriter CreateJsonWriter(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream) => throw null;
                    public static System.Xml.XmlDictionaryWriter CreateJsonWriter(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream, bool indent) => throw null;
                    public static System.Xml.XmlDictionaryWriter CreateJsonWriter(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream, bool indent, string indentChars) => throw null;
                }
            }
        }
    }
}
