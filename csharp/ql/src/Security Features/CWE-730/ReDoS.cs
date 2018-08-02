using System;
using System.Web;
using System.Text.RegularExpressions;

public class ReDoSHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD: User input is matched against a regex with exponential worst case behavior
        new Regex("^([a-z]*)*$").Match(userInput);

        // GOOD: Regex is given a timeout to avoid DoS
        new Regex("^([a-z]*)*$",
                  RegexOptions.IgnoreCase,
                  TimeSpan.FromSeconds(1)).Match(userInput);
    }
}
