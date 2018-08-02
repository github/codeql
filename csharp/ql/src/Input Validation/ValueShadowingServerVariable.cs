class ValueShadowingServerVariable
{
    public bool isHTTPS(HttpRequest request)
    {
        String https = request["HTTPS"];
        return https == "ON";
    }
}
