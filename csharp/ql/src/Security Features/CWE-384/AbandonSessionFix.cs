public void Login(HttpContext ctx, string username, string password)
{
    if (FormsAuthentication.Authenticate(username, password)
    {
        // GOOD: Abandon the session first.
        ctx.Session.Abandon();
    }
}
