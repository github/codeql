# Missing XML validation

```
ID: cs/xml/missing-validation
Kind: path-problem
Severity: recommendation
Precision: high
Tags: security external/cwe/cwe-112

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-112/MissingXMLValidation.ql)

If unsanitized user input is processed as XML, it should be validated against a known schema. If no validation occurs, or if the validation relies on the schema or DTD specified in the document itself, then the XML document may contain any data in any form, which may invalidate assumptions the program later makes.


## Recommendation
All XML provided by a user should be validated against a known schema when it is processed.

If using `XmlReader.Create`, you should always pass an instance of `XmlReaderSettings`, with the following properties:

* `ValidationType` must be set to `Schema`. If this property is unset, no validation occurs. If it is set to `DTD`, the document is only validated against the DTD specified in the user-provided document itself - which could be specified as anything by a malicious user.
* `ValidationFlags` must not include `ProcessInlineSchema` or `ProcessSchemaLocation`. These flags allow a user to provide their own inline schema or schema location for validation, allowing a malicious user to bypass the known schema validation.

## Example
In the following example, text provided by a user is loaded using `XmlReader.Create`. In the first three examples, insufficient validation occurs, because either no validation is specified, or validation is only specified against a DTD provided by the user, or the validation permits a user to provide an inline schema. In the final example, a known schema is provided, and validation is set, using an instance of `XmlReaderSettings`. This ensures that the user input is properly validated against the known schema.


```csharp
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

```

## References
* Microsoft: [XML Schema (XSD) Validation with XmlSchemaSet](https://msdn.microsoft.com/en-us/library/3740e0b5(v=vs.110).aspx).
* Common Weakness Enumeration: [CWE-112](https://cwe.mitre.org/data/definitions/112.html).