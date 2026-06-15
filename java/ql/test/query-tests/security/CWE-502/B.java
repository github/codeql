import java.io.*;
import java.net.Socket;
import com.alibaba.fastjson.JSON;

public class B {
  public Object deserializeJson1(Socket sock) throws java.io.IOException {
    InputStream inputStream = sock.getInputStream(); // $ Source
    return JSON.parseObject(inputStream, null); // $ Alert
  }

  public Object deserializeJson2(Socket sock) throws java.io.IOException {
    InputStream inputStream = sock.getInputStream(); // $ Source
    byte[] bytes = new byte[100];
    inputStream.read(bytes);
    return JSON.parse(bytes); // $ Alert
  }

  public Object deserializeJson3(Socket sock) throws java.io.IOException {
    InputStream inputStream = sock.getInputStream(); // $ Source
    byte[] bytes = new byte[100];
    inputStream.read(bytes);
    String s = new String(bytes);
    return JSON.parseObject(s); // $ Alert
  }

  public Object deserializeJson4(Socket sock) throws java.io.IOException {
    InputStream inputStream = sock.getInputStream(); // $ Source
    byte[] bytes = new byte[100];
    inputStream.read(bytes);
    String s = new String(bytes);
    return JSON.parse(s); // $ Alert
  }
}
