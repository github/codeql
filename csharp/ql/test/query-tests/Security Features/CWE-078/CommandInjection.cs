using System;
using System.Data.SqlClient;
using System.Diagnostics;

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

        public void StoredCommandInjection()
        {
            using (SqlConnection connection = new SqlConnection(""))
            {
                connection.Open();
                SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
                SqlDataReader customerReader = customerCommand.ExecuteReader();

                while (customerReader.Read())
                {
                    // BAD: Read from database, and use it to directly execute a command
                    Process.Start("foo.exe", "/c " + customerReader.GetString(1));
                }
                customerReader.Close();
            }
        }
    }
}
