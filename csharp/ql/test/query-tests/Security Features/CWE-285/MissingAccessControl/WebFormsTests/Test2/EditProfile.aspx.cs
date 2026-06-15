using System;
using System.Web.UI;

class EditProfile2 : System.Web.UI.Page {
    private void doThings() { }

    // GOOD: The Web.config file specifies auth for this path.
    protected void btn1_Click(object sender, EventArgs e) {
        doThings();
    }
} 