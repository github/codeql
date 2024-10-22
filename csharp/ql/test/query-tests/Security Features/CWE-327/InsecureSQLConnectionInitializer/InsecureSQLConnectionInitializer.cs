namespace System.Data.SqlClient
{
    public sealed class SqlConnectionStringBuilder
    {
        public bool Encrypt { get; set; }
        public SqlConnectionStringBuilder(string connectionString) { }
    }

}

namespace InsecureSQLConnection
{
    public class Class1
    {
        void Test6()
        {
            string connectString = "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            var conn = new System.Data.SqlClient.SqlConnectionStringBuilder(connectString) { Encrypt = false };    // Bug - cs/insecure-sql-connection-initializer
        }

        void Test72ndPhase(bool encrypt)
        {
            string connectString = "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            var conn = new System.Data.SqlClient.SqlConnectionStringBuilder(connectString) { Encrypt = encrypt };    // Bug - cs/insecure-sql-connection-initializer (sink)
        }

        void Test7()
        {
            Test72ndPhase(false);    // Bug - cs/insecure-sql-connection-initializer (source)
        }

        void Test7FP()
        {
            Test72ndPhase(true);    // Not a bug source
        }

        void Test8FP()
        {
            string connectString = "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            var conn = new System.Data.SqlClient.SqlConnectionStringBuilder(connectString) { Encrypt = true };
        }
    }
}
