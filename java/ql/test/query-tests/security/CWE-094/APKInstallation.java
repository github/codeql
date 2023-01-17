import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import java.io.File;

public class APKInstallation extends Activity {
    static final String APK_MIMETYPE = "application/vnd.android.package-archive";

    public void installAPK(String path) {
        // BAD: the path is not checked
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(Uri.fromFile(new File(path)), "application/vnd.android.package-archive");
        startActivity(intent);
    }

    public void downloadAPK(String url) {
        // BAD: the url is not checked
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(Uri.parse(url), "application/vnd.android.package-archive");
        startActivity(intent);
    }

    public void installAPK2() {
        String path = "file:///sdcard/Download/MyApp.apk";
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setType("application/vnd.android.package-archive");
        intent.setData(Uri.parse(path));
        startActivity(intent);
    }

    public void installAPK3(String path) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setType(APK_MIMETYPE);
        intent.setData(Uri.fromFile(new File(path)));
        startActivity(intent);
    }
}
