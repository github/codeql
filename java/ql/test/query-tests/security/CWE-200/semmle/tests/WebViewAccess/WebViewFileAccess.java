import android.webkit.WebView;
import android.webkit.WebSettings;

class WebViewFileAccess {
    void configure(WebView view) {
        WebSettings settings = view.getSettings();

        settings.setAllowFileAccess(true); // $ Alert[java/android/websettings-file-access]

        settings.setAllowFileAccessFromFileURLs(true); // $ Alert[java/android/websettings-file-access]

        settings.setAllowUniversalAccessFromFileURLs(true); // $ Alert[java/android/websettings-file-access]
    }

    void configureSafe(WebView view) {
        WebSettings settings = view.getSettings();

        settings.setAllowFileAccess(false);

        settings.setAllowFileAccessFromFileURLs(false);

        settings.setAllowUniversalAccessFromFileURLs(false);
    }
}
