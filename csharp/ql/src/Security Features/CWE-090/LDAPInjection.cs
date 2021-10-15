using Microsoft.Security.Application.Encoder
using System;
using System.DirectoryServices;
using System.Web;

public class LDAPInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["username"];
        string organizationName = ctx.Request.QueryString["organization_name"];
        // BAD: User input used in DN (Distinguished Name) without encoding
        string ldapQuery = "LDAP://myserver/OU=People,O=" + organizationName;
        using (DirectoryEntry root = new DirectoryEntry(ldapQuery))
        {
            // BAD: User input used in search filter without encoding
            DirectorySearcher ds = new DirectorySearcher(root, "username=" + userName);

            SearchResult result = ds.FindOne();
            if (result != null)
            {
                using (DirectoryEntry user = result.getDirectoryEntry())
                {
                    ctx.Response.Write(user.Properties["type"].Value)
                }
            }
        }

        // GOOD: Organization name is encoded before being used in DN
        string safeOrganizationName = Encoder.LdapDistinguishedNameEncode(organizationName);
        string safeLDAPQuery = "LDAP://myserver/OU=People,O=" + safeOrganizationName;
        using (DirectoryEntry root = new DirectoryEntry(safeLDAPQuery))
        {
            // GOOD: User input is encoded before being used in search filter
            string safeUserName = Encoder.LdapFilterEncode(userName);
            DirectorySearcher ds = new DirectorySearcher(root, "username=" + safeUserName);

            SearchResult result = ds.FindOne();
            if (result != null)
            {
                using (DirectoryEntry user = result.getDirectoryEntry())
                {
                    ctx.Response.Write(user.Properties["type"].Value)
                }
            }
        }
    }
}
