using System;

namespace MySql.Data.MySqlClient
{
    using System.Data;

    public class MySqlCommand : IDbCommand
    {
        public MySqlCommand(string commandText) { }

        public void Cancel() => throw null;
        public string CommandText { get; set; }
        public int CommandTimeout { get; set; }
        public CommandType CommandType { get; set; }
        public IDbConnection Connection { get; set; }
        public IDbDataParameter CreateParameter() => throw null;
        public int ExecuteNonQuery() => throw null;
        public IDataReader ExecuteReader() => throw null;
        public IDataReader ExecuteReader(CommandBehavior behavior) => throw null;
        public object ExecuteScalar() => throw null;
        public IDataParameterCollection Parameters { get; }
        public void Prepare() => throw null;
        public IDbTransaction Transaction { get; set; }
        public UpdateRowSource UpdatedRowSource { get; set; }
        public void Dispose() => throw null;
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
            new SqlDataAdapter(text, string.Empty);
            MySqlHelper.ExecuteScalar("", text);
            SqlHelper.ExecuteScalar("", System.Data.CommandType.Text, text);
        }
    }
}
