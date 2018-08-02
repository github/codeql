// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Data.cs /r:System.Data.Common.dll

using System;
using System.Data.SqlClient;
using System.DirectoryServices;

namespace Test
{

    class StoredLDAPInjection
    {

        public void processRequest()
        {
            using (SqlConnection connection = new SqlConnection(""))
            {
                connection.Open();
                SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
                SqlDataReader customerReader = customerCommand.ExecuteReader();

                while (customerReader.Read())
                {
                    // BAD: Read from database, write it straight to a response
                    DirectorySearcher ds = new DirectorySearcher("accountname=" + customerReader.GetString(1));
                }
                customerReader.Close();
            }
        }
    }
}
