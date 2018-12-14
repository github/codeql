// semmle-extractor-options: /r:${testdir}/../../../../resources/assemblies/System.Data.dll /r:${testdir}/../../../../resources/assemblies/System.Web.dll /r:${testdir}/../../../../resources/assemblies/System.Web.Mvc.dll /r:System.ComponentModel.Primitives.dll /r:System.Collections.Specialized.dll /r:${testdir}/../../../../resources/assemblies/System.Net.Http.dll

using System;
using System.Data.SqlClient;
using System.Web;

namespace Test
{

    class StoredXSS
    {

        public void processRequest(HttpContext context)
        {
            using (SqlConnection connection = new SqlConnection(""))
            {
                connection.Open();
                SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
                SqlDataReader customerReader = customerCommand.ExecuteReader();

                while (customerReader.Read())
                {
                    // BAD: Read from database, write it straight to a response
                    context.Response.Write("Orders for " + customerReader.GetString(1));
                }
                customerReader.Close();
            }
        }
    }
}
