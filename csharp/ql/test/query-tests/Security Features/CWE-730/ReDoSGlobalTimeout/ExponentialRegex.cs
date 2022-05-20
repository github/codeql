using System;
using System.Web;
using System.Text.RegularExpressions;

public class RegexHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        AppDomain domain = AppDomain.CurrentDomain;
        // Set a timeout interval of 2 seconds.
        domain.SetData("REGEX_DEFAULT_MATCH_TIMEOUT", TimeSpan.FromSeconds(2));
        string userInput = ctx.Request.QueryString["userInput"];

        // GOOD: Global timeout
        new Regex("^([a-z]+)+$").Match(userInput);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

}
