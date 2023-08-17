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

    void editComment(int commentId, string text) { }

    bool canEditComment(int commentId, string userName) { return false; }
}