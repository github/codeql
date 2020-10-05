# SQL query built from user-controlled sources

```
ID: cs/sql-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-089

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-089/SqlInjection.ql)

If a SQL query is built using string concatenation, and the components of the concatenation include user input, a user is likely to be able to run malicious database queries.


## Recommendation
Usually, it is better to use a prepared statement than to build a complete query with string concatenation. A prepared statement can include a parameter, written as either a question mark (`?`) or with an explicit name (`@parameter`), for each part of the SQL query that is expected to be filled in by a different value each time it is run. When the query is later executed, a value must be supplied for each parameter in the query.

It is good practice to use prepared statements for supplying parameters to a query, whether or not any of the parameters are directly traceable to user input. Doing so avoids any need to worry about quoting and escaping.


## Example
In the following example, the code runs a simple SQL query in three different ways.

The first way involves building a query, `query1`, by concatenating a user-supplied text box value with some string literals. The text box value can include special characters, so this code allows for SQL injection attacks.

The second way uses a stored procedure, `ItemsStoredProcedure`, with a single parameter (`@category`). The parameter is then given a value by calling `Parameters.Add`. This version is immune to injection attacks, because any special characters are not given any special treatment.

The third way builds a query, `query2`, with a single string literal that includes a parameter (`@category`). The parameter is then given a value by calling `Parameters.Add`. This version is immune to injection attacks, because any special characters are not given any special treatment.


```csharp
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

```

## References
* MSDN: [How To: Protect From SQL Injection in ASP.NET](https://msdn.microsoft.com/en-us/library/ff648339.aspx).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).