using System.Security.Cryptography.X509Certificates;

public class RootCertExample
{
    public void AddCertificateToUserStore(X509Certificate2 cert)
    {
        // GOOD: Using a user-specific store limits the scope of the trusted certificate.
        var store = new X509Store(StoreName.My, StoreLocation.CurrentUser);
        store.Open(OpenFlags.ReadWrite);
        store.Add(cert);
        store.Close();
    }
}
