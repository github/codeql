using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

[Authorize]
public class ProfileController : Controller {
    // GOOD: The Authorize attribute of the class restricts access to this method.
    public ActionResult Edit1(int profileId, string text) {
        editProfileName(profileId, text);
        return View();
    }

    // BAD: The AllowAnonymous attribute overrides the Authorize attribute on the class.
    [AllowAnonymous]
    public ActionResult Edit2(int profileId, string text) {
        editProfileName(profileId, text);
        return View();
    }

    void editProfileName(int profileId, string text) { }
}