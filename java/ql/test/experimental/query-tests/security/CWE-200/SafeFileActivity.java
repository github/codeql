import java.io.RandomAccessFile;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

public class SafeFileActivity extends Activity {
    @Override
    // GOOD: Load file from activity with path validation
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == GetFileActivity.REQUEST_CODE__SELECT_CONTENT_FROM_APPS &&
                resultCode == RESULT_OK) {
            safeLoadOfContentFromApps(data, resultCode);
        }
    }

    private void safeLoadOfContentFromApps(Intent contentIntent, int resultCode) {
        Uri streamsToUpload = contentIntent.getData();
        try {
            if (!streamsToUpload.getPath().startsWith("/data/data")) {
                RandomAccessFile file = new RandomAccessFile(streamsToUpload.getPath(), "r");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
