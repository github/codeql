import com.google.gson.Gson;

public class Test {
    public static class Potato {
        private String name;
        private Potato inner;
        private Object object;

        private String getName() {
            return name;
        }

        private Potato getInner() {
            return inner;
        }

        private Object getObject() {
            return object;
        }

    }

    public static String source() {
        return "";
    }

    public static void sink(Object any) {}

    public static void gsonfromJson() throws Exception {
        String s = source();
        Potato tainted = new Gson().fromJson(s, Potato.class);
        sink(tainted); // $ hasTaintFlow
        sink(tainted.getName()); // $ hasTaintFlow
        sink(tainted.getInner()); // $ hasTaintFlow
        sink(tainted.getInner().getName()); // $ hasTaintFlow
        sink(tainted.getObject()); // $ hasTaintFlow
    }
}
