class ValueShadowing
{
    public bool checkCSRF(HttpRequest request)
    {
        string postCSRF = request["csrf"];
        string cookieCSRF = request.Cookies["csrf"];
        return postCSRF.Equals(cookieCSRF);
    }
}
