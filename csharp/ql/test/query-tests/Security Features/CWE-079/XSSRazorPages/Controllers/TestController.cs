namespace test;

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class UserData
{
    public string Name { get; set; }
}

public class TestController : Controller {
    public IActionResult test1(UserData tainted) {
        return View("Test1", tainted);
    }
}