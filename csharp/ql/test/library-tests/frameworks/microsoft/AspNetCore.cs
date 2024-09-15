using Microsoft.AspNetCore.Mvc;

// has sufix "Controller"
public class HomeController
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// derived from Microsoft.AspNetCore.Mvc.Controller which has suffix "Controller"
public class HomeController1 : Controller
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// derived from Microsoft.AspNetCore.Mvc.ControllerBase which has attribute [Microsoft.AspNetCore.Mvc.Controller]
public class HomeController2 : ControllerBase
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// has [ApiController] attribute
[ApiController]
public class HomeController3
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// has [Controller] attribute
[Controller]
public class HomeController4
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// derived from a class that is a controller
public class HomeController5 : HomeController4
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// is abstract
public abstract class HomeController6 : Controller
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// is not public
internal class NotHomeController : Controller
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// contains generic parameters
public class NotHomeController2<T> : Controller
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// has [NonController] attribute
[NonController]
public class NotHomeController3 : Controller
{
    public string Index()
    {
        return "This is Home Controller";
    }
}

// derived from a class that has [NonController] attribute
public class NotController : NotHomeController3
{
    public string Index()
    {
        return "This is Home Controller";
    }
}
