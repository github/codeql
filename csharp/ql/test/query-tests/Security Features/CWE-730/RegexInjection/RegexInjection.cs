using System;
using System.Web;
using System.Text.RegularExpressions;

public class RegexInjectionHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string regex = ctx.Request.QueryString["regex"]; // $ Source=r1
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD: User input used as regex
        new Regex(regex).Match(userInput); // $ Alert=r1
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
