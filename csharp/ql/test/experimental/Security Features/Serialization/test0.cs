// semmle-extractor-options: /r:System.Data.Common.dll /r:System.Runtime.WindowsRuntime.dll /r:System.Xml.XmlSerializer.dll /r:System.Runtime.Serialization.Xml.dll /r:System.Runtime.Serialization.Xml.dll /r:System.Collections.dll /r:System.Private.Xml.dll /r:System.Private.DataContractSerialization.dll /r:System.Runtime.Extensions.dll /r:System.ComponentModel.TypeConverter.dll /r:System.Xml.ReaderWriter.dll /r:System.IO.FileSystem.dll

using System;
using System.Data;
using System.IO;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Xml;
using System.Collections.Generic;

namespace DataSetSerializationTest
{
    public class DerivesFromDeprecatedType1 : XmlSerializer // warning:DefiningDatasetRelatedType.ql
    {
        public DataSet MyDataSet { get; set; }  // bug:DefiningPotentiallyUnsafeXmlSerializer.ql

        public DerivesFromDeprecatedType1()
        {
        }
    }

    /*  
     *  TODO: I cannot use DataContract on a QL unit test
     *  
    [DataContract(Name = "Customer", Namespace = "http://www.contoso.com")]
    public class PatternDataContractSerializer : XmlObjectSerializer
    {
        [DataMember()]
        public DataSet MyDataSet { get; set; }
        [DataMember()]
        public DataTable MyDataTable { get; set; }

        PatternDataContractSerializer() { }
        private ExtensionDataObject extensionData_Value;
        public ExtensionDataObject ExtensionData
        {
            get
            {
                return extensionData_Value;
            }
            set
            {
                extensionData_Value = value;
            }
        }

        public override void WriteObject(System.IO.Stream stream, object graph) { }
        public override void WriteObjectContent(System.Xml.XmlDictionaryWriter writer, object graph) { }
        public override bool IsStartObject(System.Xml.XmlDictionaryReader reader) { return false; }
        public override void WriteStartObject(System.Xml.XmlDictionaryWriter writer, object graph) { }
        public override void WriteEndObject(System.Xml.XmlWriter writer) { }
        public override void WriteEndObject(XmlDictionaryWriter writer) { }
        public override object ReadObject(System.IO.Stream stream) { return null; }
        public override object ReadObject(XmlDictionaryReader reader, bool b) { return null; }
    }
    */

    [Serializable()]
    public class AttributeSerializer01  // warning:DefiningDatasetRelatedType.ql
    {
        private DataSet MyDataSet;  // bug:DefiningPotentiallyUnsafeXmlSerializer.ql

        AttributeSerializer01()
        {
        }
    }

    class Program
    {
        static string GetSerializedDataSet(DataSet dataSet)
        {
            DataTable dataTable = new DataTable("MyTable");
            dataTable.Columns.Add("FirstName", typeof(string));
            dataTable.Columns.Add("LastName", typeof(string));
            dataTable.Columns.Add("Age", typeof(int));

            StringWriter writer = new StringWriter();
            dataSet.WriteXml(writer, XmlWriteMode.DiffGram);
            return writer.ToString();
        }

        static void datatable_readxmlschema_01(string fileName)
        {
            using (FileStream fs = File.OpenRead(fileName))
            {
                DataTable newTable = new DataTable();
                System.Xml.XmlTextReader reader = new System.Xml.XmlTextReader(fs);
                newTable.ReadXmlSchema(reader); //bug:XmlDeserializationWithDataSet.ql
            }
        }

        static void Main(string[] args)
        {

            XmlSerializer x = new XmlSerializer(typeof(DataSet));   // bug:UnsafeTypeUsedDataContractSerializer.ql
            XmlSerializer y = new XmlSerializer(typeof(AttributeSerializer01)); //bug:UnsafeTypeUsedDataContractSerializer.ql

            Console.WriteLine("Hello World!");
        }
    }
}