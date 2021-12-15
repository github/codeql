import java.net.HttpURLConnection;
import javax.net.ssl.HttpsURLConnection;
import java.io.*;

class UseSSLTest {
  public void m1(HttpURLConnection connection) throws java.io.IOException {
    InputStream input;
    if (connection instanceof HttpsURLConnection) {
      input = connection.getInputStream(); // OK
    } else {
      input = connection.getInputStream(); // BAD
    }
  }
}
