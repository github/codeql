// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            // Generated from `System.Runtime.Serialization.DateTimeFormat` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DateTimeFormat
            {
                public DateTimeFormat(string formatString) => throw null;
                public DateTimeFormat(string formatString, System.IFormatProvider formatProvider) => throw null;
                public System.Globalization.DateTimeStyles DateTimeStyles { get => throw null; set => throw null; }
                public System.IFormatProvider FormatProvider { get => throw null; }
                public string FormatString { get => throw null; }
            }

            // Generated from `System.Runtime.Serialization.EmitTypeInformation` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EmitTypeInformation
            {
                Always,
                AsNeeded,
                Never,
            }

            namespace Json
            {
                // Generated from `System.Runtime.Serialization.Json.DataContractJsonSerializer` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DataContractJsonSerializer : System.Runtime.Serialization.XmlObjectSerializer
                {
                    public DataContractJsonSerializer(System.Type type) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Runtime.Serialization.Json.DataContractJsonSerializerSettings settings) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Xml.XmlDictionaryString rootName) => throw null;
                    public DataContractJsonSerializer(System.Type type, System.Xml.XmlDictionaryString rootName, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                    public DataContractJsonSerializer(System.Type type, string rootName) => throw null;
                    public DataContractJsonSerializer(System.Type type, string rootName, System.Collections.Generic.IEnumerable<System.Type> knownTypes) => throw null;
                    public System.Runtime.Serialization.DateTimeFormat DateTimeFormat { get => throw null; }
                    public System.Runtime.Serialization.EmitTypeInformation EmitTypeInformation { get => throw null; }
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

                // Generated from `System.Runtime.Serialization.Json.DataContractJsonSerializerSettings` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DataContractJsonSerializerSettings
                {
                    public DataContractJsonSerializerSettings() => throw null;
                    public System.Runtime.Serialization.DateTimeFormat DateTimeFormat { get => throw null; set => throw null; }
                    public System.Runtime.Serialization.EmitTypeInformation EmitTypeInformation { get => throw null; set => throw null; }
                    public bool IgnoreExtensionDataObject { get => throw null; set => throw null; }
                    public System.Collections.Generic.IEnumerable<System.Type> KnownTypes { get => throw null; set => throw null; }
                    public int MaxItemsInObjectGraph { get => throw null; set => throw null; }
                    public string RootName { get => throw null; set => throw null; }
                    public bool SerializeReadOnlyTypes { get => throw null; set => throw null; }
                    public bool UseSimpleDictionaryFormat { get => throw null; set => throw null; }
                }

                // Generated from `System.Runtime.Serialization.Json.IXmlJsonReaderInitializer` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IXmlJsonReaderInitializer
                {
                    void SetInput(System.Byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
                    void SetInput(System.IO.Stream stream, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose);
                }

                // Generated from `System.Runtime.Serialization.Json.IXmlJsonWriterInitializer` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IXmlJsonWriterInitializer
                {
                    void SetOutput(System.IO.Stream stream, System.Text.Encoding encoding, bool ownsStream);
                }

                // Generated from `System.Runtime.Serialization.Json.JsonReaderWriterFactory` in `System.Runtime.Serialization.Json, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public static class JsonReaderWriterFactory
                {
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(System.Byte[] buffer, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(System.Byte[] buffer, int offset, int count, System.Text.Encoding encoding, System.Xml.XmlDictionaryReaderQuotas quotas, System.Xml.OnXmlDictionaryReaderClose onClose) => throw null;
                    public static System.Xml.XmlDictionaryReader CreateJsonReader(System.Byte[] buffer, int offset, int count, System.Xml.XmlDictionaryReaderQuotas quotas) => throw null;
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
