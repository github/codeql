package callgraph;

import java.util.List;

public class A {
	Object o;
	List l;
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((l == null) ? 0 : l.hashCode());
		result = prime * result + ((o == null) ? 0 : o.hashCode());
		return result;
	}
}
