using System;
using System.Web.UI;

class EditProfile : System.Web.UI.Page {
    private void doThings() { }

    private bool isAuthorized() { return false; }

    // BAD: The class name indicates that this may be an Edit method, but there is no auth check
    protected void btn1_Click(object sender, EventArgs e) {
        doThings();
    }

    // GOOD: There is a call to isAuthorized
    protected void btn2_Click(object sender, EventArgs e) {
        if (isAuthorized()) {
            doThings();
        }
    }
} 