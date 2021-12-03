package fields;

public class FieldTest {
        float ff, g = 2.3f, hhh;
        static Object obj = null, obj2;
        @SuppressWarnings("rawtypes") java.util.List l, m;
        int x = 0;
        int y = x = 1;
        {
                x = 2; // Shouldn't show up as an initializer
        }
        static int z = 0;
        static int w = z = 1;
        static {
                z = 2; // Shouldn't show up as an initializer
        }
}
