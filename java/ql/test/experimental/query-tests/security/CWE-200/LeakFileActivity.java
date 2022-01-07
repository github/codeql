import java.io.RandomAccessFile;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

public class LeakFileActivity extends Activity {
    @Override
    // BAD: Load file from activity without validation
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == GetFileActivity.REQUEST_CODE__SELECT_CONTENT_FROM_APPS &&
                resultCode == RESULT_OK) {
            loadOfContentFromApps(data, resultCode);
        }
    }

    private void loadOfContentFromApps(Intent contentIntent, int resultCode) {
        Uri streamsToUpload = contentIntent.getData();
        try {
            RandomAccessFile file = new RandomAccessFile(streamsToUpload.getPath(), "r");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
