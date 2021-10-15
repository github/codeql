using System;
using System.Web;
using System.Text.RegularExpressions;

public class RegexHandler : IHttpHandler
{
    private static readonly string JAVA_CLASS_REGEX = "^(([a-z])+.)+[A-Z]([a-z])+$";

    public void ProcessRequest(HttpContext ctx)
    {
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD:
        // Artificial regexes
        new Regex("^([a-z]+)+$").Match(userInput);
        new Regex("^([a-z]*)*$").Replace(userInput, "");
        // Known exponential blowup regex for e-mail address validation
        // Problematic part is: ([a-zA-Z0-9]+))*
        new Regex("^([a-zA-Z0-9])(([\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$").Match(userInput);
        // Known exponential blowup regex for Java class name validation
        // Problematic part is: (([a-z])+.)+
        new Regex(JAVA_CLASS_REGEX).Match(userInput);
        // Static use
        Regex.Match(userInput, JAVA_CLASS_REGEX);
        // GOOD:
        new Regex("^(([a-b]+[c-z]+)+$").Match(userInput);
        new Regex("^([a-z]+)+$", RegexOptions.IgnoreCase, TimeSpan.FromSeconds(1)).Match(userInput);
        Regex.Match(userInput, JAVA_CLASS_REGEX, RegexOptions.IgnoreCase, TimeSpan.FromSeconds(1));
        // Known possible FP.
        new Regex("^[a-z0-9]+([_.-][a-z0-9]+)*$").Match(userInput);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

}
