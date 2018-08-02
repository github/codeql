// semmle-extractor-options: /r:System.ComponentModel.Primitives.dll /r:System.Diagnostics.Process.dll /r:System.Runtime.InteropServices.dll ${testdir}/../../../resources/stubs/System.Data.cs /r:System.Data.Common.dll

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
