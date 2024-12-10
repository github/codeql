import java.util.*;

public class A {
  private static final Set<String> SEPARATORS =
      Collections.unmodifiableSet(
          new HashSet<>(Arrays.asList("\t", "\n", ";")));

  public static void sink(String s) { }

  private void checkSeparator(String separator) {
    if (SEPARATORS.contains(separator)) {
      sink(separator);
    }
  }

  public static final String URI1 = "yarn.io/gpu";
  public static final String URI2 = "yarn.io/fpga";

  public static final Set<String> SCHEMAS = Set.of(URI1, URI2, "s3a", "wasb");

  private void checkSchema(String schema) {
    if (SCHEMAS.contains(schema)) {
      sink(schema);
    }
  }

  private void testAdd(String inp) {
    Set<String> s = new HashSet<>();
    s.add("AA");
    s.add("BB");
    if (s.contains(inp.toUpperCase())) {
      sink(inp);
    }
  }
}
