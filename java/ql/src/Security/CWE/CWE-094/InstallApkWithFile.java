import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;

import java.io.File;

/* Get a file from external storage */
File file = new File(Environment.getExternalStorageDirectory(), "myapp.apk");
Intent intent = new Intent(Intent.ACTION_VIEW);
/* Set the mimetype to APK */
intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive");

startActivity(intent);
