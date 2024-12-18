import java.net.URL;
import java.net.URLConnection;

class Test {
    URLConnection test2() throws Exception {
        return new URL("https://example.com").openConnection(); // $hasNoTrustedResult
    }

    URLConnection test3() throws Exception {
        return new URL("classpath:example/directory/test.class").openConnection();
    }

    URLConnection test4() throws Exception {
        return new URL("file:///example/file").openConnection();
    }

    URLConnection test5() throws Exception {
        return new URL("jar:file:///C:/example/test.jar!/test.xml").openConnection();
    }
}
