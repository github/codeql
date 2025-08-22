using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

public class CommentController : Controller {
    // BAD: Any user can access this.
    public ActionResult Edit1(int commentId, string text) {
        editComment(commentId, text);
        return View();
    }

    // GOOD: The user's authorization is checked.
    public ActionResult Edit2(int commentId, string text) {
        if (canEditComment(commentId, User.Identity.Name)){
            editComment(commentId, text);
        }
        return View();
    }

    // GOOD: The Authorize attribute is used
    [Authorize]
    public ActionResult Edit3(int commentId, string text) {
        editComment(commentId, text);
        return View();
    }

    // BAD: The AllowAnonymous attribute overrides the Authorize attribute
    [Authorize]
    [AllowAnonymous]
    public ActionResult Edit4(int commentId, string text) {
        editComment(commentId, text);
        return View();
    }

    void editComment(int commentId, string text) { }

    bool canEditComment(int commentId, string userName) { return false; }
}