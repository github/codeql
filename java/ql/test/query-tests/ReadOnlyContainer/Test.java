import java.util.*;

public class Test {
	boolean containsDuplicates(Object[] array) {
		Set<Object> seen = new HashSet<Object>();
		for (Object o : array) {
			// should be flagged
			if (seen.contains(o))
				return true;
		}
		return false;
	}
	
	void foo(List<Integer> l) {
		// should not be flagged
		l.contains(23);
	}
	
	void bar(Collection<List<Integer>> c) {
		for (List<Integer> l : c)
			// should not be flagged
			l.contains(c);
	}
	
	List<Integer> l = new LinkedList<Integer>();
	List<Integer> getL() {
		return l;
	}
	{
		getL().add(23);
		// should not be flagged
		l.contains(23);
	}
	
	void add23(List<Integer> l) {
		l.add(23);
	}
	
	void baz() {
		List<Integer> l = new LinkedList<Integer>();
		add23(l);
		// should not be flagged
		l.contains(23);
	}
	
	{
		List<Integer> l2 = new LinkedList<Integer>(l);
		// should not be flagged
		l2.contains(23);
		
		List<Integer> l3 = new LinkedList<Integer>();
		l3.add(42);
		// should not be flagged
		l3.contains(23);
		
		List<Integer> l4 = new LinkedList<Integer>();
		l4.addAll(l);
		// should not be flagged
		l4.contains(23);
		
		Stack<Integer> l5 = new Stack<Integer>();
		l5.push(23);
		// should not be flagged
		l5.contains(23);
	}
	
	List<Boolean> g() {
		List<Boolean> bl = new ArrayList<Boolean>();
		// should be flagged
		bl.contains(false);
		return bl;
	}
	
	// should not be flagged
	private Set<Integer> sneakySet = new LinkedHashSet<Integer>() {{
		add(23);
		add(42);
	}};
	
	boolean inSneakySet(int x) {
		return sneakySet.contains(x);
	}
	
}