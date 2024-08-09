using System.Web.Mvc;

public class HomeController : Controller
{
    // BAD: Anti forgery token has been forgotten
    [HttpPost]
    public string Login()
    {
        return View();
    }

    // GOOD: Anti forgery token is validated
    [HttpPost]
    [ValidateAntiForgeryToken]
    public string UpdateDetails()
    {
        return View();
    }

    // Dummy View method to allow compilation
    protected string View()
    {
        // Simulate returning a view. In a real application, this would return an actual view using a subclass of ActionResult.
        return "This is a dummy view.";
    }
}

