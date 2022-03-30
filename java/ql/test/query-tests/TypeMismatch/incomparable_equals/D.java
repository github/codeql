package incomparable_equals;

public class D<T> {
	public void test(java.util.List<? extends T> l, String s) {
		l.get(0).equals(s);
	}
	
	public static void main(String[] args) {
		new D<String>().test(java.util.Collections.singletonList("Hi!"), "Hi!");
	}
}
