using System.Windows.Forms;

class Bad
{
    private string title;
    private string name;

    public void DisplayDetails()
    {
        var title = "Person Details";
        var message = "Title: " + title + "\nName: " + name;
        MessageBox.Show(message, title);
    }
}
