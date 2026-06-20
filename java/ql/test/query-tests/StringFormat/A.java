import java.util.Formatter;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.Console;
import java.io.File;

public class A {
  void f_string() {
    String.format("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
  }

  void f_formatter(Formatter x) {
    x.format("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
  }

  void f_printstream(PrintStream x) {
    x.format("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
    x.printf("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
  }

  void f_printwriter(PrintWriter x) {
    x.format("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
    x.printf("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
  }

  void f_console(Console x) {
    x.format("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
    x.printf("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
    x.readLine("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
    x.readPassword("%s%s", ""); // $ Alert[java/missing-format-argument] // missing
  }

  void custom_format(Object o, String fmt, Object... args) {
    String.format(fmt, args);
  }

  void f_wrapper() {
    custom_format(new Object(), "%s%s", ""); // $ Alert[java/missing-format-argument] // missing
  }

  void f() {
    String.format("%s", "", ""); // $ Alert[java/unused-format-argument] // unused
    String.format("s", ""); // $ Alert[java/unused-format-argument] // unused
    String.format("%2$s %2$s", "", ""); // $ Alert[java/unused-format-argument] // unused
    String.format("%2$s %1$s", "", ""); // ok
    String.format("%2$s %s", ""); // $ Alert[java/missing-format-argument] // missing
    String.format("%s%<s", "", ""); // $ Alert[java/unused-format-argument] // unused
    String.format("%s%%%%%%%%s%n", "", ""); // $ Alert[java/unused-format-argument] // unused
    String.format("%s%%%%%%%%s%n", ""); // ok
    String.format("%s%%%%%%%s%n", "", ""); // ok
    String.format("%s%%%%%%%s%n", ""); // $ Alert[java/missing-format-argument] // missing
    String.format("%2$s %% %n %1$s %<s %s %<s %s %1$s", "", ""); // ok
  }

  final String f_fmt1 = "%s" + File.separator;
  final String f_fmt2 = "%s" + f_fmt1 + System.getProperty("line.separator");
  final String f_fmt3 = "%s" + f_fmt2;

  void g(boolean b, int i) {
    String fmt1 = "%s" + (b ? "%s" : ""); 
    String.format(fmt1, ""); // $ Alert[java/missing-format-argument] // missing
    String.format(fmt1, "", ""); // ok
    String.format(fmt1, "", "", ""); // $ Alert[java/unused-format-argument] // unused

    String fmt2 = "%s%" + i + "s%n"; 
    String.format(fmt2, ""); // $ Alert[java/missing-format-argument] // missing
    String.format(fmt2, "", ""); // ok
    String.format(fmt2, "", "", ""); // $ Alert[java/unused-format-argument] // unused

    String.format(f_fmt3, "", ""); // $ Alert[java/missing-format-argument] // missing
    String.format(f_fmt3, "", "", ""); // ok
    String.format(f_fmt3, "", "", "", ""); // $ Alert[java/unused-format-argument] // unused

    String.format("%s%s", new Object[] { "a" }); // $ Alert[java/missing-format-argument] // missing
    String.format("%s%s", new Object[] { "a", "b" }); // ok
    String.format("%s%s", new Object[] { "a", "b", "c" }); // $ Alert[java/unused-format-argument] // unused

    Object[] a1 = new Object[] { "a", "b" };
    String.format("%s%s%s", a1); // $ Alert[java/missing-format-argument] // missing
    String.format("%s%s", a1); // ok
    String.format("%s", a1); // $ Alert[java/unused-format-argument] // unused

    Object[] a2 = new Object[2];
    String.format("%s%s%s", a2); // $ Alert[java/missing-format-argument] // missing
    String.format("%s%s", a2); // ok
    String.format("%s", a2); // $ Alert[java/unused-format-argument] // unused
  }

  void formatted() {
    "%s%s".formatted(""); // $ Alert[java/missing-format-argument] // missing
    "%s".formatted("", ""); // $ Alert[java/unused-format-argument] // unused
  }
}
