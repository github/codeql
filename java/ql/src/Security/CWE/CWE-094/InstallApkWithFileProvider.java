import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import androidx.core.content.FileProvider;

import java.io.File;
import java.io.FileOutputStream;

String tempFilename = "temporary.apk";
byte[] buffer = new byte[16384];

/* Copy application asset into temporary file */
try (InputStream is = getAssets().open(assetName);
     FileOutputStream fout = openFileOutput(tempFilename, Context.MODE_PRIVATE)) {
    int n;
    while ((n=is.read(buffer)) >= 0) {
        fout.write(buffer, 0, n);
    }
}

/* Expose temporary file with FileProvider */
File toInstall = new File(this.getFilesDir(), tempFilename);
Uri applicationUri = FileProvider.getUriForFile(this, "com.example.apkprovider", toInstall);

/* Create Intent and set data to APK file. */
Intent intent = new Intent(Intent.ACTION_INSTALL_PACKAGE);
intent.setData(applicationUri);
intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

startActivity(intent);
