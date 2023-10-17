namespace test;

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class UserData
{
    public string Name { get; set; }
}

public class TestController : Controller {
    public IActionResult test1(UserData tainted1) {
        // Expected to find file /Views/Test/Test1.cshtml
        return View("Test1", tainted1);
    }

    public IActionResult test2(UserData tainted2) {
        // Expected to find file /Views/Shared/Test2.cshtml
        return View("Test2", tainted2);
    }

    public IActionResult test3(UserData tainted3) {
        // Expected to find file /Views/Test/Test3.cshtml and NOT /Views/Shared/Test3.cshtml
        return View("Test3", tainted3);
    }

    public IActionResult test4(UserData tainted4) {
        // Expected to find file /Views/Test/Test4.cshtml
        return View("./Test4", tainted4);
    }

    public IActionResult test5(UserData tainted5) {
        // Expected to find file /Views/Other/Test5.cshtml
        return View("../Other/Test5", tainted5);
    }

    public IActionResult test6(UserData tainted6) {
        // Expected to find file /Views/Other/Test6.cshtml
        return View("../../Views/.////Shared/../Other//Test6", tainted6);
    }

    public IActionResult Test7(UserData tainted7) {
        // Expected to find file /Views/Test/Test7.cshtml
        return View(tainted7);
    }

    public IActionResult test8(UserData tainted8) {
        // Expected to find file /Views/Other/Test8.cshtml
        return View("/Views/Other/Test8.cshtml", tainted8);
    }

    public IActionResult test9(UserData tainted9) {
        // Expected to find file /Views/Test/Test9.cshtml
        return View("~/Views/Other/Test9.cshtml", tainted9);
    }
}

public class Test2Controller : Controller { 
    public IActionResult test10(UserData tainted10) {
        // Expected to find file /Views/Test2/Test10.cshtml
        return View("Test10", tainted10);
    }

    public IActionResult test11(UserData tainted11) {
        // Expected to find file /Views/Test2/Test10.cshtml
        return helper(tainted11);
    }

    private IActionResult helper(UserData x) { return View("Test11", x); }

    public IActionResult Test12(UserData tainted12) {
        // Expected to find nothing.
        return helper2(tainted12);
    }

    private IActionResult helper2(UserData x) {
        return View(x);
    }    

    private IActionResult test13(UserData tainted13) {
        // Expected to find file /Views/Other/Test13.cshtml
        return Helper.helper3(this, tainted13);
    }

    private IActionResult test14(UserData tainted14) {
        // Expected to find file /Views/Shared/Test14.cshtml and NOT /Views/Test2/Test14.cshtml
        return Helper.helper4(this, tainted14);
    }

}

class Helper {
    public static IActionResult helper3(Controller c, UserData x) { return c.View("/Views/Other/Test13.cshtml", x); }

    public static IActionResult helper4(Controller c, UserData x) { return c.View("Test14", x); }
}

public class Test3Controller : Controller {
    public void Setup(RazorViewEngineOptions o) {
        o.ViewLocationFormats.Add("/Views/Custom/{1}/{0}.cshtml");
    }

    private IActionResult Test15(UserData tainted14) {
        // Expected to find file /Views/Custom/Test3/Test15.cshtml
        return View(x);
    }
}