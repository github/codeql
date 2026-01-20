class MyController : Controller
{
    void Login()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = true };
        Response.Cookies.Append("auth", "secret", cookieOptions);
    }
}