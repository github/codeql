using System;
using Microsoft.Data;
using Microsoft.Data.SqlClient;

namespace Test
{
    class SqlInjection
    {
        string connectionString;
        System.Windows.Forms.TextBox box1;

        public void MakeSqlCommand()
        {
            // BAD: Text from a local textbox
            using (var connection = new SqlConnection(connectionString))
            {
                var queryString = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                  + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                var cmd = new SqlCommand(queryString); // $ Alert[cs/sql-injection]
                var adapter = new SqlDataAdapter(cmd); // $ Alert[cs/sql-injection]
            }

            // BAD: Input from the command line.
            using (var connection = new SqlConnection(connectionString))
            {
                var queryString = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                  + Console.ReadLine() + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                var cmd = new SqlCommand(queryString); // $ Alert[cs/sql-injection]
                var adapter = new SqlDataAdapter(cmd); // $ Alert[cs/sql-injection]
            }
        }
    }
}
