import java.util.*;
import java.util.function.*;
import java.util.stream.*;

public class NamingTest {
	public boolean equals(Object other) { return false; }
	public boolean equals(NamingTest other) { return true; }

	public void visit(Object node) {}
	public void visit(NamingTest t) {}

	public class Elem<T> {}

	public Object get(List<Elem<String>> lll) {
		Predicate<?> p = null;
		p.test(null);
		return lll.stream().map(l -> l).filter(Objects::nonNull).collect(Collectors.toList());
	}
}
