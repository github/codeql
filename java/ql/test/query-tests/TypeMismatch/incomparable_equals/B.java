package incomparable_equals;

public class B<T extends B> {
	T t;
	
	void test(String s) {
		t.equals(s); // $ Alert[java/equals-on-unrelated-types]
		t.equals(this);
	}
}
