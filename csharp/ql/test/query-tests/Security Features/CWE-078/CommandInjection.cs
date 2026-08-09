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
            string userInput = categoryTextBox.Text; // $ Source=r1 Source=r2 Source=r3 Source=r4 Source=r5 Source=r6 Source=r7
            Process.Start("foo.exe" + userInput, "/c " + userInput); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7

            ProcessStartInfo startInfo = new ProcessStartInfo(userInput, userInput); // $ Alert=r3 Alert=r4 Alert=r1 Alert=r2 Alert=r5 Alert=r6 Alert=r7
            Process.Start(startInfo);

            ProcessStartInfo startInfoProps = new ProcessStartInfo();
            startInfoProps.FileName = userInput; // $ Alert=r5 Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r6 Alert=r7
            startInfoProps.Arguments = userInput; // $ Alert=r6 Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r7
            startInfoProps.WorkingDirectory = userInput; // $ Alert=r7 Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6
            Process.Start(startInfoProps);
        }

        public void StoredCommandInjection()
        {
            using (SqlConnection connection = new SqlConnection(""))
            {
                connection.Open();
                SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
                SqlDataReader customerReader = customerCommand.ExecuteReader(); // $ Source=r8

                while (customerReader.Read())
                {
                    // BAD: Read from database, and use it to directly execute a command
                    Process.Start("foo.exe", "/c " + customerReader.GetString(1)); // $ Alert=r8
                }
                customerReader.Close();
            }
        }
    }
}
