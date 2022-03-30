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
}
