using System;
using System.Web.UI;
using System.Web.Security;

class ViewProfile : System.Web.UI.Page {
    private void doThings() { }

    protected void btn_safe_Click(object sender, EventArgs e) {
        doThings();
    }

    protected void btn_delete1_Click(object sender, EventArgs e) {
        doThings();
    }

    protected void btn_delete2_Click(object sender, EventArgs e) {
        if (User.IsInRole("admin")) {
            doThings();
        }
    }
} 