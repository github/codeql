// Generated automatically from android.webkit.WebResourceRequest for testing purposes

package android.webkit;

import android.net.Uri;
import java.util.Map;

public interface WebResourceRequest
{
    Map<String, String> getRequestHeaders();
    String getMethod();
    Uri getUrl();
    boolean hasGesture();
    boolean isForMainFrame();
    boolean isRedirect();
}
