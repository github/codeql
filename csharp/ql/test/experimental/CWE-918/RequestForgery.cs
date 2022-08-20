// semmle-extractor-options: ${testdir}/../../resources/stubs/System.Web.cs /r:System.Threading.Tasks.dll /r:System.Collections.Specialized.dll /r:System.Runtime.dll /r:System.Private.Uri.dll

using System;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Net.Http;

namespace RequestForgery.Controllers
{
    public class SSRFController : Controller
    {
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Bad(string url)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);

            var client = new HttpClient();
            await client.SendAsync(request);

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Good(string url)
        {
            string baseUrl = "www.mysecuresite.com/";
            if (url.StartsWith(baseUrl))
            {
                var request = new HttpRequestMessage(HttpMethod.Get, url);
                var client = new HttpClient();
                await client.SendAsync(request);

            }

            return View();
        }
    }
}
// Missing stubs:
namespace System.Net.Http
{
    public class HttpClient
    {
        public async Task SendAsync(HttpRequestMessage request) => throw null;
    }

    public class HttpRequestMessage
    {
        public HttpRequestMessage(HttpMethod method, string requestUri) => throw null;
    }

    public class HttpMethod
    {
        public static readonly HttpMethod Get;
    }
}
