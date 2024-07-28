    // BAD - Any user can access this method.
    protected void btn1_Click(object sender, EventArgs e) {
        string commentId = Request.QueryString["Id"];
        Comment comment = getCommentById(commentId);
        comment.Body = inputCommentBody.Text;
    }

    // GOOD - The user ID is verified.
    protected void btn2_Click(object sender, EventArgs e) {
        string commentId = Request.QueryString["Id"];
        Comment comment = getCommentById(commentId);
        if (comment.AuthorName == User.Identity.Name){
            comment.Body = inputCommentBody.Text;
        }
    }