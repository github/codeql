import java.util.Map;
import java.util.AbstractMap;
import java.util.Collection;
import java.util.AbstractCollection;
import java.util.List;
import java.util.AbstractList;

public class Test {

  public static void test(
    Map<String, String> p1,
    AbstractMap<String, String> p2,
    Collection<String> p3,
    AbstractCollection<String> p4,
    List<String> p5,
    AbstractList<String> p6) {

    // Use a method of each to ensure method prototypes are extracted:
    p1.remove("Hello");
    p2.remove("Hello");
    p3.remove("Hello");
    p4.remove("Hello");
    p5.remove("Hello");
    p6.remove("Hello");

  }

}
