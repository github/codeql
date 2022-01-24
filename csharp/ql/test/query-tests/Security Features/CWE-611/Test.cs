using System;
using System.Web;
using System.Web.Mvc;
using System.Xml;

public class XMLHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: XmlTextReader is insecure with these options, using user-provided data
        XmlTextReader reader = new XmlTextReader(ctx.Request.QueryString["document"]) { DtdProcessing = DtdProcessing.Parse, XmlResolver = new XmlUrlResolver() };
    }

    public void insecureXMLBad(string content)
    {
        XmlReaderSettings settings = new XmlReaderSettings();
        settings.DtdProcessing = DtdProcessing.Parse;
        settings.XmlResolver = new XmlUrlResolver();

        // BAD: insecure settings
        XmlReader reader1 = XmlReader.Create(content, settings);

        // BAD: XmlTextReader is insecure with these options
        XmlTextReader reader2 = new XmlTextReader(content) { DtdProcessing = DtdProcessing.Parse, XmlResolver = new XmlUrlResolver() };
    }

    public void insecureXMLGood(string content)
    {
        // GOOD: XmlDocument is secure after 4.6
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(content);

        // GOOD: XmlTextReader is secure by default after 4.5.2
        XmlTextReader reader = new XmlTextReader(content);

        // GOOD: prohibit DTD processing
        XmlTextReader reader1 = new XmlTextReader(content) { DtdProcessing = DtdProcessing.Prohibit };

        // GOOD: set resolver to null
        XmlTextReader reader2 = new XmlTextReader(content) { XmlResolver = null };

        // GOOD: set resolver to null
        XmlDocument doc2 = new XmlDocument() { XmlResolver = null };
        doc2.LoadXml(content);
    }

    public bool IsReusable
    {
        get => true;
    }
}
