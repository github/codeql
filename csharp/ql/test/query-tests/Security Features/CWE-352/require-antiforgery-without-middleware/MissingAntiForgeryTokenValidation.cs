using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Mvc;

public class HomeController : Controller
{
    [HttpPost]
    [ValidateAntiForgeryToken]
    public ActionResult FilterValidated()
    {
        return View();
    }

    [HttpPost]
    [RequireAntiforgeryToken]
    public ActionResult MetadataWithoutMiddleware() // $ Alert
    {
        return View();
    }
}
