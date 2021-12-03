public class ReflectionMethodTest {
  public static class TestObject1 {
    public void test1() { }
  }

  public static class TestObject2 {
    public void test2() { }
  }

  public static class TestObject3 {
    public void test3() { }
  }

  public static class TestObject4 {
    public void test4() { }
  }

  public static class TestObject4a extends TestObject4 {
    public void test4() { }
  }

  public static void main(String[] args) throws InstantiationException, IllegalAccessException, ClassNotFoundException, NoSuchMethodException {
    // Get class by name
    Class.forName("ReflectionTest$TestObject1").getMethod("test1");
    // Use classloader
    ReflectionTest.class.getClassLoader().loadClass("ReflectionTest$TestObject2").getMethod("test2");
    // Store in variable, load from that
    Class<?> clazz = Class.forName("ReflectionTest$TestObject3");
    clazz.getMethod("test3");
    /*
     * We cannot determine the class by looking at a String literal, so we should look to the
     * type - in this case Class<? extends TestObject4>. We should therefore identify both
     * TestObject4 and TestObject4a as live.
     */
    getClass4().getMethod("test4");
  }

  public static Class<? extends TestObject4> getClass4() {
    return TestObject4.class;
  }
}
