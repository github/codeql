using System;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Dapper;

namespace Test
{
    class UseDapper
    {
        public static void Bad01(string connectionString, string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var result = connection.Query<object>(query);
                Sink(result); // $ hasTaintFlow=line:16
            }
        }

        public static async Task Bad02(string connectionString, string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var result = await connection.QueryAsync<object>(query);
                Sink(result); // $ hasTaintFlow=line:25
            }
        }

        public static void Bad03(string connectionString, string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var result = connection.QueryFirst(query);
                Sink(result); // $ hasTaintFlow=line:34
            }
        }

        public static void Bad04(string connectionString, string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var results = connection.Query<object>(query).AsList();
                Sink(results[0]); // $ hasTaintFlow=line:43
            }
        }

        public static void Sink(object o) { }
    }
}