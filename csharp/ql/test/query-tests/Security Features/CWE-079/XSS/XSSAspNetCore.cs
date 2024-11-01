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
            var source = Request.Query["Bad data"]; // $ Source=req1
            v.ViewData["BadData"] = new HtmlString(source); // $ Alert=req1

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
        public IActionResult Submit([FromQuery] string foo) // $ Source=foo
        {
            var view = new ViewResult();
            //BAD: flow of submitted value to view in HtmlString.
            view.ViewData["FOO"] = new HtmlString(foo); // $ Alert=foo
            return view;
        }

        public IActionResult IndexToModel()
        {
            //BAD: flow of submitted value to view in HtmlString.
            var req2 = Request.QueryString.Value; // $ Source=req2
            HtmlString v = new HtmlString(req2); // $ Alert=req2
            return View(new HomeViewModel() { Message = "Message from Index", Description = v });
        }

        public IActionResult About()
        {
            //BAD: flow of submitted value to view in HtmlString.
            var req3 = Request.Query["Foo"].ToString(); // $ Source=req3
            HtmlString v = new HtmlString(req3); // $ Alert=req3

            //BAD: flow of submitted value to view in HtmlString.
            var req4 = Request.Query["Foo"][0]; // $ Source=req4
            HtmlString v1 = new HtmlString(req4); // $ Alert=req4

            return View(new HomeViewModel() { Message = "Message from About", Description = v });
        }

        public IActionResult Contact()
        {
            //BAD: flow of user content type to view in HtmlString.
            var ct = Request.ContentType; // $ Source=ct
            HtmlString v = new HtmlString(ct); // $ Alert=ct

            //BAD: flow of headers to view in HtmlString.
            var header = Request.Headers["Foo"]; // $ Source=header
            HtmlString v1 = new HtmlString(value: header); // $ Alert=header

            return View(new HomeViewModel() { Message = "Message from Contact", Description = v });
        }
    }
}
