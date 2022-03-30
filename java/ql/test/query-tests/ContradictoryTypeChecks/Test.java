public class Test<T> {
	static class Super {}
	static class Sub1 extends Super {}
	static class Sub2 extends Super {}

	// modeled after results on Alfresco
	void foo(Super lhs, Super rhs) {
		if (lhs instanceof Sub1) ;
		else if (rhs instanceof Sub1)
			if ((lhs instanceof Sub1) || (lhs instanceof Sub2));
	}

	void bar(Super x) {
		if (x instanceof Super);
		else if (x instanceof Sub1);
	}

	// modeled after results on Apache Lucene
	void baz(Super x, Super y) {
		if (x instanceof Sub1);
		else if (x instanceof Sub1);
	}

	// NOT OK
	void w(Super x) {
		if (x instanceof Sub2 || x instanceof Super);
		else if (x instanceof Sub1);
	}

	// modeled after result on WildFly
	@Override
	public boolean equals(Object object) {
		if ((object != null) && !(object instanceof Test)) {
			Test<?> value = (Test<?>) object;
			return (this.hashCode() == value.hashCode()) && super.equals(object);
		}
		return super.equals(object);
	}

	// NOT OK
	Sub1 m(Super o) {
		if (!(o instanceof Sub1))
			return (Sub1)o;
		return null;
	}


	// OK: not a guaranteed failure
	Sub1 m2(Super o) {
		if (!(o instanceof Sub1));
		return (Sub1)o;
	}

	// OK: reassigned
	Sub1 m3(Super o) {
		if (!(o instanceof Sub1)) {
			o = new Sub1();
			return (Sub1)o;
		}
		return null;
	}
}
