import java.io.FileOutputStream;

import android.app.Service;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.AsyncTask;

public class FileService extends Service {
    public static String KEY_LOCAL_FILE = "local_file";
     /**
     * Service initialization
     */
    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String localPath = intent.getStringExtra(KEY_LOCAL_FILE);
        CopyAndUploadContentUrisTask copyTask = new CopyAndUploadContentUrisTask();

        copyTask.execute(
            copyTask.makeParamsToExecute(localPath)
        );
        return 2;
    }

    public class CopyAndUploadContentUrisTask extends AsyncTask<Object, Void, String> {
        public Object[] makeParamsToExecute(
            String sourceUri
        ) {
            return new Object[] {
                sourceUri
            };
        }

        @Override
        protected String doInBackground(Object[] params) {
            FileOutputStream outputStream = null;

            try {
                String[] uris = (String[]) params[1];
                outputStream = new FileOutputStream(uris[0]);
                return "success";
            } catch (Exception e) {
            }
            return "failure";
        }

        @Override
        protected void onPostExecute(String result) {
        }
    
        @Override
        protected void onPreExecute() {
        }

        @Override
        protected void onProgressUpdate(Void... values) {
        }    
    }
}
