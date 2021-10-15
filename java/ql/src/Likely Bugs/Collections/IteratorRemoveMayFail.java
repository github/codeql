import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

public class A {
	private List<Integer> l;
	
	public A(Integer... is) {
		this.l = Arrays.asList(is);
	}
	
	public List<Integer> getList() {
		return l;
	}

	public static void main(String[] args) {
		A a = new A(23, 42);
		for (Iterator<Integer> iter = a.getList().iterator(); iter.hasNext();)
			if (iter.next()%2 != 0)
				iter.remove();
	}
}
