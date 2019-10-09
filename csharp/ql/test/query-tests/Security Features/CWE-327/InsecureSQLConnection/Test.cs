// semmle-extractor-options: /nostdlib /noconfig /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\mscorlib.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.Data.dll

using System.Data.SqlClient;

namespace TLSEnabled
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
            SqlConnection conn = new SqlConnection("Server=myServerName\\myInstanceName;Database=myDataBase;User Id=myUsername;");            
        }

        void Test4()
        {
            // BAD, Encrypt not specified
            string connectString =
                "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd";
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
            var conn = new SqlConnection(builder.ConnectionString);
        }

        void Test5()
        {
            // BAD, Encrypt set to false
            string connectString =
                "Server=1.2.3.4;Database=Anything;UID=ab;Pwd=cd;Encrypt=false";
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
            var conn = new SqlConnection(builder.ConnectionString);
        }
    }
}
