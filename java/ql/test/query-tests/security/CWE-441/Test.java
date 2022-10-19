package test;

import android.content.ContentResolver;
import android.net.Uri;
import android.app.Activity;

public class Test extends Activity {
    private void validateWithEquals(Uri uri) {
        if (!uri.equals(Uri.parse("content://safe/uri")))
            throw new SecurityException();
    }

    private void validateWithAllowList(Uri uri) throws SecurityException {
        String path = uri.getPath();
        java.nio.file.Path normalized =
                java.nio.file.FileSystems.getDefault().getPath(path).normalize();
        if (!normalized.startsWith("/safe/path"))
            throw new SecurityException();
    }

    private void validateWithBlockList(Uri uri) throws SecurityException {
        String path = uri.getPath();
        java.nio.file.Path normalized =
                java.nio.file.FileSystems.getDefault().getPath(path).normalize();
        if (normalized.startsWith("/data"))
            throw new SecurityException();
    }

    public void onCreate() {
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            contentResolver.openInputStream(uri); // $ hasTaintFlow
            contentResolver.openOutputStream(uri); // $ hasTaintFlow
            contentResolver.openAssetFile(uri, null, null); // $ hasTaintFlow
            contentResolver.openAssetFileDescriptor(uri, null); // $ hasTaintFlow
            contentResolver.openFile(uri, null, null); // $ hasTaintFlow
            contentResolver.openFileDescriptor(uri, null); // $ hasTaintFlow
            contentResolver.openTypedAssetFile(uri, null, null, null); // $ hasTaintFlow
            contentResolver.openTypedAssetFileDescriptor(uri, null, null); // $ hasTaintFlow
        }
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            if (path.startsWith("/data"))
                throw new SecurityException();
            contentResolver.openInputStream(uri); // $ hasTaintFlow
        }
        // Equals checks
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            if (!uri.equals(Uri.parse("content://safe/uri")))
                throw new SecurityException();
            contentResolver.openInputStream(uri); // Safe
        }
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            validateWithEquals(uri);
            contentResolver.openInputStream(uri); // Safe
        }
        // Allow list checks
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            if (!path.startsWith("/safe/path"))
                throw new SecurityException();
            contentResolver.openInputStream(uri); // $ hasTaintFlow
        }
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            java.nio.file.Path normalized =
                    java.nio.file.FileSystems.getDefault().getPath(path).normalize();
            if (!normalized.startsWith("/safe/path"))
                throw new SecurityException();
            contentResolver.openInputStream(uri); // Safe
        }
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            validateWithAllowList(uri);
            contentResolver.openInputStream(uri); // Safe
        }
        // Block list checks
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            if (path.startsWith("/data"))
                throw new SecurityException();
            contentResolver.openInputStream(uri); // $ hasTaintFlow
        }
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            String path = uri.getPath();
            java.nio.file.Path normalized =
                    java.nio.file.FileSystems.getDefault().getPath(path).normalize();
            if (normalized.startsWith("/data"))
                throw new SecurityException();
            contentResolver.openInputStream(uri); // Safe
        }
        {
            ContentResolver contentResolver = getContentResolver();
            Uri uri = (Uri) getIntent().getParcelableExtra("URI_EXTRA");
            validateWithBlockList(uri);
            contentResolver.openInputStream(uri); // Safe
        }
    }
}
