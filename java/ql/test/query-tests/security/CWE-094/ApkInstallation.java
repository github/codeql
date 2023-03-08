import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;

import java.io.File;

public class ApkInstallation extends Activity {
    static final String APK_MIMETYPE = "application/vnd.android.package-archive";

    public void installAPK(String path) {
        // BAD: the path is not checked
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(Uri.fromFile(new File(path)), "application/vnd.android.package-archive"); // $ hasApkInstallation
        startActivity(intent);
    }

    public void installAPK3(String path) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setType(APK_MIMETYPE);
        // BAD: the path is not checked
        intent.setData(Uri.fromFile(new File(path))); // $ hasApkInstallation
        startActivity(intent);
    }

    public void installAPKFromExternalStorage(String path) {
        // BAD: file is from external storage
        File file = new File(Environment.getExternalStorageDirectory(), path);
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(Uri.fromFile(file), APK_MIMETYPE); // $ hasApkInstallation
        startActivity(intent);
    }

    public void installAPKFromExternalStorageWithActionInstallPackage(String path) {
        // BAD: file is from external storage
        File file = new File(Environment.getExternalStorageDirectory(), path);
        Intent intent = new Intent(Intent.ACTION_INSTALL_PACKAGE);
        intent.setData(Uri.fromFile(file)); // $ hasApkInstallation
        startActivity(intent);
    }

    public void installAPKInstallPackageLiteral(String path) {
        File file = new File(Environment.getExternalStorageDirectory(), path);
        Intent intent = new Intent("android.intent.action.INSTALL_PACKAGE");
        intent.setData(Uri.fromFile(file)); // $ hasApkInstallation
        startActivity(intent);
    }

    public void otherIntent(File file) {
        Intent intent = new Intent(this, OtherActivity.class);
        intent.setAction(Intent.ACTION_VIEW);
        // BAD: the file is from unknown source
        intent.setData(Uri.fromFile(file)); // $ hasApkInstallation
    }
}

class OtherActivity extends Activity {
}
