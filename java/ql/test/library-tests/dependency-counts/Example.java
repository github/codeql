import java.util.Set;
import java.util.List;

public interface Example <A> extends Set<List<A>> {
	public interface InnerExample extends Example<Set> {
	}
}
