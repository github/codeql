class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("auth"); // GOOD: httpOnlyCookies is set to true in config
    }
}
