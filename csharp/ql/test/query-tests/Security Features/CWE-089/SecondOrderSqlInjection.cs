using System;
using System.Data.SqlClient;

namespace Test
{

    class SecondOrderSqlInjection
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
                    // BAD: Read from database, write it straight to another query
                    SqlCommand secondCustomerCommand = new SqlCommand("SELECT * FROM customers WHERE customerName=" + customerReader.GetString(1), connection);
                }
                customerReader.Close();
            }
        }
    }
}
