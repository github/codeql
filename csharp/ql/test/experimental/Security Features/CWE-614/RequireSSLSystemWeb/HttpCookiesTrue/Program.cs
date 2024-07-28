class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("cookieName"); // GOOD: requireSSL is set to true in config
    }

    void CookieDirectTrue()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        cookie.Secure = true;  // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = true }; // GOOD
    }

    void CookieIntermediateTrue()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        bool v = true;
        cookie.Secure = v; // GOOD: should track local data flow
    }

    void CookieIntermediateTrueInitializer()
    {
        bool v = true;
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = v }; // GOOD: should track local data flow
    }
}
