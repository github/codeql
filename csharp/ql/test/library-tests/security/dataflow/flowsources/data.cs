using System;
using System.Data;
using System.Data.Common;
using System.Data.OleDb;

class DataConnection
{

    public void Test()
    {
        using (OleDbConnection connection = new OleDbConnection(
          "Provider=MSDataShape;Data Provider=SQLOLEDB;" +
          "Data Source=localhost;Integrated Security=SSPI;Initial Catalog=northwind"))
        {
            OleDbCommand customerCommand = new OleDbCommand(
                "SHAPE {SELECT CustomerID, CompanyName FROM Customers} " +
                    "APPEND ({SELECT CustomerID, OrderID FROM Orders} AS CustomerOrders " +
                    "RELATE CustomerID TO CustomerID)", connection);
            connection.Open();

            OleDbDataReader customerReader = customerCommand.ExecuteReader();

            // This access should be tainted.
            while (customerReader.Read())
            {
                // This access should be tainted.
                Console.WriteLine("Orders for " + customerReader.GetString(1));
                Console.WriteLine("Orders for " + customerReader["foo"]);
            }
            customerReader.Close();
        }
    }
}
