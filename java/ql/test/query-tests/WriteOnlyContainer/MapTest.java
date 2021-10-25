import java.util.*;

public class MapTest {
	// should not be flagged since l1 is public
	public Map<String, Integer> l1 = new HashMap<String, Integer>();
	
	// should not be flagged since l2 is a parameter
	public Map<String, Integer> m(Map<String, Integer> l2) {
		l2.remove("");
		// should not be flagged since it is assigned an existing map
		Map<String, Integer> l3 = l2;
		// should not be flagged since it is assigned an existing map
		Map<String, Integer> l33;
		l33 = l2;
		// should not be flagged since it is returned
		Map<String, Integer> s1 = new LinkedHashMap<String, Integer>();
		// should not be flagged since it is assigned to another variable
		Map<String, Integer> l4 = new HashMap<String, Integer>();
		this.l1 = l4;
		// should not be flagged since its contents are accessed
		Map<String, Integer> l5 = new HashMap<String, Integer>();
		if(!l5.containsKey("hello"))
			l5.put("hello", 23);
		// should not be flagged since its contents are accessed
		Map<String, Integer> l6 = new HashMap<String, Integer>();
		if(l6.remove("") != null)
			return null;
		return s1;
	}
	
	public void n(Collection<Map<String, Integer>> ms) {
		// should not be flagged since it is implicitly assigned an existing collection
		for (Map<String, Integer> m : ms)
			m.put("world", 42);
	}
	
	// should be flagged
	private Map<String, Integer> useless = new HashMap<String, Integer>();
	{
		useless.put("hello", 23);
		useless.remove("hello");
	}
	
	// should not be flagged since it is annotated with @SuppressWarnings("unused")
	@SuppressWarnings("unused")
	private Map<String, Integer> l7 = new HashMap<String, Integer>();
	
	// should not be flagged since it is annotated with a non-standard annotation suggesting reflective access
	@interface MyReflectionAnnotation {}
	@MyReflectionAnnotation
	private Map<String, Integer> l8 = new HashMap<String, Integer>();
}