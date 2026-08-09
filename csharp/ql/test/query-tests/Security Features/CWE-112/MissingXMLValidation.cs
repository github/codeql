using System;
using System.IO;
using System.Web;
using System.Xml;
using System.Xml.Schema;

public class MissingXMLValidationHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        String userProvidedXml = ctx.Request.QueryString["userProvidedXml"]; // $ Source=r1 Source=r2 Source=r3 Source=r4 Source=r5

        // BAD: User provided XML is processed without any validation,
        //      because there is no settings instance configured.
        XmlReader.Create(new StringReader(userProvidedXml)); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5

        // BAD: User provided XML is processed without any validation,
        //      because the settings instance does not specify the ValidationType
        XmlReaderSettings badSettings1 = new XmlReaderSettings();
        XmlReader.Create(new StringReader(userProvidedXml), badSettings1); // $ Alert=r2 Alert=r1 Alert=r3 Alert=r4 Alert=r5

        // BAD: User provided XML is processed without any validation,
        //      because the settings instance specifies DTD as the ValidationType
        XmlReaderSettings badSettings2 = new XmlReaderSettings();
        badSettings2.ValidationType = ValidationType.DTD;
        XmlReader.Create(new StringReader(userProvidedXml), badSettings2); // $ Alert=r3 Alert=r1 Alert=r2 Alert=r4 Alert=r5

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
        XmlReader.Create(new StringReader(userProvidedXml), badSettings3); // $ Alert=r4 Alert=r5 Alert=r1 Alert=r2 Alert=r3
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
