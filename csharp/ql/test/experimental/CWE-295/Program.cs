using System;
using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Security.Cryptography.X509Certificates;
using System.IO;
using System.Net.Http;

class Program
{

    void M1()
    {
        TcpClient client = new TcpClient("www.example.com", 443);
        SslStream sslStream = new SslStream(
            client.GetStream(),
            false,
            new RemoteCertificateValidationCallback(ValidateServerCertificate), // BAD: unsafe callback used
            null
        );
        sslStream = new SslStream(
           client.GetStream(),
           false,
           new RemoteCertificateValidationCallback(SafeValidateServerCertificate), // GOOD: safe callback used
           null
       );

        try
        {
            sslStream.AuthenticateAsClient("www.example.com");
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
        }
    }

    public static bool ValidateServerCertificate(
          object sender,
          X509Certificate certificate,
          X509Chain chain,
          SslPolicyErrors sslPolicyErrors)
    {
        return true;
    }

    public static bool SafeValidateServerCertificate(
      object sender,
      X509Certificate certificate,
      X509Chain chain,
      SslPolicyErrors sslPolicyErrors)
    {
        return sslPolicyErrors == SslPolicyErrors.None;
    }

    void M2()
    {
        HttpClientHandler handler = new HttpClientHandler();
        handler.ServerCertificateCustomValidationCallback = (sender, cert, chain, sslPolicyErrors) => true; // BAD: unsafe callback used
        handler.ServerCertificateCustomValidationCallback = SafeValidateServerCertificate; // GOOD: safe callback used
        HttpClient client = new HttpClient(handler);
    }

    void M3()
    {
        ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(ValidateServerCertificate); // BAD: unsafe callback used
        ServicePointManager.ServerCertificateValidationCallback = (sender, cert, chain, sslPolicyErrors) => true; // BAD: unsafe callback used
        ServicePointManager.ServerCertificateValidationCallback = ValidateServerCertificate; // BAD: unsafe callback used
        ServicePointManager.ServerCertificateValidationCallback = SafeValidateServerCertificate; // GOOD: safe callback used
    }

    void M4()
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://www.example.com");
        request.ServerCertificateValidationCallback = ValidateServerCertificate; // BAD: unsafe callback used
        request.ServerCertificateValidationCallback = SafeValidateServerCertificate; // GOOD: safe callback used

    }

    void SetCallback(RemoteCertificateValidationCallback callback)
    {
        ServicePointManager.ServerCertificateValidationCallback = callback; // BAD: unsafe callback used
    }

    void M5(bool b)
    {
        RemoteCertificateValidationCallback callback = ValidateServerCertificate;
        if (b) {
            SetCallback(callback); // BAD: unsafe callback used
        }
    }

    void M6(Settings settings)
    {
        RemoteCertificateValidationCallback callback = ValidateServerCertificate;
        if (settings.IgnoreCertificateValidation)
        {
            SetCallback(callback); // GOOD: We don't do validation.
        }
    }

    void M7(Settings settings)
    {
        if (settings.IgnoreCertificateValidation)
        {
            ServicePointManager.ServerCertificateValidationCallback = ValidateServerCertificate; // GOOD: We don't do validation.
        }
    }

    void M8(Settings settings)
    {
        if (!settings.IgnoreCertificateValidation)
        {
            ServicePointManager.ServerCertificateValidationCallback = ValidateServerCertificate; // BAD: unsafe callback used
        }
    }
}

public class Settings {

    public bool IgnoreCertificateValidation { get; set; }
}
