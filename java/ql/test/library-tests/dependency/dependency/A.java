package dependency;

public class A<T> {
}

class B {
}

class C {
	A<B> b;
	C[] c;
}

class D extends A<B> {
	class E { 
		C m(A<F> f) throws G {
			return null;
		}
	}
}

class F { }

class G extends Throwable { }

class H {
	<T extends String> T test(T t) { return t; }
	void test2(java.util.Collection<? extends Number> t) {}
        void test3(Object o) {
                if (o instanceof Used1) return;
                switch (o) {
                        case Used2 u2: break;
                        default: break;
                }
                var x = switch (o) {
                        case Used3 u3: yield 1;
                        default: yield 2;
                };
        }

        static class Used1 { }
        static class Used2 { }
        static class Used3 { }
}
