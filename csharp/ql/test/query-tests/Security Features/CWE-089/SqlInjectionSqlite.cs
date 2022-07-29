using System;

namespace TestSqlite
{

    using System.Data.SQLite;
    using System.Web.UI.WebControls;

    class SqlInjection
    {
        private string connectionString;
        public TextBox untrustedData;

        public void InjectUntrustedData()
        {
            // BAD: untrusted data is not sanitized.
            SQLiteCommand cmd = new SQLiteCommand(untrustedData.Text);

            // BAD: untrusted data is not sanitized.
            using (var connection = new SQLiteConnection(connectionString))
            {
                cmd = new SQLiteCommand(untrustedData.Text, connection);
            }

        }
    }
}