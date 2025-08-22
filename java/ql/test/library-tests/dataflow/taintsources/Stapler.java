import org.kohsuke.stapler.InjectedParameter;

public class Stapler {

    @InjectedParameter
    private @interface MyInjectedParameter {
    }

    private static void sink(Object o) {}

    public static void test(@MyInjectedParameter String src) {
        sink(src); // $ hasRemoteValueFlow
    }
}
