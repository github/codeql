// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll ${testdir}/../../../resources/stubs/System.Data.cs /r:System.Private.Xml.dll /r:System.Xml.XPath.dll /r:System.Data.Common.dll

using System;
using System.Web;
using System.Xml;
using System.Xml.XPath;

public class XPathInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];
        string password = ctx.Request.QueryString["password"];

        // BAD: User input used directly in an XPath expression
        XPathExpression.Compile("//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()");
        XmlNode xmlNode = null;
        // BAD: User input used directly in an XPath expression to SelectNodes
        xmlNode.SelectNodes("//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()");

        // GOOD: Uses parameters to avoid including user input directly in XPath expression
        XPathExpression.Compile("//users/user[login/text()=$username]/home_dir/text()");
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
