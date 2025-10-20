class MyController : Controller
{
    void Login()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { HttpOnly = true };
    }
}