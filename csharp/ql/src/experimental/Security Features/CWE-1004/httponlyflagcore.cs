class MyController : Controller
{
    void Login()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { HttpOnly = true };
        Response.Cookies.Append("auth", "secret", cookieOptions);
    }
}