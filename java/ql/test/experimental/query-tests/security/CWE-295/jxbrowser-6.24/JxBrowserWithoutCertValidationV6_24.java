import com.teamdev.jxbrowser.chromium.Browser;
import com.teamdev.jxbrowser.chromium.LoadHandler;
import com.teamdev.jxbrowser.chromium.LoadParams;
import com.teamdev.jxbrowser.chromium.CertificateErrorParams;

public class JxBrowserWithoutCertValidationV6_24 {

    public static void main(String[] args) {

        goodUsage();

        goodUsage2();

    }

    private static void goodUsage() {
        Browser browser = new Browser();
        browser.loadURL("https://example.com");
        // no further calls
        // GOOD: On version 6.24 the browser properly validates certificates by default!
    }

    private static void goodUsage2() {
        Browser browser = new Browser();
        browser.setLoadHandler(new LoadHandler() {
            public boolean onLoad(LoadParams params) {
                return true;
            }

            public boolean onCertificateError(CertificateErrorParams params) {
                return true; // GOOD: This means that loading will be cancelled on certificate errors
            }
        }); // GOOD: A secure `LoadHandler` is used.
        browser.loadURL("https://example.com");
    }
}