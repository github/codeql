import java.util.Iterator;
import java.util.List;
import static org.junit.Assert.*;
import static org.hamcrest.core.IsNull.*;
import static org.hamcrest.MatcherAssert.*;

public class A {
  public void notTest() {
    Object not_ok = null;
    if (!(!(!(not_ok == null)))) {
      not_ok.hashCode();
    }
    Object not = null;
    if (!(not != null)) {
      not.hashCode();
    }
  }

  public void assertNull(Object o) {
    if (o != null)
      throw new RuntimeException("assert failed");
  }

  private static boolean isNull(Object o) {
    return o == null;
  }

  private static boolean isNotNull(Object o) {
    return o != null;
  }

  public void assertNonNull(Object o, String msg) {
    if (o == null)
      throw new RuntimeException("assert failed: " + msg);
  }

  public void assertNotNullTest() {
    Object assertNotNull_ok1 = maybe() ? null : new Object();
    assertNotNull(assertNotNull_ok1);
    assertNotNull_ok1.toString();

    Object assertNotNull_ok2 = maybe() ? null : new Object();
    assertNotNull("", assertNotNull_ok2);
    assertNotNull_ok2.toString();

    Object assertNotNull_ok3 = maybe() ? null : new Object();
    assertNonNull(assertNotNull_ok3, "");
    assertNotNull_ok3.toString();
  }

  public void assertTrueTest() {
    String assertTrue = "";
    assertTrue(assertTrue == null);
    assertTrue.toString();

    String assertTrue_ok = maybe() ? null : "";
    assertTrue(assertTrue_ok != null);
    assertTrue_ok.toString();
  }

  public void assertFalseTest() {
    String assertFalse = "";
    assertFalse(assertFalse != null);
    assertFalse.toString();

    String assertFalse_ok = maybe() ? null : "";
    assertFalse(assertFalse_ok == null);
    assertFalse_ok.toString();
  }

  public void assertNullTest() {
    String assertNull = "";
    assertNull(assertNull);
    assertNull.toString();
  }

  public void testNull() {
    String testNull_ok1 = null;
    if (isNotNull(testNull_ok1)) {
      testNull_ok1.toString();
    }
    String testNull_ok2 = null;
    if (!isNull(testNull_ok2)) {
      testNull_ok2.toString();
    }
  }

  public void instanceOf() {
    Object instanceof_ok = null;
    if (instanceof_ok instanceof String) {
      instanceof_ok.hashCode();
    }
  }

  public void synchronised() {
    Object synchronized_always = null;
    synchronized(synchronized_always) {
      synchronized_always.hashCode();
    }
  }

  public void loop1(List<Integer> list){
    for (Integer loop1_ok : list) {
      loop1_ok.toString();
      loop1_ok = null;
    }
  }

  public void loop2(Iterator<Integer> iter){
    for (Integer loop2_ok = 0; iter.hasNext(); loop2_ok = iter.next()) {
      loop2_ok.toString();
      loop2_ok = null;
    }
  }

  public void conditional(){
    String colours = null;
    String colour = (((colours == null)) || colours.isEmpty()) ? "Black" : colours.toString();
  }

  public void simple() {
    String[] children = null;
    String comparator = "";
    if (children == null) {
      children = new String[0];
    }
    if (children.length > 1) { }
  }

  public void assignIf() {
    String xx;
    String ok = null;
    if ((ok = (xx = null)) == null || ok.isEmpty()) {
    }
  }

  public void assignIf2() {
    String ok2 = null;
    if (foo(ok2 = "hello") || ok2.isEmpty()) {
    }
  }

  public void assignIfAnd() {
    String xx;
    String ok3 = null;
    if ((xx = (ok3 = null)) != null && ok3.isEmpty() ) {
    }
  }

  public boolean foo(String o) { return false; }

