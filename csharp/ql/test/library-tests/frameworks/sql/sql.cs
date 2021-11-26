using System;

namespace MySql.Data.MySqlClient
{
    using System.Data;

    public class MySqlCommand : IDbCommand
    {
        public MySqlCommand(string commandText) { }

        public string CommandText { get; set; }

        public IDataReader ExecuteReader() => throw null;
        public CommandType CommandType { get; set; }
        public IDataParameterCollection Parameters { get; set; }
    }

    public class MySqlHelper
    {
        public static object ExecuteScalar(string connectionString, string commandText) { return null; }
    }
}

namespace Microsoft.ApplicationBlocks.Data
{
    class SqlHelper
    {
        public static object ExecuteScalar(string connectionString, System.Data.CommandType ct, string commandText) { return null; }
    }
}

namespace SqlClientTests
{
    using System.Data;
    using System.Data.SqlClient;
    using MySql.Data.MySqlClient;
    using Microsoft.ApplicationBlocks.Data;

    class TestClass
    {
        public static void TestMethod(string text)
        {
            System.Data.IDbCommand command = new SqlCommand(text);
            command = new MySqlCommand(text);
            command.CommandText = text;
            new MySqlCommand(text).CommandText = text;
            new SqlDataAdapter(text, null);
            MySqlHelper.ExecuteScalar("", text);
            SqlHelper.ExecuteScalar("", System.Data.CommandType.Text, text);
        }
    }
}
