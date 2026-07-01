using System.Net.Http;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public class CertificateValidation
{
    public void Bad()
    {
        var handler = new HttpClientHandler();
        // BAD: the callback always returns true, so every certificate is trusted.
        handler.ServerCertificateCustomValidationCallback =
            (request, certificate, chain, errors) => true;
    }

    public void Good()
    {
        var handler = new HttpClientHandler();
        // GOOD: the certificate is only trusted when there are no validation errors.
        handler.ServerCertificateCustomValidationCallback =
            (request, certificate, chain, errors) => errors == SslPolicyErrors.None;
    }
}
