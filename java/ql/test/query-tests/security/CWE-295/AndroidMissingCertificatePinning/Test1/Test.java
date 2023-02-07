import java.net.URL;
import java.net.URLConnection;

class Test{
    URLConnection test1() throws Exception {
        return new URL("https://good.example.com").openConnection();
    }

    URLConnection test2() throws Exception {
        return new URL("https://bad.example.com").openConnection(); // $hasUntrustedResult
    }
}