import java.io.FilterInputStream;
import java.io.InputStream;

public class A {

    public String src;

    private static void sink(Object o) {}

    public void test() {
        sink(src); // $ hasTaintFlow
    }

    class TestFis extends FilterInputStream {

        protected TestFis(InputStream in) {
            super(in);
        }

        public void testOutOfSource() {
            // out of source field
            sink(this.in); // $ hasTaintFlow
        }
    }
}
