import java.io.*;
import java.net.Socket;
import com.alibaba.fastjson.JSON;

public class B {
  public Object deserializeJson1(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    return JSON.parseObject(inputStream, null); // unsafe
  }

  public Object deserializeJson2(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    byte[] bytes = new byte[100];
    inputStream.read(bytes);
    return JSON.parse(bytes); // unsafe
  }

  public Object deserializeJson3(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    byte[] bytes = new byte[100];
    inputStream.read(bytes);
    String s = new String(bytes);
    return JSON.parseObject(s); // unsafe
  }

  public Object deserializeJson4(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    byte[] bytes = new byte[100];
    inputStream.read(bytes);
    String s = new String(bytes);
    return JSON.parse(s); // unsafe
  }
}
