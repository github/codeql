using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

public class HomeController : Controller
{
    // GOOD: This is validated by the global filter.
    [HttpPost]
    public ActionResult Login()
    {
        return View();
    }

    // GOOD: Antiforgery token is validated explicitly.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public ActionResult UpdateDetails()
    {
        return View();
    }
}

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Register MVC controllers and Razor views.
        // The global filter automatically validates antiforgery tokens
        // for unsafe HTTP methods such as POST, PUT, PATCH, and DELETE.
        builder.Services.AddControllersWithViews(options =>
        {
            options.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
        });
    }
}
