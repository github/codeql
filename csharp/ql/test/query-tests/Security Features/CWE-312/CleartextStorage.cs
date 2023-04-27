using System.Text;
using System.Web;
using System.Web.Security;
using System.Windows.Forms;
using System.IO;
using System.Security.Cryptography;

public class ClearTextStorageHandler : IHttpHandler
{
    private string accountKey;

    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: Setting a cookie value or values with sensitive data.
        ctx.Response.Cookies["MyCookie"].Value = accountKey;
        ctx.Response.Cookies["MyOtherCookie"]["Sensitive"] = GetPassword();
        ctx.Response.Cookies["MyOtherCookie"].Values["Sensitive"] = GetPassword();
        ctx.Response.Cookies["MyCookie"].Value = GetAccountID();
        // GOOD: Encoding the value before setting it.
        ctx.Response.Cookies["MyCookie"].Value = Encode(accountKey, "Account key");

        // OK: Account name is not considered to be secret data
        ctx.Response.Cookies["MyCookie"].Value = GetAccountName();
        ILogger logger = new ILogger();
        // BAD: Logging sensitive data
        logger.Warn(GetPassword());
        // GOOD: Logging encrypted sensitive data
        logger.Warn(Encode(GetPassword(), "Password"));

        // BAD: Storing sensitive data in local file 
        using (var writeStream = File.Open("passwords.txt", FileMode.Create))
        {
            var writer = new StreamWriter(writeStream);
            writer.Write(GetPassword());
            writer.Close();
        }

        // GOOD: Storing encrypted sensitive data
        using (var writeStream = File.Open("passwords.txt", FileMode.Create))
        {
            var writer = new StreamWriter(new CryptoStream(writeStream, GetEncryptor(), CryptoStreamMode.Write));
            writer.Write(GetPassword());
            writer.Close();
        }
    }

    public string Encode(string value, string type)
    {
        return Encoding.UTF8.GetString(MachineKey.Protect(Encoding.UTF8.GetBytes(value), type));
    }

    public ICryptoTransform GetEncryptor(){
        return null;
    }

    public string GetPassword()
    {
        return "password";
    }

    public string GetAccountName()
    {
        return "accountName";
    }

    public string GetAccountID()
    {
        return "accountID";
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}

class ILogger
{
    public void Warn(string message) { }
}

class MyForm : Form
{
    TextBox password, box1, box2, box3;
    ILogger logger;

    public void OnButtonClicked()
    {
        box1.PasswordChar = '*';
        box2.UseSystemPasswordChar = true;
        logger.Warn(password.Text);  // BAD
        logger.Warn(box1.Text);  // BAD
        logger.Warn(box2.Text);  // BAD
        logger.Warn(box3.Text);  // GOOD
    }
}
