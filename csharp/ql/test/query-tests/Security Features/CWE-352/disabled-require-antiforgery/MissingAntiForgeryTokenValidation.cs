using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;

public class HomeController : Controller
{
    [HttpPost]
    [RequireAntiforgeryToken(false)]
    public ActionResult DisabledValidation()
    {
        return View();
    }

    [HttpPost]
    public ActionResult MissingValidation()
    {
        return View();
    }
}

public class Startup
{
    public void Configure(IApplicationBuilder app)
    {
        app.UseAntiforgery();
    }
}
