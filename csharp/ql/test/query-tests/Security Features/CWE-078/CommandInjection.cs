using System;

namespace System.Web.UI.WebControls
{
    public class TextBox
    {
        public string Text { get; set; }
        public string InnerHtml { get; set; }
    }
}

namespace Test
{
    using System.Web.UI.WebControls;
    using System.Web;
    using System.Diagnostics;

    class CommandInjection
    {
        TextBox categoryTextBox;

        public void WebCommandInjection()
        {
            // BAD: Reading from textbox, then using that in the arguments and file name
            string userInput = categoryTextBox.Text;
            Process.Start("foo.exe" + userInput, "/c " + userInput);

            ProcessStartInfo startInfo = new ProcessStartInfo(userInput, userInput);
            Process.Start(startInfo);

            ProcessStartInfo startInfoProps = new ProcessStartInfo();
            startInfoProps.FileName = userInput;
            startInfoProps.Arguments = userInput;
            startInfoProps.WorkingDirectory = userInput;
            Process.Start(startInfoProps);
        }
    }
}
