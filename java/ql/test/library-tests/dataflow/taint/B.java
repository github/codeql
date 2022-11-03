import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.util.StringTokenizer;

public class B {
  public static String[] taint() { return new String[] { "tainted" }; }

  public static void sink(Object o) { }

  public static void maintest() throws java.io.UnsupportedEncodingException, java.net.MalformedURLException {
    String[] args = taint();
    // tainted - access to main args
    String[] aaaargs = args;
    sink(aaaargs);
    // tainted - access to tainted array
    String s = args[0];
    sink(s);
    // tainted - concatenation of tainted string
    String concat = "Look at me " + s + ", I'm tainted!";
    sink(concat);
    // tainted - parenthesised
    String pars = (concat);
    sink(pars);
    // tainted method argument, implies tainted return value
    String method = tainty(pars);
    sink(method);
    // tainted - complex
    String complex = ("Look at me " + args[0]) + ", I'm tainted!";
    sink(complex);
    // tainted - data preserving constructors
    String constructed = new String(complex);
    sink(constructed);
    // tainted - data preserving method
    String valueOf = String.valueOf(complex.toCharArray());
    sink(valueOf);
    // tainted - data preserving method
    String valueOfSubstring = String.valueOf(complex.toCharArray(), 0, 1);
    sink(valueOfSubstring);
    // tainted - unsafe escape
    String badEscape = constructed.replaceAll("(<script>)", "");
    sink(badEscape);
    // tainted - tokenized string
    String token = new StringTokenizer(badEscape).nextToken();
    sink(token);
    // tainted - fluent concatenation
    String fluentConcat = "".concat("str").concat(token).concat("bar");
    sink(fluentConcat);

    // not tainted
    String safe = notTainty(complex);
    sink(safe);
    String shouldBeFine = taintyOtherArg(safe, complex);
    sink(shouldBeFine);
    // non-whitelisted constructors don't pass taint
    StringWrapper herring = new StringWrapper(complex);
    sink(herring);
    // toString does not pass taint yet 
    String valueOfObject = String.valueOf(args);
    sink(valueOfObject);

    
    // tainted equality check with constant
    boolean cond = "foo" == s;
    sink(cond);
    // tainted logic with tainted operand
    boolean logic = cond && safe();
    sink(logic);
    // tainted condition
    sink(concat.endsWith("I'm tainted"));
    // tainted
    logic = safe() || cond;
    sink(logic);
    // tainted, use of equals
    logic = badEscape.equals("constant");
    sink(logic);

    // not tainted
    boolean okay = s == shouldBeFine;
    sink(okay);

    // methods on string that pass on taint
    String trimmed = s.trim();
    sink(trimmed);
    String[] split = s.split(" ");
    sink(split);
    String lower = s.toLowerCase();
    sink(lower);
    String upper = s.toUpperCase();
    sink(upper);
    byte[] bytes = s.getBytes("UTF-8");
    sink(bytes);
    String toString = s.toString();
    sink(toString);
    String subs = s.substring(1, 10);
    sink(subs);
    String repl = "some constant".replace(" ", s);
    sink(repl);
    String replAll = "some constant".replaceAll(" ", s);
    sink(replAll);
    String replFirst = "some constant".replaceFirst(" ", s);
    sink(replFirst);
    char[] chars = new char[10];
    s.getChars(0, 1, chars, 0);
    sink(chars);
    String translated = s.translateEscapes();
    sink(translated);

    ByteArrayOutputStream baos = null;
    ObjectOutput oos = null;
    ByteArrayInputStream bais = null;
    ObjectInputStream ois = null;
    try
    {
      // serialization of tainted string
      baos = new ByteArrayOutputStream();
      oos = new ObjectOutputStream(baos);
      oos.writeObject(s);
      byte[] serializedData = baos.toByteArray(); // tainted
      sink(serializedData);
      // serialization of fixed string
      baos = new ByteArrayOutputStream();
      oos = new ObjectOutputStream(baos);
      oos.writeObject("not tainted");
      byte[] serializedData2 = baos.toByteArray(); // *not* tainted
      sink(serializedData2);

      // de-serialization of tainted string
      bais = new ByteArrayInputStream(serializedData);
      ois = new ObjectInputStream(bais);
      String deserializedData = (String)ois.readObject(); // tainted
      sink(deserializedData);
    } catch (IOException e) {
      // ignored in test code
    } catch (ClassNotFoundException e) {
      // ignored in test code
    }

    // tainted array initializers
    String[] taintedArray = new String[] { s };
    sink(taintedArray);
    String[][] taintedArray2 = new String[][] { { s } };
    sink(taintedArray2);
    String[][][] taintedArray3 = new String[][][] { { { s } } };
    sink(taintedArray3);

    // Tainted file path and URI
    sink(new java.io.File(s).toURI().toURL());

    // Tainted file to Path
    sink(new java.io.File(s).toPath());

    // Tainted File to Path to File
    sink(new java.io.File(s).toPath().toFile());

    return;
  }

  public static String tainty(String arg) {
    // tainted return value
    return arg;
  }

  public static String taintyOtherArg(String safe, String tainted) {
    return safe;
  }

  public static String notTainty(String arg) {
    return "foo";
  }

  public static class StringWrapper {
    public String wrapped;

    public StringWrapper(String s) {
      this.wrapped = s;
    }
  }

  public static boolean safe() {
    return true;
  }
}
