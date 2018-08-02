using System.Web.Mvc;

public class HomeController : Controller
{
    // BAD: Anti forgery token has been forgotten
    [HttpPost]
    public ActionResult Login()
    {
        return View();
    }

    // GOOD: Anti forgery token is validated
    [HttpPost]
    [ValidateAntiForgeryToken]
    public ActionResult UpdateDetails()
    {
        return View();
    }
}
