class Test {
    interface Function<T> {
        Object apply(T o) throws Exception;
    }

    interface IntFunction {
        Object apply(int i);
    }

    interface Supplier {
        Object get() throws Exception;
    }

    public Test() { }

    static class BaseClass {
    }

    static class Generic<T> extends BaseClass {
        public Generic() { }

        class Inner {
            public Inner() { }

            void test() {
                Supplier s0 = Generic.this::toString;
                Supplier s1 = Generic.super::toString;
            }
        }

        void test() {
            Supplier s0 = Generic<Number>.Inner::new;
            Supplier s1 = super::toString;
        }
    }

    void doSomething() { }

    static void staticMethod() { }

    static class Sub extends Test {
    }

    interface SubtypeConsumer {
        void consume(Sub s);
    }

    void test() {
        Function<Test> f0 = Test::toString;
        Function<Test> f1 = Test::hashCode;
        Function<Test> f2 = Test::clone;
        Function<Generic<String>> f3 = Generic<String>::toString;

        Supplier s0 = this::toString;
        Supplier s1 = this::hashCode;
        Supplier s2 = this::clone;
        Supplier s3 = ((Supplier) this::toString)::toString;

        // Discards result of method call
        Runnable r0 = this::toString;

        Runnable r1 = Test::staticMethod;

        Supplier[] classInstances = {
            Test::new,
            Generic<String>::new,
        };

        IntFunction[] arrays = {
            int[]::new,
            Generic[]::new,
        };

        // SubtypeConsumer has `Sub` as parameter type, but receiver here is `Test` (supertype)
        SubtypeConsumer sub = Test::doSomething;
    }
}
