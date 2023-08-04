using System.Web;
using System.Security.Cryptography; 
using System.IO;

public class Person
{
    public string getTelephone()
    {
        return "";
    }
}

public class ExposureOfPrivateInformationHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: Setting a cookie value or values with private data.
        ctx.Response.Cookies["MyCookie"].Value = ctx.Request.QueryString["postcode"];
        Person p = new Person();
        ctx.Response.Cookies["MyCookie"].Value = p.getTelephone();

        // BAD: Logging private data
        ILogger logger = new ILogger();
        logger.Warn(p.getTelephone());

        // BAD: Storing sensitive data in unencrypted local file 
        using (var writeStream = File.Open("telephones.txt", FileMode.Create))
        {
            var writer = new StreamWriter(writeStream);
            writer.Write(p.getTelephone());
            writer.Close();
        }

        // GOOD: Storing encrypted sensitive data
        using (var writeStream = File.Open("telephones.txt", FileMode.Create))
        {
            var writer = new StreamWriter(new CryptoStream(writeStream, GetEncryptor(), CryptoStreamMode.Write));
            writer.Write(p.getTelephone());
            writer.Close();
        }

        // GOOD: Don't write these values to sensitive locations in the first place
    }

    public ICryptoTransform GetEncryptor(){
        return null;
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

    System.Windows.Forms.TextBox postcode;

    void OnButtonClicked()
    {
        ILogger logger = new ILogger();
        logger.Warn(postcode.Text);
    }
}

class ILogger
{
    public void Warn(string message) { }
}
