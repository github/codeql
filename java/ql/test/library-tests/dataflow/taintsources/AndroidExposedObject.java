import android.webkit.JavascriptInterface;

public class AndroidExposedObject {
    public void sink(Object o) {
    }

    @JavascriptInterface
    public void test(String arg) {
        sink(arg); // $hasRemoteValueFlow
    }
}
