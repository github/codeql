using System.Text;
using System.Web;
using System.Web.Security;

public class CleartextStorageHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string accountName = ctx.Request.QueryString["AccountName"];
        // BAD: Setting a cookie value with cleartext sensitive data.
        ctx.Response.Cookies["AccountName"].Value = accountName;
        // GOOD: Encoding the value before setting it.
        ctx.Response.Cookies["AccountName"].Value = Protect(accountName, "Account name");
    }

    /// <summary>
    /// Protect the cleartext value, using the given type.
    /// </summary>
    /// <value>
    /// The protected value, which is no longer cleartext.
    /// </value>
    public string Protect(string value, string type)
    {
        return Encoding.UTF8.GetString(MachineKey.Protect(Encoding.UTF8.GetBytes(value), type));
    }
}
