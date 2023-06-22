using Microsoft.AspNetCore.Mvc;

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
}