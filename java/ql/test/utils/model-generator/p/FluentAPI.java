package p;

public final class FluentAPI {

    public FluentAPI returnsThis(String input) {
        return this;
    }

    public class Inner {
        public FluentAPI notThis(String input) {
            return FluentAPI.this;
        }
    }

}