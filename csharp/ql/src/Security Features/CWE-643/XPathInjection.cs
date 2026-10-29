using System;
using System.Web;
using System.Xml.XPath;

public class XPathInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];

        // BAD: Use user-provided data directly in an XPath expression
        string badXPathExpr = "//users/user[login/text()='" + userName + "']/home_dir/text()";
        XPathExpression.Compile(badXPathExpr);

        // GOOD: XPath expression uses variables to refer to parameters
        string xpathExpression = "//users/user[login/text()=$username]/home_dir/text()";
        XPathExpression xpath = XPathExpression.Compile(xpathExpression);

        // Arguments are provided as a XsltArgumentList()
        XsltArgumentList varList = new XsltArgumentList();
        varList.AddParam("userName", string.Empty, userName);

        // CustomContext is an application specific class, that looks up variables in the
        // expression from the varList.
        CustomContext context = new CustomContext(new NameTable(), varList)
      xpath.SetContext(context);
    }
}
