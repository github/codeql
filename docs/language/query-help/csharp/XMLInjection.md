# XML injection

```
ID: cs/xml-injection
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-091

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-091/XMLInjection.ql)

The APIs provided by the .NET libraries for XML manipulation allow the insertion of "raw" text at a specified point in an XML document. If user input is passed to this API, it could allow a malicious user to add extra content that could corrupt or supersede existing content, or enable unintended additional functionality.


## Recommendation
Avoid using the `WriteRaw` method on `System.Xml.XmlWriter` with user input. If possible, use the high-level APIs to write new XML elements to a document, as these automatically escape user content. If that is not possible, then user input should be escaped before being included in a string that will be used with the `WriteRaw` API.


## Example
In this example, user input is provided describing the name of an employee to add to an XML document representing a set of names. The `WriteRaw` API is used to write the new employee record to the XML file.


```csharp
using System;
using System.Security;
using System.Web;
using System.Xml;

public class XMLInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string employeeName = ctx.Request.QueryString["employeeName"];

    using (XmlWriter writer = XmlWriter.Create("employees.xml"))
    {
        writer.WriteStartDocument();

        // BAD: Insert user input directly into XML
        writer.WriteRaw("<employee><name>" + employeeName + "</name></employee>");

        writer.WriteEndElement();
        writer.WriteEndDocument();
    }
  }
}
```
However, if a malicious user were to provide the content `Bobby Pages</name></employee><employee><name>Hacker1`, they would be able to add an extra entry into the XML file.

The corrected version demonstrates two ways to avoid this issue. The first is to escape user input before passing it to the `WriteRaw` API, which prevents a malicious user from closing or opening XML tags. The second approach uses the high level XML API to add XML elements, which ensures the content is appropriately escaped.


```csharp
using System;
using System.Security;
using System.Web;
using System.Xml;

public class XMLInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string employeeName = ctx.Request.QueryString["employeeName"];

    using (XmlWriter writer = XmlWriter.Create("employees.xml"))
    {
        writer.WriteStartDocument();

        // GOOD: Escape user input before inserting into string
        writer.WriteRaw("<employee><name>" + SecurityElement.Escape(employeeName) + "</name></employee>");

        // GOOD: Use standard API, which automatically encodes values
        writer.WriteStartElement("Employee");
        writer.WriteElementString("Name", employeeName);
        writer.WriteEndElement();

        writer.WriteEndElement();
        writer.WriteEndDocument();
    }
  }
```

## References
* Web Application Security Consortium: [XML Injection](http://projects.webappsec.org/w/page/13247004/XML%20Injection).
* Microsoft Docs: [WriteRaw](https://docs.microsoft.com/en-us/dotnet/api/system.xml.xmlwriter.writeraw?view=netframework-4.8).
* Common Weakness Enumeration: [CWE-91](https://cwe.mitre.org/data/definitions/91.html).