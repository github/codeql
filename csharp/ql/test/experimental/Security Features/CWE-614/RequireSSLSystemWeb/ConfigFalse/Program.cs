// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("cookieName"); // BAD: requireSSL is set to false in config
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
