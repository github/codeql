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
        string userName = ctx.Request.QueryString["username"]; // $ Source=r1 Source=r2 Source=r3 Source=r4 Source=r5 Source=r6

        // BAD: Filter includes user input without encoding
        DirectorySearcher ds = new DirectorySearcher("accountname=" + userName); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6
        DirectorySearcher ds2 = new DirectorySearcher();
        ds.Filter = "accountname=" + userName; // $ Alert=r2 Alert=r1 Alert=r3 Alert=r4 Alert=r5 Alert=r6

        // GOOD: Filter includes user input with encoding
        DirectorySearcher ds3 = new DirectorySearcher("accountname=" + LDAPEncode(userName));

        // BAD: SearchRequest Filter includes user input without encoding
        SearchRequest sr = new SearchRequest();
        sr.Filter = "accountname=" + userName; // $ Alert=r3 Alert=r1 Alert=r2 Alert=r4 Alert=r5 Alert=r6
        SearchRequest sr2 = new SearchRequest(null, "accountname=" + userName, System.DirectoryServices.Protocols.SearchScope.Base, null); // $ Alert=r4 Alert=r1 Alert=r2 Alert=r3 Alert=r5 Alert=r6

        // BAD: Distinguished Name includes user input without encoding
        DirectoryEntry de = new DirectoryEntry("LDAP://Cn=" + userName); // $ Alert=r5 Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r6
        DirectoryEntry de2 = new DirectoryEntry();
        de2.Path = "LDAP://Cn=" + userName; // $ Alert=r6 Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5

        using (SqlConnection connection = new SqlConnection(""))
        {
            connection.Open();
            SqlCommand customerCommand = new SqlCommand("SELECT * FROM customers", connection);
            SqlDataReader customerReader = customerCommand.ExecuteReader(); // $ Source=r7

            while (customerReader.Read())
            {
                // BAD: Read from database, write it straight to a response
                DirectorySearcher ds4 = new DirectorySearcher("accountname=" + customerReader.GetString(1)); // $ Alert=r7
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
