using Microsoft.AspNetCore.Mvc;

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

// GOOD: Base class has AutoValidateAntiforgeryToken attribute
[AutoValidateAntiforgeryToken]
public abstract class BaseController : Controller
{
}

public class DerivedController : BaseController
{
    // GOOD: Inherits antiforgery validation from base class
    [HttpPost]
    public ActionResult InheritedValidation()
    {
        return View();
    }
}

// BAD: Base class without antiforgery attribute
public abstract class UnprotectedBaseController : Controller
{
}

public class DerivedUnprotectedController : UnprotectedBaseController
{
    // BAD: No antiforgery validation on this or any base class
    [HttpPost]
    public ActionResult NoInheritedValidation()
    {
        return View();
    }
}
