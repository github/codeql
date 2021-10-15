using System.Web;
using System.Web.Security;

public class Handler1 : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {

        if (FormsAuthentication.Authenticate("username", "password"))
        {
            ctx.Session["foo"] = "bar"; // BAD: Session has not been abandoned
            ctx.Session.Abandon();
            ctx.Session["foo"] = "bar"; // GOOD: Session is abandoned
        }
        else
        {
            ctx.Session["foo"] = "bar"; // GOOD: Logon didn't succeed
        }
    }

    public bool IsReusable => true;
}

public class Handler2 : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {

        if (Membership.ValidateUser("username", "password"))
        {
            AbandonSession(ctx);
            ctx.Session["foo"] = "bar"; // GOOD: Session is abandoned (indirectly)
        }
    }

    void AbandonSession(HttpContext ctx)
    {
        ctx.Session.Clear();
    }

    public bool IsReusable => true;
}

public class Handler3 : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {

        if (Membership.ValidateUser("username", "password"))
        {
            ctx.Session["foo"] = "bar";  // BAD: Session not abandoned
        }
        ctx.Session["foo"] = "bar"; // BAD: here as well
    }

    public bool IsReusable => true;
}
