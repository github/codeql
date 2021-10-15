package remove_type_mismatch;

import java.util.Collection;

public class A {
	void test1(Collection<StringBuffer> c, String s, StringBuffer b) {
		c.remove(s);
		c.remove(b);
	}
	
	void test2(Collection<? extends CharSequence> c, A a, String b) {
		c.remove(a);
		c.remove(b);
	}
}

interface RunnableList extends Runnable, java.util.List {}
class TestB {
	Collection<? extends Runnable> coll1 = null;
	Collection<? extends java.util.List> coll2 = null;
	Collection<RunnableList> coll3;
	{
		coll3.remove("");
	}
}

class MyIntList extends java.util.LinkedList<Integer> {
	public boolean remove(Object o) { return super.remove(o); }
}
class TestC {
	MyIntList mil;
	{
		mil.remove("");
	}
}

class MyOtherIntList<T> extends java.util.LinkedList<Integer> {
	public boolean remove(Object o) { return super.remove(o); }
}
class TestD {
	MyOtherIntList<Runnable> moil;
	{
		moil.remove("");
	}
}