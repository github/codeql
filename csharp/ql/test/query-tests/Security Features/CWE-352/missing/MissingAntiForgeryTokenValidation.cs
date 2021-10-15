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

    // No validation required, as this is a GET method.
    public ActionResult ShowHelp()
    {
        return View();
    }

    // Should be ignored, because it is not an action method
    [NonAction]
    public void UtilityMethod()
    {
    }
}
