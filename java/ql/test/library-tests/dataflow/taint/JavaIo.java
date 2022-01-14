import java.io.*;

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
    StringWriter w = new StringWriter();
    CharSequence seq = taint();
    sink(w.toString());
    w.append(seq);
    sink(w.toString());
  }

}
