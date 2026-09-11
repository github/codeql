using System.Collections.Generic;
using Microsoft.AspNetCore.Http;
using Microsoft.Net.Http.Headers;
using AspNetCoreHttpContext = Microsoft.AspNetCore.Http.HttpContext;

public class HeaderWrites
{
    public void AspNetCoreResponseHeaders(AspNetCoreHttpContext context)
    {
        context.Response.Headers.Append(HeaderNames.XFrameOptions, "DENY"); // $ Alert
        context.Response.Headers.Add("x-frame-options", "SAMEORIGIN"); // $ Alert
        context.Response.Headers.TryAdd(
            HeaderNames.ContentSecurityPolicy,
            "default-src 'self'; FrAmE-AnCeStOrS 'none'"); // $ Alert

        context.Response.Headers["X-Frame-Options"] = "DENY"; // $ Alert
        context.Response.Headers["Content-Security-Policy"] =
            "default-src 'self'; frame-ancestors 'none'"; // $ Alert

        context.Response.Headers.XFrameOptions = "DENY"; // $ Alert
        context.Response.Headers.ContentSecurityPolicy =
            "default-src 'self'; frame-ancestors 'self'"; // $ Alert
        context.Response.Headers["Content-Security-Policy"] =
            "default-src 'self', frame-ancestors 'none'"; // $ Alert

        IHeaderDictionary responseHeaders = context.Response.Headers;
        responseHeaders.Append("X-Frame-Options", "DENY"); // $ Alert
    }

    public void IgnoredHeaderWrites(AspNetCoreHttpContext context)
    {
        context.Request.Headers["X-Frame-Options"] = "DENY";

        IHeaderDictionary reassignedHeaders = context.Response.Headers;
        reassignedHeaders = context.Request.Headers;
        reassignedHeaders["X-Frame-Options"] = "DENY";

        var standaloneHeaders = new HeaderDictionary();
        standaloneHeaders.Append("X-Frame-Options", "DENY");
        standaloneHeaders["Content-Security-Policy"] = "frame-ancestors 'none'";

        context.Response.Headers["Content-Security-Policy-Report-Only"] =
            "frame-ancestors 'none'";
        context.Response.Headers.ContentSecurityPolicyReportOnly = "frame-ancestors 'none'";
        context.Response.Headers["X-Content-Security-Policy"] = "frame-ancestors 'none'";
        context.Response.Headers["Content-Security-Policy"] = "default-src 'self'";
        context.Response.Headers["Content-Security-Policy"] =
            "report-uri https://example.test/frame-ancestors";
        context.Response.Headers["Content-Security-Policy"] =
            "default-src 'self'; not-frame-ancestors 'none'";
    }
}
