using System;
using System.Net;
using System.Web;

public class ConditionalBypassHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string user = ctx.Request.QueryString["user"];
        string password = ctx.Request.QueryString["password"];
        string isAdmin = ctx.Request.QueryString["isAdmin"]; // $ Source=r1

        // BAD: login is only executed if isAdmin is false, but isAdmin
        // is controlled by the user
        if (isAdmin == "false") // $ Alert=r1
            login(user, password);

        HttpCookie adminCookie = ctx.Request.Cookies["adminCookie"]; // $ Source=r2 Source=r3 Source=r4
        // BAD: login is only executed if the cookie value is false, but the cookie
        // is controlled by the user
        if (adminCookie.Value.Equals("false")) // $ Alert=r2 Alert=r3 Alert=r4
            login(user, password);

        // FALSE POSITIVES: both methods are conditionally executed, but they probably
        // both perform the security-critical action
        if (adminCookie.Value == "false") // $ SPURIOUS: Alert=r3 Alert=r4 Alert=r2
        {
            login(user, password);
        }
        else
        {
            reCheckAuth(user, password);
        }

        // FALSE NEGATIVE: we have no way of telling that the skipped method is sensitive
        if (adminCookie.Value == "false")
            doReallyImportantSecurityWork();

        // BAD: DNS may be controlled by the user
        IPAddress hostIPAddress = IPAddress.Parse("1.2.3.4");
        IPHostEntry hostInfo = Dns.GetHostByAddress(hostIPAddress); // $ Source=r5 Source=r6
        // Exact comparison
        if (hostInfo.HostName == "trustme.com") // $ Alert=r5 Alert=r6
        {
            login(user, password);
        }
        // Substring comparison
        if (hostInfo.HostName.EndsWith("trustme.com")) // $ Alert=r6 Alert=r5
        {
            login(user, password);
        }
    }

    public static void Test(HttpContext ctx, String user, String password)
    {
        HttpCookie adminCookie = ctx.Request.Cookies["adminCookie"];
        // GOOD: login always happens
        if (adminCookie.Value == "false")
            login(user, password);
        else
        {
            // do something else
            login(user, password);
        }
    }

    public static void Test2(HttpContext ctx, String user, String password)
    {
        HttpCookie adminCookie = ctx.Request.Cookies["adminCookie"]; // $ Source=r7
        // BAD: login may happen once or twice
        if (adminCookie.Value == "false") // $ Alert=r7
            login(user, password);
        else
        {
            // do something else
        }
        login(user, password);
    }

    public static void Test3(HttpContext ctx, String user, String password)
    {
        HttpCookie adminCookie = ctx.Request.Cookies["adminCookie"]; // $ Source=r8
        if (adminCookie.Value == "false") // $ Alert=r8
            login(user, password);
        else
        {
            // do something else
            // BAD: login may not happen
            return;
        }
    }

    public static void Test4(HttpContext ctx, String user, String password)
    {
        HttpCookie adminCookie = ctx.Request.Cookies["adminCookie"];
        // GOOD: login always happens
        if (adminCookie.Value == "false")
        {
            login(user, password);
            return;
        }

        // do other things
        login(user, password);
        return;
    }

    public static void login(String user, String password)
    {
        // login
    }

    public static void reCheckAuth(String user, String password)
    {
        // login
    }

    public static void doIt() { }

    public static void doReallyImportantSecurityWork()
    {
        // login, authenticate, everything
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
