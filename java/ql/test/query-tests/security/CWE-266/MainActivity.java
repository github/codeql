package com.example.app;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

public class MainActivity extends Activity {

    public void onCreate(Bundle savedInstance) {
        {
            Intent intent = getIntent();
            setResult(RESULT_OK, intent); // $ hasTaintFlow
        }
        {
            Intent extraIntent = (Intent) getIntent().getParcelableExtra("extraIntent");
            setResult(RESULT_OK, extraIntent); // $ hasTaintFlow
        }
        {
            Intent intent = getIntent();
            intent.setData(Uri.parse("content://safe/uri")); // Sanitizer
            setResult(RESULT_OK, intent); // Safe
        }
        {
            Intent intent = getIntent();
            intent.setFlags(0); // Sanitizer
            setResult(RESULT_OK, intent); // Safe
        }
        {
            Intent intent = getIntent();
            intent.setFlags( // Not properly sanitized
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            setResult(RESULT_OK, intent); // $ hasTaintFlow
        }
        {
            Intent intent = getIntent();
            intent.removeFlags( // Sanitizer
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
            setResult(RESULT_OK, intent); // Safe
        }
        {
            Intent intent = getIntent();
            // Combined, the following two calls are a sanitizer
            intent.removeFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.removeFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            setResult(RESULT_OK, intent); // $ SPURIOUS: $ hasTaintFlow
        }
        {
            Intent intent = getIntent();
            intent.removeFlags( // Not properly sanitized
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            setResult(RESULT_OK, intent); // $ hasTaintFlow
        }
        {
            Intent intent = getIntent();
            // Good check
            if (intent.getData().equals(Uri.parse("content://safe/uri"))) {
                setResult(RESULT_OK, intent); // Safe
            } else {
                setResult(RESULT_OK, intent); // $ hasTaintFlow
            }
        }
        {
            Intent intent = getIntent();
            int flags = intent.getFlags();
            // Good check
            if ((flags & Intent.FLAG_GRANT_READ_URI_PERMISSION) == 0
                    && (flags & Intent.FLAG_GRANT_WRITE_URI_PERMISSION) == 0) {
                setResult(RESULT_OK, intent); // Safe
            } else {
                setResult(RESULT_OK, intent); // $ hasTaintFlow
            }
        }
        {
            Intent intent = getIntent();
            int flags = intent.getFlags();
            // Insufficient check
            if ((flags & Intent.FLAG_GRANT_READ_URI_PERMISSION) == 0) {
                setResult(RESULT_OK, intent); // $ MISSING: $ hasTaintFlow
            } else {
                setResult(RESULT_OK, intent); // $ hasTaintFlow
            }
        }
    }
}
