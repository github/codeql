using System;
using System.IO;
using System.Web;
using System.Xml;
using System.Xml.Schema;

public class MissingXMLValidationHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        String userProvidedXml = ctx.Request.QueryString["userProvidedXml"];

        // BAD: User provided XML is processed without any validation,
        //      because there is no settings instance configured.
        XmlReader.Create(new StringReader(userProvidedXml));

        // BAD: User provided XML is processed without any validation,
        //      because the settings instance does not specify the ValidationType
        XmlReaderSettings badSettings1 = new XmlReaderSettings();
        XmlReader.Create(new StringReader(userProvidedXml), badSettings1);

        // BAD: User provided XML is processed without any validation,
        //      because the settings instance specifies DTD as the ValidationType
        XmlReaderSettings badSettings2 = new XmlReaderSettings();
        badSettings2.ValidationType = ValidationType.DTD;
        XmlReader.Create(new StringReader(userProvidedXml), badSettings2);

        // GOOD: User provided XML is processed with validation
        XmlReaderSettings goodSettings = new XmlReaderSettings();
        goodSettings.ValidationType = ValidationType.Schema;
        XmlSchemaSet sc = new XmlSchemaSet();
        sc.Add("urn:my-schema", "my.xsd");
        goodSettings.Schemas = sc;
        XmlReader.Create(new StringReader(userProvidedXml), goodSettings);

        // BAD: Allows user specified schemas
        XmlReaderSettings badSettings3 = new XmlReaderSettings();
        badSettings3.ValidationType = ValidationType.Schema;
        badSettings3.ValidationFlags = XmlSchemaValidationFlags.ProcessInlineSchema;
        badSettings3.ValidationFlags |= XmlSchemaValidationFlags.ProcessSchemaLocation;
        XmlSchemaSet sc2 = new XmlSchemaSet();
        sc2.Add("urn:my-schema", "my.xsd");
        goodSettings.Schemas = sc2;
        XmlReader.Create(new StringReader(userProvidedXml), badSettings3);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
