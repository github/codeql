
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.os.Bundle;

public class InsecureClassLoading extends Application {
  @Override
  public void onCreate() {
    super.onCreate();
    invokePlugins();
  }

  private void invokePlugins() {

    PackageManager packageManager = getPackageManager();
    List<PackageInfo> packageList = packageManager.getInstalledPackages(PackageManager.GET_SIGNATURES);

    for (PackageInfo p : packageList) {

      // Check the signature of the package before using it.
      final Signature[] arrSignatures = p.signatures;
      for (final Signature sig : arrSignatures) {
        final byte[] rawCert = sig.toByteArray();
        InputStream certStream = new ByteArrayInputStream(rawCert);

        try {
          CertificateFactory certFactory = CertificateFactory.getInstance("X509");
          X509Certificate x509Cert = (X509Certificate) certFactory.generateCertificate(certStream);

          if (!x509Cert.getSubjectDN().equals("Trusted Subject DN")
              || !x509Cert.getIssuerDN().equals("Trusted Issuer DN")
              || !x509Cert.getSerialNumber().equals("Serial Number")) {
            throw Exception("Signature mismatch");
          }
        } catch (Exception e) {
          // e.printStackTrace();
        }
      }

      // This is now safe as the signature of the package is verified
      String packageName = info.packageName;
      Bundle meta = info.applicationInfo.metaData;
      if (packageName.startsWith("somename.plugin.")) {
        try {
          Context packageContext = createPackageContext(packageName, CONTEXT_INCLUDE_CODE | CONTEXT_IGNORE_SECURITY);
          packageContext.getClassLoader().loadClass("somename.pluginLoader").getMethod("load", Context.class)
              .invoke(null, this);
        } catch (Exception e) {
          throw new RuntimeException(e);
        }
      }
    }
  }
}
