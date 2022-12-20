import java.net.URL;
import java.net.URLConnection;

class Test{
    URLConnection test2() throws Exception {
        return new URL("https://example.com").openConnection(); // $hasNoTrustedResult
    }
}