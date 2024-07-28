using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

public class BaseController : Controller {
    // GOOD
    [Authorize]
    public virtual ActionResult Edit1(int id) { return View(); }
}

class MyAuthorizeAttribute : AuthorizeAttribute { }
class MyAllowAnonymousAttribute : AllowAnonymousAttribute { }

public class AController : BaseController {
    // GOOD - Authorize is inherited from overridden method
    public override ActionResult Edit1(int id) { return View(); }

    // GOOD - A subclass of Authorize is used
    [MyAuthorize]
    public ActionResult Edit2(int id) { return View(); }
}

[Authorize]
public class BaseAuthController : Controller {
    // BAD - A subclass of AllowAnonymous is used
    [MyAllowAnonymous]
    public virtual ActionResult EditAnon(int id) { return View(); }
}

public class BController : BaseAuthController {
    // GOOD - Authorize is inherited from parent class
    public ActionResult Edit3(int id) { return View(); }

    // BAD - MyAllowAnonymous is inherited from overridden method
    public override ActionResult EditAnon(int id) { return View(); }
}

[AllowAnonymous]
public class BaseAnonController : Controller {

}

public class CController : BaseAnonController {
    // BAD - AllowAnonymous is inherited from base class and overrides Authorize
    [Authorize]
    public ActionResult Edit4(int id) { return View(); }
}

[Authorize]
public class BaseGenController<T> : Controller {

}

public class SubGenController : BaseGenController<string> {
    // GOOD - Authorize is inherited from parent class
    public ActionResult Edit5(int id) { return View(); }
}