using System;
using System.IO;
using System.Web;
using System.Xml;
using System.Xml.Schema;

public class MissingXmlValidationHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        String userProvidedXml = ctx.Request.QueryString["userProvidedXml"];

        // BAD: User provided XML is processed without any validation,
        //      because there is no settings instance configured.
        XmlReader.Create(new StringReader(userProvidedXml));

        // BAD: User provided XML is processed without any validation,
        //      because the settings instance specifies DTD as the ValidationType
        XmlReaderSettings badSettings = new XmlReaderSettings();
        badSettings.ValidationType = ValidationType.DTD;
        XmlReader.Create(new StringReader(userProvidedXml), badSettings);

        // BAD: User provided XML is processed with validation, but the ProcessInlineSchema
        //      option is specified, so an attacker can provide their own schema to validate
        //      against.
        XmlReaderSettings badInlineSettings = new XmlReaderSettings();
        badInlineSettings.ValidationType = ValidationType.Schema;
        badInlineSettings.ValidationFlags |= XmlSchemaValidationFlags.ProcessInlineSchema;
        XmlReader.Create(new StringReader(userProvidedXml), badInlineSettings);

        // GOOD: User provided XML is processed with validation
        XmlReaderSettings goodSettings = new XmlReaderSettings();
        goodSettings.ValidationType = ValidationType.Schema;
        goodSettings.Schemas = new XmlSchemaSet() { { "urn:my-schema", "my.xsd" } };
        XmlReader.Create(new StringReader(userProvidedXml), goodSettings);
    }
}
