import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInstaller;

private static final String PACKAGE_INSTALLED_ACTION =
    "com.example.SESSION_API_PACKAGE_INSTALLED";

/* Create the package installer and session */
PackageInstaller packageInstaller = getPackageManager().getPackageInstaller();
PackageInstaller.SessionParams params =
    new PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL);
int sessionId = packageInstaller.createSession(params);
session = packageInstaller.openSession(sessionId);

/* Load asset into session */
try (OutputStream packageInSession = session.openWrite("package", 0, -1);
     InputStream is = getAssets().open(assetName)) {
    byte[] buffer = new byte[16384];
    int n;
    while ((n = is.read(buffer)) >= 0) {
        packageInSession.write(buffer, 0, n);
    }
}

/* Create status receiver */
Intent intent = new Intent(this, InstallApkSessionApi.class);
intent.setAction(PACKAGE_INSTALLED_ACTION);
PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
IntentSender statusReceiver = pendingIntent.getIntentSender();

/* Commit the session */
session.commit(statusReceiver);
