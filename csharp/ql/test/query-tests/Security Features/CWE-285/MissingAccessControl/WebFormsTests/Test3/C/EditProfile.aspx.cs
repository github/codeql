using System;
using System.Web.UI;

class EditProfile5 : System.Web.UI.Page {
    private void doThings() { }

    // GOOD: The Web.config file specifies auth for the path Virtual, which is mapped to C in Global.asax
    protected void btn1_Click(object sender, EventArgs e) {
        doThings();
    }
} 