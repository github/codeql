


interface I {
	// NOT OK: no overriding method uses x
	void foo(int x);
	
	// OK: no concrete implementation
	void bar(String y);
	
	// OK: no concrete implementation
	void baz(float f);
	
	// OK: some overriding method uses x
	int qux(boolean b);
}

abstract class A implements I {
	// OK: I.foo is already flagged
	@Override public void foo(int x) {}
	
	// OK: no concrete implementation
	@Override public abstract void baz(float f);
	
	// OK: uses b
	@Override public int qux(boolean b) {
		return b ? 42 : 23;
	}
}

abstract class B extends A {
	// OK: I.foo is already flagged
	@Override public void foo(int x) {}
}

abstract class C implements I {
	// OK: overrides I.qux
	@Override public int qux(boolean b) {
		return 56;
	}
}

interface F {
	void doSomething(int arg2);
}

public class Test {
	// OK: external interface
	public static void main(String[] args) {}
	
	// OK: external interface
	public static void premain(String arg) {}
	
	// OK: external interface
	public static void premain(String arg, java.lang.instrument.Instrumentation i) {}
	
	// OK: Pseudo-abstract method
	public static void foo(Object bar) {
		throw new UnsupportedOperationException();
	}

	public static F getF() {
		return Test::myFImplementation;
	}

	// OK: mentioned in member reference
	private static void myFImplementation(int foo) {}
	
	// OK: native method
	native int baz(int x);

	{
		class MyMap extends java.util.HashMap<String,String> {
			// OK: method overrides super-class method
			@Override
			public void putAll(java.util.Map<? extends String,? extends String> m) {};
		}
		class MyComparable<T> implements Comparable<T> {
			// OK: method overrides super-interface method
			@Override public int compareTo(T o) { return 0; }
		};
		class MyComparable2 implements Comparable<Boolean> {
			// OK: method overrides super-interface method
			@Override public int compareTo(Boolean o) { return 0; }
		};





		class MySub<T> implements java.util.concurrent.ScheduledFuture<T> {
			public int compareTo(java.util.concurrent.Delayed o) {
				return 0;
			}
			public long getDelay(java.util.concurrent.TimeUnit unit) {
				return 0;
			}
			// OK: method overrides super-super-interface method
			@Override public boolean cancel(boolean mayInterruptIfRunning) {
				return false;
			}
			public T get() {
				return null;
			}
			// OK: method overrides super-super-interface method
			@Override public T get(long timeout, java.util.concurrent.TimeUnit unit) {
				return null;
			}
			public boolean isCancelled() { return false; };
			public boolean isDone() { return false; };
		}
	}
}
