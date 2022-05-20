package generics;

import java.util.HashMap;
import java.util.Map;

public class A<T> {
	class B { }
}

class C { 
	A<String> f;
	A<String>.B b;
	Map<String, Object> m = new HashMap<String, Object>();
}

class D<V extends Number> {
	D<?> d1;
	D<? extends Object> d2;
	D<? extends Float> d3;
	D<? super Double> d4;
	{ java.util.Arrays.asList(); }
}