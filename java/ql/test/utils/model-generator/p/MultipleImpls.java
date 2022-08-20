package p;

import java.util.concurrent.Callable;

public class MultipleImpls {

    public static interface Strategy {
        String doSomething(String value);
    }

    public static class Strat1 implements Strategy {
        public String doSomething(String value) {
            return value;
        }
    }

    // implements in different library should not count as impl
    public static class Strat3 implements Callable<String> {

        @Override
        public String call() throws Exception {
            return null;
        }

    }    
    public static class Strat2 implements Strategy {
        private String foo;

        public String doSomething(String value) {
            this.foo = value;
            return "none";
        }
        
        public String getValue() {
            return this.foo;
        }
    }
}
