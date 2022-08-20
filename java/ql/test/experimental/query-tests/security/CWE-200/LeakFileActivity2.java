import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

public class LeakFileActivity2 extends Activity {
    @Override
    // BAD: Load file in a service without validation
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Uri localPath = data.getData();

        if (requestCode == GetFileActivity.REQUEST_CODE__SELECT_CONTENT_FROM_APPS &&
                resultCode == RESULT_OK) {
            Intent intent = new Intent(this, FileService.class);
            intent.putExtra(FileService.KEY_LOCAL_FILE, localPath);
            startService(intent);
        }
    }
}
