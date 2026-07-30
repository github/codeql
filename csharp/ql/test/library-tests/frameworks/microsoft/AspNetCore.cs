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

// has case-insensitive suffix "Controller"
public class LowerCasecontroller
{
    public void Action() { }
}

// derives from ControllerBase, whose [Controller] attribute is inherited
public class Products : ControllerBase
{
    public void List() { }
}

// is a nested type
public class ControllerContainer
{
    public class NestedController
    {
        public void Action() { }
    }
}

// only this base class has the Controller suffix
public class PlainController
{
    public void BaseAction() { }
}

public class DerivedFromPlain : PlainController
{
    public void DerivedAction() { }
}

// is a closed subclass of an open generic controller
public class GenericBaseController<T> : ControllerBase
{
    public void GenericBaseAction(string input) { }
}

public class ClosedGenericController : GenericBaseController<string>
{
    public void ClosedAction(string input) { }
}

[Controller]
public abstract class AbstractActionBase
{
    public abstract void AbstractAction(string input);

    public void InheritedAction(string input) { }

    [NonAction]
    public virtual void InheritedNonAction(string input) { }
}

public class ConcreteActionEndpoint : AbstractActionBase
{
    public override void AbstractAction(string input) { }

    public override void InheritedNonAction(string input) { }
}

public class ActionCasesController : ControllerBase, System.IDisposable
{
    public void PublicAction(string input) { }

    public static void StaticAction(string input) { }

    public void GenericAction<T>(T input) { }

    [NonAction]
    public void ExplicitNonAction(string input) { }

    public override string ToString() => "action cases";

    public void Dispose() { }

    protected void ProtectedAction(string input) { }

    internal void InternalAction(string input) { }

    private void PrivateAction(string input) { }
}
