using System;
using System.Web.UI;

class EditProfile3 : System.Web.UI.Page {
    private void doThings() { }

    // GOOD: This is covered by the Web.config's location tag referring to A
    protected void btn1_Click(object sender, EventArgs e) {
        doThings();
    }
} 