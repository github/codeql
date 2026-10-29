package incomparable_equals;

import java.util.Map.Entry;

@SuppressWarnings("rawtypes")
public abstract class MyEntry implements Entry {
	void test(Entry e) {
		this.equals(e);
	}
}