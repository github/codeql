import android.content.ContentResolver;
import android.net.Uri;

public class Example extends Activity {
    public void onCreate() {
        // BAD: Externally-provided URI directly used in content resolution
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            InputStream is = contentResolver.openInputStream(uri);
            copyToExternalCache(is);
        }
        // BAD: input URI is not normalized, and check can be bypassed with ".." characters
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            if (path.startsWith("/data"))
                throw new SecurityException();
            InputStream is = contentResolver.openInputStream(uri);
            copyToExternalCache(is);
        }
        // GOOD: URI is properly validated to block access to internal files
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            java.nio.file.Path normalized =
                    java.nio.file.FileSystems.getDefault().getPath(path).normalize();
            if (normalized.startsWith("/data"))
                throw new SecurityException();
            InputStream is = contentResolver.openInputStream(uri);
            copyToExternalCache(is);
        }
    }

    private void copyToExternalCache(InputStream is) {
        // Reads the contents of is and writes a file in the app's external
        // cache directory, which can be read publicly by applications in the same device.
    }
}
