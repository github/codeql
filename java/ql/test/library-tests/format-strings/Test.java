public class Test {

  public static void test () {
    String.format("%s", "", "");
    String.format("s", "");
    String.format("%2$s %2$s", "", "");
    String.format("%2$s %1$s", "", "");
    String.format("%2$s %s", "");
    String.format("%s%<s", "", "");
    String.format("%s%%%%%%%%s%n", "", "");
    String.format("%s%%%%%%%%s%n", "");
    String.format("%s%%%%%%%s%n", "", "");
    String.format("%s%%%%%%%s%n", "");
    String.format("%2$s %% %n %1$s %<s %s %<s %<s %s %<s %1$s %<s", "", "");
  }

}