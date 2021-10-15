import java.util.HashMap;
import java.util.IdentityHashMap;

class Test {
	{
		IdentityHashMap<Object, String> map = new IdentityHashMap<>();
		A a = new A();
		map.put(a, "value");
		HashMap<Object, String> map2 = new HashMap<>();
		map2.put(a, "value");
	}
}

class A {
	int i;
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (!(obj instanceof A)) {
			return false;
		}
		A other = (A) obj;
		if (i != other.i) {
			return false;
		}
		return true;
	}

}
