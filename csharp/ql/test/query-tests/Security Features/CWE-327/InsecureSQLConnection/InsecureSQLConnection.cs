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

        public void TriggerThis()
        {
            // BAD, Encrypt not specified [NOT DETECTED]
            SqlConnection conn = new SqlConnection("Server=myServerName\\myInstanceName;Database=myDataBase;User Id=myUsername;");
        }

        void Test4()
        {
            string connectString =
                "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd";
            // BAD, Encrypt not specified [NOT DETECTED]
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
            var conn = new SqlConnection(builder.ConnectionString);
        }

        void Test5()
        {
            string connectString =
                "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            // BAD, Encrypt set to false [NOT DETECTED]
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
            var conn = new SqlConnection(builder.ConnectionString);
        }
    }
}
