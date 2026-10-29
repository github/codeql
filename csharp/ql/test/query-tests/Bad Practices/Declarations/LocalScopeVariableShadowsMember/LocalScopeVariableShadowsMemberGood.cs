using System.Windows.Forms;

class Good
{
    private string title;
    private string name;

    public void DisplayDetails()
    {
        var boxTitle = "Person Details";
        var message = "Title: " + title + "\nName: " + name;
        MessageBox.Show(message, boxTitle);
    }
}
