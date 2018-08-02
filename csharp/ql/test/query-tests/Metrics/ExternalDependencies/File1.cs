// semmle-extractor-options: /r:System.Collections.dll /r:System.Data.Common.dll /r:System.Runtime.Serialization.Primitives.dll /r:System.Private.Xml.dll /r:System.Xml.ReaderWriter.dll /r:System.Net.Primitives.dll /r:System.Net.Http.dll /r:System.Private.DataContractSerialization.dll /r:System.Runtime.Serialization.dll /r:System.ComponentModel.Primitives.dll

using System.Collections.Generic;
using System.Net.Http;
using System.Xml;
using System.Runtime.Serialization.Json;
using System.Data;

class C
{
    System.Net.Http.HttpClient client;
    System.Xml.XmlReader reader;
    IXmlJsonReaderInitializer init;

    [DataSysDescription("")]
    void Test()
    {
        client = new HttpClient();
        var request = new HttpRequestMessage();
        client.SendAsync(request);

        Method<XmlReader>();
    }

    List<IXmlJsonReaderInitializer> initializerList;

    void Method<T>()
    {
    }
}
