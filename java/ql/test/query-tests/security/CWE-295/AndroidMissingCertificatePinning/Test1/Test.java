import java.net.URL;
import java.net.URLConnection;

class Test {
    URLConnection test1() throws Exception {
        return new URL("https://good.example.com").openConnection();
    }

    URLConnection test2() throws Exception {
        return new URL("https://bad.example.com").openConnection(); // $hasUntrustedResult
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
