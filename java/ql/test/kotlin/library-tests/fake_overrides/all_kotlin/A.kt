
class A {
    fun foo(z: OB<G1, G2>.B<E1, E2>) {
        val foo = z.someFun()
    }
}

class OB<S1, S2>: OC<F1, F2>() {
	public inner class B<T1, T2>: OC<F1, F2>.C<D1, D2, T1, T2>() {
	}
}

open class OC<U1, U2> {
	open inner class C<X1, X2, Y1, Y2> {
	    fun someFun(): Int {
	        return 5
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

