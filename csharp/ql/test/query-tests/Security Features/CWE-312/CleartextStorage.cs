// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

using System.Text;
using System.Web;
using System.Web.Security;

public class ClearTextStorageHandler : IHttpHandler
{
    private string accountKey;

    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: Setting a cookie value or values with sensitive data.
        ctx.Response.Cookies["MyCookie"].Value = accountKey;
        ctx.Response.Cookies["MyOtherCookie"]["Sensitive"] = GetPassword();
        ctx.Response.Cookies["MyOtherCookie"].Values["Sensitive"] = GetPassword();
        ctx.Response.Cookies["MyCookie"].Value = GetAccountID();
        // GOOD: Encoding the value before setting it.
        ctx.Response.Cookies["MyCookie"].Value = Encode(accountKey, "Account key");

        // OK: Account name is not considered to be secret data
        ctx.Response.Cookies["MyCookie"].Value = GetAccountName();
        ILogger logger = new ILogger();
        // BAD: Logging sensitive data
        logger.Warn(GetPassword());
        // GOOD: Logging encrypted sensitive data
        logger.Warn(Encode(GetPassword(), "Password"));
    }

    public string Encode(string value, string type)
    {
        return Encoding.UTF8.GetString(MachineKey.Protect(Encoding.UTF8.GetBytes(value), type));
    }

    public string GetPassword()
    {
        return "password";
    }

    public string GetAccountName()
    {
        return "accountName";
    }

    public string GetAccountID()
    {
        return "accountID";
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}

class ILogger
{
    public void Warn(string message) { }
}
