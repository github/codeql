using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Builder;

public class HomeController : Controller
{
    private const bool ValidationEnabled = true;
    private const bool ValidationDisabled = false;

    // BAD: Anti forgery token has been forgotten
    [HttpPost]
    public ActionResult Login() // $ Alert
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

    // GOOD: Anti forgery token is required by ASP.NET Core middleware
    [HttpPost]
    [RequireAntiforgeryToken]
    public ActionResult UpdateProfile()
    {
        return View();
    }

    // GOOD: Explicitly requires anti forgery validation
    [HttpPost]
    [RequireAntiforgeryToken(true)]
    public ActionResult UpdatePreferences()
    {
        return View();
    }

    // GOOD: Named and constant arguments are supported
    [HttpPost]
    [RequireAntiforgeryToken(required: ValidationEnabled)]
    public ActionResult UpdateSettings()
    {
        return View();
    }

    // BAD: Explicitly disables anti forgery validation
    [HttpPost]
    [RequireAntiforgeryToken(false)]
    public ActionResult DisabledValidation() // $ Alert
    {
        return View();
    }

    // BAD: A false constant also disables anti forgery validation
    [HttpPost]
    [RequireAntiforgeryToken(ValidationDisabled)]
    public ActionResult ConstantDisabledValidation() // $ Alert
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

// GOOD: Base class requires anti forgery validation
[RequireAntiforgeryToken]
public abstract class AntiforgeryBaseController : Controller
{
}

public abstract class IntermediateAntiforgeryController : AntiforgeryBaseController
{
}

public class DerivedAntiforgeryController : IntermediateAntiforgeryController
{
    [HttpPost]
    public ActionResult InheritedRequiredValidation()
    {
        return View();
    }
}

[RequireAntiforgeryToken]
public class ProtectedController : Controller
{
    // GOOD: Controller requires anti forgery validation
    [HttpPost]
    public ActionResult ProtectedAction()
    {
        return View();
    }

    // BAD: Action-level metadata overrides the controller metadata
    [HttpPost]
    [RequireAntiforgeryToken(false)]
    public ActionResult DisabledAction() // $ Alert
    {
        return View();
    }
}

[RequireAntiforgeryToken(false)]
public class DisabledController : Controller
{
    // BAD: Controller explicitly disables anti forgery validation
    [HttpPost]
    public ActionResult DisabledControllerAction() // $ Alert
    {
        return View();
    }

    // GOOD: Action-level metadata overrides the controller metadata
    [HttpPost]
    [RequireAntiforgeryToken(true)]
    public ActionResult EnabledAction()
    {
        return View();
    }
}

[RequireAntiforgeryToken]
public abstract class ProtectedBaseController : Controller
{
}

[RequireAntiforgeryToken(false)]
public class DisabledDerivedController : ProtectedBaseController
{
    // BAD: Derived controller metadata overrides base controller metadata
    [HttpPost]
    public ActionResult DisabledInheritedAction() // $ Alert
    {
        return View();
    }
}

[AutoValidateAntiforgeryToken]
public class FilterProtectedController : Controller
{
    // GOOD: Disabled middleware metadata does not disable the MVC filter
    [HttpPost]
    [RequireAntiforgeryToken(false)]
    public ActionResult FilterProtectedAction()
    {
        return View();
    }
}

public abstract class MethodMetadataBaseController : Controller
{
    [RequireAntiforgeryToken]
    public virtual ActionResult InheritedMethodValidation()
    {
        return View();
    }
}

public class MethodMetadataController : MethodMetadataBaseController
{
    // GOOD: Method metadata is inherited by the override
    [HttpPost]
    public override ActionResult InheritedMethodValidation()
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
    public ActionResult NoInheritedValidation() // $ Alert
    {
        return View();
    }
}

namespace Custom
{
    public class RequireAntiforgeryTokenAttribute : System.Attribute
    {
    }

    public class CustomAttributeController : Controller
    {
        // BAD: An unrelated attribute with the same name does not provide validation
        [HttpPost]
        [RequireAntiforgeryToken]
        public ActionResult LookalikeAttribute() // $ Alert
        {
            return View();
        }
    }
}

public class Startup
{
    public void Configure(IApplicationBuilder app)
    {
        app.UseAntiforgery();
    }
}
