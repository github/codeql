public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        try
        {
       ...
    }
        catch (DbException ex)
        {
            ctx.Response.Write("Database error: " + ex.Message);
        }
    }
}
