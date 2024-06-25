// semmle-extractor-options: /r:System.Net.Sockets.dll /r:System.Net.Security.dll /r:System.Security.Cryptography.Algorithms.dll /r:System.Net.Http.dll /r:System.Net.ServicePoint.dll /r:System.Security.Cryptography.dll /r:System.Net.Primitives.dll /r:System.Net.Requests.dll /r:System.Private.Uri.dll
using System;
using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Security.Cryptography.X509Certificates;
using System.IO;
using System.Net.Http;

class Program
{

    static void First()
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

    static void Second()
    {
        HttpClientHandler handler = new HttpClientHandler();
        handler.ServerCertificateCustomValidationCallback = (sender, cert, chain, sslPolicyErrors) => true; // BAD: unsafe callback used
        handler.ServerCertificateCustomValidationCallback = SafeValidateServerCertificate; // GOOD: safe callback used
        HttpClient client = new HttpClient(handler);
    }

    static void Third()
    {
        ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(ValidateServerCertificate); // BAD: unsafe callback used
        ServicePointManager.ServerCertificateValidationCallback = (sender, cert, chain, sslPolicyErrors) => true; // BAD: unsafe callback used
        ServicePointManager.ServerCertificateValidationCallback = ValidateServerCertificate; // BAD: unsafe callback used
        ServicePointManager.ServerCertificateValidationCallback = SafeValidateServerCertificate; // GOOD: safe callback used
    }
    static void Fourth()
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://www.example.com");
        request.ServerCertificateValidationCallback = ValidateServerCertificate; // BAD: unsafe callback used
        request.ServerCertificateValidationCallback = SafeValidateServerCertificate; // GOOD: safe callback used

    }

}
