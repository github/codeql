import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

public class JavaIo {
  public static String taint() { return "tainted"; }
  
  public static void sink(Object o) { }

  void testWritingChars() throws IOException {
    StringWriter w = new StringWriter();
    char[] chars = taint().toCharArray();
    sink(w.toString());
    w.write(chars);
    sink(w.toString());
    sink(w.getBuffer().toString());
  }

  void testAppendingToWriter() throws IOException {
    Writer w = new StringWriter();
    CharSequence seq = taint();
    sink(w.toString());
    w.append("harmless").append(seq);
    sink(w.toString());
  }
  
  void testCharArrayWriter() throws IOException {
    CharArrayWriter w = new CharArrayWriter();
    CharSequence seq = taint();
    sink(w.toCharArray());
    w.append("harmless").append(seq);
    sink(w.toCharArray());
  }

  void testByteChannelToBuffer() throws IOException {
    ReadableByteChannel c = Channels.newChannel(new ByteArrayInputStream(taint().getBytes()));
    ByteBuffer buf = ByteBuffer.allocate(10);
    sink(buf);
    c.read(buf);
    sink(buf);
  }

}
