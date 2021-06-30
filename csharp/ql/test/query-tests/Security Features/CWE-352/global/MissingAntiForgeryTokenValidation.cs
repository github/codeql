using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;

public class HomeController : Controller
{
    // This is fine because of the global filter
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

public class AntiForgeryFilter : FilterAttribute, IAuthorizationFilter
{
    public void OnAuthorization(AuthorizationContext filterContext)
    {
        AntiForgery.Validate();
    }
}
public class UserApplication : HttpApplication
{
    public void Application_Start()
    {
        GlobalFilters.Filters.Add(new AntiForgeryFilter());
    }
}
