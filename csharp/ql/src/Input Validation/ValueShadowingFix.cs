class ValueShadowingFix
{
    public bool checkCSRF(HttpRequest request)
    {
        string postCSRF = request.Form["csrf"];
        string cookieCSRF = request.Cookies["csrf"];
        return postCSRF.Equals(cookieCSRF);
    }
}
