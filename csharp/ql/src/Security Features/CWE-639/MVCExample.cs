public class CommentController : Controller {
    private readonly IAuthorizationService _authorizationService;
    private readonly IDocumentRepository _commentRepository;

    public CommentController(IAuthorizationService authorizationService,
                              ICommentRepository commentRepository)
    {
        _authorizationService = authorizationService;
        _commentRepository = commentRepository;
    }

    // BAD: Any user can access this.
    public async Task<IActionResult> Edit1(int commentId, string text) {
        Comment comment = _commentRepository.Find(commentId);
        
        comment.Text = text;

        return View();
    }

    // GOOD: An authorization check is made.
    public async Task<IActionResult> Edit2(int commentId, string text) {
        Comment comment = _commentRepository.Find(commentId);
        
        var authResult = await _authorizationService.AuthorizeAsync(User, Comment, "EditPolicy");

        if (authResult.Succeeded) {
            comment.Text = text;
            return View();
        }
        else {
            return ForbidResult();
        }
    }

    // GOOD: Only users with the `admin` role can access this method.
    [Authorize(Roles="admin")]
    public async Task<IActionResult> Edit3(int commentId, string text) {
        Comment comment = _commentRepository.Find(commentId);
        
        comment.Text = text;

        return View();
    }
}