public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        try
        {
       ...
    }
        catch (AuthenticationFailure ex)
        {
            ctx.Response.Write("Invalid password: " + password);
        }
    }
}
