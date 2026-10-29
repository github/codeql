
namespace System.Windows.Forms
{
    public class HtmlElement
    {
        public void SetAttribute(string attributeName, string value) { }
    }

    public class MessageBox
    {
        public static void Show(string msg, string title) { }
    }

    public class Application
    {
        public static void Exit() { }
    }

    class HtmlDocument
    {
        public void Write(string s) { }
    }

    class TextBoxBase
    {
        public string Text { get; set; }
    }

    class TextBox : TextBoxBase
    {
        public char PasswordChar { get; set; }
        public bool UseSystemPasswordChar { get; set; }
    }

    class RichTextBox : TextBoxBase
    {
        public string Rtf => null;
        public string SelectedText => null;
        public string SelectedRtf => null;
    }

    class WebBrowser
    {
        public string DocumentText { get; set; }
        public HtmlDocument Document => null;
    }

    class Form
    {
    }

    struct EventArgs
    {
    }
}
