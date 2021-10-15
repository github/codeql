import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;

public class A {
	private List<Integer> l;
	
	public A(Integer... is) {
		this.l = new ArrayList<Integer>(Arrays.asList(is));
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
