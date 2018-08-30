import java.util.*;

public class CollectionTest {
	// should not be flagged since l1 is public
	public List<Integer> l1 = new ArrayList<Integer>();
	
	// should not be flagged since l2 is a parameter
	public Set<Integer> m(List<Integer> l2) {
		l2.add(23);
		// should not be flagged since it is assigned an existing collection
		Collection<Integer> l3 = l2;
		// should not be flagged since it is assigned an existing collection
		Collection<Integer> l33;
		l33 = l2;
		// should not be flagged since it is returned
		Set<Integer> s1 = new LinkedHashSet<Integer>();
		// should not be flagged since it is assigned to another variable
		List<Integer> l4 = new ArrayList<Integer>();
		this.l1 = l4;
		// should not be flagged since its contents are accessed
		List<Integer> l5 = new ArrayList<Integer>();
		if(!l5.contains(23))
			l5.add(23);
		// should not be flagged since its contents are accessed
		List<Integer> l6 = new ArrayList<Integer>();
		if(!l6.add(23))
			return null;
		return s1;
	}
	
	public void n(Collection<Set<Integer>> ss) {
		// should not be flagged since it is implicitly assigned an existing collection
		for (Set<Integer> s : ss)
			s.add(23);
	}
	
	// should be flagged
	private List<Integer> useless = new ArrayList<Integer>();
	{
		useless.add(23);
		useless.remove(0);
	}
	
	// should not be flagged since it is annotated with @SuppressWarnings("unused")
	@SuppressWarnings("unused")
	private List<Integer> l7 = new ArrayList<Integer>();
	
	// should not be flagged since it is annotated with a non-standard annotation suggesting reflective access
	@interface MyReflectionAnnotation {}
	@MyReflectionAnnotation
	private List<Integer> l8 = new ArrayList<Integer>();
}