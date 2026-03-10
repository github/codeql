using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Threading.Tasks;

public class CommentController : Controller
{
    private readonly IAuthorizationService _authorizationService;

    public CommentController(IAuthorizationService authorizationService)
    {
        _authorizationService = authorizationService;
    }

    // BAD: Any user can access this.
    public ActionResult Edit1(int commentId, string text)
    {
        editComment(commentId, text);
        return View();
    }

    // GOOD: The user's authorization is checked.
    public ActionResult Edit2(int commentId, string text)
    {
        if (canEditComment(commentId, User.Identity.Name))
        {
            editComment(commentId, text);
        }
        return View();
    }

    // GOOD: The Authorize attribute is used
    [Authorize]
    public ActionResult Edit3(int commentId, string text)
    {
        editComment(commentId, text);
        return View();
    }

    // BAD: The AllowAnonymous attribute overrides the Authorize attribute
    [Authorize]
    [AllowAnonymous]
    public ActionResult Edit4(int commentId, string text)
    {
        editComment(commentId, text);
        return View();
    }

    // GOOD: An authorization check is made.
    public async Task<IActionResult> Edit5(int commentId, string text)
    {
        var authResult = await _authorizationService.AuthorizeAsync(User, "Comment", "EditPolicy");

        if (authResult.Succeeded)
        {
            editComment(commentId, text);
            return View();
        }
        return Forbid();
    }

    // GOOD: Only users with the `admin` role can access this method.
    [Authorize(Roles = "admin")]
    public async Task<IActionResult> Edit6(int commentId, string text)
    {
        editComment(commentId, text);
        return View();
    }

    void editComment(int commentId, string text) { }

    bool canEditComment(int commentId, string userName) { return false; }
}