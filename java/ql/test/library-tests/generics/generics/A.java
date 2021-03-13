package generics;

import java.util.HashMap;
import java.util.Map;

public class A<T> { // $bounded=
	class B { }

	public <R> void noBound() { } // $bounded=
	public <R extends String> void upperBound() { } // $bounded=String
}

class C { 
	A<String> f;
	A<String>.B b;
	Map<String, Object> m = new HashMap<String, Object>(); // $parameterizedNew=0String,1Object
}

class D<V extends Number> { // $bounded=Number
	// Currently erroneously reports implicit Object as bound, see https://github.com/github/codeql/issues/5405
	D<?> d1; // $SPURIOUS: boundedAccess=Object MISSING: boundedAccess=
	D<? extends Object> d2; // $boundedAccess=Object
	D<? extends Float> d3; // $boundedAccess=Float
	D<? super Double> d4; // $boundedAccess=Double
	{ java.util.Arrays.asList(); }
}

interface I1 { }
interface I2 { }

class E1<T extends C & I1 & I2> { } // $bounded=C,I1,I2
class E2<T extends I2 & I1> { } // $bounded=I2,I1
class E3<T extends Object & I2 & I1> { } // $bounded=Object,I2,I1

class F {
	public <T extends C & I1 & I2> void test1() { } // $bounded=C,I1,I2
	public <T extends I2 & I1> void test2() { } // $bounded=I2,I1
	public <T extends Object & I2 & I1> void test3() { } // $bounded=Object,I2,I1
}
