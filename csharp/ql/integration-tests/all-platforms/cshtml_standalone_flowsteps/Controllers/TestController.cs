namespace test;

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Razor;

public class UserData
{
    public string Name { get; set; }
}

public class TestController : Controller {
    public IActionResult Test(UserData tainted1) {
        return View("Test", tainted1);
    }
}