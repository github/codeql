import java.net.HttpURLConnection;
import javax.net.ssl.HttpsURLConnection;
import java.io.*;

class Test {
  public void m1(HttpURLConnection connection) {
    InputStream input;
    if (connection instanceof HttpsURLConnection) {
      input = connection.getInputStream(); // OK
    } else {
      input = connection.getInputStream(); // BAD
    }
  }
}
