using System;
using System.Data.SqlClient;
using System.DirectoryServices;
using System.DirectoryServices.Protocols;
using System.Web;
using System.Xml;

public class LDAPInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["username"];

        // BAD: Filter includes user input without encoding
        DirectorySearcher ds = new DirectorySearcher("accountname=" + userName);
        DirectorySearcher ds2 = new DirectorySearcher();
        ds.Filter = "accountname=" + userName;

        // GOOD: Filter includes user input with encoding
        DirectorySearcher ds3 = new DirectorySearcher("accountname=" + LDAPEncode(userName));

        // BAD: SearchRequest Filter includes user input without encoding
        SearchRequest sr = new SearchRequest();
        sr.Filter = "accountname=" + userName;
        SearchRequest sr2 = new SearchRequest(null, "accountname=" + userName, System.DirectoryServices.Protocols.SearchScope.Base, null);

        // BAD: Distinguished Name includes user input without encoding
        DirectoryEntry de = new DirectoryEntry("LDAP://Cn=" + userName);
        DirectoryEntry de2 = new DirectoryEntry();
        de2.Path = "LDAP://Cn=" + userName;

        using (SqlConnection connection = new SqlConnection(""))
        {
            connection.Open();
            SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
            SqlDataReader customerReader = customerCommand.ExecuteReader();

            while (customerReader.Read())
            {
                // BAD: Read from database, write it straight to a response
                DirectorySearcher ds4 = new DirectorySearcher("accountname=" + customerReader.GetString(1));
            }
            customerReader.Close();
        }
    }

    public string LDAPEncode(string value)
    {
        // Query identifies encoders by method name only, so the body is not important
        return value;
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
