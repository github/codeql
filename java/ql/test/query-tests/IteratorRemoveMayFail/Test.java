import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class Test {
	public static void main(String[] args) {
		A a = A.mkA(23, 42);
		Iterator<Integer> iter = a.getL().iterator();
		removeOdd(iter);
	}

	private static void removeOdd(Iterator<Integer> iter) {
		while (iter.hasNext()) {
			if (iter.next()%2 != 0)
				iter.remove();
		}
	}
}

class A {
	private List<Integer> l;
	
	private A(List<Integer> l) {
		this.l = l;
	}
	
	public static A mkA(Integer... is) {
		return new A(Arrays.asList(is));
	}
	
	public static A mkA2(int i) {
		return new A(Collections.singletonList(i));
	}
	
	public List<Integer> getL() {
		return l;
	}
}