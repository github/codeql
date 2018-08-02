// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

class Program
{
    void SetHttpCookie(System.Web.HttpCookie cookies)
    {
        cookies.Secure = true;
    }
}
