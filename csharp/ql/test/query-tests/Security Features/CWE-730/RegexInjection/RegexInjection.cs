// semmle-extractor-options: ${testdir}/../../../../resources/stubs/System.Web.cs /r:System.Text.RegularExpressions.dll /r:System.Collections.Specialized.dll

using System;
using System.Web;
using System.Text.RegularExpressions;

public class RegexInjectionHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string regex = ctx.Request.QueryString["regex"];
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD: User input used as regex
        new Regex(regex).Match(userInput);
        // GOOD: User input escaped before being used as regex
        new Regex(Regex.Escape(regex)).Match(userInput);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

}
