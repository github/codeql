using System;
using System.Windows.Forms;

public partial class ManagedCodeExample : Form
{
    private void btnSayHello_Click(object sender, EventArgs e)
    {
         MessageBox.Show("Hello World", "Title");
    }
}
