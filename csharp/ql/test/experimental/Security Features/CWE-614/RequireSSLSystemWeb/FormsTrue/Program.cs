// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

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

    void CookieDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        cookie.Secure = false; // GOOD: separate query for setting `false`
    }

    void CookieDirectFalseInitializer()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = false }; // GOOD: separate query for setting `false`
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

    void CookieIntermediateFalse()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        bool v = false;
        cookie.Secure = v; // GOOD: separate query for setting `false`
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = v }; // GOOD: separate query for setting `false`
    }
}
