using System;
using System.IO;
using System.Web;
using System.Net;

public class TaintedWebClientHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String url = ctx.Request.QueryString["domain"];

        // BAD: This could read any file on the filesystem. (../../../../etc/passwd)
		using(WebClient client = new WebClient()) {
			ctx.Response.Write(client.DownloadString(url));
        }

        // BAD: This could still read any file on the filesystem. (https://../../../../etc/passwd)
        if (url.StartsWith("https://")){
            using(WebClient client = new WebClient()) {
                ctx.Response.Write(client.DownloadString(url));
            }
        }

        // GOOD: IsWellFormedUriString ensures that it is a valid URL
        if (Uri.IsWellFormedUriString(url, UriKind.Absolute)){
            using(WebClient client = new WebClient()) {
                ctx.Response.Write(client.DownloadString(url));
            }
        }
    }
}
