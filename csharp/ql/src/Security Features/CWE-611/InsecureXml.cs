public class XMLHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: XmlTextReader is insecure by default, and the payload is user-provided data
        XmlTextReader reader = new XmlTextReader(ctx.Request.QueryString["document"]);
    ...
  }
}

