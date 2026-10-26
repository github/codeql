using System;
using System.Data.SqlClient;

namespace Test
{

    using System.Data.SQLite;
    using System.IO;
    using System.Text;

    class SecondOrderSqlInjection
    {

        public void ProcessRequest()
        {
            using (SqlConnection connection = new SqlConnection(""))
            {
                connection.Open();
                SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
                SqlDataReader customerReader = customerCommand.ExecuteReader(); // $ Source[cs/sql-injection]

                while (customerReader.Read())
                {
                    // BAD: Read from database, write it straight to another query
                    SqlCommand secondCustomerCommand = new SqlCommand("SELECT * FROM customers WHERE customerName=" + customerReader.GetString(1), connection); // $ Alert[cs/sql-injection]
                }
                customerReader.Close();
            }
        }

        public void RunSQLFromFile()
        {
            using (FileStream fs = new FileStream("myfile.txt", FileMode.Open)) // $ Source[cs/sql-injection]
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
                            var cmd = new SQLiteCommand(sql, connection); // $ Alert[cs/sql-injection]
                            cmd.ExecuteScalar();
                        }
                    }
                }
            }
        }

    }
}
