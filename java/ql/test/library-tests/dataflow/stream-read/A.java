import java.io.InputStream;
import java.io.IOException;

public class A {

    private static InputStream source() {
        return null;
    }

    private static void sink(Object s) {}

    static class MyStream extends InputStream {
        private InputStream wrapped;

        MyStream(InputStream wrapped) {
            this.wrapped = wrapped;
        }

        @Override
        public int read() throws IOException {
            return 0;
        }

        @Override
        public int read(byte[] b) throws IOException {
            return wrapped.read(b);
        }
    }

    public static void testSeveralWrappers() {
        InputStream src = source();
        InputStream wrapper1 = new MyStream(src);
        sink(wrapper1); // $ hasTaintFlow
        InputStream wrapper2 = new MyStream(wrapper1);
        sink(wrapper2); // $ hasTaintFlow
        InputStream wrapper3 = new MyStream(wrapper2);
        sink(wrapper3); // $ hasTaintFlow

        InputStream wrapper4 = new InputStream() {
            @Override
            public int read() throws IOException {
                return 0;
            }

            @Override
            public int read(byte[] b) throws IOException {
                return wrapper3.read(b);

            }
        };
        sink(wrapper4); // $ hasTaintFlow
    }

    public static void testAnonymous() throws Exception {
        InputStream wrapper = new InputStream() {
            @Override
            public int read() throws IOException {
                return 0;
            }

            @Override
            public int read(byte[] b) throws IOException {
                InputStream in = source();
                return in.read(b);
            }
        };
        sink(wrapper); // $ hasTaintFlow
    }

    public static void testAnonymousVarCapture() throws Exception {
        InputStream in = source();
        InputStream wrapper = new InputStream() {
            @Override
            public int read() throws IOException {
                return 0;
            }

            @Override
            public int read(byte[] b) throws IOException {
                return in.read(b);

            }
        };
        sink(wrapper); // $ hasTaintFlow
    }

    public static InputStream wrapStream(InputStream in) {
        return new InputStream() {
            @Override
            public int read() throws IOException {
                return 0;
            }

            @Override
            public int read(byte[] b) throws IOException {
                return in.read(b);
            }
        };
    }

    public static void testWrapCall() {
        sink(wrapStream(null)); // no flow
        sink(wrapStream(source())); // $ hasTaintFlow
    }

    public static void testLocal() {

        class LocalInputStream extends InputStream {
            @Override
            public int read() throws IOException {
                return 0;
            }

            @Override
            public int read(byte[] b) throws IOException {
                InputStream in = source();
                return in.read(b);
            }
        }
        sink(new LocalInputStream()); // $ hasTaintFlow
    }

    public static void testLocalVarCapture() {
        InputStream in = source();

        class LocalInputStream extends InputStream {
            @Override
            public int read() throws IOException {
                return 0;
            }

            @Override
            public int read(byte[] b) throws IOException {
                return in.read(b);
            }
        }
        sink(new LocalInputStream()); // $ hasTaintFlow
    }
}
