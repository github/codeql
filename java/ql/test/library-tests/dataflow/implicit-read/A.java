public class A {
    String field;

    static String source(String name) {
        return name;
    }

    static void sink(Object o) {}

    static String step(Object o) {
        return "";
    }

    static Object getA() {
        A a = new A();
        a.field = source("source");
        return a;
    }

    static void test() {
        Object object = getA();

        sink(step(object)); // $ hasTaintFlow=source
        sink(object);
        sink(((A)object).field); // $ hasTaintFlow=source
    }
}
