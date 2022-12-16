public class Test {

    void sink(Object o) { }

    Object source() { return null; }

    public void test() throws Exception {
        Exception e1 = new RuntimeException((String)source());
        sink((String)e1.getMessage()); // $hasValueFlow

        Exception e2 = new RuntimeException((Throwable)source());
        sink((Throwable)e2.getCause()); // $hasValueFlow

        Exception e3 = new IllegalArgumentException((String)source());
        sink((String)e3.getMessage()); // $hasValueFlow

        Exception e4 = new IllegalStateException((String)source());
        sink((String)e4.getMessage()); // $hasValueFlow

        Throwable t = new Throwable((Throwable)source());
        sink((Throwable)t.getCause()); // $hasValueFlow
    }
}
