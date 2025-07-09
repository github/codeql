using System;

namespace Test
{
    using System.Data;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Web.UI.WebControls;
    using System.Threading.Tasks;
    using Dapper;

    class SqlInjectionDapper
    {
        string connectionString;

        public void Bad01()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                var result = connection.Query<object>(query); // $ Alert[cs/sql-injection]
            }
        }

        public async Task Bad02()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                var result = await connection.QueryAsync<object>(query); // $ Alert[cs/sql-injection]
            }
        }

        public async Task Bad03()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                var result = await connection.QueryFirstAsync(query); // $ Alert[cs/sql-injection]
            }
        }

        public async Task Bad04()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]

                await connection.ExecuteAsync(query); // $ Alert[cs/sql-injection]
            }
        }

        public void Bad05()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                connection.ExecuteScalar(query); // $ Alert[cs/sql-injection]
            }
        }

        public void Bad06()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]
                connection.ExecuteReader(query); // $ Alert[cs/sql-injection]
            }
        }

        public async Task Bad07()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE"; // $ Source[cs/sql-injection]

                var comDef = new CommandDefinition(query); // $ Alert[cs/sql-injection]
                var result = await connection.QueryFirstAsync(comDef);
            }
        }

        public async Task Ok07()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + box1.Text + "' ORDER BY PRICE";

                var comDef = new CommandDefinition(query);
                // no call to any query method
            }
        }

        System.Windows.Forms.TextBox box1;
    }
}
