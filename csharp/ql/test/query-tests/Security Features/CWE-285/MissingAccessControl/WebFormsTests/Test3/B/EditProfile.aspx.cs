using System;
using System.Web.UI;

class EditProfile4 : System.Web.UI.Page {
    private void doThings() { }

    // BAD: The Web.config file does not specify auth for this path.
    protected void btn1_Click(object sender, EventArgs e) {
        doThings();
    }
} 