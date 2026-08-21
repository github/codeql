using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public class CertificateValidationTests
{
    public void HttpClientHandlerBad()
    {
        var handler = new HttpClientHandler();
        // BAD: always trusts any certificate.
        handler.ServerCertificateCustomValidationCallback =
            (request, certificate, chain, errors) => true; // $ Alert
    }

    public void HttpClientHandlerBlockBodyBad()
    {
        var handler = new HttpClientHandler();
        // BAD: always trusts any certificate.
        handler.ServerCertificateCustomValidationCallback =
            (request, certificate, chain, errors) =>
            {
                return true;
            }; // $ Alert
    }

    public void HttpClientHandlerDangerousBad()
    {
        var handler = new HttpClientHandler();
        // BAD: built-in callback that accepts any certificate.
        handler.ServerCertificateCustomValidationCallback =
            HttpClientHandler.DangerousAcceptAnyServerCertificateValidator; // $ Alert
    }

    public void ServicePointManagerBad()
    {
        // BAD: always trusts any certificate.
        ServicePointManager.ServerCertificateValidationCallback =
            (sender, certificate, chain, errors) => true; // $ Alert
    }

    public void ServicePointManagerCompoundBad()
    {
        // BAD: always trusts any certificate (compound assignment).
        ServicePointManager.ServerCertificateValidationCallback +=
            (sender, cert, chain, errors) => { return true; }; // $ Alert
        // BAD
        ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => true; // $ Alert
        // BAD: parameterless anonymous method.
        ServicePointManager.ServerCertificateValidationCallback += delegate { return true; }; // $ Alert
    }

    private static bool AcceptAll(object sender, X509Certificate certificate, X509Chain chain,
        SslPolicyErrors errors)
    {
        return true;
    }

    public bool AcceptAllNonStatic(object sender, X509Certificate certificate, X509Chain chain,
        SslPolicyErrors errors)
    {
        return true;
    }

    public void MethodGroupBad()
    {
        // BAD: the referenced static method always returns true.
        ServicePointManager.ServerCertificateValidationCallback = AcceptAll; // $ Alert
    }

    public void MethodGroupNonStaticBad()
    {
        // BAD: the referenced instance method always returns true.
        ServicePointManager.ServerCertificateValidationCallback =
            new RemoteCertificateValidationCallback(this.AcceptAllNonStatic); // $ Alert
    }

    public void SslStreamBad(Stream stream)
    {
        // BAD: the validation callback always returns true.
        var ssl = new SslStream(stream, false,
            (sender, certificate, chain, errors) => true); // $ Alert
    }

    public void IndirectBad(Stream stream)
    {
        RemoteCertificateValidationCallback callback =
            (sender, certificate, chain, errors) => true; // $ Source Alert
        // BAD: the callback flowing here always returns true.
        var ssl = new SslStream(stream, false, callback); // $ Alert
    }

    public void HttpClientHandlerGood()
    {
        var handler = new HttpClientHandler();
        // GOOD: the certificate is only trusted when there are no validation errors.
        handler.ServerCertificateCustomValidationCallback =
            (request, certificate, chain, errors) => errors == SslPolicyErrors.None;
    }

    public void ControlFlowGood()
    {
        // GOOD: not every returned value is `true`.
        ServicePointManager.ServerCertificateValidationCallback +=
            (sender, cert, chain, errors) =>
            {
                if (cert == null)
                {
                    return false;
                }

                if (errors != SslPolicyErrors.None)
                {
                    return false;
                }

                return true;
            };
    }

    private static bool Validate(object sender, X509Certificate certificate, X509Chain chain,
        SslPolicyErrors errors)
    {
        return errors == SslPolicyErrors.None;
    }

    public void MethodGroupGood()
    {
        // GOOD: the referenced method performs real validation.
        ServicePointManager.ServerCertificateValidationCallback = Validate;
    }
}
