using System;
using System.Web.UI;

class EditProfile : System.Web.UI.Page {
    private void doThings() { }

    private bool isAuthorized() { return false; }

    protected void btn1_Click(object sender, EventArgs e) {
        doThings();
    }

    protected void btn2_Click(object sender, EventArgs e) {
        if (isAuthorized()) {
            doThings();
        }
    }
} 