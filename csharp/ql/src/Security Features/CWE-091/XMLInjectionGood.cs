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