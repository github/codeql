using Microsoft.AspNetCore.Mvc;

public class ProfileController : Controller {
    private void doThings() { }
    private bool isAuthorized() { return false; }

    public ActionResult Delete1(int id) {
        doThings();
        return View();
    }

    public ActionResult Delete2(int id) {
        if (!isAuthorized()) {
            return null;
        }
        doThings();
        return View();
    }
}