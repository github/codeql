using System;
using System.Web.UI;

class EditComment : System.Web.UI.Page {
    
    // BAD - Any user can access this method.
    protected void btn1_Click(object sender, EventArgs e) {
        string commentId = Request.QueryString["Id"];
        Comment comment = getCommentById(commentId);
        comment.Text = "xyz";
    }

    // GOOD - The user ID is verified.
    protected void btn2_Click(object sender, EventArgs e) {
        string commentId = Request.QueryString["Id"];
        Comment comment = getCommentById(commentId);
        if (comment.AuthorName == User.Identity.Name){
            comment.Text = "xyz";
        }
    }

    class Comment {
        public string Text { get; set; }
        public string AuthorName { get; }
    }

    Comment getCommentById(string id) { return null; }
} 