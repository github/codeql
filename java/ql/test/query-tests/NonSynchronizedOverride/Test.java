class Super {
	synchronized void quack() {
		System.out.println("Quack.");
	}
	
	synchronized Super self() {
		return this;
	}
	
	synchronized void foo() {}
	void bar() {}
}

class Sub extends Super {
	// NOT OK
	void quack() {
		super.quack();
		super.quack();
	}
	
	// OK
	Sub self() {
		return (Sub)super.self();
	}
	
	// NOT OK
	void foo() {
		super.bar();
	}
}

class A<T> {
	synchronized void foo() {}
}

class B extends A<Integer> {
	// NOT OK
	void foo() {}
}

class C extends A<String> {
	// NOT OK
	void foo() {}
}