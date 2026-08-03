using System;
using System.Data.SqlClient;
using System.Web;
using System.Xml;
using System.Xml.XPath;

public class XPathInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"]; // $ Source=r1 Source=r3 Source=r5 Source=r7 Source=r9 Source=r11 Source=r13
        string password = ctx.Request.QueryString["password"]; // $ Source=r2 Source=r4 Source=r6 Source=r8 Source=r10 Source=r12 Source=r14

        var s = "//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()";

        // BAD: User input used directly in an XPath expression
        XPathExpression.Compile(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14
        XmlNode xmlNode = null;
        // BAD: User input used directly in an XPath expression to SelectNodes
        xmlNode.SelectNodes(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14

        // GOOD: Uses parameters to avoid including user input directly in XPath expression
        var expr = XPathExpression.Compile("//users/user[login/text()=$username]/home_dir/text()");

        var doc = new XPathDocument("");
        var nav = doc.CreateNavigator();

        // BAD
        nav.Select(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14

        // GOOD
        nav.Select(expr);

        // BAD
        nav.SelectSingleNode(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14

        // GOOD
        nav.SelectSingleNode(expr);

        // BAD
        nav.Compile(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14

        // GOOD
        nav.Compile("//users/user[login/text()=$username]/home_dir/text()");

        // BAD
        nav.Evaluate(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14

        // Good
        nav.Evaluate(expr);

        // BAD
        nav.Matches(s); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7 Alert=r8 Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14

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
            SqlDataReader customerReader = customerCommand.ExecuteReader(); // $ Source=r15 Source=r16

            while (customerReader.Read())
            {
                string userName = customerReader.GetString(1);
                string password = customerReader.GetString(2);
                // BAD: User input used directly in an XPath expression
                XPathExpression.Compile("//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()"); // $ Alert=r15 Alert=r16
                XmlNode xmlNode = null;
                // BAD: User input used directly in an XPath expression to SelectNodes
                xmlNode.SelectNodes("//users/user[login/text()='" + userName + "' and password/text() = '" + password + "']/home_dir/text()"); // $ Alert=r16 Alert=r15

                // GOOD: Uses parameters to avoid including user input directly in XPath expression
                XPathExpression.Compile("//users/user[login/text()=$username]/home_dir/text()");
            }
            customerReader.Close();
        }
    }
}
