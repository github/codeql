using System;

namespace System.Web.UI.WebControls
{
    public class TextBox { public string Text { get; set; } }
}

namespace Test
{
    using System.Data;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Diagnostics.CodeAnalysis;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Web.UI.WebControls;
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Mvc;

    public class EntityFrameworkContext : DbContext
    {
        public EntityFrameworkContext()
        {
        }
    }

    class SqlInjection
    {
        TextBox categoryTextBox;
        string connectionString;

        public void GetDataSetByCategory()
        {
            // BAD: the category might have SQL special characters in it
            using (var connection = new SqlConnection(connectionString))
            {
                var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                  + categoryTextBox.Text + "' ORDER BY PRICE";
                var adapter = new SqlDataAdapter(query1, connection);
                var result = new DataSet();
                adapter.Fill(result);
            }

            // GOOD: use parameters with stored procedures
            using (var connection = new SqlConnection(connectionString))
            {
                var adapter = new SqlDataAdapter("ItemsStoredProcedure", connection);
                adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                var parameter = new SqlParameter("category", categoryTextBox.Text);
                adapter.SelectCommand.Parameters.Add(parameter);
                var result = new DataSet();
                adapter.Fill(result);
            }

            // GOOD: use parameters with dynamic SQL
            using (var connection = new SqlConnection(connectionString))
            {
                var query2 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY="
                  + "@category ORDER BY PRICE";
                var adapter = new SqlDataAdapter(query2, connection);
                var parameter = new SqlParameter("category", categoryTextBox.Text);
                adapter.SelectCommand.Parameters.Add(parameter);
                var result = new DataSet();
                adapter.Fill(result);
            }

            using (var connection = new SqlConnection(connectionString))
            {
                using (var context = new EntityFrameworkContext())
                {
                    // BAD: Use EntityFramework direct Sql execution methods
                    var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                              + categoryTextBox.Text + "' ORDER BY PRICE";
                    context.Database.ExecuteSqlCommand(query1);
                    context.Database.SqlQuery<string>(query1);
                    // GOOD: Use EntityFramework direct Sql execution methods with parameter
                    var query2 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY="
                            + "@p0 ORDER BY PRICE";
                    context.Database.ExecuteSqlCommand(query2, categoryTextBox.Text);
                }
            }

            // BAD: Text from a local textbox
            using (var connection = new SqlConnection(connectionString))
            {
                var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                  + box1.Text + "' ORDER BY PRICE";
                var adapter = new SqlDataAdapter(query1, connection);
                var result = new DataSet();
                adapter.Fill(result);
            }

            // BAD: Text from a local textbox
            using (var connection = new SqlConnection(connectionString))
            {
                var queryString = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                  + box1.Text + "' ORDER BY PRICE";
                var cmd = new SqlCommand(queryString);
                var adapter = new SqlDataAdapter(cmd);
                var result = new DataSet();
                adapter.Fill(result);
            }

            // BAD: Input from the command line. (also implicitly check flow via suppress nullable warning `!`)
            using (var connection = new SqlConnection(connectionString))
            {
                var queryString = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                  + Console.ReadLine()! + "' ORDER BY PRICE";
                var cmd = new SqlCommand(queryString);
                var adapter = new SqlDataAdapter(cmd);
                var result = new DataSet();
                adapter.Fill(result);
            }
        }

        System.Windows.Forms.TextBox box1;
    }

    public abstract class MyController : Controller
    {
        [HttpPost("{userId:string}")]
        public async Task<IActionResult> GetUserById([FromRoute] string userId, CancellationToken cancellationToken)
        {
            // This is a vulnerable method due to SQL injection
            string query = "SELECT * FROM Users WHERE UserId = '" + userId + "'";

            using (SqlConnection connection = new SqlConnection("YourConnectionString"))
            {
                SqlCommand command = new SqlCommand(query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Console.WriteLine(String.Format("{0}, {1}", reader["UserId"], reader["Username"]));
                }
            }

            return Ok();
        }
    }
}
