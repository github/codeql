// semmle-extractor-options: /r:System.Private.Xml.dll /r:System.Xml.dll /r:System.Xml.ReaderWriter.dll /r:System.Runtime.Extensions.dll /r:System.Collections.Specialized.dll ${testdir}/../../../../resources/stubs/System.Web.cs

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

  public bool IsReusable {
    get {
      return true;
    }
  }
}
