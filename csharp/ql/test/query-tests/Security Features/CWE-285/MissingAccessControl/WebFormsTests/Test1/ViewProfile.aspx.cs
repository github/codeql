using System;
using System.Web.UI;
using System.Web.Security;

class ViewProfile : System.Web.UI.Page {
    private void doThings() { }

    // GOOD: This method and class name do not indicate a sensitive method.
    protected void btn_safe_Click(object sender, EventArgs e) {
        doThings();
    }

    // BAD: The name indicates a Delete method, but no auth is present.
    protected void btn_delete1_Click(object sender, EventArgs e) {
        doThings();
    }

    // GOOD: User.IsInRole is checked.
    protected void btn_delete2_Click(object sender, EventArgs e) {
        if (User.IsInRole("admin")) {
            doThings();
        }
    }
} 