
public class A {
    void foo(OB<G1, G2>.B<E1, E2> z) {
        int foo = z.someFun();
    }
}

class OB<S1, S2> extends OC<F1, F2> {
	class B<T1, T2> extends OC<F1, F2>.C<D1, D2, T1, T2> {
	}
}

class OC<U1, U2> {
	class C<X1, X2, Y1, Y2> {
	    int someFun() {
	        return 5;
	    }
	}
}

class D1 {}
class D2 {}

class E1 {}
class E2 {}

class F1 {}
class F2 {}

class G1 {}
class G2 {}

