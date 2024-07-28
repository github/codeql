using System;
using System.Data.SqlClient;
using System.Web;
using System.Xml;
using System.Xml.XPath;

public class XPathInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];
        string password = ctx.Request.QueryString["password"];

        var s = "//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()";

        // BAD: User input used directly in an XPath expression
        XPathExpression.Compile(s);
        XmlNode xmlNode = null;
        // BAD: User input used directly in an XPath expression to SelectNodes
        xmlNode.SelectNodes(s);

        // GOOD: Uses parameters to avoid including user input directly in XPath expression
        var expr = XPathExpression.Compile("//users/user[login/text()=$username]/home_dir/text()");

        var doc = new XPathDocument("");
        var nav = doc.CreateNavigator();

        // BAD
        nav.Select(s);

        // GOOD
        nav.Select(expr);

        // BAD
        nav.SelectSingleNode(s);

        // GOOD
        nav.SelectSingleNode(expr);

        // BAD
        nav.Compile(s);

        // GOOD
        nav.Compile("//users/user[login/text()=$username]/home_dir/text()");

        // BAD
        nav.Evaluate(s);

        // Good
        nav.Evaluate(expr);

        // BAD
        nav.Matches(s);

        // GOOD
        nav.Matches(expr);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

    public void ProcessStoredRequest()
    {

        using (SqlConnection connection = new SqlConnection(""))
        {
            connection.Open();
            SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
            SqlDataReader customerReader = customerCommand.ExecuteReader();

            while (customerReader.Read())
            {
                string userName = customerReader.GetString(1);
                string password = customerReader.GetString(2);
                // BAD: User input used directly in an XPath expression
                XPathExpression.Compile("//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()");
                XmlNode xmlNode = null;
                // BAD: User input used directly in an XPath expression to SelectNodes
                xmlNode.SelectNodes("//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()");

                // GOOD: Uses parameters to avoid including user input directly in XPath expression
                XPathExpression.Compile("//users/user[login/text()=$username]/home_dir/text()");
            }
            customerReader.Close();
        }
    }
}
