public void Login(HttpContext ctx, string username, string password)
{
    if (FormsAuthentication.Authenticate(username, password)
    {
        // BAD: Reusing the previous session
        ctx.Session["Mode"] = GetModeForUser(username);
    }
}
