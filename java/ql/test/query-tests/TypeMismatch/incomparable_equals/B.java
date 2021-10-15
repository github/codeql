package incomparable_equals;

public class B<T extends B> {
	T t;
	
	void test(String s) {
		t.equals(s);
		t.equals(this);
	}
}
