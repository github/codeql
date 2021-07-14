import java.util.Formatter;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.Console;
import java.io.File;

public class A {
  void f_string() {
    String.format("%s%s", ""); // missing
  }

  void f_formatter(Formatter x) {
    x.format("%s%s", ""); // missing
  }

  void f_printstream(PrintStream x) {
    x.format("%s%s", ""); // missing
    x.printf("%s%s", ""); // missing
  }

  void f_printwriter(PrintWriter x) {
    x.format("%s%s", ""); // missing
    x.printf("%s%s", ""); // missing
  }

  void f_console(Console x) {
    x.format("%s%s", ""); // missing
    x.printf("%s%s", ""); // missing
    x.readLine("%s%s", ""); // missing
    x.readPassword("%s%s", ""); // missing
  }

  void custom_format(Object o, String fmt, Object... args) {
    String.format(fmt, args);
  }

  void f_wrapper() {
    custom_format(new Object(), "%s%s", ""); // missing
  }

  void f() {
    String.format("%s", "", ""); // unused
    String.format("s", ""); // unused
    String.format("%2$s %2$s", "", ""); // unused
    String.format("%2$s %1$s", "", ""); // ok
    String.format("%2$s %s", ""); // missing
    String.format("%s%<s", "", ""); // unused
    String.format("%s%%%%%%%%s%n", "", ""); // unused
    String.format("%s%%%%%%%%s%n", ""); // ok
    String.format("%s%%%%%%%s%n", "", ""); // ok
    String.format("%s%%%%%%%s%n", ""); // missing
    String.format("%2$s %% %n %1$s %<s %s %<s %s %1$s", "", ""); // ok
  }

  final String f_fmt1 = "%s" + File.separator;
  final String f_fmt2 = "%s" + f_fmt1 + System.getProperty("line.separator");
  final String f_fmt3 = "%s" + f_fmt2;

  void g(boolean b, int i) {
    String fmt1 = "%s" + (b ? "%s" : ""); 
    String.format(fmt1, ""); // missing
    String.format(fmt1, "", ""); // ok
    String.format(fmt1, "", "", ""); // unused

    String fmt2 = "%s%" + i + "s%n"; 
    String.format(fmt2, ""); // missing
    String.format(fmt2, "", ""); // ok
    String.format(fmt2, "", "", ""); // unused

    String.format(f_fmt3, "", ""); // missing
    String.format(f_fmt3, "", "", ""); // ok
    String.format(f_fmt3, "", "", "", ""); // unused

    String.format("%s%s", new Object[] { "a" }); // missing
    String.format("%s%s", new Object[] { "a", "b" }); // ok
    String.format("%s%s", new Object[] { "a", "b", "c" }); // unused

    Object[] a1 = new Object[] { "a", "b" };
    String.format("%s%s%s", a1); // missing
    String.format("%s%s", a1); // ok
    String.format("%s", a1); // unused

    Object[] a2 = new Object[2];
    String.format("%s%s%s", a2); // missing
    String.format("%s%s", a2); // ok
    String.format("%s", a2); // unused
  }

  void formatted() {
    "%s%s".formatted(""); // missing
    "%s".formatted("", ""); // unused
  }
}
