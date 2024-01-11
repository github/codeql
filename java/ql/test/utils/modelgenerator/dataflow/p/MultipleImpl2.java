package p;

class MultipleImpl2 {

    public interface IInterface {
        Object m(Object value);
    }

    public class Impl1 implements IInterface {
        public Object m(Object value) {
            return null;
        }
    }

    public class Impl2 implements IInterface {
        public Object m(Object value) {
            return value;
        }
    }
}
