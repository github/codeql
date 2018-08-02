using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

class SqlInjection
{
    TextBox categoryTextBox;
    string connectionString;

    public DataSet GetDataSetByCategory()
    {
        // BAD: the category might have SQL special characters in it
        using (var connection = new SqlConnection(connectionString))
        {
            var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
              + categoryTextBox.Text + "' ORDER BY PRICE";
            var adapter = new SqlDataAdapter(query1, connection);
            var result = new DataSet();
            adapter.Fill(result);
            return result;
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
            return result;
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
            return result;
        }
    }
}
