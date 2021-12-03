import java.util.HashMap;
import java.util.Map;

public class Test2 {
	public static void main(Sub[] args) {
		Map<Sub, Super> m = new HashMap<>();
		Sub k = null, v = null;
		m.put(k, (Super) v);
		m.put(k, v);
	}
}