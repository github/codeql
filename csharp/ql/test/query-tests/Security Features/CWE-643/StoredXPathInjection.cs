using System;
using System.Data.SqlClient;
using System.Xml;
using System.Xml.XPath;

namespace Test
{

    class StoredXPathInjection
    {

        public void processRequest()
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
}
