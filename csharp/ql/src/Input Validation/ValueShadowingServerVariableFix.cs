class ValueShadowingServerVariableFix
{
    public bool isHTTPS(HttpRequest request)
    {
        String https = request.ServerVariables["HTTPS"];
        return https == "ON";
    }
}
