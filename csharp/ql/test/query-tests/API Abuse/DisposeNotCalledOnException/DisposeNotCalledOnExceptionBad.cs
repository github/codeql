using System;
using System.Data.SqlClient;

class Bad
{
    public SqlDataReader GetAllCustomers()
    {
        var conn = new SqlConnection("connection string");
        conn.Open();

        var cmd = new SqlCommand("SELECT * FROM Customers", conn);
        var ret = cmd.ExecuteReader();

        cmd.Dispose(); // $ Alert
        conn.Dispose(); // $ Alert

        return ret;
    }
}
