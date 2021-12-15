using System;
using System.Data.SqlClient;
using System.Diagnostics;

namespace Test
{

    class StoredCommandInjection
    {

        public void Test()
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
