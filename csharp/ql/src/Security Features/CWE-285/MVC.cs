public class ProfileController : Controller {

    // BAD: No authorization is used.
    public ActionResult Edit(int id) {
        ...
    }

    // GOOD: The `Authorize` attribute is used.
    [Authorize]
    public ActionResult Delete(int id) {
        ...
    }
}