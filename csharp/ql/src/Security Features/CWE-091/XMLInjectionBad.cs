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