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