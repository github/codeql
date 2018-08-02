// example of using unmanaged code
using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;

public partial class UnmanagedCodeExample : Form
{
    [DllImport("User32.dll")]
    public static extern int MessageBox(int h, string m, string c, int type); // BAD

    private void btnSayHello_Click(object sender, EventArgs e)
    {
        MessageBox(0, "Hello World", "Title", 0);
    }
}



// the same thing in managed code
using System;
using System.Windows.Forms;

public partial class ManagedCodeExample : Form
{
    private void btnSayHello_Click(object sender, EventArgs e)
    {
        MessageBox.Show("Hello World", "Title");
    }
}
