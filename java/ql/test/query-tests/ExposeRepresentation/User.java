import java.util.Map;

public class User {
  public static void test1(ExposesRep er) {
    er.getStrings()[0] = "Hello world";
  }

  public static void test2(ExposesRep er) {
    er.getStringMap().put("Hello", "world");
  }

  public String[] indirectGetStrings(ExposesRep er) {
    return er.getStrings();
  }

  public void test3(ExposesRep er) {
    indirectGetStrings(er)[0] = "Hello world";
  }

  public static void test4(ExposesRep er, String[] ss) {
    er.setStrings(ss);
    ss[0] = "Hello world";
  }

  public static void test5(ExposesRep er, Map<String, String> m) {
    er.setStringMap(m);
    m.put("Hello", "world");
  }

  public static void test6(GenericExposesRep<String> ger) {
    ger.getArray()[0] = "Hello world";
  }
}

class GenericUser<T> {

  public String[] indirectGetStrings(ExposesRep er) {
    return er.getStrings();
  }

  public static void test1(ExposesRep er, GenericUser<String> gu) {
    gu.indirectGetStrings(er)[0] = "Hello world";
  }

}
