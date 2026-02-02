class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("cookieName"); // GOOD: requireSSL is set to true in config
    }
}
