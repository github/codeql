// semmle-extractor-options: /r:${testdir}/../../../resources/assemblies/System.Web.dll /r:${testdir}/../../../resources/assemblies/System.Web.ApplicationServices.dll /r:${testdir}/../../../resources/assemblies/System.Data.dll /r:System.Text.RegularExpressions.dll /r:System.Collections.Specialized.dll /r:System.Data.Common.dll /r:System.Security.Cryptography.X509Certificates.dll /r:System.Runtime.InteropServices.dll

using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Security.Cryptography.X509Certificates;

public class HardcodedHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string password = ctx.Request.QueryString["password"];

        // BAD: Inbound authentication made by comparison to string literal
        if (password == "myPa55word")
        {
            ctx.Response.Redirect("login");
        }

        string hashedPassword = LoadPasswordFromSecretConfig();

        // GOOD: the password is checked
        if (VerifyHashedPassword(hashedPassword, password))
        {
            ctx.Response.Redirect("login");
        }

        // BAD: Create a membership user with hardcoded username
        MembershipUser user = new MembershipUser(
            providerName: "provider",
            name: "username",
            providerUserKey: "username",
            email: "foo@bar.com",
            passwordQuestion: "Hardcoded question.",
            comment: "",
            isApproved: true,
            isLockedOut: false,
            creationDate: DateTime.Now,
            lastLoginDate: DateTime.Now,
            lastActivityDate: DateTime.Now,
            lastPasswordChangedDate: DateTime.Now,
            lastLockoutDate: DateTime.Now
            );
        // BAD: Set the password to a hardcoded string literal
        user.ChangePassword(password, "myNewPa55word");

        byte[] rawCertData = new byte[] { 0x20, 0x20, 0x20 };
        // BAD: Passing a literal certificate and password to an X509 certificate constructor
        X509Certificate2 cert = new X509Certificate2(
            rawCertData,
            "myPa55word");

        // BAD: Passing literal Password to connection string
        SqlConnection conn = new SqlConnection("Password=12345");
        // BAD: Passing literal User Id to connection string
        SqlConnection conn2 = new SqlConnection("User Id=12345");
        // GOOD: Password is not specified literally
        SqlConnection conn3 = new SqlConnection("Password=" + LoadPasswordFromSecretConfig() + ";");

        // SANITIZERS:
        // GOOD: Password is not set literally, and the replace characters should not be considered as sources
        X509Certificate2 cert2 = new X509Certificate2(
            "cert.cert",
            LoadPasswordFromSecretConfig().Replace("=", "\\="));
        // GOOD: Password is not set literally, and ToString
        X509Certificate2 cert3 = new X509Certificate2(
            "cert.cert",
            new Foo().ToString());
        // GOOD: Password is not set literally
        conn = new SqlConnection(string.Format("Password={0}", LoadPasswordFromSecretConfig()));
        conn = new SqlConnection($"Password={LoadPasswordFromSecretConfig()}");

        // BAD: Hard-coded user
        Membership.CreateUser("myusername", "mypassword");
    }

    class Foo
    {
        string ToString()
        {
            // We don't consider this hard-coded data - too many ToString implementations include
            // string literal construction
            return "Foo";
        }
    }

    public string LoadPasswordFromSecretConfig()
    {
        return null;
    }

    public static bool VerifyHashedPassword(string hashedPassword, string password)
    {
        // API provided by System.Web.Helpers.Crypto.VerifyHashedPassword
        // but that assembly not available on Mono.
        return true;
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
