import android.webkit.WebView;
import android.webkit.WebSettings;

class WebViewFileAccess {
    void configure(WebView view) {
        WebSettings settings = view.getSettings();

        settings.setAllowFileAccess(true);

        settings.setAllowFileAccessFromFileURLs(true);

        settings.setAllowUniversalAccessFromFileURLs(true);
    }
}
