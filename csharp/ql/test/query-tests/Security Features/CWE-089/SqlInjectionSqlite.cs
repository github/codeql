using System;

namespace TestSqlite
{
    using System.Data;
    using System.Data.SQLite;
    using System.IO;
    using System.Text;
    using System.Web.UI.WebControls;

    class SqlInjection
    {
        private string connectionString;
        public TextBox untrustedData;

        public void InjectUntrustedData()
        {
            // BAD: untrusted data is not sanitized.
            SQLiteCommand cmd = new SQLiteCommand(untrustedData.Text); // $ Alert[cs/sql-injection]

            // BAD: untrusted data is not sanitized.
            using (var connection = new SQLiteConnection(connectionString))
            {
                cmd = new SQLiteCommand(untrustedData.Text, connection); // $ Source[cs/sql-injection] Alert[cs/sql-injection]
            }

            SQLiteDataAdapter adapter;
            DataSet result;

            // BAD: untrusted data is not sanitized.
            using (var connection = new SQLiteConnection(connectionString))
            {
                adapter = new SQLiteDataAdapter(untrustedData.Text, connection); // $ Alert[cs/sql-injection]
                result = new DataSet();
                adapter.Fill(result);
            }

            // BAD: untrusted data is not sanitized.
            adapter = new SQLiteDataAdapter(untrustedData.Text, connectionString); // $ Alert[cs/sql-injection]
            result = new DataSet();
            adapter.Fill(result);

            // BAD: untrusted data is not sanitized.
            adapter = new SQLiteDataAdapter(cmd); // $ Alert[cs/sql-injection]
            result = new DataSet();
            adapter.Fill(result);

            // BAD: untrusted data as filename is not sanitized.
            using (FileStream fs = new FileStream(untrustedData.Text, FileMode.Open)) // $ Source[cs/sql-injection]
            {
                using (StreamReader sr = new StreamReader(fs, Encoding.UTF8))
                {
                    var sql = String.Empty;
                    while ((sql = sr.ReadLine()) != null)
                    {
                        sql = sql.Trim();
                        if (sql.StartsWith("--"))
                            continue;
                        using (var connection = new SQLiteConnection(""))
                        {
                            cmd = new SQLiteCommand(sql, connection); // $ Alert[cs/sql-injection]
                            cmd.ExecuteScalar();
                        }
                    }
                }
            }
        }
    }
}
