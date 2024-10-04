using System;
using System.Data.SqlClient;

namespace InsecureSQLConnection
{
    public class Class1
    {
        public void StringInConstructor()
        {
            SqlConnection conn = new SqlConnection("Encrypt=true");
        }

        public void StringInProperty()
        {
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Encrypt=true";

        }

        public void StringInBuilder()
        {
            SqlConnectionStringBuilder conBuilder = new SqlConnectionStringBuilder();
            conBuilder.Encrypt = true;
            SqlConnection conn = new SqlConnection(conBuilder.ToString());
        }

        public void StringInBuilderProperty()
        {
            SqlConnectionStringBuilder conBuilder = new SqlConnectionStringBuilder();
            conBuilder.Encrypt = true;
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = conBuilder.ToString();
        }

        public void StringInInitializer()
        {
            string connectString = "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            SqlConnectionStringBuilder conBuilder = new SqlConnectionStringBuilder(connectString) { Encrypt = true}; // False Positive
        }
        

        public void TriggerThis()
        {
            // BAD, Encrypt not specified (version dependent)
            SqlConnection conn = new SqlConnection("Server=myServerName\\myInstanceName;Database=myDataBase;User Id=myUsername;");
        }

        void Test4()
        {
            string connectString =
                "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd";
            // BAD, Encrypt not specified (version dependent)
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
            var conn = new SqlConnection(builder.ConnectionString);
        }

        void Test5()
        {
            string connectString =
                "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            // BAD, Encrypt set to false
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
            var conn = new SqlConnection(builder.ConnectionString);
        }

        void Test6()
        {
            var conn = new SqlConnectionStringBuilder(SetToTrueConnStr) { Encrypt = false };    // Bug - cs/insecure-sql-connection-initializer
        }

        void Test72ndPhase(bool encrypt)
        {
            var conn = new SqlConnectionStringBuilder(SetToTrueConnStr) { Encrypt = encrypt };    // Bug - cs/insecure-sql-connection-initializer (sink)
        }

        void Test7()
        {
            Test72ndPhase(false);    // Bug - cs/insecure-sql-connection-initializer (source)
        }
    }
}
