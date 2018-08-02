using System;
using System.Web;
using System.Text.RegularExpressions;

public class RegexInjectionHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string name = ctx.Request.QueryString["name"];
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD: Unsanitized user input is used to construct a regular expression
        new Regex("^" + name + "=.*$").Match(userInput);

        // GOOD: User input is sanitized before constructing the regex
        string safeName = Regex.Escape(name);
        new Regex("^" + safeName + "=.*$").Match(userInput);
    }
}
