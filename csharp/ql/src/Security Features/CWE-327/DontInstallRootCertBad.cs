using System.Security.Cryptography.X509Certificates;

public class RootCertExample
{
    public void AddCertificateToRootStore(X509Certificate2 cert)
    {
        // BAD: Adding a certificate to the system root store weakens security
        // for all applications on the machine.
        var store = new X509Store(StoreName.Root, StoreLocation.LocalMachine);
        store.Open(OpenFlags.ReadWrite);
        store.Add(cert);
        store.Close();
    }
}