  public void dowhile() {
    String do_ok = "";
    do {
      System.out.println(do_ok.length());
      do_ok = null;
    } while((do_ok != null));

    String do_always = null;
    do {
      System.out.println(do_always.length());
      do_always = null;
    } while(do_always != null);

    String do_maybe1 = null;
    do {
      System.out.println(do_maybe1.length());
    } while(do_maybe1 != null);

    String do_maybe = "";
    do {
      System.out.println(do_maybe.length());
      do_maybe = null;
    } while(true);
  }

  public void while_() {
    String while_ok = "";
    while(while_ok != null) {
      System.out.println(while_ok.length());
      while_ok = null;
    }

    boolean TRUE = true;
    String while_always = null;
    while(TRUE) {
      System.out.println(while_always.length());
      while_always = null;
    }

    String while_maybe = "";
    while(true) {
      System.out.println(while_maybe.length());
      while_maybe = null;
    }
  }

  public void if_() {
    String if_ok = "";
    if (if_ok != null) {
      System.out.println(if_ok.length());
      if_ok = null;
    }

    String if_always = null;
    if (if_always == null) {
      System.out.println(if_always.length());
      if_always = null;
    }

    String if_maybe = "";
    if (if_maybe != null && if_maybe.length() % 2 == 0) {
      if_maybe = null;
    }
    System.out.println(if_maybe.length());
  }

  public void for_() {
    String for_ok ;
    for (for_ok = ""; for_ok != null; for_ok = null) {
      System.out.println(for_ok.length());
    }
    System.out.println(for_ok.length());

    for (String for_always = null; ((for_always == null)); for_always = null) {
      System.out.println(for_always.length());
    }

    for (String for_maybe = ""; ; for_maybe = null) {
      System.out.println(for_maybe.length());
    }
  }

  public void array_assign_test() {
    int[] array_null = null;
    array_null[0] = 10;

    int[] array_ok;
    array_ok = new int[10];
    array_ok[0] = 42;
  }

  public void access() {
    int[] arrayaccess = null;
    String[] fieldaccess = null;
    Object methodaccess = null;

    System.out.println(arrayaccess[1]);
    System.out.println(fieldaccess.length);
    System.out.println(methodaccess.toString());

    System.out.println(arrayaccess[1]);
    System.out.println(fieldaccess.length);
    System.out.println(methodaccess.toString());
  }

  public void enhanced_for() {
    List<String> for_ok = java.util.Collections.emptyList();
    for (String s : for_ok)
      System.out.println(s);
    System.out.println(for_ok.size());

    List<String> for_always = null;
    for (String s : for_always)
      System.out.println(s);
    System.out.println(for_always.size());

    List<String> for_maybe = java.util.Collections.emptyList();
    for (String s : for_maybe) {
      System.out.println(s);
      for_maybe = null;
    }
    System.out.println(for_maybe.size());
  }

  public void assertFalseInstanceofTest() {
    Object s = String.valueOf(1);
    assertFalse(s instanceof Number);
    s.toString().isEmpty();
  }

  public void assertVariousTest() {
    Object s = String.valueOf(1);
    assertNotNull(s);
    assertFalse(s instanceof Number);
    assertTrue(s.toString().contains("1"));
    assertFalse(s.toString().isEmpty());
  }

  public void assertFalseNotNullNestedTest() {
    Object s = String.valueOf(1);
    assertFalse(s != null || !"1".equals("1")); // assertTrue(s==null)
    s.toString().isEmpty();
  }

  public void testForLoopCondition(Iterable iter) {
    Iterator it = null;
    for (it = iter.iterator(); !!it.hasNext(); ) {}
  }

  public void assertThatTest() {
    Object assertThat_ok1 = maybe() ? null : new Object();
    assertThat(assertThat_ok1, notNullValue());
    assertThat_ok1.toString();
  }

  private boolean m;
  A(boolean m) {
    this.m = m;
  }

  boolean maybe() {
    return this.m;
  }
}
