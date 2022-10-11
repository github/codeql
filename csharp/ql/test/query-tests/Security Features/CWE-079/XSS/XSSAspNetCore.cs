using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Html;
using Microsoft.Extensions.Primitives;

namespace Testing.Controllers
{
    public class HomeViewModel
    {
        public string Message { get; set; }

        public HtmlString Description { get; set; }
    }

    public class TestController : Controller
    {
        public IActionResult Index()
        {
            // BAD: flow of content type to.
            var v = new ViewResult();
            v.ViewData["BadData"] = new HtmlString(Request.Query["Bad data"]);

            StringValues vOut;
            Request.Query.TryGetValue("Foo", out vOut);

            // BAD: via Enumerable. (false negative)
            v.ViewData["FooFirst"] = new HtmlString(vOut.First());

            // BAD: via toArray. (false negative)
            v.ViewData["FooArray0"] = new HtmlString(vOut.ToArray()[0]);

            // BAD: via implicit conversion operator. (false negative)
            v.ViewData["FooImplicit"] = new HtmlString(vOut);

            return v;
        }

        [HttpPost("Test")]
        [ValidateAntiForgeryToken]
        public IActionResult Submit([FromQuery] string foo)
        {
            var view = new ViewResult();
            //BAD: flow of submitted value to view in HtmlString.
            view.ViewData["FOO"] = new HtmlString(foo);
            return view;
        }

        public IActionResult IndexToModel()
        {
            //BAD: flow of submitted value to view in HtmlString.
            HtmlString v = new HtmlString(Request.QueryString.Value);
            return View(new HomeViewModel() { Message = "Message from Index", Description = v });
        }

        public IActionResult About()
        {
            //BAD: flow of submitted value to view in HtmlString.
            HtmlString v = new HtmlString(Request.Query["Foo"].ToString());

            //BAD: flow of submitted value to view in HtmlString.
            HtmlString v1 = new HtmlString(Request.Query["Foo"][0]);

            return View(new HomeViewModel() { Message = "Message from About", Description = v });
        }

        public IActionResult Contact()
        {
            //BAD: flow of user content type to view in HtmlString.
            HtmlString v = new HtmlString(Request.ContentType);

            //BAD: flow of headers to view in HtmlString.
            HtmlString v1 = new HtmlString(value: Request.Headers["Foo"]);

            return View(new HomeViewModel() { Message = "Message from Contact", Description = v });
        }
    }
}
