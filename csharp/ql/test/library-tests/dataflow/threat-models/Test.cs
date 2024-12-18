using System.Net.Sockets;
using System.Data.SqlClient;

namespace My.Qltest
{
    public class Test
    {
        private TestSources Sources = new TestSources();

        private SqlConnection Connection => throw null;

        private string BytesToString(byte[] bytes)
        {
            // Encode bytes to a UTF8 string.
            return System.Text.Encoding.UTF8.GetString(bytes);
        }

        public void M1()
        {
            // Only a source if "remote" is a selected threat model.
            // This is included in the "default" threat model.
            using TcpClient client = new TcpClient("localhost", 1234);
            using NetworkStream stream = client.GetStream();
            byte[] buffer = new byte[1024];
            int bytesRead = stream.Read(buffer, 0, buffer.Length);

            // SQL sink
            var command = new SqlCommand("SELECT * FROM Users WHERE Username = '" + BytesToString(buffer) + "'", Connection);
        }

        public void M2()
        {
            // Only a source if "database" is a selected threat model.
            string result = Sources.ExecuteQuery("SELECT * FROM foo");

            // SQL sink
            var command = new SqlCommand("SELECT * FROM Users WHERE Username = '" + result + "'", Connection);
        }

        public void M3()
        {
            // Only a source if "environment" is a selected threat model.
            string result = Sources.ReadEnv("foo");

            // SQL sink
            var command = new SqlCommand("SELECT * FROM Users WHERE Username = '" + result + "'", Connection);

        }

        public void M4()
        {
            // Only a source if "custom" is a selected threat model.
            string result = Sources.GetCustom("foo");

            // SQL sink
            var command = new SqlCommand("SELECT * FROM Users WHERE Username = '" + result + "'", Connection);
        }

        public void M5()
        {
            // Only a source if "commandargs" is a selected threat model.
            string result = Sources.GetCliArg(0);

            // SQL sink
            var command = new SqlCommand("SELECT * FROM Users WHERE Username = '" + result + "'", Connection);
        }
    }
}