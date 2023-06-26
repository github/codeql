using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

public class ProfileController : Controller {
    private void doThings() { }
    private bool isAuthorized() { return false; }

    // BAD: This is a Delete method, but no auth is specified.
    public ActionResult Delete1(int id) {
        doThings();
        return View();
    }

    // GOOD: isAuthorized is checked.
    public ActionResult Delete2(int id) {
        if (!isAuthorized()) {
            return null;
        }
        doThings();
        return View();
    }

    // GOOD: The Authorize attribute is used.
    [Authorize]
    public ActionResult Delete3(int id) {
        doThings();
        return View();
    }

}