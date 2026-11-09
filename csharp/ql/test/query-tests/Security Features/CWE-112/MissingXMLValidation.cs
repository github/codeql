using System;
using System.IO;
using System.Text;
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

    public void ProcessInitializedSettings(HttpContext ctx)
    {
        string xml = ctx.Request.QueryString["xml"];
        var schemaSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        schemaSettings.Schemas.Add("urn:my-schema", "my.xsd");
        XmlReader.Create(new StringReader(xml), schemaSettings);

        var inlineSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema,
            ValidationFlags = XmlSchemaValidationFlags.ProcessInlineSchema
        };
        XmlReader.Create(new StringReader(xml), inlineSettings); // $ Alert

        var locationSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema,
            ValidationFlags = XmlSchemaValidationFlags.ProcessSchemaLocation
        };
        XmlReader.Create(new StringReader(xml), locationSettings); // $ Alert

        var resetSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        resetSettings.ValidationType = ValidationType.None;
        XmlReader.Create(new StringReader(xml), resetSettings); // $ Alert

        var unknownSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        unknownSettings.ValidationType = (ValidationType)int.Parse(ctx.Request.QueryString["type"]);
        XmlReader.Create(new StringReader(xml), unknownSettings); // $ Alert

        var escapedSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        DisableValidation(escapedSettings);
        XmlReader.Create(new StringReader(xml), escapedSettings); // $ Alert

        var unknownFlagsSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        unknownFlagsSettings.ValidationFlags =
            (XmlSchemaValidationFlags)int.Parse(ctx.Request.QueryString["flags"]);
        XmlReader.Create(new StringReader(xml), unknownFlagsSettings); // $ Alert

        var aliasSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        var alias = aliasSettings;
        alias.ValidationType = ValidationType.None;
        XmlReader.Create(new StringReader(xml), aliasSettings); // $ Alert

        var capturedSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        Action reset = () => capturedSettings.ValidationType = ValidationType.None;
        reset();
        XmlReader.Create(new StringReader(xml), capturedSettings); // $ Alert

        var storedSettings = new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema
        };
        SharedSettings = storedSettings;
        DisableValidation(SharedSettings);
        XmlReader.Create(new StringReader(xml), storedSettings); // $ Alert

        var returnedSettings = CreateSettings();
        DisableValidation(returnedSettings);
        XmlReader.Create(new StringReader(xml), returnedSettings); // $ Alert

        XmlReader.Create(new StringReader(xml), new XmlReaderSettings
        {
            ValidationType = ValidationType.Schema,
            ValidationFlags = XmlSchemaValidationFlags.ProcessIdentityConstraints |
                XmlSchemaValidationFlags.AllowXmlAttributes
        });
    }

    private static XmlReaderSettings SharedSettings;

    private static XmlReaderSettings CreateSettings()
    {
        return new XmlReaderSettings { ValidationType = ValidationType.Schema };
    }

    private static void DisableValidation(XmlReaderSettings settings)
    {
        settings.ValidationType = ValidationType.None;
    }

    public void ProcessStreams(HttpContext ctx)
    {
        var input = new MemoryStream(Encoding.UTF8.GetBytes(ctx.Request.QueryString["xml"]));
        input.CopyTo(Stream.Null);
        XmlReader.Create(Stream.Null);

        var stream = new MemoryStream();
        input.CopyTo(stream);
        stream.Position = 0;
        XmlReader.Create(stream); // $ Alert

        Streams.Null = new MemoryStream(Encoding.UTF8.GetBytes(ctx.Request.QueryString["otherXml"]));
        XmlReader.Create(Streams.Null); // $ Alert
    }

    private static class Streams
    {
        public static Stream Null;
    }
}
